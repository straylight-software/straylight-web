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
    NavigationSpec.runNavigationTests env
    ProductsSpec.spec env
    
    liftEffect $ log ""
    liftEffect $ log "═══════════════════════════════════════════════════════════════"
    liftEffect $ log "  ALL TESTS COMPLETE"
    liftEffect $ log "═══════════════════════════════════════════════════════════════"
    liftEffect $ log ""
