-- | .plan Page - Papers and writings
module Straylight.Pages.Plan where

import Prelude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

import Straylight.UI (cls, sectionHeader)

-- ============================================================
-- DATA
-- ============================================================

type Paper = 
  { title :: String
  , subtitle :: String
  , meta :: String
  , tags :: Array String
  , href :: Maybe String
  }

papers :: Array Paper
papers =
  [ { title: "The Villa Straylight Papers"
    , subtitle: "Jensen's Razor and the malevolent combinatorics of CUDA architecture."
    , meta: "January 8, 2026 // 13 min read"
    , tags: ["CUDA", "NVIDIA", "TENSOR CORES", "NEUROMANCER"]
    , href: Just "/plan/papers"
    }
  , { title: "Part I: The Rectilinear Chamber"
    , subtitle: "Layouts, Coordinate Spaces, and the CuTe Contract."
    , meta: "January 8, 2026 // 5 min read"
    , tags: ["CUTE", "LAYOUTS", "LEAN"]
    , href: Just "/plan/part-1"
    }
  , { title: "Part II: The Sense/Net Pyramid"
    , subtitle: "Coalescence, Noetherian Reduction, and Why the Gothic Folly Terminates."
    , meta: "January 8, 2026 // 4 min read"
    , tags: ["COALESCENCE", "TERMINATION"]
    , href: Just "/plan/part-2"
    }
  , { title: "Part III: Built Him up From Nothing"
    , subtitle: "Complementation, the FTTC, and the Holes in Your Iteration Space."
    , meta: "January 8, 2026 // 4 min read"
    , tags: ["FTTC", "TMA", "HOLES"]
    , href: Just "/plan/part-3"
    }
  , { title: "Part IV: Take Your Word, Thief"
    , subtitle: "Composition, the Tensor Core Cathedral, and Jensen's Razor."
    , meta: "January 8, 2026 // 5 min read"
    , tags: ["RAZORGIRL", "COMPOSITION"]
    , href: Just "/plan/part-4"
    }
  , { title: "Part V: VillaStraylight.lean"
    , subtitle: "21 theorems from nvfuser. 0 sorry. The blade studied you back."
    , meta: "January 2026 // 1575 lines // Lean 4"
    , tags: ["LEAN4", "MATHLIB", "PROOFS"]
    , href: Just "/plan/lean"
    }
  ]

-- ============================================================
-- COMPONENT
-- ============================================================

planPage :: forall q i o m. H.Component q i o m
planPage = H.mkComponent
  { initialState: const unit
  , render: const render
  , eval: H.mkEval H.defaultEval
  }

render :: forall w i. HH.HTML w i
render =
  HH.div_
    [ sectionHeader ".plan"
    , HH.div
        [ cls [ "flex flex-col gap-4" ] ]
        (map paperCard papers)
    ]

paperCard :: forall w i. Paper -> HH.HTML w i
paperCard paper =
  case paper.href of
    Just url -> 
      HH.a
        [ HP.href url
        , cls [ "block p-4 bg-card border-l-[3px] border-l-primary hover:bg-secondary transition-colors" ]
        ]
        (cardContent paper)
    Nothing ->
      HH.div
        [ cls [ "block p-4 bg-card border-l-[3px] border-l-primary" ] ]
        (cardContent paper)

cardContent :: forall w i. Paper -> Array (HH.HTML w i)
cardContent paper =
  [ HH.div
      [ cls [ "text-text font-medium mb-1" ] ]
      [ HH.text paper.title ]
  , HH.div
      [ cls [ "text-[0.85rem] text-muted-foreground mb-2" ] ]
      [ HH.text paper.subtitle ]
  , HH.div
      [ cls [ "text-[0.8rem] text-muted-foreground/70" ] ]
      [ HH.text paper.meta ]
  , HH.div
      [ cls [ "mt-2 text-[0.75rem]" ] ]
      (map (\tag -> HH.span [ cls [ "text-primary/80 mr-2" ] ] [ HH.text $ "// " <> tag ]) paper.tags)
  ]
