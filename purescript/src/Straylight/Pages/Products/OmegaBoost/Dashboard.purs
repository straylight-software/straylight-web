-- | omega//boost Dashboard Page
module Straylight.Pages.Products.OmegaBoost.Dashboard where

import Prelude
import Halogen as H
import Halogen.HTML as HH
import Straylight.UI (cls, codeBlock, emptyDashboard)

dashboardPage :: forall q i o m. H.Component q i o m
dashboardPage = H.mkComponent
  { initialState: const unit
  , render: const render
  , eval: H.mkEval H.defaultEval
  }

render :: forall w i. HH.HTML w i
render =
  HH.div
    [ cls [ "max-w-[1100px] mx-auto px-6 py-8" ] ]
    [ header, quickStart, emptyDashboard "omega//boost" ]

header :: forall w i. HH.HTML w i
header =
  HH.div [ cls [ "mb-8" ] ]
    [ HH.h1 [ cls [ "text-2xl font-bold text-text mb-2" ] ] [ HH.text "Dashboard" ]
    , HH.p [ cls [ "text-muted-foreground" ] ] 
        [ HH.text "Inference usage, latency metrics, and cost tracking." ]
    ]

quickStart :: forall w i. HH.HTML w i
quickStart =
  HH.div [ cls [ "bg-card border border-border rounded-lg p-6 mb-8" ] ]
    [ HH.h3 [ cls [ "text-lg font-semibold text-text mb-4" ] ] [ HH.text "Quick Start" ]
    , codeBlock
        [ HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text "# Point your SDK to omega//boost\n" ]
        , HH.span [ cls [ "text-primary" ] ] [ HH.text "export " ]
        , HH.text "OPENAI_BASE_URL=https://boost.omega.dev/v1"
        ]
    ]
