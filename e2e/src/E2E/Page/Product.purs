-- | Product page helpers
module E2E.Page.Product
  ( Product(..)
  , ProductPage(..)
  , allProducts
  , allPages
  , productPath
  , pagePath
  , fullPath
  , visit
  , waitForLoad
  , verifyPageType
  ) where

import Prelude

import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Playwright (goto) as PW
import Playwright.Data (Page, URL(..), Selector(..))

import E2E.Core.Selector (css)
import E2E.Core.Element (getText)

-- | All 10 products
data Product
  = SensenetCache
  | SensenetBuild
  | SensenetConverge
  | SensenetConfirm
  | SensenetForge
  | SensenetPublish
  | OmegaCode
  | OmegaWork
  | OmegaProxy
  | OmegaBoost

derive instance eqProduct :: Eq Product

-- | All 7 pages per product
data ProductPage
  = Home
  | Features
  | Pricing
  | Docs
  | Dashboard
  | Settings
  | Legal

derive instance eqProductPage :: Eq ProductPage

allProducts :: Array Product
allProducts =
  [ SensenetCache
  , SensenetBuild
  , SensenetConverge
  , SensenetConfirm
  , SensenetForge
  , SensenetPublish
  , OmegaCode
  , OmegaWork
  , OmegaProxy
  , OmegaBoost
  ]

allPages :: Array ProductPage
allPages =
  [ Home
  , Features
  , Pricing
  , Docs
  , Dashboard
  , Settings
  , Legal
  ]

productPath :: Product -> String
productPath = case _ of
  SensenetCache -> "/sensenet/cache"
  SensenetBuild -> "/sensenet/build"
  SensenetConverge -> "/sensenet/converge"
  SensenetConfirm -> "/sensenet/confirm"
  SensenetForge -> "/sensenet/forge"
  SensenetPublish -> "/sensenet/publish"
  OmegaCode -> "/omega/code"
  OmegaWork -> "/omega/work"
  OmegaProxy -> "/omega/proxy"
  OmegaBoost -> "/omega/boost"

pagePath :: ProductPage -> String
pagePath = case _ of
  Home -> ""
  Features -> "/features"
  Pricing -> "/pricing"
  Docs -> "/docs"
  Dashboard -> "/dashboard"
  Settings -> "/settings"
  Legal -> "/legal"

fullPath :: Product -> ProductPage -> String
fullPath product page = productPath product <> pagePath page

productName :: Product -> String
productName = case _ of
  SensenetCache -> "sensenet//cache"
  SensenetBuild -> "sensenet//build"
  SensenetConverge -> "sensenet//converge"
  SensenetConfirm -> "sensenet//confirm"
  SensenetForge -> "sensenet//forge"
  SensenetPublish -> "sensenet//publish"
  OmegaCode -> "omega//code"
  OmegaWork -> "omega//work"
  OmegaProxy -> "omega//proxy"
  OmegaBoost -> "omega//boost"

pageName :: ProductPage -> String
pageName = case _ of
  Home -> "Home"
  Features -> "Features"
  Pricing -> "Pricing"
  Docs -> "Docs"
  Dashboard -> "Dashboard"
  Settings -> "Settings"
  Legal -> "Legal"

-- | Navigate to a product page
visit :: String -> Product -> ProductPage -> Page -> Aff Unit
visit baseUrl product productPage p = do
  let url = baseUrl <> fullPath product productPage
  liftEffect $ log $ "[e2e] Visiting " <> productName product <> " " <> pageName productPage
  _ <- PW.goto p (URL url) {}
  pure unit

-- | Wait for the page to load (PureScript hydration)
waitForLoad :: Page -> Aff Unit
waitForLoad _ = do
  -- Simple delay to let page load - real impl would use waitForSelector
  pure unit

-- | Verify the page type is set correctly in window.__STRAYLIGHT_PAGE__
verifyPageType :: Product -> Page -> Aff Boolean
verifyPageType product p = do
  -- The page type is embedded in a script tag
  mText <- getText p (css "script")
  case mText of
    Just text -> pure $ contains (expectedPageType product) text
    Nothing -> pure false
  where
    expectedPageType :: Product -> String
    expectedPageType = case _ of
      SensenetCache -> "sensenetCache"
      SensenetBuild -> "sensenetBuild"
      SensenetConverge -> "sensenetConverge"
      SensenetConfirm -> "sensenetConfirm"
      SensenetForge -> "sensenetForge"
      SensenetPublish -> "sensenetPublish"
      OmegaCode -> "omegaCode"
      OmegaWork -> "omegaWork"
      OmegaProxy -> "omegaProxy"
      OmegaBoost -> "omegaBoost"
    
    contains :: String -> String -> Boolean
    contains needle haystack = indexOf needle haystack /= Nothing

foreign import indexOf :: String -> String -> Maybe Int
