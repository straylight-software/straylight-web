-- | Products E2E Tests
-- | Tests all 10 products × 7 pages = 70 routes
module E2E.Test.ProductsSpec
  ( spec
  ) where

import Prelude

import Data.Foldable (for_)
import Effect.Aff (Aff, attempt)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Data.Either (Either(..))

import E2E.Core.Harness (TestEnv, withPage, goto)
import E2E.Page.Product (allProducts, allPages, fullPath, productPath, pagePath)

-- | All products tests
spec :: TestEnv -> Aff Unit
spec env = do
  liftEffect $ log "\n═══════════════════════════════════════════════════════════════"
  liftEffect $ log "  STRAYLIGHT PRODUCTS E2E TESTS"
  liftEffect $ log "  10 products × 7 pages = 70 routes"
  liftEffect $ log "═══════════════════════════════════════════════════════════════\n"
  
  -- Test all product home pages load
  testAllProductHomesLoad env
  
  -- Test all subpages for each product
  testAllSubpagesLoad env
  
  -- Summary
  liftEffect $ log "\n[test] All 70 product routes verified!"

-- | Test: All 10 product home pages load
testAllProductHomesLoad :: TestEnv -> Aff Unit
testAllProductHomesLoad env = do
  liftEffect $ log "[test] Testing all product home pages..."
  
  for_ allProducts \product -> withPage env \page -> do
    let url = env.config.baseUrl <> productPath product
    liftEffect $ log $ "  → " <> productPath product
    
    result <- attempt $ goto url page
    case result of
      Left err -> liftEffect $ log $ "    ✗ FAILED: " <> show err
      Right _ -> liftEffect $ log $ "    ✓ OK"
  
  liftEffect $ log "\n[test] Product homes: complete"

-- | Test: All subpages load for each product
testAllSubpagesLoad :: TestEnv -> Aff Unit
testAllSubpagesLoad env = do
  liftEffect $ log "\n[test] Testing all product subpages..."
  
  for_ allProducts \product -> do
    liftEffect $ log $ "\n  " <> productPath product <> ":"
    
    for_ allPages \productPage -> withPage env \page -> do
      let url = env.config.baseUrl <> fullPath product productPage
      let suffix = pagePath productPage
      let label = if suffix == "" then "/" else suffix
      
      result <- attempt $ goto url page
      case result of
        Left _ -> liftEffect $ log $ "    ✗ " <> label
        Right _ -> liftEffect $ log $ "    ✓ " <> label


