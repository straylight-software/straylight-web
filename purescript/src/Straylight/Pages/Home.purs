-- | Product Landing Page
-- | Two product families. Ten external products. One attestation layer.
module Straylight.Pages.Home where

import Prelude

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

import Straylight.UI (cls, svgNS)

-- ============================================================
-- COMPONENT
-- ============================================================

homePage :: forall q i o m. H.Component q i o m
homePage = H.mkComponent
  { initialState: const unit
  , render: const render
  , eval: H.mkEval H.defaultEval
  }

-- ============================================================
-- RENDER
-- ============================================================

render :: forall w i. HH.HTML w i
render =
  HH.div_
    [ featured
    , productFamilies
    , cta
    ]

-- ============================================================
-- FEATURED: omega//code
-- ============================================================

featured :: forall w i. HH.HTML w i
featured =
  HH.section
    [ cls [ "py-16 md:py-24" ] ]
    [ HH.div
        [ cls [ "relative" ] ]
        [ -- Background glow
          HH.div 
            [ cls [ "absolute inset-0 bg-gradient-to-b from-blue-500/5 to-transparent rounded-3xl -z-10" ] ] 
            []
        , HH.div
            [ cls [ "text-center mb-12" ] ]
            [ badge "FLAGSHIP"
            , HH.h1
                [ cls [ "text-5xl md:text-7xl font-bold text-text mb-4" ] ]
                [ HH.span [ cls [ "text-blue-300" ] ] [ HH.text "omega" ]
                , HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text "//" ]
                , HH.span [ cls [ "text-text" ] ] [ HH.text "code" ]
                ]
            , HH.p
                [ cls [ "text-xl md:text-2xl text-muted-foreground max-w-2xl mx-auto mb-8" ] ]
                [ HH.text "Native terminal AI coding agent. Haskell core. io_uring event loop. 509k req/s." ]
            , HH.div
                [ cls [ "flex flex-col sm:flex-row items-center justify-center gap-4" ] ]
                [ primaryButton "/omega/code" "Get Started"
                , secondaryButton "/omega/code/docs" "Documentation"
                ]
            ]
        , -- Feature highlights
          HH.div
            [ cls [ "grid grid-cols-1 md:grid-cols-3 gap-6 mt-12" ] ]
            [ featureCard iconTerminal "Native TUI" "Brick-based terminal UI with mouse support, splits, and vim keybindings"
            , featureCard iconZap "509k req/s" "io_uring event loop. Zero-copy parsing. SIGIL protocol compression"
            , featureCard iconShield "Attestation" "Every code change cryptographically signed. Audit trail built-in"
            ]
        ]
    ]

-- ============================================================
-- PRODUCT FAMILIES
-- ============================================================

productFamilies :: forall w i. HH.HTML w i
productFamilies =
  HH.section
    [ cls [ "py-16 border-t border-border" ] ]
    [ -- Section header
      HH.div
        [ cls [ "text-center mb-12" ] ]
        [ HH.h2
            [ cls [ "text-3xl md:text-4xl font-bold text-text mb-4" ] ]
            [ HH.text "Product Map" ]
        , HH.p
            [ cls [ "text-muted-foreground text-lg" ] ]
            [ HH.text "Two product families. Ten products. One attestation layer." ]
        ]
    , -- Product grids
      HH.div
        [ cls [ "grid grid-cols-1 lg:grid-cols-2 gap-12" ] ]
        [ sensenetFamily
        , omegaFamily
        ]
    ]

sensenetFamily :: forall w i. HH.HTML w i
sensenetFamily =
  HH.div_
    [ familyHeader iconCube "SENSE//NET" "Build Infrastructure" "text-primary" "border-primary/30 bg-primary/5"
    , HH.div
        [ cls [ "grid gap-4" ] ]
        [ productCard 
            { icon: iconDatabase
            , name: "cache"
            , tagline: "Binary cache & artifact store"
            , desc: "Content-addressed. Post-quantum signatures. Attestation-aware."
            , href: "/sensenet/cache"
            , accent: "primary"
            }
        , productCard 
            { icon: iconHammer
            , name: "build"
            , tagline: "Typed build system"
            , desc: "Dhall configs. Lean4-proven derivations. Formal verification."
            , href: "/sensenet/build"
            , accent: "primary"
            }
        , productCard 
            { icon: iconGlobe
            , name: "converge"
            , tagline: "Infrastructure-as-code"
            , desc: "Desired-state convergence. No state files. No drift."
            , href: "/sensenet/converge"
            , accent: "primary"
            }
        , productCard 
            { icon: iconCheck
            , name: "confirm"
            , tagline: "CI with proof obligations"
            , desc: "Typed Dhall pipelines. Agent code faces higher review burden."
            , href: "/sensenet/confirm"
            , accent: "primary"
            }
        , productCard 
            { icon: iconGit
            , name: "forge"
            , tagline: "Code hosting + review"
            , desc: "Stacked diffs, not PRs. jujutsu first-class. Agent-era design."
            , href: "/sensenet/forge"
            , accent: "primary"
            }
        , productCard 
            { icon: iconBook
            , name: "publish"
            , tagline: "Scope-graph documentation"
            , desc: "References resolve or the build fails. Machine-readable."
            , href: "/sensenet/publish"
            , accent: "primary"
            }
        ]
    ]

omegaFamily :: forall w i. HH.HTML w i
omegaFamily =
  HH.div_
    [ familyHeader iconBrain "OMEGA" "Agent Infrastructure" "text-blue-300" "border-blue-300/30 bg-blue-300/5"
    , HH.div
        [ cls [ "grid gap-4" ] ]
        [ productCard 
            { icon: iconTerminal
            , name: "code"
            , tagline: "Native terminal AI agent"
            , desc: "Haskell + Brick TUI. io_uring. 509k req/s. SIGIL-native."
            , href: "/omega/code"
            , accent: "blue"
            }
        , productCard 
            { icon: iconWindow
            , name: "work"
            , tagline: "Desktop app for teams"
            , desc: "Same agent engine, GUI surface. For PMs, designers, analysts."
            , href: "/omega/work"
            , accent: "blue"
            }
        , productCard 
            { icon: iconNetwork
            , name: "proxy"
            , tagline: "Verified inference proxy"
            , desc: "jaylene-slide ingress. SSE → SIGIL over ZeroMQ. 200–600% compression."
            , href: "/omega/proxy"
            , accent: "blue"
            }
        , productCard 
            { icon: iconRocket
            , name: "boost"
            , tagline: "Managed inference"
            , desc: "BYOK vendor co-location. Custom CUTLASS 3.x sm_120 kernels."
            , href: "/omega/boost"
            , accent: "blue"
            }
        ]
    , -- Shared architecture
      sharedArchitecture
    ]

familyHeader :: forall w i. (forall w2 i2. HH.HTML w2 i2) -> String -> String -> String -> String -> HH.HTML w i
familyHeader icon name tagline accentClass bgClass =
  HH.div
    [ cls [ "flex items-center gap-4 mb-6 p-4 rounded-lg border", bgClass ] ]
    [ HH.div [ cls [ "w-10 h-10 flex items-center justify-center", accentClass ] ] [ icon ]
    , HH.div_
        [ HH.h3 [ cls [ "font-mono font-bold text-lg", accentClass ] ] [ HH.text name ]
        , HH.p [ cls [ "text-sm text-muted-foreground" ] ] [ HH.text tagline ]
        ]
    ]

productCard :: forall w i. 
  { icon :: HH.HTML w i
  , name :: String
  , tagline :: String
  , desc :: String
  , href :: String
  , accent :: String
  } -> HH.HTML w i
productCard opts =
  HH.a
    [ HP.href opts.href
    , cls [ "group flex gap-4 p-5 bg-card border border-border rounded-lg transition-all"
          , case opts.accent of
              "primary" -> "hover:border-primary hover:bg-primary/5"
              "blue" -> "hover:border-blue-300 hover:bg-blue-300/5"
              _ -> "hover:border-primary"
          ]
    ]
    [ -- Icon
      HH.div 
        [ cls [ "w-12 h-12 flex items-center justify-center rounded-lg border border-border bg-background group-hover:border-opacity-50 transition-colors"
              , case opts.accent of
                  "primary" -> "group-hover:border-primary group-hover:text-primary"
                  "blue" -> "group-hover:border-blue-300 group-hover:text-blue-300"
                  _ -> ""
              ] 
        ] 
        [ opts.icon ]
    , -- Content
      HH.div
        [ cls [ "flex-1 min-w-0" ] ]
        [ HH.div
            [ cls [ "flex items-baseline gap-2 mb-1" ] ]
            [ HH.span 
                [ cls [ "font-mono text-sm"
                      , case opts.accent of
                          "primary" -> "text-primary"
                          "blue" -> "text-blue-300"
                          _ -> "text-primary"
                      ] 
                ] 
                [ HH.text "//" ]
            , HH.span 
                [ cls [ "font-semibold text-text group-hover:text-primary transition-colors"
                      , case opts.accent of
                          "blue" -> "group-hover:text-blue-300"
                          _ -> ""
                      ] 
                ] 
                [ HH.text opts.name ]
            , HH.span
                [ cls [ "text-xs text-muted-foreground ml-2" ] ]
                [ HH.text opts.tagline ]
            ]
        , HH.p
            [ cls [ "text-sm text-muted-foreground line-clamp-2" ] ]
            [ HH.text opts.desc ]
        ]
    , -- Arrow
      HH.div
        [ cls [ "flex items-center text-muted-foreground group-hover:text-text transition-colors" ] ]
        [ HH.text "→" ]
    ]

featureCard :: forall w i. (forall w2 i2. HH.HTML w2 i2) -> String -> String -> HH.HTML w i
featureCard icon title desc =
  HH.div
    [ cls [ "p-6 bg-card border border-border rounded-lg text-center" ] ]
    [ HH.div 
        [ cls [ "w-12 h-12 mx-auto mb-4 flex items-center justify-center text-blue-300" ] ] 
        [ icon ]
    , HH.h4 
        [ cls [ "font-semibold text-text mb-2" ] ] 
        [ HH.text title ]
    , HH.p 
        [ cls [ "text-sm text-muted-foreground" ] ] 
        [ HH.text desc ]
    ]

sharedArchitecture :: forall w i. HH.HTML w i
sharedArchitecture =
  HH.div
    [ cls [ "mt-6 p-5 border border-blue-300/20 rounded-lg bg-blue-300/5" ] ]
    [ HH.div
        [ cls [ "font-mono text-[10px] text-blue-300 text-center mb-4 tracking-widest" ] ]
        [ HH.text "SHARED ARCHITECTURE" ]
    , HH.div
        [ cls [ "flex justify-center items-center gap-2 font-mono text-xs" ] ]
        [ archPill "code" "TUI"
        , HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text "╲" ]
        , HH.span [ cls [ "text-text px-4 py-2 border border-blue-300 rounded-md bg-blue-300/10 font-medium" ] ] 
            [ HH.text "Agent Engine" ]
        , HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text "╱" ]
        , archPill "work" "Electron"
        ]
    , HH.div
        [ cls [ "text-center mt-4 font-mono text-[9px] text-muted-foreground" ] ]
        [ HH.text "weapon-server · 95 endpoints · 221 property tests · SIGIL protocol" ]
    ]

archPill :: forall w i. String -> String -> HH.HTML w i
archPill name label =
  HH.span 
    [ cls [ "text-blue-300 px-3 py-1.5 border border-border rounded-md" ] ] 
    [ HH.text $ name <> " "
    , HH.span [ cls [ "text-muted-foreground text-[9px]" ] ] [ HH.text label ] 
    ]

-- ============================================================
-- CTA
-- ============================================================

cta :: forall w i. HH.HTML w i
cta =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "text-center" ] ]
        [ HH.h2
            [ cls [ "text-3xl font-bold text-text mb-4" ] ]
            [ HH.text "Ready to ship?" ]
        , HH.p
            [ cls [ "text-muted-foreground mb-8 max-w-xl mx-auto" ] ]
            [ HH.text "omega//code is in private beta. Join the waitlist or explore the documentation." ]
        , HH.div
            [ cls [ "flex flex-col sm:flex-row items-center justify-center gap-4" ] ]
            [ primaryButton "/omega/code" "Start with omega//code"
            , secondaryButton "https://github.com/straylight-software" "GitHub"
            ]
        ]
    ]

-- ============================================================
-- HELPERS
-- ============================================================

badge :: forall w i. String -> HH.HTML w i
badge label =
  HH.span
    [ cls [ "inline-block px-3 py-1 bg-blue-300/10 border border-blue-300/20 rounded-full text-blue-300 text-xs font-medium mb-4 tracking-wider" ] ]
    [ HH.text label ]

primaryButton :: forall w i. String -> String -> HH.HTML w i
primaryButton href label =
  HH.a
    [ HP.href href
    , cls [ "inline-flex items-center justify-center px-8 py-4 bg-blue-400 text-background font-semibold rounded-lg hover:bg-blue-300 transition-colors text-lg" ]
    ]
    [ HH.text label ]

secondaryButton :: forall w i. String -> String -> HH.HTML w i
secondaryButton href label =
  HH.a
    [ HP.href href
    , HP.target "_blank"
    , HP.rel "noopener noreferrer"
    , cls [ "inline-flex items-center justify-center px-8 py-4 border border-border text-text font-semibold rounded-lg hover:bg-card transition-colors text-lg" ]
    ]
    [ HH.text label ]

-- ============================================================
-- ICONS (SVG)
-- ============================================================

iconTerminal :: forall w i. HH.HTML w i
iconTerminal =
  HH.elementNS svgNS (HH.ElemName "svg")
    [ cls [ "w-6 h-6" ]
    , HP.attr (HH.AttrName "fill") "none"
    , HP.attr (HH.AttrName "stroke") "currentColor"
    , HP.attr (HH.AttrName "viewBox") "0 0 24 24"
    , HP.attr (HH.AttrName "stroke-width") "1.5"
    ]
    [ HH.elementNS svgNS (HH.ElemName "path")
        [ HP.attr (HH.AttrName "stroke-linecap") "round"
        , HP.attr (HH.AttrName "stroke-linejoin") "round"
        , HP.attr (HH.AttrName "d") "m6.75 7.5 3 2.25-3 2.25m4.5 0h3m-9 8.25h13.5A2.25 2.25 0 0 0 21 18V6a2.25 2.25 0 0 0-2.25-2.25H5.25A2.25 2.25 0 0 0 3 6v12a2.25 2.25 0 0 0 2.25 2.25Z"
        ]
        []
    ]

iconZap :: forall w i. HH.HTML w i
iconZap =
  HH.elementNS svgNS (HH.ElemName "svg")
    [ cls [ "w-6 h-6" ]
    , HP.attr (HH.AttrName "fill") "none"
    , HP.attr (HH.AttrName "stroke") "currentColor"
    , HP.attr (HH.AttrName "viewBox") "0 0 24 24"
    , HP.attr (HH.AttrName "stroke-width") "1.5"
    ]
    [ HH.elementNS svgNS (HH.ElemName "path")
        [ HP.attr (HH.AttrName "stroke-linecap") "round"
        , HP.attr (HH.AttrName "stroke-linejoin") "round"
        , HP.attr (HH.AttrName "d") "m3.75 13.5 10.5-11.25L12 10.5h8.25L9.75 21.75 12 13.5H3.75Z"
        ]
        []
    ]

iconShield :: forall w i. HH.HTML w i
iconShield =
  HH.elementNS svgNS (HH.ElemName "svg")
    [ cls [ "w-6 h-6" ]
    , HP.attr (HH.AttrName "fill") "none"
    , HP.attr (HH.AttrName "stroke") "currentColor"
    , HP.attr (HH.AttrName "viewBox") "0 0 24 24"
    , HP.attr (HH.AttrName "stroke-width") "1.5"
    ]
    [ HH.elementNS svgNS (HH.ElemName "path")
        [ HP.attr (HH.AttrName "stroke-linecap") "round"
        , HP.attr (HH.AttrName "stroke-linejoin") "round"
        , HP.attr (HH.AttrName "d") "M9 12.75 11.25 15 15 9.75m-3-7.036A11.959 11.959 0 0 1 3.598 6 11.99 11.99 0 0 0 3 9.749c0 5.592 3.824 10.29 9 11.623 5.176-1.332 9-6.03 9-11.622 0-1.31-.21-2.571-.598-3.751h-.152c-3.196 0-6.1-1.248-8.25-3.285Z"
        ]
        []
    ]

iconDatabase :: forall w i. HH.HTML w i
iconDatabase =
  HH.elementNS svgNS (HH.ElemName "svg")
    [ cls [ "w-5 h-5" ]
    , HP.attr (HH.AttrName "fill") "none"
    , HP.attr (HH.AttrName "stroke") "currentColor"
    , HP.attr (HH.AttrName "viewBox") "0 0 24 24"
    , HP.attr (HH.AttrName "stroke-width") "1.5"
    ]
    [ HH.elementNS svgNS (HH.ElemName "path")
        [ HP.attr (HH.AttrName "stroke-linecap") "round"
        , HP.attr (HH.AttrName "stroke-linejoin") "round"
        , HP.attr (HH.AttrName "d") "M20.25 6.375c0 2.278-3.694 4.125-8.25 4.125S3.75 8.653 3.75 6.375m16.5 0c0-2.278-3.694-4.125-8.25-4.125S3.75 4.097 3.75 6.375m16.5 0v11.25c0 2.278-3.694 4.125-8.25 4.125s-8.25-1.847-8.25-4.125V6.375m16.5 0v3.75m-16.5-3.75v3.75m16.5 0v3.75C20.25 16.153 16.556 18 12 18s-8.25-1.847-8.25-4.125v-3.75m16.5 0c0 2.278-3.694 4.125-8.25 4.125s-8.25-1.847-8.25-4.125"
        ]
        []
    ]

iconHammer :: forall w i. HH.HTML w i
iconHammer =
  HH.elementNS svgNS (HH.ElemName "svg")
    [ cls [ "w-5 h-5" ]
    , HP.attr (HH.AttrName "fill") "none"
    , HP.attr (HH.AttrName "stroke") "currentColor"
    , HP.attr (HH.AttrName "viewBox") "0 0 24 24"
    , HP.attr (HH.AttrName "stroke-width") "1.5"
    ]
    [ HH.elementNS svgNS (HH.ElemName "path")
        [ HP.attr (HH.AttrName "stroke-linecap") "round"
        , HP.attr (HH.AttrName "stroke-linejoin") "round"
        , HP.attr (HH.AttrName "d") "M11.42 15.17 17.25 21A2.652 2.652 0 0 0 21 17.25l-5.877-5.877M11.42 15.17l2.496-3.03c.317-.384.74-.626 1.208-.766M11.42 15.17l-4.655 5.653a2.548 2.548 0 1 1-3.586-3.586l6.837-5.63m5.108-.233c.55-.164 1.163-.188 1.743-.14a4.5 4.5 0 0 0 4.486-6.336l-3.276 3.277a3.004 3.004 0 0 1-2.25-2.25l3.276-3.276a4.5 4.5 0 0 0-6.336 4.486c.091 1.076-.071 2.264-.904 2.95l-.102.085m-1.745 1.437L5.909 7.5H4.5L2.25 3.75l1.5-1.5L7.5 4.5v1.409l4.26 4.26m-1.745 1.437 1.745-1.437m6.615 8.206L15.75 15.75M4.867 19.125h.008v.008h-.008v-.008Z"
        ]
        []
    ]

iconGlobe :: forall w i. HH.HTML w i
iconGlobe =
  HH.elementNS svgNS (HH.ElemName "svg")
    [ cls [ "w-5 h-5" ]
    , HP.attr (HH.AttrName "fill") "none"
    , HP.attr (HH.AttrName "stroke") "currentColor"
    , HP.attr (HH.AttrName "viewBox") "0 0 24 24"
    , HP.attr (HH.AttrName "stroke-width") "1.5"
    ]
    [ HH.elementNS svgNS (HH.ElemName "path")
        [ HP.attr (HH.AttrName "stroke-linecap") "round"
        , HP.attr (HH.AttrName "stroke-linejoin") "round"
        , HP.attr (HH.AttrName "d") "M12 21a9.004 9.004 0 0 0 8.716-6.747M12 21a9.004 9.004 0 0 1-8.716-6.747M12 21c2.485 0 4.5-4.03 4.5-9S14.485 3 12 3m0 18c-2.485 0-4.5-4.03-4.5-9S9.515 3 12 3m0 0a8.997 8.997 0 0 1 7.843 4.582M12 3a8.997 8.997 0 0 0-7.843 4.582m15.686 0A11.953 11.953 0 0 1 12 10.5c-2.998 0-5.74-1.1-7.843-2.918m15.686 0A8.959 8.959 0 0 1 21 12c0 .778-.099 1.533-.284 2.253m0 0A17.919 17.919 0 0 1 12 16.5c-3.162 0-6.133-.815-8.716-2.247m0 0A9.015 9.015 0 0 1 3 12c0-1.605.42-3.113 1.157-4.418"
        ]
        []
    ]

iconCheck :: forall w i. HH.HTML w i
iconCheck =
  HH.elementNS svgNS (HH.ElemName "svg")
    [ cls [ "w-5 h-5" ]
    , HP.attr (HH.AttrName "fill") "none"
    , HP.attr (HH.AttrName "stroke") "currentColor"
    , HP.attr (HH.AttrName "viewBox") "0 0 24 24"
    , HP.attr (HH.AttrName "stroke-width") "1.5"
    ]
    [ HH.elementNS svgNS (HH.ElemName "path")
        [ HP.attr (HH.AttrName "stroke-linecap") "round"
        , HP.attr (HH.AttrName "stroke-linejoin") "round"
        , HP.attr (HH.AttrName "d") "M9 12.75 11.25 15 15 9.75M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"
        ]
        []
    ]

iconGit :: forall w i. HH.HTML w i
iconGit =
  HH.elementNS svgNS (HH.ElemName "svg")
    [ cls [ "w-5 h-5" ]
    , HP.attr (HH.AttrName "fill") "none"
    , HP.attr (HH.AttrName "stroke") "currentColor"
    , HP.attr (HH.AttrName "viewBox") "0 0 24 24"
    , HP.attr (HH.AttrName "stroke-width") "1.5"
    ]
    [ HH.elementNS svgNS (HH.ElemName "path")
        [ HP.attr (HH.AttrName "stroke-linecap") "round"
        , HP.attr (HH.AttrName "stroke-linejoin") "round"
        , HP.attr (HH.AttrName "d") "M17.25 6.75 22.5 12l-5.25 5.25m-10.5 0L1.5 12l5.25-5.25m7.5-3-4.5 16.5"
        ]
        []
    ]

iconBook :: forall w i. HH.HTML w i
iconBook =
  HH.elementNS svgNS (HH.ElemName "svg")
    [ cls [ "w-5 h-5" ]
    , HP.attr (HH.AttrName "fill") "none"
    , HP.attr (HH.AttrName "stroke") "currentColor"
    , HP.attr (HH.AttrName "viewBox") "0 0 24 24"
    , HP.attr (HH.AttrName "stroke-width") "1.5"
    ]
    [ HH.elementNS svgNS (HH.ElemName "path")
        [ HP.attr (HH.AttrName "stroke-linecap") "round"
        , HP.attr (HH.AttrName "stroke-linejoin") "round"
        , HP.attr (HH.AttrName "d") "M12 6.042A8.967 8.967 0 0 0 6 3.75c-1.052 0-2.062.18-3 .512v14.25A8.987 8.987 0 0 1 6 18c2.305 0 4.408.867 6 2.292m0-14.25a8.966 8.966 0 0 1 6-2.292c1.052 0 2.062.18 3 .512v14.25A8.987 8.987 0 0 0 18 18a8.967 8.967 0 0 0-6 2.292m0-14.25v14.25"
        ]
        []
    ]

iconCube :: forall w i. HH.HTML w i
iconCube =
  HH.elementNS svgNS (HH.ElemName "svg")
    [ cls [ "w-6 h-6" ]
    , HP.attr (HH.AttrName "fill") "none"
    , HP.attr (HH.AttrName "stroke") "currentColor"
    , HP.attr (HH.AttrName "viewBox") "0 0 24 24"
    , HP.attr (HH.AttrName "stroke-width") "1.5"
    ]
    [ HH.elementNS svgNS (HH.ElemName "path")
        [ HP.attr (HH.AttrName "stroke-linecap") "round"
        , HP.attr (HH.AttrName "stroke-linejoin") "round"
        , HP.attr (HH.AttrName "d") "m21 7.5-9-5.25L3 7.5m18 0-9 5.25m9-5.25v9l-9 5.25M3 7.5l9 5.25M3 7.5v9l9 5.25m0-9v9"
        ]
        []
    ]

iconBrain :: forall w i. HH.HTML w i
iconBrain =
  HH.elementNS svgNS (HH.ElemName "svg")
    [ cls [ "w-6 h-6" ]
    , HP.attr (HH.AttrName "fill") "none"
    , HP.attr (HH.AttrName "stroke") "currentColor"
    , HP.attr (HH.AttrName "viewBox") "0 0 24 24"
    , HP.attr (HH.AttrName "stroke-width") "1.5"
    ]
    [ HH.elementNS svgNS (HH.ElemName "path")
        [ HP.attr (HH.AttrName "stroke-linecap") "round"
        , HP.attr (HH.AttrName "stroke-linejoin") "round"
        , HP.attr (HH.AttrName "d") "M9.813 15.904 9 18.75l-.813-2.846a4.5 4.5 0 0 0-3.09-3.09L2.25 12l2.846-.813a4.5 4.5 0 0 0 3.09-3.09L9 5.25l.813 2.846a4.5 4.5 0 0 0 3.09 3.09L15.75 12l-2.846.813a4.5 4.5 0 0 0-3.09 3.09ZM18.259 8.715 18 9.75l-.259-1.035a3.375 3.375 0 0 0-2.455-2.456L14.25 6l1.036-.259a3.375 3.375 0 0 0 2.455-2.456L18 2.25l.259 1.035a3.375 3.375 0 0 0 2.456 2.456L21.75 6l-1.035.259a3.375 3.375 0 0 0-2.456 2.456ZM16.894 20.567 16.5 21.75l-.394-1.183a2.25 2.25 0 0 0-1.423-1.423L13.5 18.75l1.183-.394a2.25 2.25 0 0 0 1.423-1.423l.394-1.183.394 1.183a2.25 2.25 0 0 0 1.423 1.423l1.183.394-1.183.394a2.25 2.25 0 0 0-1.423 1.423Z"
        ]
        []
    ]

iconWindow :: forall w i. HH.HTML w i
iconWindow =
  HH.elementNS svgNS (HH.ElemName "svg")
    [ cls [ "w-5 h-5" ]
    , HP.attr (HH.AttrName "fill") "none"
    , HP.attr (HH.AttrName "stroke") "currentColor"
    , HP.attr (HH.AttrName "viewBox") "0 0 24 24"
    , HP.attr (HH.AttrName "stroke-width") "1.5"
    ]
    [ HH.elementNS svgNS (HH.ElemName "path")
        [ HP.attr (HH.AttrName "stroke-linecap") "round"
        , HP.attr (HH.AttrName "stroke-linejoin") "round"
        , HP.attr (HH.AttrName "d") "M9 17.25v1.007a3 3 0 0 1-.879 2.122L7.5 21h9l-.621-.621A3 3 0 0 1 15 18.257V17.25m6-12V15a2.25 2.25 0 0 1-2.25 2.25H5.25A2.25 2.25 0 0 1 3 15V5.25m18 0A2.25 2.25 0 0 0 18.75 3H5.25A2.25 2.25 0 0 0 3 5.25m18 0V12a2.25 2.25 0 0 1-2.25 2.25H5.25A2.25 2.25 0 0 1 3 12V5.25"
        ]
        []
    ]

iconNetwork :: forall w i. HH.HTML w i
iconNetwork =
  HH.elementNS svgNS (HH.ElemName "svg")
    [ cls [ "w-5 h-5" ]
    , HP.attr (HH.AttrName "fill") "none"
    , HP.attr (HH.AttrName "stroke") "currentColor"
    , HP.attr (HH.AttrName "viewBox") "0 0 24 24"
    , HP.attr (HH.AttrName "stroke-width") "1.5"
    ]
    [ HH.elementNS svgNS (HH.ElemName "path")
        [ HP.attr (HH.AttrName "stroke-linecap") "round"
        , HP.attr (HH.AttrName "stroke-linejoin") "round"
        , HP.attr (HH.AttrName "d") "M7.5 21 3 16.5m0 0L7.5 12M3 16.5h13.5m0-13.5L21 7.5m0 0L16.5 12M21 7.5H7.5"
        ]
        []
    ]

iconRocket :: forall w i. HH.HTML w i
iconRocket =
  HH.elementNS svgNS (HH.ElemName "svg")
    [ cls [ "w-5 h-5" ]
    , HP.attr (HH.AttrName "fill") "none"
    , HP.attr (HH.AttrName "stroke") "currentColor"
    , HP.attr (HH.AttrName "viewBox") "0 0 24 24"
    , HP.attr (HH.AttrName "stroke-width") "1.5"
    ]
    [ HH.elementNS svgNS (HH.ElemName "path")
        [ HP.attr (HH.AttrName "stroke-linecap") "round"
        , HP.attr (HH.AttrName "stroke-linejoin") "round"
        , HP.attr (HH.AttrName "d") "M15.59 14.37a6 6 0 0 1-5.84 7.38v-4.8m5.84-2.58a14.98 14.98 0 0 0 6.16-12.12A14.98 14.98 0 0 0 9.631 8.41m5.96 5.96a14.926 14.926 0 0 1-5.841 2.58m-.119-8.54a6 6 0 0 0-7.381 5.84h4.8m2.581-5.84a14.927 14.927 0 0 0-2.58 5.84m2.699 2.7c-.103.021-.207.041-.311.06a15.09 15.09 0 0 1-2.448-2.448 14.9 14.9 0 0 1 .06-.312m-2.24 2.39a4.493 4.493 0 0 0-1.757 4.306 4.493 4.493 0 0 0 4.306-1.758M16.5 9a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0Z"
        ]
        []
    ]
