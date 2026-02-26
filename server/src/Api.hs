-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--                                                    // straylight-api // api
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--
-- Combined Servant API for all Straylight products.
--
-- This module re-exports all product APIs and provides a combined API type
-- for serving all products from a single server with OpenAPI spec endpoints.
--
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Api
    ( -- * Combined API
      StraylightAPI
    , straylightApi
    
      -- * OpenAPI Endpoints
    , OpenApiEndpoints
    
      -- * Re-exports
    , module Api.Types
    , module Api.OpenApi
    
      -- * Full Product API types (for OpenAPI specs)
    , CacheAPI
    , BuildAPI
    , ConvergeAPI
    , ConfirmAPI
    , ForgeAPI
    , PublishAPI
    , CodeAPI
    , WorkAPI
    , ProxyAPI
    , BoostAPI
    
      -- * Simplified Server APIs
    , SimpleCacheAPI
    , SimpleBuildAPI
    , SimpleConvergeAPI
    , SimpleConfirmAPI
    , SimpleForgeAPI
    , SimplePublishAPI
    , SimpleCodeAPI
    , SimpleWorkAPI
    , SimpleProxyAPI
    , SimpleBoostAPI
    ) where

import Data.Aeson (Value)
import Data.Proxy
import Data.Text (Text)
import Servant

-- Core types
import Api.Types
import Api.OpenApi

-- sensenet products
import Api.Sensenet.Cache
import Api.Sensenet.Build
import Api.Sensenet.Converge
import Api.Sensenet.Confirm
import Api.Sensenet.Forge
import Api.Sensenet.Publish

-- omega products
import Api.Omega.Code
import Api.Omega.Work
import Api.Omega.Proxy
import Api.Omega.Boost


-- ═══════════════════════════════════════════════════════════════════════════
-- // openapi endpoints //
-- ═══════════════════════════════════════════════════════════════════════════

-- | OpenAPI spec endpoints for each product
type OpenApiEndpoints =
    -- sensenet specs
    "openapi" :> "sensenet" :> "cache.json" :> Get '[JSON] Value
        :<|> "openapi" :> "sensenet" :> "build.json" :> Get '[JSON] Value
        :<|> "openapi" :> "sensenet" :> "converge.json" :> Get '[JSON] Value
        :<|> "openapi" :> "sensenet" :> "confirm.json" :> Get '[JSON] Value
        :<|> "openapi" :> "sensenet" :> "forge.json" :> Get '[JSON] Value
        :<|> "openapi" :> "sensenet" :> "publish.json" :> Get '[JSON] Value
    -- omega specs
        :<|> "openapi" :> "omega" :> "code.json" :> Get '[JSON] Value
        :<|> "openapi" :> "omega" :> "work.json" :> Get '[JSON] Value
        :<|> "openapi" :> "omega" :> "proxy.json" :> Get '[JSON] Value
        :<|> "openapi" :> "omega" :> "boost.json" :> Get '[JSON] Value
    -- combined spec
        :<|> "openapi.json" :> Get '[JSON] Value
    -- spec index
        :<|> "openapi" :> Get '[JSON] Value


-- ═══════════════════════════════════════════════════════════════════════════
-- // combined api //
-- ═══════════════════════════════════════════════════════════════════════════

-- | Combined API for all Straylight products
type StraylightAPI =
    -- OpenAPI spec endpoints
    OpenApiEndpoints
    -- sensenet products (simplified for server impl)
        :<|> SimpleCacheAPI
        :<|> SimpleBuildAPI
        :<|> SimpleConvergeAPI
        :<|> SimpleConfirmAPI
        :<|> SimpleForgeAPI
        :<|> SimplePublishAPI
    -- omega products (simplified for server impl)
        :<|> SimpleCodeAPI
        :<|> SimpleWorkAPI
        :<|> SimpleProxyAPI
        :<|> SimpleBoostAPI


straylightApi :: Proxy StraylightAPI
straylightApi = Proxy


-- ═══════════════════════════════════════════════════════════════════════════
-- // simplified server apis //
-- These are the simplified APIs that the server implements.
-- The full APIs in Api.Sensenet.* and Api.Omega.* are used for OpenAPI specs.
-- ═══════════════════════════════════════════════════════════════════════════

-- | Simplified Cache API for server implementation
type SimpleCacheAPI =
    "api" :> "sensenet" :> "cache" :>
        ( Get '[JSON] [CacheResponse]
          :<|> ReqBody '[JSON] CreateCacheReq :> Post '[JSON] CacheResponse
          :<|> Capture "id" Text :> Get '[JSON] CacheResponse
          :<|> Capture "id" Text :> Delete '[JSON] NoContent
        )

-- | Simplified Build API for server implementation
type SimpleBuildAPI =
    "api" :> "sensenet" :> "build" :>
        ( QueryParam "limit" Int :> QueryParam "offset" Int :> Get '[JSON] [BuildResponse]
          :<|> ReqBody '[JSON] TriggerBuildReq :> Post '[JSON] BuildResponse
          :<|> Capture "id" Text :> Get '[JSON] BuildResponse
        )

-- | Simplified Converge API (stub)
type SimpleConvergeAPI =
    "api" :> "sensenet" :> "converge" :>
        ( Get '[JSON] [Value]
          :<|> Capture "id" Text :> Get '[JSON] Value
          :<|> Capture "id" Text :> "sync" :> Post '[JSON] Value
        )

-- | Simplified Confirm API (stub)
type SimpleConfirmAPI =
    "api" :> "sensenet" :> "confirm" :>
        ( Get '[JSON] [Value]
          :<|> Capture "id" Text :> Get '[JSON] Value
          :<|> Capture "id" Text :> "trigger" :> Post '[JSON] Value
        )

-- | Simplified Forge API (stub)
type SimpleForgeAPI =
    "api" :> "sensenet" :> "forge" :>
        ( Get '[JSON] [Value]
          :<|> Capture "id" Text :> Get '[JSON] Value
          :<|> ReqBody '[JSON] Value :> Post '[JSON] Value
        )

-- | Simplified Publish API (stub)
type SimplePublishAPI =
    "api" :> "sensenet" :> "publish" :>
        ( Get '[JSON] [Value]
          :<|> Capture "id" Text :> Get '[JSON] Value
          :<|> ReqBody '[JSON] Value :> Post '[JSON] Value
        )

-- | Simplified Code API for server implementation
type SimpleCodeAPI =
    "api" :> "omega" :> "code" :>
        ( Get '[JSON] [AgentSessionResponse]
          :<|> ReqBody '[JSON] CreateAgentSessionReq :> Post '[JSON] AgentSessionResponse
          :<|> Capture "id" Text :> Get '[JSON] AgentSessionResponse
        )

-- | Simplified Work API for server implementation
type SimpleWorkAPI =
    "api" :> "omega" :> "work" :>
        ( Get '[JSON] [WorkspaceResponse]
          :<|> ReqBody '[JSON] CreateWorkspaceReq :> Post '[JSON] WorkspaceResponse
          :<|> Capture "id" Text :> Get '[JSON] WorkspaceResponse
        )

-- | Simplified Proxy API (stub)
type SimpleProxyAPI =
    "api" :> "omega" :> "proxy" :>
        ( Get '[JSON] [Value]
          :<|> Capture "id" Text :> Get '[JSON] Value
          :<|> ReqBody '[JSON] Value :> Post '[JSON] Value
        )

-- | Simplified Boost API (stub)
type SimpleBoostAPI =
    "api" :> "omega" :> "boost" :>
        ( Get '[JSON] [Value]
          :<|> Capture "id" Text :> Get '[JSON] Value
          :<|> ReqBody '[JSON] Value :> Post '[JSON] Value
        )
