-- | Razorgirl Page - Aesthetic, quotes, assets
module Straylight.Pages.Razorgirl where

import Prelude

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

import Straylight.UI (cls, sectionHeader, keyword)

-- ============================================================
-- DATA
-- ============================================================

type Quote =
  { source :: String
  , text :: String
  , attribution :: String
  , accent :: String -- "primary" or "status"
  }

quotes :: Array Quote
quotes =
  [ { source: "GIBSON"
    , text: "\"The Panther Moderns differ from other terrorists precisely in their degree of self-consciousness, in their awareness of the extent to which media divorce the act of terrorism from the original sociopolitical intent.\""
    , attribution: "\"Skip it,\" Case said."
    , accent: "primary"
    }
  , { source: "TESSIER-ASHPOOL"
    , text: "\"Hans Becker is an Austrian video artist whose hallmark is an obsessive interrogation of rigidly delimited fields of visual information. His approaches range from classical montage to techniques borrowed from industrial espionage, deep-space imaging, and kino-archaeology.\""
    , attribution: "— Antarctica Starts Here, Net library intro-critique"
    , accent: "status"
    }
  , { source: "GIBSON"
    , text: "\"Cyberspace. A consensual hallucination experienced daily by billions of legitimate operators, in every nation.\""
    , attribution: ""
    , accent: "primary"
    }
  , { source: "GIBSON"
    , text: "\"The sky above the port was the color of television, tuned to a dead channel.\""
    , attribution: ""
    , accent: "status"
    }
  , { source: "GIBSON"
    , text: "\"Night City was like a deranged experiment in social Darwinism, designed by a bored researcher who kept one thumb permanently on the fast-forward button.\""
    , attribution: ""
    , accent: "primary"
    }
  ]

type Asset =
  { filename :: String
  , href :: String
  , desc :: String
  }

assets :: Array Asset
assets =
  [ { filename: "wallpaper-razorgirl.svg", href: "/assets/wallpaper-razorgirl.svg", desc: "villa straylight. myelin tactics. svg." }
  , { filename: "wallpaper-continuity.svg", href: "/assets/wallpaper-continuity.svg", desc: "continuity is continuity. svg." }
  , { filename: "logo.svg", href: "/assets/logo.svg", desc: "vector mark. primary." }
  , { filename: "ono-sendai.svg", href: "/assets/agency-sheet-ono-sendai.svg", desc: "ono-sendai theme. base16." }
  , { filename: "maas.svg", href: "/assets/agency-sheet-maas.svg", desc: "maas neoform theme. base16." }
  ]

-- ============================================================
-- COMPONENT
-- ============================================================

razorgirlPage :: forall q i o m. H.Component q i o m
razorgirlPage = H.mkComponent
  { initialState: const unit
  , render: const render
  , eval: H.mkEval H.defaultEval
  }

render :: forall w i. HH.HTML w i
render =
  HH.div_
    [ sectionHeader "razorgirl"
    , HH.p
        [ cls [ "mb-4" ] ]
        [ HH.text "it was the style that mattered and the style was the same." ]
    , HH.p
        [ cls [ "mb-8" ] ]
        [ HH.text "the moderns were mercenaries, practical jokers, "
        , keyword 3 "nihilistic technofetishists"
        , HH.text "."
        ]
    , sectionHeader "assets"
    , HH.div
        [ cls [ "flex flex-col gap-4 mb-12" ] ]
        (map assetRow assets)
    , sectionHeader "transmissions"
    , HH.div_ (map quoteBlock quotes)
    ]

quoteBlock :: forall w i. Quote -> HH.HTML w i
quoteBlock q =
  HH.div
    [ cls [ "bg-card border-l-[3px] px-6 py-4 my-6 quote-breathe"
          , if q.accent == "primary" then "border-l-primary" else "border-l-status"
          ]
    ]
    [ HH.div
        [ cls [ "text-[0.75rem] text-muted-foreground uppercase tracking-wide mb-3 flex items-center gap-2" ] ]
        [ HH.span_ [ HH.text "i" ]
        , HH.text q.source
        ]
    , HH.div
        [ cls [ "text-text italic text-[0.9rem] leading-relaxed" ] ]
        [ HH.text q.text ]
    , if q.attribution == "" 
        then HH.text ""
        else HH.div
          [ cls [ "mt-3 text-muted-foreground text-[0.9rem]" ] ]
          [ HH.text q.attribution ]
    ]

assetRow :: forall w i. Asset -> HH.HTML w i
assetRow a =
  HH.div
    [ cls [ "grid grid-cols-[160px_1fr] gap-4 items-baseline group" ] ]
    [ HH.a
        [ HP.href a.href
        , HP.attr (HH.AttrName "download") ""
        , cls [ "text-text hover:text-primary transition-colors geo-hover" ]
        ]
        [ HH.text a.filename ]
    , HH.span
        [ cls [ "text-muted-foreground group-hover:text-text/70 transition-colors" ] ]
        [ HH.text a.desc ]
    ]
