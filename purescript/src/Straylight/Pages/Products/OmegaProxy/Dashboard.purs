-- | omega//proxy Dashboard Page
module Straylight.Pages.Products.OmegaProxy.Dashboard where

import Prelude

import Halogen as H
import Halogen.HTML as HH

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
    , emptyDashboard "omega//proxy"
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
        [ HH.text "Request metrics, compression ratios, and provider health." ]
    ]

quickStart :: forall w i. HH.HTML w i
quickStart =
  HH.div
    [ cls [ "bg-card border border-border rounded-lg p-6 mb-8" ] ]
    [ HH.h3
        [ cls [ "text-lg font-semibold text-text mb-4" ] ]
        [ HH.text "Quick Start" ]
    , codeBlock
        [ HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text "# Configure your API endpoint\n" ]
        , HH.span [ cls [ "text-orange-400" ] ] [ HH.text "$ " ]
        , HH.text "export OMEGA_PROXY_URL=https://proxy.omega.dev\n\n"
        , HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text "# Route requests through omega//proxy\n" ]
        , HH.span [ cls [ "text-orange-400" ] ] [ HH.text "$ " ]
        , HH.text "omega proxy start"
        ]
    ]
