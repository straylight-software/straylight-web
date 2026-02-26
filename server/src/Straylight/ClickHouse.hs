{-# LANGUAGE StrictData #-}
-- | ClickHouse HTTP Client
-- | Queries ClickHouse for analytics data across all Straylight products
module Straylight.ClickHouse
  ( -- * Configuration
    ClickHouseConfig(..)
  , defaultConfig
  , configFromEnv
    -- * Client
  , ClickHouseClient
  , newClient
    -- * Queries
  , query
  , execute
    -- * Analytics Queries
  , getCacheStatsHourly
  , getCacheStatsDaily
  , getBuildStatsDaily
  , getAgentUsageDaily
  , getProxyUsageHourly
    -- * Insert Events
  , insertCacheEvent
  , insertBuildEvent
  , insertAgentEvent
  , insertProxyEvent
    -- * Types
  , CacheEventType(..)
  , CacheEvent(..)
  , BuildEventType(..)
  , BuildEvent(..)
  , AgentEventType(..)
  , AgentEvent(..)
  , ProxyEvent(..)
  , HourlyStat(..)
  , DailyStat(..)
  ) where

import Control.Exception (try, SomeException)
import Data.Aeson
import qualified Data.ByteString.Lazy as LBS
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import Data.Time.Clock (UTCTime)
import qualified Data.Vector as V
import GHC.Generics (Generic)
import Network.HTTP.Client
import Network.HTTP.Client.TLS (tlsManagerSettings)
import Network.HTTP.Types.Status (statusCode)
import System.Environment (lookupEnv)

-- ============================================================
-- Configuration
-- ============================================================

data ClickHouseConfig = ClickHouseConfig
  { host     :: Text
  , port     :: Int
  , user     :: Text
  , password :: Text
  , database :: Text
  , useTLS   :: Bool
  } deriving (Show, Eq)

defaultConfig :: ClickHouseConfig
defaultConfig = ClickHouseConfig
  { host     = "localhost"
  , port     = 8123
  , user     = "default"
  , password = ""
  , database = "default"
  , useTLS   = False
  }

configFromEnv :: IO (Maybe ClickHouseConfig)
configFromEnv = do
  mHost <- lookupEnv "CLICKHOUSE_HOST"
  mPort <- lookupEnv "CLICKHOUSE_PORT"
  mUser <- lookupEnv "CLICKHOUSE_USER"
  mPass <- lookupEnv "CLICKHOUSE_PASSWORD"
  mDb   <- lookupEnv "CLICKHOUSE_DATABASE"
  case mHost of
    Nothing -> pure Nothing
    Just h  -> pure $ Just ClickHouseConfig
      { host     = T.pack h
      , port     = maybe 8123 read mPort
      , user     = maybe "default" T.pack mUser
      , password = maybe "" T.pack mPass
      , database = maybe "default" T.pack mDb
      , useTLS   = False  -- Local dev uses HTTP
      }

-- ============================================================
-- Client
-- ============================================================

data ClickHouseClient = ClickHouseClient
  { config  :: ClickHouseConfig
  , manager :: Manager
  }

newClient :: ClickHouseConfig -> IO ClickHouseClient
newClient cfg = do
  mgr <- newManager tlsManagerSettings
  pure ClickHouseClient
    { config  = cfg
    , manager = mgr
    }

baseUrl :: ClickHouseConfig -> String
baseUrl cfg =
  let scheme = if cfg.useTLS then "https://" else "http://"
  in scheme <> T.unpack cfg.host <> ":" <> show cfg.port

query :: ClickHouseClient -> Text -> IO (Either Text Value)
query client sql = do
  let url = baseUrl client.config <> "/?default_format=JSONEachRow"
  result <- try $ do
    initReq <- parseRequest url
    let req = initReq
          { method = "POST"
          , requestBody = RequestBodyBS (T.encodeUtf8 sql)
          , requestHeaders =
              [ ("Content-Type", "text/plain")
              , ("X-ClickHouse-User", T.encodeUtf8 client.config.user)
              , ("X-ClickHouse-Key", T.encodeUtf8 client.config.password)
              , ("X-ClickHouse-Database", T.encodeUtf8 client.config.database)
              ]
          }
    response <- httpLbs req client.manager
    let status = statusCode $ responseStatus response
    if status >= 200 && status < 300
      then do
        let body = responseBody response
            lines' = filter (not . LBS.null) $ LBS.split 0x0A body
        case traverse eitherDecode lines' of
          Left err -> pure $ Left $ T.pack err
          Right rows -> pure $ Right $ Array $ V.fromList rows
      else pure $ Left $ "ClickHouse error: " <> T.decodeUtf8 (LBS.toStrict $ responseBody response)
  case result of
    Left (e :: SomeException) -> pure $ Left $ "HTTP error: " <> T.pack (show e)
    Right r -> pure r

execute :: ClickHouseClient -> Text -> IO (Either Text ())
execute client sql = do
  let url = baseUrl client.config <> "/"
  result <- try $ do
    initReq <- parseRequest url
    let req = initReq
          { method = "POST"
          , requestBody = RequestBodyBS (T.encodeUtf8 sql)
          , requestHeaders =
              [ ("Content-Type", "text/plain")
              , ("X-ClickHouse-User", T.encodeUtf8 client.config.user)
              , ("X-ClickHouse-Key", T.encodeUtf8 client.config.password)
              , ("X-ClickHouse-Database", T.encodeUtf8 client.config.database)
              ]
          }
    response <- httpLbs req client.manager
    let status = statusCode $ responseStatus response
    if status >= 200 && status < 300
      then pure $ Right ()
      else pure $ Left $ "ClickHouse error: " <> T.decodeUtf8 (LBS.toStrict $ responseBody response)
  case result of
    Left (e :: SomeException) -> pure $ Left $ "HTTP error: " <> T.pack (show e)
    Right r -> pure r

-- ============================================================
-- Event Types
-- ============================================================

data CacheEventType = CachePush | CachePull | CacheHit | CacheMiss
  deriving (Show, Eq)

data CacheEvent = CacheEvent
  { orgId      :: Text
  , cacheId    :: Text
  , eventType  :: CacheEventType
  , storePath  :: Text
  , narHash    :: Text
  , narSize    :: Int
  , clientIp   :: Text
  , userAgent  :: Text
  , region     :: Text
  , durationMs :: Int
  } deriving (Show, Eq)

data BuildEventType = BuildQueued | BuildStarted | BuildCompleted | BuildFailed | BuildCancelled
  deriving (Show, Eq)

data BuildEvent = BuildEvent
  { orgId         :: Text
  , buildId       :: Text
  , cacheId       :: Text
  , eventType     :: BuildEventType
  , name          :: Text
  , flakeRef      :: Maybe Text
  , commit        :: Maybe Text
  , branch        :: Maybe Text
  , durationMs    :: Int
  , pathsBuilt    :: Int
  , pathsCached   :: Int
  , pathsUploaded :: Int
  , exitCode      :: Maybe Int
  , errorMessage  :: Maybe Text
  , triggeredBy   :: Text
  } deriving (Show, Eq)

data AgentEventType = AgentMessage | AgentToolCall | AgentToolResult | AgentError
  deriving (Show, Eq)

data AgentEvent = AgentEvent
  { orgId        :: Text
  , sessionId    :: Text
  , userId       :: Text
  , eventType    :: AgentEventType
  , model        :: Text
  , inputTokens  :: Int
  , outputTokens :: Int
  , durationMs   :: Int
  , toolName     :: Maybe Text
  } deriving (Show, Eq)

data ProxyEvent = ProxyEvent
  { orgId        :: Text
  , endpointId   :: Text
  , provider     :: Text
  , model        :: Text
  , inputTokens  :: Int
  , outputTokens :: Int
  , latencyMs    :: Int
  , cached       :: Bool
  , verified     :: Bool
  , statusCode   :: Int
  } deriving (Show, Eq)

-- ============================================================
-- Result Types
-- ============================================================

data HourlyStat = HourlyStat
  { hour       :: UTCTime
  , eventType  :: Text
  , eventCount :: Int
  , totalBytes :: Int
  } deriving (Show, Eq, Generic)

instance FromJSON HourlyStat where
  parseJSON = withObject "HourlyStat" $ \o -> HourlyStat
    <$> o .: "hour"
    <*> o .: "event_type"
    <*> o .: "event_count"
    <*> o .: "total_bytes"

data DailyStat = DailyStat
  { day        :: UTCTime
  , eventType  :: Text
  , eventCount :: Int
  , totalBytes :: Int
  } deriving (Show, Eq, Generic)

instance FromJSON DailyStat where
  parseJSON = withObject "DailyStat" $ \o -> DailyStat
    <$> o .: "day"
    <*> o .: "event_type"
    <*> o .: "event_count"
    <*> o .: "total_bytes"

-- ============================================================
-- Analytics Queries
-- ============================================================

getCacheStatsHourly :: ClickHouseClient -> Text -> Text -> Int -> IO (Either Text [HourlyStat])
getCacheStatsHourly client orgId cacheId hours = do
  let sql = T.unlines
        [ "SELECT hour, event_type, sum(event_count) AS event_count, sum(total_bytes) AS total_bytes"
        , "FROM cache_stats_hourly"
        , "WHERE org_id = '" <> escapeString orgId <> "'"
        , "  AND cache_id = '" <> escapeString cacheId <> "'"
        , "  AND hour >= now() - INTERVAL " <> T.pack (show hours) <> " HOUR"
        , "GROUP BY hour, event_type"
        , "ORDER BY hour ASC"
        , "FORMAT JSONEachRow"
        ]
  result <- query client sql
  case result of
    Left err -> pure $ Left err
    Right (Array arr) -> 
      case traverse fromJSON (V.toList arr) of
        Error err -> pure $ Left $ T.pack err
        Success stats -> pure $ Right stats
    Right _ -> pure $ Left "Unexpected response format"

getCacheStatsDaily :: ClickHouseClient -> Text -> Text -> Int -> IO (Either Text [DailyStat])
getCacheStatsDaily client orgId cacheId days = do
  let sql = T.unlines
        [ "SELECT day, event_type, sum(event_count) AS event_count, sum(total_bytes) AS total_bytes"
        , "FROM cache_stats_daily"
        , "WHERE org_id = '" <> escapeString orgId <> "'"
        , "  AND cache_id = '" <> escapeString cacheId <> "'"
        , "  AND day >= today() - INTERVAL " <> T.pack (show days) <> " DAY"
        , "GROUP BY day, event_type"
        , "ORDER BY day ASC"
        , "FORMAT JSONEachRow"
        ]
  result <- query client sql
  case result of
    Left err -> pure $ Left err
    Right (Array arr) -> 
      case traverse fromJSON (V.toList arr) of
        Error err -> pure $ Left $ T.pack err
        Success stats -> pure $ Right stats
    Right _ -> pure $ Left "Unexpected response format"

getBuildStatsDaily :: ClickHouseClient -> Text -> Int -> IO (Either Text [DailyStat])
getBuildStatsDaily client orgId days = do
  let sql = T.unlines
        [ "SELECT day, outcome AS event_type, sum(build_count) AS event_count, 0 AS total_bytes"
        , "FROM build_stats_daily"
        , "WHERE org_id = '" <> escapeString orgId <> "'"
        , "  AND day >= today() - INTERVAL " <> T.pack (show days) <> " DAY"
        , "GROUP BY day, outcome"
        , "ORDER BY day ASC"
        , "FORMAT JSONEachRow"
        ]
  result <- query client sql
  case result of
    Left err -> pure $ Left err
    Right (Array arr) -> 
      case traverse fromJSON (V.toList arr) of
        Error err -> pure $ Left $ T.pack err
        Success stats -> pure $ Right stats
    Right _ -> pure $ Left "Unexpected response format"

getAgentUsageDaily :: ClickHouseClient -> Text -> Int -> IO (Either Text [DailyStat])
getAgentUsageDaily client orgId days = do
  let sql = T.unlines
        [ "SELECT day, model AS event_type, sum(message_count) AS event_count,"
        , "  sum(total_input_tokens + total_output_tokens) AS total_bytes"
        , "FROM agent_usage_daily"
        , "WHERE org_id = '" <> escapeString orgId <> "'"
        , "  AND day >= today() - INTERVAL " <> T.pack (show days) <> " DAY"
        , "GROUP BY day, model"
        , "ORDER BY day ASC"
        , "FORMAT JSONEachRow"
        ]
  result <- query client sql
  case result of
    Left err -> pure $ Left err
    Right (Array arr) -> 
      case traverse fromJSON (V.toList arr) of
        Error err -> pure $ Left $ T.pack err
        Success stats -> pure $ Right stats
    Right _ -> pure $ Left "Unexpected response format"

getProxyUsageHourly :: ClickHouseClient -> Text -> Int -> IO (Either Text [HourlyStat])
getProxyUsageHourly client orgId hours = do
  let sql = T.unlines
        [ "SELECT hour, concat(provider, '/', model) AS event_type,"
        , "  sum(request_count) AS event_count,"
        , "  sum(total_input_tokens + total_output_tokens) AS total_bytes"
        , "FROM proxy_usage_hourly"
        , "WHERE org_id = '" <> escapeString orgId <> "'"
        , "  AND hour >= now() - INTERVAL " <> T.pack (show hours) <> " HOUR"
        , "GROUP BY hour, provider, model"
        , "ORDER BY hour ASC"
        , "FORMAT JSONEachRow"
        ]
  result <- query client sql
  case result of
    Left err -> pure $ Left err
    Right (Array arr) -> 
      case traverse fromJSON (V.toList arr) of
        Error err -> pure $ Left $ T.pack err
        Success stats -> pure $ Right stats
    Right _ -> pure $ Left "Unexpected response format"

-- ============================================================
-- Insert Functions
-- ============================================================

insertCacheEvent :: ClickHouseClient -> CacheEvent -> IO (Either Text ())
insertCacheEvent client evt = do
  let eventTypeStr = case evt.eventType of
        CachePush -> "push"
        CachePull -> "pull"
        CacheHit  -> "hit"
        CacheMiss -> "miss"
      sql = T.unlines
        [ "INSERT INTO cache_events"
        , "(org_id, cache_id, event_type, store_path, nar_hash, nar_size,"
        , " client_ip, user_agent, region, duration_ms, timestamp)"
        , "VALUES"
        , "('" <> escapeString evt.orgId <> "',"
        , " '" <> escapeString evt.cacheId <> "',"
        , " '" <> eventTypeStr <> "',"
        , " '" <> escapeString evt.storePath <> "',"
        , " '" <> escapeString evt.narHash <> "',"
        , " " <> T.pack (show evt.narSize) <> ","
        , " toIPv4('" <> escapeString evt.clientIp <> "'),"
        , " '" <> escapeString evt.userAgent <> "',"
        , " '" <> escapeString evt.region <> "',"
        , " " <> T.pack (show evt.durationMs) <> ","
        , " now())"
        ]
  execute client sql

insertBuildEvent :: ClickHouseClient -> BuildEvent -> IO (Either Text ())
insertBuildEvent client evt = do
  let eventTypeStr = case evt.eventType of
        BuildQueued    -> "queued"
        BuildStarted   -> "started"
        BuildCompleted -> "completed"
        BuildFailed    -> "failed"
        BuildCancelled -> "cancelled"
      sql = T.unlines
        [ "INSERT INTO build_events"
        , "(org_id, build_id, cache_id, event_type, name, flake_ref, commit, branch,"
        , " duration_ms, paths_built, paths_cached, paths_uploaded, exit_code, error_message,"
        , " triggered_by, timestamp)"
        , "VALUES"
        , "('" <> escapeString evt.orgId <> "',"
        , " '" <> escapeString evt.buildId <> "',"
        , " '" <> escapeString evt.cacheId <> "',"
        , " '" <> eventTypeStr <> "',"
        , " '" <> escapeString evt.name <> "',"
        , " " <> maybeText evt.flakeRef <> ","
        , " " <> maybeText evt.commit <> ","
        , " " <> maybeText evt.branch <> ","
        , " " <> T.pack (show evt.durationMs) <> ","
        , " " <> T.pack (show evt.pathsBuilt) <> ","
        , " " <> T.pack (show evt.pathsCached) <> ","
        , " " <> T.pack (show evt.pathsUploaded) <> ","
        , " " <> maybeInt evt.exitCode <> ","
        , " " <> maybeText evt.errorMessage <> ","
        , " '" <> escapeString evt.triggeredBy <> "',"
        , " now())"
        ]
  execute client sql

insertAgentEvent :: ClickHouseClient -> AgentEvent -> IO (Either Text ())
insertAgentEvent client evt = do
  let eventTypeStr = case evt.eventType of
        AgentMessage    -> "message"
        AgentToolCall   -> "tool_call"
        AgentToolResult -> "tool_result"
        AgentError      -> "error"
      sql = T.unlines
        [ "INSERT INTO agent_events"
        , "(org_id, session_id, user_id, event_type, model, input_tokens, output_tokens,"
        , " duration_ms, tool_name, timestamp)"
        , "VALUES"
        , "('" <> escapeString evt.orgId <> "',"
        , " '" <> escapeString evt.sessionId <> "',"
        , " '" <> escapeString evt.userId <> "',"
        , " '" <> eventTypeStr <> "',"
        , " '" <> escapeString evt.model <> "',"
        , " " <> T.pack (show evt.inputTokens) <> ","
        , " " <> T.pack (show evt.outputTokens) <> ","
        , " " <> T.pack (show evt.durationMs) <> ","
        , " " <> maybeText evt.toolName <> ","
        , " now())"
        ]
  execute client sql

insertProxyEvent :: ClickHouseClient -> ProxyEvent -> IO (Either Text ())
insertProxyEvent client evt = do
  let sql = T.unlines
        [ "INSERT INTO proxy_events"
        , "(org_id, endpoint_id, provider, model, input_tokens, output_tokens,"
        , " latency_ms, cached, verified, status_code, timestamp)"
        , "VALUES"
        , "('" <> escapeString evt.orgId <> "',"
        , " '" <> escapeString evt.endpointId <> "',"
        , " '" <> escapeString evt.provider <> "',"
        , " '" <> escapeString evt.model <> "',"
        , " " <> T.pack (show evt.inputTokens) <> ","
        , " " <> T.pack (show evt.outputTokens) <> ","
        , " " <> T.pack (show evt.latencyMs) <> ","
        , " " <> (if evt.cached then "1" else "0") <> ","
        , " " <> (if evt.verified then "1" else "0") <> ","
        , " " <> T.pack (show evt.statusCode) <> ","
        , " now())"
        ]
  execute client sql

-- ============================================================
-- Helpers
-- ============================================================

maybeText :: Maybe Text -> Text
maybeText Nothing  = "NULL"
maybeText (Just t) = "'" <> escapeString t <> "'"

maybeInt :: Maybe Int -> Text
maybeInt Nothing  = "NULL"
maybeInt (Just n) = T.pack (show n)

escapeString :: Text -> Text
escapeString = T.replace "'" "''"
