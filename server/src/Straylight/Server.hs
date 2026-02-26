{-# LANGUAGE StrictData #-}
-- | Straylight Server
-- | Servant handlers for all 10 products
module Straylight.Server
  ( mkApp
  , StraylightServer
  ) where

import Control.Monad.IO.Class (liftIO)
import Data.Aeson (Value(..), object, (.=))
import Data.Maybe (fromMaybe)
import Data.String (fromString)
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.UUID as UUID
import Network.Wai (Application)
import Network.Wai.Middleware.Cors
import Servant

import Api
import Api.Types
import Straylight.Env (AppEnv(..))
import qualified Straylight.Postgres as PG
import qualified Straylight.ClickHouse as CH

-- ============================================================
-- Server Type
-- ============================================================

type StraylightServer = Server StraylightAPI

-- ============================================================
-- WAI Application
-- ============================================================

mkApp :: AppEnv -> Application
mkApp env = corsMiddleware $ serve straylightApi (server env)

corsMiddleware :: Application -> Application
corsMiddleware = cors $ const $ Just CorsResourcePolicy
  { corsOrigins = Nothing  -- Allow all origins in dev
  , corsMethods = ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"]
  , corsRequestHeaders = ["Content-Type", "Authorization", "Accept"]
  , corsExposedHeaders = Nothing
  , corsMaxAge = Just 86400
  , corsVaryOrigin = True
  , corsRequireOrigin = False
  , corsIgnoreFailures = False
  }

-- ============================================================
-- Server Implementation
-- ============================================================

server :: AppEnv -> StraylightServer
server env =
  -- OpenAPI endpoints
  openApiServer env
  -- sensenet products
  :<|> cacheServer env
  :<|> buildServer env
  :<|> convergeServer env
  :<|> confirmServer env
  :<|> forgeServer env
  :<|> publishServer env
  -- omega products
  :<|> codeServer env
  :<|> workServer env
  :<|> proxyServer env
  :<|> boostServer env

-- ============================================================
-- OpenAPI Handlers
-- ============================================================

openApiServer :: AppEnv -> Server OpenApiEndpoints
openApiServer _env =
  -- Individual specs
  pure cacheOpenApiSpec
  :<|> pure buildOpenApiSpec
  :<|> pure convergeOpenApiSpec
  :<|> pure confirmOpenApiSpec
  :<|> pure forgeOpenApiSpec
  :<|> pure publishOpenApiSpec
  :<|> pure codeOpenApiSpec
  :<|> pure workOpenApiSpec
  :<|> pure proxyOpenApiSpec
  :<|> pure boostOpenApiSpec
  -- Combined spec
  :<|> pure combinedOpenApiSpec
  -- Spec index
  :<|> pure openApiIndex

-- Placeholder specs (would be generated from servant-openapi3)
cacheOpenApiSpec, buildOpenApiSpec, convergeOpenApiSpec, confirmOpenApiSpec :: Value
forgeOpenApiSpec, publishOpenApiSpec, codeOpenApiSpec, workOpenApiSpec :: Value
proxyOpenApiSpec, boostOpenApiSpec, combinedOpenApiSpec, openApiIndex :: Value

cacheOpenApiSpec = object ["openapi" .= ("3.1.0" :: Text), "info" .= object ["title" .= ("sensenet//cache" :: Text), "version" .= ("0.1.0" :: Text)]]
buildOpenApiSpec = object ["openapi" .= ("3.1.0" :: Text), "info" .= object ["title" .= ("sensenet//build" :: Text), "version" .= ("0.1.0" :: Text)]]
convergeOpenApiSpec = object ["openapi" .= ("3.1.0" :: Text), "info" .= object ["title" .= ("sensenet//converge" :: Text), "version" .= ("0.1.0" :: Text)]]
confirmOpenApiSpec = object ["openapi" .= ("3.1.0" :: Text), "info" .= object ["title" .= ("sensenet//confirm" :: Text), "version" .= ("0.1.0" :: Text)]]
forgeOpenApiSpec = object ["openapi" .= ("3.1.0" :: Text), "info" .= object ["title" .= ("sensenet//forge" :: Text), "version" .= ("0.1.0" :: Text)]]
publishOpenApiSpec = object ["openapi" .= ("3.1.0" :: Text), "info" .= object ["title" .= ("sensenet//publish" :: Text), "version" .= ("0.1.0" :: Text)]]
codeOpenApiSpec = object ["openapi" .= ("3.1.0" :: Text), "info" .= object ["title" .= ("omega//code" :: Text), "version" .= ("0.1.0" :: Text)]]
workOpenApiSpec = object ["openapi" .= ("3.1.0" :: Text), "info" .= object ["title" .= ("omega//work" :: Text), "version" .= ("0.1.0" :: Text)]]
proxyOpenApiSpec = object ["openapi" .= ("3.1.0" :: Text), "info" .= object ["title" .= ("omega//proxy" :: Text), "version" .= ("0.1.0" :: Text)]]
boostOpenApiSpec = object ["openapi" .= ("3.1.0" :: Text), "info" .= object ["title" .= ("omega//boost" :: Text), "version" .= ("0.1.0" :: Text)]]
combinedOpenApiSpec = object ["openapi" .= ("3.1.0" :: Text), "info" .= object ["title" .= ("Straylight API" :: Text), "version" .= ("0.1.0" :: Text)]]
openApiIndex = object 
  [ "specs" .= 
    [ object ["name" .= ("sensenet//cache" :: Text), "url" .= ("/openapi/sensenet/cache.json" :: Text)]
    , object ["name" .= ("sensenet//build" :: Text), "url" .= ("/openapi/sensenet/build.json" :: Text)]
    , object ["name" .= ("sensenet//converge" :: Text), "url" .= ("/openapi/sensenet/converge.json" :: Text)]
    , object ["name" .= ("sensenet//confirm" :: Text), "url" .= ("/openapi/sensenet/confirm.json" :: Text)]
    , object ["name" .= ("sensenet//forge" :: Text), "url" .= ("/openapi/sensenet/forge.json" :: Text)]
    , object ["name" .= ("sensenet//publish" :: Text), "url" .= ("/openapi/sensenet/publish.json" :: Text)]
    , object ["name" .= ("omega//code" :: Text), "url" .= ("/openapi/omega/code.json" :: Text)]
    , object ["name" .= ("omega//work" :: Text), "url" .= ("/openapi/omega/work.json" :: Text)]
    , object ["name" .= ("omega//proxy" :: Text), "url" .= ("/openapi/omega/proxy.json" :: Text)]
    , object ["name" .= ("omega//boost" :: Text), "url" .= ("/openapi/omega/boost.json" :: Text)]
    ]
  ]

-- ============================================================
-- sensenet//cache Handlers
-- ============================================================

cacheServer :: AppEnv -> Server SimpleCacheAPI
cacheServer env =
  listCaches env
  :<|> createCacheHandler env
  :<|> getCacheHandler env
  :<|> deleteCacheHandler env

listCaches :: AppEnv -> Handler [CacheResponse]
listCaches env = do
  rows <- liftIO $ PG.listCaches env.postgres env.defaultOrgId
  pure $ map cacheRowToResponse rows

createCacheHandler :: AppEnv -> CreateCacheReq -> Handler CacheResponse
createCacheHandler env req = do
  let publicKey = req.cacheName <> ".cache.sensenet.digital:NewKey123456789=="
      substituterUrl = "https://cache.sensenet.digital/" <> req.cacheName
  row <- liftIO $ PG.createCache env.postgres env.defaultOrgId req.cacheName req.cacheIsPrivate publicKey substituterUrl
  pure $ cacheRowToResponse row

getCacheHandler :: AppEnv -> Text -> Handler CacheResponse
getCacheHandler env cacheIdText = do
  case UUID.fromText cacheIdText of
    Nothing -> throwError err400 { errBody = "Invalid cache ID format" }
    Just cacheId -> do
      mRow <- liftIO $ PG.getCache env.postgres env.defaultOrgId cacheId
      case mRow of
        Nothing -> throwError err404 { errBody = "Cache not found" }
        Just row -> pure $ cacheRowToResponse row

deleteCacheHandler :: AppEnv -> Text -> Handler NoContent
deleteCacheHandler env cacheIdText = do
  case UUID.fromText cacheIdText of
    Nothing -> throwError err400 { errBody = "Invalid cache ID format" }
    Just cacheId -> do
      liftIO $ PG.deleteCache env.postgres env.defaultOrgId cacheId
      pure NoContent

cacheRowToResponse :: PG.CacheRow -> CacheResponse
cacheRowToResponse row = CacheResponse
  { cacheId = UUID.toText row.cacheRowId
  , cacheName = row.cacheRowName
  , cacheIsPrivate = row.cacheRowIsPrivate
  , cacheSizeBytes = row.cacheRowSizeBytes
  , cachePathCount = row.cacheRowPathCount
  , cachePublicKey = row.cacheRowPublicKey
  , cacheSubstituterUrl = row.cacheRowSubstituterUrl
  }

-- ============================================================
-- sensenet//build Handlers
-- ============================================================

buildServer :: AppEnv -> Server SimpleBuildAPI
buildServer env =
  listBuilds env
  :<|> triggerBuild env
  :<|> getBuildHandler env

listBuilds :: AppEnv -> Maybe Int -> Maybe Int -> Handler [BuildResponse]
listBuilds env mLimit mOffset = do
  rows <- liftIO $ PG.listBuilds env.postgres env.defaultOrgId Nothing mLimit mOffset
  pure $ map buildRowToResponse rows

triggerBuild :: AppEnv -> TriggerBuildReq -> Handler BuildResponse
triggerBuild env req = do
  row <- liftIO $ PG.createBuild env.postgres env.defaultOrgId Nothing req.buildName (Just req.buildFlakeRef) "api" Nothing Nothing
  -- Record event to ClickHouse
  let event = CH.BuildEvent
        { orgId = UUID.toText env.defaultOrgId
        , buildId = UUID.toText row.buildRowId
        , cacheId = "default"
        , eventType = CH.BuildQueued
        , name = req.buildName
        , flakeRef = Just req.buildFlakeRef
        , commit = Nothing
        , branch = Nothing
        , durationMs = 0
        , pathsBuilt = 0
        , pathsCached = 0
        , pathsUploaded = 0
        , exitCode = Nothing
        , errorMessage = Nothing
        , triggeredBy = "api"
        }
  _ <- liftIO $ CH.insertBuildEvent env.clickhouse event
  pure $ buildRowToResponse row

getBuildHandler :: AppEnv -> Text -> Handler BuildResponse
getBuildHandler env buildIdText = do
  case UUID.fromText buildIdText of
    Nothing -> throwError err400 { errBody = "Invalid build ID format" }
    Just buildId -> do
      mRow <- liftIO $ PG.getBuild env.postgres env.defaultOrgId buildId
      case mRow of
        Nothing -> throwError err404 { errBody = "Build not found" }
        Just row -> pure $ buildRowToResponse row

buildRowToResponse :: PG.BuildRow -> BuildResponse
buildRowToResponse row = BuildResponse
  { buildId = UUID.toText row.buildRowId
  , buildName = row.buildRowName
  , buildFlakeRef = row.buildRowFlakeRef
  , buildStatus = row.buildRowStatus
  , buildDurationMs = row.buildRowDurationMs
  , buildPathsBuilt = row.buildRowPathsBuilt
  , buildPathsCached = row.buildRowPathsCached
  }

-- ============================================================
-- sensenet//converge Handlers (stub)
-- ============================================================

convergeServer :: AppEnv -> Server SimpleConvergeAPI
convergeServer _env =
  pure []  -- listResources
  :<|> (\_ -> throwError err501)  -- getResource
  :<|> (\_ -> throwError err501)  -- syncResource

-- ============================================================
-- sensenet//confirm Handlers (stub)
-- ============================================================

confirmServer :: AppEnv -> Server SimpleConfirmAPI
confirmServer _env =
  pure []  -- listPipelines
  :<|> (\_ -> throwError err501)  -- getPipeline
  :<|> (\_ -> throwError err501)  -- triggerPipeline

-- ============================================================
-- sensenet//forge Handlers (stub)
-- ============================================================

forgeServer :: AppEnv -> Server SimpleForgeAPI
forgeServer _env =
  pure []  -- listStacks
  :<|> (\_ -> throwError err501)  -- getStack
  :<|> (\_ -> throwError err501)  -- createStack

-- ============================================================
-- sensenet//publish Handlers (stub)
-- ============================================================

publishServer :: AppEnv -> Server SimplePublishAPI
publishServer _env =
  pure []  -- listDocSites
  :<|> (\_ -> throwError err501)  -- getDocSite
  :<|> (\_ -> throwError err501)  -- createDocSite

-- ============================================================
-- omega//code Handlers
-- ============================================================

codeServer :: AppEnv -> Server SimpleCodeAPI
codeServer env =
  listAgentSessions env
  :<|> createAgentSession env
  :<|> getAgentSessionHandler env

listAgentSessions :: AppEnv -> Handler [AgentSessionResponse]
listAgentSessions env = do
  rows <- liftIO $ PG.listAgentSessions env.postgres env.defaultOrgId Nothing
  pure $ map agentSessionRowToResponse rows

createAgentSession :: AppEnv -> CreateAgentSessionReq -> Handler AgentSessionResponse
createAgentSession env req = do
  row <- liftIO $ PG.createAgentSession env.postgres env.defaultOrgId env.defaultOrgId req.sessionDirectory req.sessionModel
  pure $ agentSessionRowToResponse row

getAgentSessionHandler :: AppEnv -> Text -> Handler AgentSessionResponse
getAgentSessionHandler env sessionIdText = do
  case UUID.fromText sessionIdText of
    Nothing -> throwError err400 { errBody = "Invalid session ID format" }
    Just sessionId -> do
      mRow <- liftIO $ PG.getAgentSession env.postgres env.defaultOrgId sessionId
      case mRow of
        Nothing -> throwError err404 { errBody = "Session not found" }
        Just row -> pure $ agentSessionRowToResponse row

agentSessionRowToResponse :: PG.AgentSessionRow -> AgentSessionResponse
agentSessionRowToResponse row = AgentSessionResponse
  { sessionId = UUID.toText row.agentSessionRowId
  , sessionDirectory = row.agentSessionRowDirectory
  , sessionStatus = row.agentSessionRowStatus
  , sessionModel = row.agentSessionRowModel
  , sessionTotalTokens = row.agentSessionRowTotalTokens
  }

-- ============================================================
-- omega//work Handlers
-- ============================================================

workServer :: AppEnv -> Server SimpleWorkAPI
workServer env =
  listWorkspaces env
  :<|> createWorkspaceHandler env
  :<|> getWorkspaceHandler env

listWorkspaces :: AppEnv -> Handler [WorkspaceResponse]
listWorkspaces env = do
  rows <- liftIO $ PG.listWorkspaces env.postgres env.defaultOrgId
  pure $ map workspaceRowToResponse rows

createWorkspaceHandler :: AppEnv -> CreateWorkspaceReq -> Handler WorkspaceResponse
createWorkspaceHandler env req = do
  row <- liftIO $ PG.createWorkspace env.postgres env.defaultOrgId env.defaultOrgId req.workspaceName req.workspaceType
  pure $ workspaceRowToResponse row

getWorkspaceHandler :: AppEnv -> Text -> Handler WorkspaceResponse
getWorkspaceHandler env workspaceIdText = do
  case UUID.fromText workspaceIdText of
    Nothing -> throwError err400 { errBody = "Invalid workspace ID format" }
    Just workspaceId -> do
      mRow <- liftIO $ PG.getWorkspace env.postgres env.defaultOrgId workspaceId
      case mRow of
        Nothing -> throwError err404 { errBody = "Workspace not found" }
        Just row -> pure $ workspaceRowToResponse row

workspaceRowToResponse :: PG.WorkspaceRow -> WorkspaceResponse
workspaceRowToResponse row = WorkspaceResponse
  { workspaceId = UUID.toText row.workspaceRowId
  , workspaceName = row.workspaceRowName
  , workspaceType = row.workspaceRowType
  }

-- ============================================================
-- omega//proxy Handlers (stub)
-- ============================================================

proxyServer :: AppEnv -> Server SimpleProxyAPI
proxyServer _env =
  pure []  -- listEndpoints
  :<|> (\_ -> throwError err501)  -- getEndpoint
  :<|> (\_ -> throwError err501)  -- createEndpoint

-- ============================================================
-- omega//boost Handlers (stub)
-- ============================================================

boostServer :: AppEnv -> Server SimpleBoostAPI
boostServer _env =
  pure []  -- listModels
  :<|> (\_ -> throwError err501)  -- getModel
  :<|> (\_ -> throwError err501)  -- createInferenceJob
