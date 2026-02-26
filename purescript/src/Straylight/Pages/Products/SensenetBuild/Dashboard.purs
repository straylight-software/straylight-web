-- | sensenet//build Dashboard Page
module Straylight.Pages.Products.SensenetBuild.Dashboard where

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
    , emptyDashboard "sensenet//build"
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
        [ HH.text "Manage builds, jobs, and proofs." ]
    ]

quickStart :: forall w i. HH.HTML w i
quickStart =
  HH.div
    [ cls [ "bg-card border border-border rounded-lg p-6 mb-8" ] ]
    [ HH.h3
        [ cls [ "text-lg font-semibold text-text mb-4" ] ]
        [ HH.text "Quick Start" ]
    , codeBlock
        [ HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text "# Install sensenet//build\n" ]
        , HH.span [ cls [ "text-green-400" ] ] [ HH.text "$ " ]
        , HH.text "nix profile install github:sensenet/build\n\n"
        , HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text "# Run your first verified build\n" ]
        , HH.span [ cls [ "text-green-400" ] ] [ HH.text "$ " ]
        , HH.text "build --verify"
        ]
    ]
