{-# LANGUAGE StrictData #-}
-- | Application Environment
-- | Configuration and shared resources for the Straylight API server
module Straylight.Env
  ( AppEnv(..)
  , initEnv
  ) where

import Data.UUID (UUID)
import qualified Data.UUID as UUID
import System.Exit (exitFailure)

import qualified Straylight.ClickHouse as CH
import qualified Straylight.Postgres as PG

-- | Application environment with shared resources
-- NOTE: Both Postgres and ClickHouse are REQUIRED. No mock fallbacks.
data AppEnv = AppEnv
  { postgres :: PG.PostgresPool           -- Required - transactional data
  , clickhouse :: CH.ClickHouseClient     -- Required - analytics/usage
  , defaultOrgId :: UUID                  -- For now, single-tenant (dev org)
  }

-- | Initialize the application environment
-- Fails if Postgres or ClickHouse is not configured.
initEnv :: IO AppEnv
initEnv = do
  -- Initialize Postgres (REQUIRED)
  mPGConfig <- PG.configFromEnv
  pgPool <- case mPGConfig of
    Nothing -> do
      putStrLn "[env] ERROR: Postgres not configured"
      putStrLn "[env] Set POSTGRES_HOST, POSTGRES_PORT, POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DATABASE"
      putStrLn "[env] Run: nix run .#dev-all  # to start all services"
      exitFailure
    Just cfg -> do
      putStrLn "[env] Connecting to Postgres..."
      pool <- PG.newPool cfg
      putStrLn "[env] Postgres pool initialized"
      pure pool
  
  -- Initialize ClickHouse (REQUIRED)
  mCHConfig <- CH.configFromEnv
  chClient <- case mCHConfig of
    Nothing -> do
      putStrLn "[env] ERROR: ClickHouse not configured"
      putStrLn "[env] Set CLICKHOUSE_HOST, CLICKHOUSE_PORT, CLICKHOUSE_USER, CLICKHOUSE_PASSWORD, CLICKHOUSE_DATABASE"
      putStrLn "[env] Run: nix run .#dev-all  # to start all services"
      exitFailure
    Just cfg -> do
      putStrLn "[env] Connecting to ClickHouse..."
      client <- CH.newClient cfg
      putStrLn "[env] ClickHouse client initialized"
      pure client
  
  -- Default org ID for development (matches seed data)
  let devOrgId = maybe UUID.nil id $ UUID.fromString "00000000-0000-0000-0000-000000000001"
  
  pure AppEnv
    { postgres = pgPool
    , clickhouse = chClient
    , defaultOrgId = devOrgId
    }
