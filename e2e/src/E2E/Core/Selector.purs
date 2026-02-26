-- | Type-safe selectors
module E2E.Core.Selector
  ( Selector
  , TestId(..)
  , Role
  , testId
  , role
  , roleNamed
  , text
  , textExact
  , css
  , within
  , nth
  , first
  , last
  , toPlaywright
  ) where

import Prelude

import Playwright.Data (Selector(..)) as PW

newtype Selector = Selector String

newtype TestId = TestId String

data Role
  = Button
  | Link
  | Textbox
  | Checkbox
  | Heading
  | Navigation
  | Main
  | Region

derive instance eqRole :: Eq Role

roleToString :: Role -> String
roleToString = case _ of
  Button -> "button"
  Link -> "link"
  Textbox -> "textbox"
  Checkbox -> "checkbox"
  Heading -> "heading"
  Navigation -> "navigation"
  Main -> "main"
  Region -> "region"

testId :: TestId -> Selector
testId (TestId id) = Selector $ "[data-testid=\"" <> id <> "\"]"

role :: Role -> Selector
role r = Selector $ "role=" <> roleToString r

roleNamed :: Role -> String -> Selector
roleNamed r name = Selector $ "role=" <> roleToString r <> "[name=\"" <> name <> "\"]"

text :: String -> Selector
text content = Selector $ "text=" <> content

textExact :: String -> Selector
textExact content = Selector $ "text=\"" <> content <> "\""

css :: String -> Selector
css sel = Selector sel

within :: Selector -> Selector -> Selector
within (Selector parent) (Selector child) = Selector $ parent <> " >> " <> child

nth :: Int -> Selector -> Selector
nth n (Selector sel) = Selector $ sel <> " >> nth=" <> show n

first :: Selector -> Selector
first = nth 0

last :: Selector -> Selector
last (Selector sel) = Selector $ sel <> " >> nth=-1"

toPlaywright :: Selector -> PW.Selector
toPlaywright (Selector s) = PW.Selector s
