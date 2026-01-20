-- | Software Page - Projects list
module Straylight.Pages.Software where

import Prelude

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

import Straylight.UI (cls, sectionHeader)

-- ============================================================
-- DATA
-- ============================================================

type Project =
  { name :: String
  , desc :: String
  }

projects :: Array Project
projects =
  [ { name: "nix", desc: "our fork. correct, modern, apolitical." }
  , { name: "aleph", desc: "typed infrastructure. System Fω. droids ship code that works." }
  , { name: "zeitschrift", desc: "scope graph publishing. references resolve or the build fails." }
  , { name: "isospin-microvm", desc: "microvm orchestration. GPUs appear inside firecracker." }
  , { name: "hacker-flake", desc: "nix flake for NVIDIA dev. just compile some shit." }
  ]

-- ============================================================
-- COMPONENT
-- ============================================================

softwarePage :: forall q i o m. H.Component q i o m
softwarePage = H.mkComponent
  { initialState: const unit
  , render: const render
  , eval: H.mkEval H.defaultEval
  }

render :: forall w i. HH.HTML w i
render =
  HH.div_
    [ sectionHeader "software"
    , HH.div
        [ cls [ "flex flex-col gap-6" ] ]
        (map projectRow projects)
    ]

projectRow :: forall w i. Project -> HH.HTML w i
projectRow p =
  HH.div
    [ cls [ "grid grid-cols-[140px_1fr] gap-4 items-baseline group" ] ]
    [ HH.a
        [ HP.href $ "https://github.com/straylight-software/" <> p.name
        , HP.target "_blank"
        , HP.rel "noopener noreferrer"
        , cls [ "text-text hover:text-primary transition-colors geo-hover" ]
        ]
        [ HH.text p.name ]
    , HH.span
        [ cls [ "text-muted-foreground group-hover:text-text/70 transition-colors" ] ]
        [ HH.text p.desc ]
    ]
