-- | E2E Test Entry Point
module E2E.Main where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)

import E2E.Core.Harness (defaultConfig, withBrowser)
import E2E.Test.ProductsSpec as ProductsSpec
import E2E.Test.NavigationSpec as NavigationSpec
import E2E.Test.DashboardSpec as DashboardSpec
import E2E.Test.SettingsSpec as SettingsSpec
import E2E.Test.HeaderSpec as HeaderSpec
import E2E.Test.AuthSpec as AuthSpec
import E2E.Test.ThemeSpec as ThemeSpec

main :: Effect Unit
main = launchAff_ do
  liftEffect $ log ""
  liftEffect $ log "╔═══════════════════════════════════════════════════════════════╗"
  liftEffect $ log "║                                                               ║"
  liftEffect $ log "║   // STRAYLIGHT // WEB //                                     ║"
  liftEffect $ log "║   E2E Test Suite                                              ║"
  liftEffect $ log "║                                                               ║"
  liftEffect $ log "║   10 products × 7 pages = 70 routes                           ║"
  liftEffect $ log "║                                                               ║"
  liftEffect $ log "╚═══════════════════════════════════════════════════════════════╝"
  liftEffect $ log ""
  
  withBrowser defaultConfig \env -> do
    -- Core navigation and routing tests
    NavigationSpec.runNavigationTests env
    ProductsSpec.spec env
    
    -- Property tests for interactive UI
    DashboardSpec.runDashboardTests env
    SettingsSpec.runSettingsTests env
    HeaderSpec.runHeaderTests env
    
    -- Auth and theme tests
    AuthSpec.runAuthTests env
    ThemeSpec.runThemeTests env
    
    liftEffect $ log ""
    liftEffect $ log "═══════════════════════════════════════════════════════════════"
    liftEffect $ log "  ALL TESTS COMPLETE"
    liftEffect $ log "═══════════════════════════════════════════════════════════════"
    liftEffect $ log ""
