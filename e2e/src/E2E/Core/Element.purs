-- | Element operations wrapper
module E2E.Core.Element
  ( click
  , fill
  , getText
  , isVisible
  , waitFor
  , waitForHidden
  , query
  , queryAll
  ) where

import Prelude

import Data.Maybe (Maybe)
import Effect.Aff (Aff)
import Literals.Null (Null)
import Playwright (click, fill, textContent, waitForSelector, query, queryMany) as PW
import Playwright.Data (Page, ElementHandle, visible, hidden)
import Untagged.Union (type (|+|))

import E2E.Core.Selector (Selector, toPlaywright)

click :: Page -> Selector -> Aff Unit
click page sel = PW.click page (toPlaywright sel) {}

fill :: Page -> Selector -> String -> Aff Unit
fill page sel value = PW.fill page (toPlaywright sel) value {}

getText :: Page -> Selector -> Aff (Maybe String)
getText page sel = do
  result <- PW.textContent page (toPlaywright sel)
  pure $ extractNullable result

isVisible :: Page -> Selector -> Aff Boolean
isVisible page sel = do
  result <- PW.query page (toPlaywright sel)
  pure $ not $ isNull result

foreign import isNull :: forall a. a -> Boolean

waitFor :: Page -> Selector -> Aff Unit
waitFor page sel = do
  _ <- PW.waitForSelector page (toPlaywright sel) { state: visible }
  pure unit

waitForHidden :: Page -> Selector -> Aff Unit
waitForHidden page sel = do
  _ <- PW.waitForSelector page (toPlaywright sel) { state: hidden }
  pure unit

query :: Page -> Selector -> Aff (Maybe ElementHandle)
query page sel = do
  result <- PW.query page (toPlaywright sel)
  pure $ extractNullable result

queryAll :: Page -> Selector -> Aff (Array ElementHandle)
queryAll page sel = PW.queryMany page (toPlaywright sel)

foreign import extractNullable :: forall a. (Null |+| a) -> Maybe a
