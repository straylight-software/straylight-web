-- | E2E Test Harness
module E2E.Core.Harness
  ( TestEnv
  , Config
  , defaultConfig
  , withBrowser
  , withPage
  , goto
  , shouldBeVisible
  , shouldHaveText
  , shouldHaveCount
  , assertEq
  , fail
  ) where

import Prelude

import Data.Array (length)
import Data.Maybe (Maybe(..))

import Effect.Aff (Aff, bracket, throwError, error)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Node.Process (lookupEnv)
import Playwright (launch, close, newPage, goto) as PW
import Playwright.Data (Browser, Page, URL(..), chromium)

import E2E.Core.Selector (Selector)
import E2E.Core.Element (isVisible, getText, queryAll)

type TestEnv =
  { browser :: Browser
  , config :: Config
  }

type Config =
  { baseUrl :: String
  , headless :: Boolean
  , slowMo :: Number
  , timeout :: Number
  }

defaultConfig :: Config
defaultConfig =
  { baseUrl: "http://localhost:3000"
  , headless: true
  , slowMo: 0.0
  , timeout: 30000.0
  }

withBrowser :: Config -> (TestEnv -> Aff Unit) -> Aff Unit
withBrowser config action = bracket acquire release run
  where
    acquire = do
      liftEffect $ log "[e2e] Launching browser..."
      mExePath <- liftEffect $ lookupEnv "PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH"
      browser <- case mExePath of
        Just exePath -> do
          liftEffect $ log $ "[e2e] Using Chromium: " <> exePath
          PW.launch chromium 
            { headless: config.headless
            , slowMo: config.slowMo
            , executablePath: exePath
            }
        Nothing -> do
          liftEffect $ log "[e2e] Using Playwright's bundled Chromium"
          PW.launch chromium 
            { headless: config.headless
            , slowMo: config.slowMo
            }
      pure { browser, config }
    
    release env = do
      liftEffect $ log "[e2e] Closing browser..."
      PW.close env.browser
    
    run = action

withPage :: TestEnv -> (Page -> Aff Unit) -> Aff Unit
withPage env action = bracket acquire release action
  where
    acquire = do
      liftEffect $ log "[e2e] Opening new page..."
      PW.newPage env.browser {}
    
    release page = do
      liftEffect $ log "[e2e] Closing page..."
      PW.close page

goto :: String -> Page -> Aff Unit
goto url page = do
  _ <- PW.goto page (URL url) {}
  pure unit

shouldBeVisible :: Page -> Selector -> Aff Unit
shouldBeVisible page sel = do
  visible <- isVisible page sel
  unless visible $
    throwError $ error "Expected element to be visible but it was not"

shouldHaveText :: Page -> Selector -> String -> Aff Unit
shouldHaveText page sel expected = do
  mText <- getText page sel
  case mText of
    Nothing -> throwError $ error "Expected element to have text but element not found"
    Just actual ->
      unless (actual == expected) $
        throwError $ error $ "Expected text '" <> expected <> "' but got '" <> actual <> "'"

shouldHaveCount :: Page -> Selector -> Int -> Aff Unit
shouldHaveCount page sel expected = do
  elements <- queryAll page sel
  let actual = length elements
  unless (actual == expected) $
    throwError $ error $ "Expected " <> show expected <> " elements but found " <> show actual

assertEq :: forall a. Show a => Eq a => a -> a -> Aff Unit
assertEq expected actual = do
  unless (expected == actual) $
    throwError $ error $ "Expected " <> show expected <> " but got " <> show actual

fail :: String -> Aff Unit
fail msg = throwError $ error msg
