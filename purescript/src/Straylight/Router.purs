-- | Client-side routing using Hydrogen.Router
module Straylight.Router 
  ( Route(..)
  , module Hydrogen.Router
  ) where

import Prelude

import Data.Maybe (Maybe(..))
import Hydrogen.Router (class IsRoute, class RouteMetadata, parseRoute, routeToPath, getPathname, pushState, onPopState, navigate, normalizeTrailingSlash)

-- ============================================================
-- ROUTES
-- ============================================================

data Route
  -- Product pages (public landing)
  = Home                -- Product map overview
  | OmegaCode           -- omega//code product page
  | OmegaWork           -- omega//work product page
  | OmegaProxy          -- omega//proxy product page
  | OmegaBoost          -- omega//boost product page
  -- Team pages (moved from old homepage)
  | Team                -- Team about (old homepage content)
  | Plan                -- .plan
  | Lean                -- /plan/lean
  | Razorgirl           -- razorgirl project
  | Software            -- software portfolio
  -- Community
  | Irc
  | Discord

derive instance eqRoute :: Eq Route

-- ============================================================
-- ISROUTE INSTANCE
-- ============================================================

instance isRouteRoute :: IsRoute Route where
  parseRoute path = case normalizeTrailingSlash path of
    -- Product routes
    "/" -> Home
    "/omega/code" -> OmegaCode
    "/omega/work" -> OmegaWork
    "/omega/proxy" -> OmegaProxy
    "/omega/boost" -> OmegaBoost
    -- Team routes
    "/team" -> Team
    "/team/plan" -> Plan
    "/team/plan/lean" -> Lean
    "/razorgirl" -> Razorgirl
    "/software" -> Software
    -- Legacy redirects (old paths still work)
    "/plan" -> Plan
    "/plan/lean" -> Lean
    -- Community
    "/irc" -> Irc
    "/discord" -> Discord
    _ -> Home

  routeToPath = case _ of
    -- Product routes
    Home -> "/"
    OmegaCode -> "/omega/code"
    OmegaWork -> "/omega/work"
    OmegaProxy -> "/omega/proxy"
    OmegaBoost -> "/omega/boost"
    -- Team routes
    Team -> "/team"
    Plan -> "/team/plan"
    Lean -> "/team/plan/lean"
    Razorgirl -> "/razorgirl"
    Software -> "/software"
    -- Community
    Irc -> "/irc"
    Discord -> "/discord"

-- ============================================================
-- ROUTE METADATA (for SSG support)
-- ============================================================

instance routeMetadataRoute :: RouteMetadata Route where
  isProtected _ = false
  
  isStaticRoute _ = true
  
  routeTitle = case _ of
    Home -> "Straylight Software — Product Map"
    OmegaCode -> "omega//code — Native Terminal AI Coding Agent"
    OmegaWork -> "omega//work — Desktop AI for Teams"
    OmegaProxy -> "omega//proxy — Verified Inference Proxy"
    OmegaBoost -> "omega//boost — Managed Inference"
    Team -> "Team | Straylight"
    Plan -> "The Plan | Straylight"
    Lean -> "Lean | Straylight"
    Razorgirl -> "Razorgirl | Straylight"
    Software -> "Software | Straylight"
    Irc -> "IRC | Straylight"
    Discord -> "Discord | Straylight"
  
  routeDescription = case _ of
    Home -> "Two product families. Ten external products. One attestation layer."
    OmegaCode -> "Native terminal AI coding agent. Haskell + Brick TUI. io_uring event loop. 509k req/s. SIGIL-native."
    OmegaWork -> "Electron desktop app for non-coders. Same agent engine, GUI surface."
    OmegaProxy -> "Verified inference proxy. SSE → SIGIL over ZeroMQ. Reset-on-ambiguity."
    OmegaBoost -> "Managed inference co-located with BYOK vendor. evring HTTP stack."
    Team -> "The Straylight team and philosophy"
    Plan -> "The Straylight plan"
    Lean -> "Lean methodology at Straylight"
    Razorgirl -> "Razorgirl project"
    Software -> "Straylight software portfolio"
    Irc -> "Join Straylight on IRC"
    Discord -> "Join Straylight on Discord"
  
  routeOgImage _ = Nothing
