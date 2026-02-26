-- | omega//code Dashboard Page
-- | User dashboard for agent management
module Straylight.Pages.Products.OmegaCode.Dashboard where

import Prelude

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

import Straylight.UI (cls, codeBlock, emptyDashboard)

-- ============================================================
-- COMPONENT
-- ============================================================

dashboardPage :: forall q i o m. H.Component q i o m
dashboardPage = H.mkComponent
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
    , quickStart
    , emptyDashboard "omega//code"
    ]

header :: forall w i. HH.HTML w i
header =
  HH.div
    [ cls [ "mb-8" ] ]
    [ HH.h1
        [ cls [ "text-2xl font-bold text-text mb-2" ] ]
        [ HH.text "Dashboard" ]
    , HH.p
        [ cls [ "text-muted-foreground" ] ]
        [ HH.text "Session history, token usage, and attestation records." ]
    ]

quickStart :: forall w i. HH.HTML w i
quickStart =
  HH.div
    [ cls [ "bg-card border border-border rounded-lg p-6 mb-8" ] ]
    [ HH.h3
        [ cls [ "text-lg font-semibold text-text mb-4" ] ]
        [ HH.text "Quick Start" ]
    , codeBlock
        [ HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text "# Install omega//code\n" ]
        , HH.span [ cls [ "text-blue-300" ] ] [ HH.text "$ " ]
        , HH.text "curl -fsSL https://get.omega.code | sh\n\n"
        , HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text "# Start a session\n" ]
        , HH.span [ cls [ "text-blue-300" ] ] [ HH.text "$ " ]
        , HH.text "omega"
        ]
    ]
