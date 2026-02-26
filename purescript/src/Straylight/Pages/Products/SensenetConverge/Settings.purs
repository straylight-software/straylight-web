-- | sensenet//converge Settings Page
module Straylight.Pages.Products.SensenetConverge.Settings where

import Prelude

import Halogen as H
import Halogen.HTML as HH

import Straylight.UI (cls, emptySettings)

-- ============================================================
-- COMPONENT
-- ============================================================

settingsPage :: forall q i o m. H.Component q i o m
settingsPage = H.mkComponent
  { initialState: const unit
  , render: const render
  , eval: H.mkEval H.defaultEval
  }

-- ============================================================
-- RENDER
-- ============================================================

render :: forall w i. HH.HTML w i
render =
  HH.div
    [ cls [ "max-w-[1100px] mx-auto px-6 py-8" ] ]
    [ header
    , emptySettings
    ]

header :: forall w i. HH.HTML w i
header =
  HH.div
    [ cls [ "mb-8" ] ]
    [ HH.h1
        [ cls [ "text-2xl font-bold text-text" ] ]
        [ HH.text "Settings" ]
    , HH.p
        [ cls [ "text-muted-foreground" ] ]
        [ HH.text "Cloud credentials, environments, team access, and API keys." ]
    ]
