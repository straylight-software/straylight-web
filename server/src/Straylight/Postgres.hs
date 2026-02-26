{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeApplications #-}

-- | PostgreSQL database layer for Straylight
-- | Handles connection pooling and queries for all 10 products
module Straylight.Postgres
  ( -- * Configuration
    PostgresConfig (..)
  , configFromEnv

    -- * Connection Pool
  , PostgresPool
  , newPool
  , withConnection

    -- * Row Types
  , OrgRow (..)
  , UserRow (..)
  , TeamMemberRow (..)
  , ApiKeyRow (..)
  , AuditLogRow (..)
  -- sensenet//cache
  , CacheRow (..)
  , StorePathRow (..)
  -- sensenet//build
  , BuildRow (..)
  -- omega//code
  , AgentSessionRow (..)
  -- omega//work
  , WorkspaceRow (..)

    -- * Queries: Organizations
  , getOrgBySlug
  , getOrgById

    -- * Queries: Caches
  , listCaches
  , getCache
  , createCache
  , deleteCache

    -- * Queries: Builds
  , listBuilds
  , getBuild
  , createBuild
  , updateBuildStatus

    -- * Queries: Team
  , listTeamMembers
  , createTeamMember

    -- * Queries: API Keys
  , listApiKeys
  , createApiKey
  , deleteApiKey

    -- * Queries: Agent Sessions
  , listAgentSessions
  , getAgentSession
  , createAgentSession

    -- * Queries: Workspaces
  , listWorkspaces
  , getWorkspace
  , createWorkspace
  ) where

import Data.Pool (Pool, withResource, defaultPoolConfig, setNumStripes)
import qualified Data.Pool
import Data.Text (Text)
import qualified Data.Text as T
import Data.Time (UTCTime, getCurrentTime)
import Data.UUID (UUID)
import qualified Data.UUID.V4 as UUID
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.SqlQQ (sql)
import Database.PostgreSQL.Simple.Types (PGArray(..))
import GHC.Generics (Generic)
import System.Environment (lookupEnv)

-- ═══════════════════════════════════════════════════════════════════════════════
--                                                               // configuration
-- ═══════════════════════════════════════════════════════════════════════════════

data PostgresConfig = PostgresConfig
  { pgHost :: Text
  , pgPort :: Int
  , pgUser :: Text
  , pgPassword :: Text
  , pgDatabase :: Text
  }
  deriving stock (Show, Eq, Generic)

configFromEnv :: IO (Maybe PostgresConfig)
configFromEnv = do
  mHost <- lookupEnv "POSTGRES_HOST"
  mUser <- lookupEnv "POSTGRES_USER"
  mPassword <- lookupEnv "POSTGRES_PASSWORD"
  mDatabase <- lookupEnv "POSTGRES_DATABASE"
  mPort <- lookupEnv "POSTGRES_PORT"
  pure $ do
    host <- T.pack <$> mHost
    user <- T.pack <$> mUser
    password <- T.pack <$> mPassword
    database <- T.pack <$> mDatabase
    let port = maybe 5432 read mPort
    Just PostgresConfig
      { pgHost = host
      , pgPort = port
      , pgUser = user
      , pgPassword = password
      , pgDatabase = database
      }

-- ═══════════════════════════════════════════════════════════════════════════════
--                                                              // connection pool
-- ═══════════════════════════════════════════════════════════════════════════════

type PostgresPool = Pool Connection

newPool :: PostgresConfig -> IO PostgresPool
newPool cfg = do
  let connInfo = defaultConnectInfo
        { connectHost = T.unpack cfg.pgHost
        , connectPort = fromIntegral cfg.pgPort
        , connectUser = T.unpack cfg.pgUser
        , connectPassword = T.unpack cfg.pgPassword
        , connectDatabase = T.unpack cfg.pgDatabase
        }
  Data.Pool.newPool $ setNumStripes (Just 1) $ defaultPoolConfig
    (connect connInfo)
    close
    10
    10

withConnection :: PostgresPool -> (Connection -> IO a) -> IO a
withConnection = withResource

-- ═══════════════════════════════════════════════════════════════════════════════
--                                                                    // row types
-- ═══════════════════════════════════════════════════════════════════════════════

data OrgRow = OrgRow
  { orgId :: UUID
  , orgName :: Text
  , orgSlug :: Text
  , orgTier :: Text
  , orgCreatedAt :: UTCTime
  }
  deriving stock (Show, Eq, Generic)

instance FromRow OrgRow where
  fromRow = OrgRow <$> field <*> field <*> field <*> field <*> field

data UserRow = UserRow
  { userId :: UUID
  , userClerkId :: Text
  , userEmail :: Text
  , userFirstName :: Maybe Text
  , userLastName :: Maybe Text
  , userAvatarUrl :: Maybe Text
  , userCreatedAt :: UTCTime
  }
  deriving stock (Show, Eq, Generic)

instance FromRow UserRow where
  fromRow = UserRow <$> field <*> field <*> field <*> field <*> field <*> field <*> field

data TeamMemberRow = TeamMemberRow
  { teamMemberRowId :: UUID
  , teamMemberRowOrgId :: UUID
  , teamMemberRowUserId :: UUID
  , teamMemberRowRole :: Text
  , teamMemberRowJoinedAt :: UTCTime
  , teamMemberRowLastActive :: Maybe UTCTime
  , teamMemberRowEmail :: Text
  , teamMemberRowFirstName :: Maybe Text
  , teamMemberRowLastName :: Maybe Text
  , teamMemberRowAvatarUrl :: Maybe Text
  }
  deriving stock (Show, Eq, Generic)

instance FromRow TeamMemberRow where
  fromRow = TeamMemberRow 
    <$> field <*> field <*> field <*> field <*> field
    <*> field <*> field <*> field <*> field <*> field

data ApiKeyRow = ApiKeyRow
  { apiKeyRowId :: UUID
  , apiKeyRowOrgId :: UUID
  , apiKeyRowProduct :: Text
  , apiKeyRowName :: Text
  , apiKeyRowPrefix :: Text
  , apiKeyRowScopes :: [Text]
  , apiKeyRowCreatedAt :: UTCTime
  , apiKeyRowLastUsed :: Maybe UTCTime
  , apiKeyRowExpiresAt :: Maybe UTCTime
  }
  deriving stock (Show, Eq, Generic)

instance FromRow ApiKeyRow where
  fromRow = ApiKeyRow 
    <$> field <*> field <*> field <*> field <*> field
    <*> (fromPGArray <$> field) <*> field <*> field <*> field

data AuditLogRow = AuditLogRow
  { auditLogRowId :: UUID
  , auditLogRowOrgId :: UUID
  , auditLogRowProduct :: Text
  , auditLogRowActorId :: Text
  , auditLogRowActorEmail :: Maybe Text
  , auditLogRowAction :: Text
  , auditLogRowTargetType :: Maybe Text
  , auditLogRowTargetId :: Maybe Text
  , auditLogRowDetails :: Text
  , auditLogRowCreatedAt :: UTCTime
  }
  deriving stock (Show, Eq, Generic)

instance FromRow AuditLogRow where
  fromRow = AuditLogRow 
    <$> field <*> field <*> field <*> field <*> field
    <*> field <*> field <*> field <*> field <*> field

-- sensenet//cache
data CacheRow = CacheRow
  { cacheRowId :: UUID
  , cacheRowOrgId :: UUID
  , cacheRowName :: Text
  , cacheRowIsPrivate :: Bool
  , cacheRowStatus :: Text
  , cacheRowSizeBytes :: Integer
  , cacheRowPathCount :: Int
  , cacheRowLastPush :: Maybe UTCTime
  , cacheRowPublicKey :: Text
  , cacheRowSubstituterUrl :: Text
  , cacheRowRetentionDays :: Int
  , cacheRowMaxSizeBytes :: Integer
  , cacheRowGcEnabled :: Bool
  , cacheRowCreatedAt :: UTCTime
  }
  deriving stock (Show, Eq, Generic)

instance FromRow CacheRow where
  fromRow = CacheRow 
    <$> field <*> field <*> field <*> field <*> field
    <*> field <*> field <*> field <*> field <*> field 
    <*> field <*> field <*> field <*> field

data StorePathRow = StorePathRow
  { storePathRowId :: UUID
  , storePathRowCacheId :: UUID
  , storePathRowHash :: Text
  , storePathRowName :: Text
  , storePathRowVersion :: Text
  , storePathRowSizeBytes :: Integer
  , storePathRowNarSizeBytes :: Integer
  , storePathRowClosureSizeBytes :: Integer
  , storePathRowDeriver :: Maybe Text
  , storePathRowRegistrationTime :: UTCTime
  , storePathRowNarHash :: Text
  , storePathRowSignatures :: [Text]
  , storePathRowCa :: Maybe Text
  , storePathRowCreatedAt :: UTCTime
  }
  deriving stock (Show, Eq, Generic)

instance FromRow StorePathRow where
  fromRow = StorePathRow 
    <$> field <*> field <*> field <*> field <*> field
    <*> field <*> field <*> field <*> field <*> field
    <*> field <*> (fromPGArray <$> field) <*> field <*> field

-- sensenet//build
data BuildRow = BuildRow
  { buildRowId :: UUID
  , buildRowOrgId :: UUID
  , buildRowCacheId :: Maybe UUID
  , buildRowName :: Text
  , buildRowFlakeRef :: Maybe Text
  , buildRowStatus :: Text
  , buildRowDurationMs :: Maybe Int
  , buildRowStartTime :: Maybe UTCTime
  , buildRowEndTime :: Maybe UTCTime
  , buildRowCommitSha :: Maybe Text
  , buildRowBranch :: Maybe Text
  , buildRowPathsBuilt :: Int
  , buildRowPathsCached :: Int
  , buildRowPathsUploaded :: Int
  , buildRowExitCode :: Maybe Int
  , buildRowErrorMessage :: Maybe Text
  , buildRowTriggeredBy :: Text
  , buildRowLogUrl :: Maybe Text
  , buildRowCreatedAt :: UTCTime
  }
  deriving stock (Show, Eq, Generic)

instance FromRow BuildRow where
  fromRow = BuildRow 
    <$> field <*> field <*> field <*> field <*> field
    <*> field <*> field <*> field <*> field <*> field
    <*> field <*> field <*> field <*> field <*> field
    <*> field <*> field <*> field <*> field

-- omega//code
data AgentSessionRow = AgentSessionRow
  { agentSessionRowId :: UUID
  , agentSessionRowOrgId :: UUID
  , agentSessionRowUserId :: UUID
  , agentSessionRowName :: Maybe Text
  , agentSessionRowDirectory :: Text
  , agentSessionRowStatus :: Text
  , agentSessionRowModel :: Text
  , agentSessionRowTotalTokens :: Int
  , agentSessionRowTotalCostCents :: Int
  , agentSessionRowCreatedAt :: UTCTime
  , agentSessionRowLastActive :: Maybe UTCTime
  }
  deriving stock (Show, Eq, Generic)

instance FromRow AgentSessionRow where
  fromRow = AgentSessionRow 
    <$> field <*> field <*> field <*> field <*> field
    <*> field <*> field <*> field <*> field <*> field <*> field

-- omega//work
data WorkspaceRow = WorkspaceRow
  { workspaceRowId :: UUID
  , workspaceRowOrgId :: UUID
  , workspaceRowOwnerId :: UUID
  , workspaceRowName :: Text
  , workspaceRowType :: Text
  , workspaceRowCreatedAt :: UTCTime
  , workspaceRowUpdatedAt :: UTCTime
  }
  deriving stock (Show, Eq, Generic)

instance FromRow WorkspaceRow where
  fromRow = WorkspaceRow 
    <$> field <*> field <*> field <*> field <*> field <*> field <*> field

-- ═══════════════════════════════════════════════════════════════════════════════
--                                                       // queries: organizations
-- ═══════════════════════════════════════════════════════════════════════════════

getOrgBySlug :: PostgresPool -> Text -> IO (Maybe OrgRow)
getOrgBySlug pool slug = withConnection pool $ \conn -> do
  rows <- query conn 
    [sql| SELECT id, name, slug, tier::text, created_at FROM organizations WHERE slug = ? |]
    (Only slug)
  pure $ case rows of
    [row] -> Just row
    _ -> Nothing

getOrgById :: PostgresPool -> UUID -> IO (Maybe OrgRow)
getOrgById pool orgId = withConnection pool $ \conn -> do
  rows <- query conn 
    [sql| SELECT id, name, slug, tier::text, created_at FROM organizations WHERE id = ? |]
    (Only orgId)
  pure $ case rows of
    [row] -> Just row
    _ -> Nothing

-- ═══════════════════════════════════════════════════════════════════════════════
--                                                              // queries: caches
-- ═══════════════════════════════════════════════════════════════════════════════

listCaches :: PostgresPool -> UUID -> IO [CacheRow]
listCaches pool orgId = withConnection pool $ \conn ->
  query conn
    [sql| SELECT id, org_id, name, is_private, status::text, size_bytes, path_count,
                 last_push, public_key, substituter_url, retention_days,
                 max_size_bytes, gc_enabled, created_at
          FROM caches
          WHERE org_id = ?
          ORDER BY created_at DESC |]
    (Only orgId)

getCache :: PostgresPool -> UUID -> UUID -> IO (Maybe CacheRow)
getCache pool orgId cacheId = withConnection pool $ \conn -> do
  rows <- query conn
    [sql| SELECT id, org_id, name, is_private, status::text, size_bytes, path_count,
                 last_push, public_key, substituter_url, retention_days,
                 max_size_bytes, gc_enabled, created_at
          FROM caches
          WHERE org_id = ? AND id = ? |]
    (orgId, cacheId)
  pure $ case rows of
    [row] -> Just row
    _ -> Nothing

createCache :: PostgresPool -> UUID -> Text -> Bool -> Text -> Text -> IO CacheRow
createCache pool orgId name isPrivate publicKey substituterUrl = withConnection pool $ \conn -> do
  newId <- UUID.nextRandom
  now <- getCurrentTime
  _ <- execute conn
    [sql| INSERT INTO caches (id, org_id, name, is_private, public_key, substituter_url, created_at)
          VALUES (?, ?, ?, ?, ?, ?, ?) |]
    (newId, orgId, name, isPrivate, publicKey, substituterUrl, now)
  pure CacheRow
    { cacheRowId = newId
    , cacheRowOrgId = orgId
    , cacheRowName = name
    , cacheRowIsPrivate = isPrivate
    , cacheRowStatus = "active"
    , cacheRowSizeBytes = 0
    , cacheRowPathCount = 0
    , cacheRowLastPush = Nothing
    , cacheRowPublicKey = publicKey
    , cacheRowSubstituterUrl = substituterUrl
    , cacheRowRetentionDays = 30
    , cacheRowMaxSizeBytes = 10737418240
    , cacheRowGcEnabled = True
    , cacheRowCreatedAt = now
    }

deleteCache :: PostgresPool -> UUID -> UUID -> IO ()
deleteCache pool orgId cacheId = withConnection pool $ \conn ->
  void $ execute conn
    [sql| DELETE FROM caches WHERE org_id = ? AND id = ? |]
    (orgId, cacheId)
  where
    void :: IO a -> IO ()
    void = fmap (const ())

-- ═══════════════════════════════════════════════════════════════════════════════
--                                                              // queries: builds
-- ═══════════════════════════════════════════════════════════════════════════════

listBuilds :: PostgresPool -> UUID -> Maybe Text -> Maybe Int -> Maybe Int -> IO [BuildRow]
listBuilds pool orgId mStatus mLimit mOffset = withConnection pool $ \conn ->
  case mStatus of
    Nothing ->
      query conn
        [sql| SELECT id, org_id, cache_id, name, flake_ref, status::text, duration_ms,
                     start_time, end_time, commit_sha, branch, paths_built,
                     paths_cached, paths_uploaded, exit_code, error_message,
                     triggered_by, log_url, created_at
              FROM builds
              WHERE org_id = ?
              ORDER BY created_at DESC
              LIMIT ? OFFSET ? |]
        (orgId, maybe 50 id mLimit, maybe 0 id mOffset)
    Just status ->
      query conn
        [sql| SELECT id, org_id, cache_id, name, flake_ref, status::text, duration_ms,
                     start_time, end_time, commit_sha, branch, paths_built,
                     paths_cached, paths_uploaded, exit_code, error_message,
                     triggered_by, log_url, created_at
              FROM builds
              WHERE org_id = ? AND status = ?::build_status
              ORDER BY created_at DESC
              LIMIT ? OFFSET ? |]
        (orgId, status, maybe 50 id mLimit, maybe 0 id mOffset)

getBuild :: PostgresPool -> UUID -> UUID -> IO (Maybe BuildRow)
getBuild pool orgId buildId = withConnection pool $ \conn -> do
  rows <- query conn
    [sql| SELECT id, org_id, cache_id, name, flake_ref, status::text, duration_ms,
                 start_time, end_time, commit_sha, branch, paths_built,
                 paths_cached, paths_uploaded, exit_code, error_message,
                 triggered_by, log_url, created_at
          FROM builds
          WHERE org_id = ? AND id = ? |]
    (orgId, buildId)
  pure $ case rows of
    [row] -> Just row
    _ -> Nothing

createBuild :: PostgresPool -> UUID -> Maybe UUID -> Text -> Maybe Text -> Text -> Maybe Text -> Maybe Text -> IO BuildRow
createBuild pool orgId mCacheId name mFlakeRef triggeredBy mCommit mBranch = withConnection pool $ \conn -> do
  newId <- UUID.nextRandom
  now <- getCurrentTime
  _ <- execute conn
    [sql| INSERT INTO builds (id, org_id, cache_id, name, flake_ref, status, triggered_by, commit_sha, branch, created_at)
          VALUES (?, ?, ?, ?, ?, 'pending', ?, ?, ?, ?) |]
    (newId, orgId, mCacheId, name, mFlakeRef, triggeredBy, mCommit, mBranch, now)
  pure BuildRow
    { buildRowId = newId
    , buildRowOrgId = orgId
    , buildRowCacheId = mCacheId
    , buildRowName = name
    , buildRowFlakeRef = mFlakeRef
    , buildRowStatus = "pending"
    , buildRowDurationMs = Nothing
    , buildRowStartTime = Nothing
    , buildRowEndTime = Nothing
    , buildRowCommitSha = mCommit
    , buildRowBranch = mBranch
    , buildRowPathsBuilt = 0
    , buildRowPathsCached = 0
    , buildRowPathsUploaded = 0
    , buildRowExitCode = Nothing
    , buildRowErrorMessage = Nothing
    , buildRowTriggeredBy = triggeredBy
    , buildRowLogUrl = Nothing
    , buildRowCreatedAt = now
    }

updateBuildStatus :: PostgresPool -> UUID -> Text -> Maybe Int -> Maybe Int -> Maybe Int -> IO ()
updateBuildStatus pool buildId status mDuration mPathsBuilt mPathsCached = withConnection pool $ \conn -> do
  now <- getCurrentTime
  void $ execute conn
    [sql| UPDATE builds 
          SET status = ?::build_status,
              duration_ms = COALESCE(?, duration_ms),
              paths_built = COALESCE(?, paths_built),
              paths_cached = COALESCE(?, paths_cached),
              end_time = CASE WHEN ? IN ('success', 'failed', 'cancelled') THEN ? ELSE end_time END,
              start_time = CASE WHEN ? = 'running' AND start_time IS NULL THEN ? ELSE start_time END
          WHERE id = ? |]
    (status, mDuration, mPathsBuilt, mPathsCached, status, now, status, now, buildId)
  where
    void :: IO a -> IO ()
    void = fmap (const ())

-- ═══════════════════════════════════════════════════════════════════════════════
--                                                               // queries: team
-- ═══════════════════════════════════════════════════════════════════════════════

listTeamMembers :: PostgresPool -> UUID -> IO [TeamMemberRow]
listTeamMembers pool orgId = withConnection pool $ \conn ->
  query conn
    [sql| SELECT tm.id, tm.org_id, tm.user_id, tm.role::text, tm.joined_at, tm.last_active,
                 u.email, u.first_name, u.last_name, u.avatar_url
          FROM team_members tm
          JOIN users u ON u.id = tm.user_id
          WHERE tm.org_id = ?
          ORDER BY tm.joined_at |]
    (Only orgId)

createTeamMember :: PostgresPool -> UUID -> Text -> Text -> Text -> IO TeamMemberRow
createTeamMember pool orgId email role clerkId = withConnection pool $ \conn -> do
  newUserId <- UUID.nextRandom
  newMemberId <- UUID.nextRandom
  now <- getCurrentTime
  _ <- execute conn
    [sql| INSERT INTO users (id, clerk_id, email, created_at)
          VALUES (?, ?, ?, ?)
          ON CONFLICT (email) DO NOTHING |]
    (newUserId, clerkId, email, now)
  [Only realUserId] <- query conn
    [sql| SELECT id FROM users WHERE email = ? |]
    (Only email)
  _ <- execute conn
    [sql| INSERT INTO team_members (id, org_id, user_id, role, joined_at)
          VALUES (?, ?, ?, ?::team_role, ?) |]
    (newMemberId, orgId, realUserId :: UUID, role, now)
  pure TeamMemberRow
    { teamMemberRowId = newMemberId
    , teamMemberRowOrgId = orgId
    , teamMemberRowUserId = realUserId
    , teamMemberRowRole = role
    , teamMemberRowJoinedAt = now
    , teamMemberRowLastActive = Nothing
    , teamMemberRowEmail = email
    , teamMemberRowFirstName = Nothing
    , teamMemberRowLastName = Nothing
    , teamMemberRowAvatarUrl = Nothing
    }

-- ═══════════════════════════════════════════════════════════════════════════════
--                                                            // queries: api keys
-- ═══════════════════════════════════════════════════════════════════════════════

listApiKeys :: PostgresPool -> UUID -> Maybe Text -> IO [ApiKeyRow]
listApiKeys pool orgId mProduct = withConnection pool $ \conn ->
  case mProduct of
    Nothing ->
      query conn
        [sql| SELECT id, org_id, product, name, prefix, scopes::text[], created_at, last_used, expires_at
              FROM api_keys
              WHERE org_id = ?
              ORDER BY created_at DESC |]
        (Only orgId)
    Just product ->
      query conn
        [sql| SELECT id, org_id, product, name, prefix, scopes::text[], created_at, last_used, expires_at
              FROM api_keys
              WHERE org_id = ? AND product = ?
              ORDER BY created_at DESC |]
        (orgId, product)

createApiKey :: PostgresPool -> UUID -> Text -> Text -> Text -> Text -> [Text] -> IO ApiKeyRow
createApiKey pool orgId product name keyHash prefix scopes = withConnection pool $ \conn -> do
  newId <- UUID.nextRandom
  now <- getCurrentTime
  _ <- execute conn
    [sql| INSERT INTO api_keys (id, org_id, product, name, key_hash, prefix, scopes, created_at)
          VALUES (?, ?, ?, ?, ?, ?, ?::api_scope[], ?) |]
    (newId, orgId, product, name, keyHash, prefix, PGArray scopes, now)
  pure ApiKeyRow
    { apiKeyRowId = newId
    , apiKeyRowOrgId = orgId
    , apiKeyRowProduct = product
    , apiKeyRowName = name
    , apiKeyRowPrefix = prefix
    , apiKeyRowScopes = scopes
    , apiKeyRowCreatedAt = now
    , apiKeyRowLastUsed = Nothing
    , apiKeyRowExpiresAt = Nothing
    }

deleteApiKey :: PostgresPool -> UUID -> UUID -> IO ()
deleteApiKey pool orgId keyId = withConnection pool $ \conn ->
  void $ execute conn
    [sql| DELETE FROM api_keys WHERE org_id = ? AND id = ? |]
    (orgId, keyId)
  where
    void :: IO a -> IO ()
    void = fmap (const ())

-- ═══════════════════════════════════════════════════════════════════════════════
--                                                     // queries: agent sessions
-- ═══════════════════════════════════════════════════════════════════════════════

listAgentSessions :: PostgresPool -> UUID -> Maybe UUID -> IO [AgentSessionRow]
listAgentSessions pool orgId mUserId = withConnection pool $ \conn ->
  case mUserId of
    Nothing ->
      query conn
        [sql| SELECT id, org_id, user_id, name, directory, status::text, model,
                     total_tokens, total_cost_cents, created_at, last_active
              FROM agent_sessions
              WHERE org_id = ?
              ORDER BY created_at DESC |]
        (Only orgId)
    Just userId ->
      query conn
        [sql| SELECT id, org_id, user_id, name, directory, status::text, model,
                     total_tokens, total_cost_cents, created_at, last_active
              FROM agent_sessions
              WHERE org_id = ? AND user_id = ?
              ORDER BY created_at DESC |]
        (orgId, userId)

getAgentSession :: PostgresPool -> UUID -> UUID -> IO (Maybe AgentSessionRow)
getAgentSession pool orgId sessionId = withConnection pool $ \conn -> do
  rows <- query conn
    [sql| SELECT id, org_id, user_id, name, directory, status::text, model,
                 total_tokens, total_cost_cents, created_at, last_active
          FROM agent_sessions
          WHERE org_id = ? AND id = ? |]
    (orgId, sessionId)
  pure $ case rows of
    [row] -> Just row
    _ -> Nothing

createAgentSession :: PostgresPool -> UUID -> UUID -> Text -> Text -> IO AgentSessionRow
createAgentSession pool orgId userId directory model = withConnection pool $ \conn -> do
  newId <- UUID.nextRandom
  now <- getCurrentTime
  _ <- execute conn
    [sql| INSERT INTO agent_sessions (id, org_id, user_id, directory, model, created_at)
          VALUES (?, ?, ?, ?, ?, ?) |]
    (newId, orgId, userId, directory, model, now)
  pure AgentSessionRow
    { agentSessionRowId = newId
    , agentSessionRowOrgId = orgId
    , agentSessionRowUserId = userId
    , agentSessionRowName = Nothing
    , agentSessionRowDirectory = directory
    , agentSessionRowStatus = "idle"
    , agentSessionRowModel = model
    , agentSessionRowTotalTokens = 0
    , agentSessionRowTotalCostCents = 0
    , agentSessionRowCreatedAt = now
    , agentSessionRowLastActive = Nothing
    }

-- ═══════════════════════════════════════════════════════════════════════════════
--                                                        // queries: workspaces
-- ═══════════════════════════════════════════════════════════════════════════════

listWorkspaces :: PostgresPool -> UUID -> IO [WorkspaceRow]
listWorkspaces pool orgId = withConnection pool $ \conn ->
  query conn
    [sql| SELECT id, org_id, owner_id, name, workspace_type::text, created_at, updated_at
          FROM workspaces
          WHERE org_id = ?
          ORDER BY created_at DESC |]
    (Only orgId)

getWorkspace :: PostgresPool -> UUID -> UUID -> IO (Maybe WorkspaceRow)
getWorkspace pool orgId workspaceId = withConnection pool $ \conn -> do
  rows <- query conn
    [sql| SELECT id, org_id, owner_id, name, workspace_type::text, created_at, updated_at
          FROM workspaces
          WHERE org_id = ? AND id = ? |]
    (orgId, workspaceId)
  pure $ case rows of
    [row] -> Just row
    _ -> Nothing

createWorkspace :: PostgresPool -> UUID -> UUID -> Text -> Text -> IO WorkspaceRow
createWorkspace pool orgId ownerId name wsType = withConnection pool $ \conn -> do
  newId <- UUID.nextRandom
  now <- getCurrentTime
  _ <- execute conn
    [sql| INSERT INTO workspaces (id, org_id, owner_id, name, workspace_type, created_at, updated_at)
          VALUES (?, ?, ?, ?, ?::workspace_type, ?, ?) |]
    (newId, orgId, ownerId, name, wsType, now, now)
  pure WorkspaceRow
    { workspaceRowId = newId
    , workspaceRowOrgId = orgId
    , workspaceRowOwnerId = ownerId
    , workspaceRowName = name
    , workspaceRowType = wsType
    , workspaceRowCreatedAt = now
    , workspaceRowUpdatedAt = now
    }
