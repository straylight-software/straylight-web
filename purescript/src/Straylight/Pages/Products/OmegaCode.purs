-- | omega//code Product Page
-- | Native Terminal AI Coding Agent
module Straylight.Pages.Products.OmegaCode where

import Prelude

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

import Straylight.UI (cls)

-- ============================================================
-- COMPONENT
-- ============================================================

omegaCodePage :: forall q i o m. H.Component q i o m
omegaCodePage = H.mkComponent
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
    [ hero
    , benchmarks
    , featureNative
    , featureIoUring
    , featureSigil
    , featureCrew
    , architecture
    , cta
    ]

-- ============================================================
-- HERO
-- ============================================================

hero :: forall w i. HH.HTML w i
hero =
  HH.section
    [ cls [ "py-24 md:py-32" ] ]
    [ HH.div
        [ cls [ "text-center" ] ]
        [ badge "Private Beta"
        , HH.h1
            [ cls [ "text-4xl md:text-6xl font-bold text-text mb-6 leading-tight" ] ]
            [ HH.span [ cls [ "text-blue-300" ] ] [ HH.text "omega//" ]
            , HH.text "code"
            ]
        , HH.p
            [ cls [ "text-xl text-muted-foreground max-w-2xl mx-auto mb-4" ] ]
            [ HH.text "Native Terminal AI Coding Agent" ]
        , HH.p
            [ cls [ "font-mono text-sm text-muted-foreground" ] ]
            [ HH.span [ cls [ "text-blue-300/60" ] ] [ HH.text "replaces " ]
            , HH.text "Claude Code, Cursor, Windsurf, Aider, Copilot Workspace"
            ]
        ]
    ]

-- ============================================================
-- BENCHMARKS
-- ============================================================

benchmarks :: forall w i. HH.HTML w i
benchmarks =
  HH.section
    [ cls [ "py-16 border-t border-border" ] ]
    [ HH.div
        [ cls [ "grid grid-cols-2 md:grid-cols-4 gap-4" ] ]
        [ benchItem "509k" "req/s (evring-wai)"
        , benchItem "5.1×" "vs Warp throughput"
        , benchItem "63×" "better p99 latency"
        , benchItem "95" "API endpoints (100%)"
        ]
    ]

benchItem :: forall w i. String -> String -> HH.HTML w i
benchItem value label =
  HH.div
    [ cls [ "bg-card border border-border rounded-lg p-6 text-center hover:border-blue-300/50 transition-colors" ] ]
    [ HH.div
        [ cls [ "font-mono font-bold text-3xl text-blue-300 mb-1" ] ]
        [ HH.text value ]
    , HH.div
        [ cls [ "font-mono text-xs text-muted-foreground" ] ]
        [ HH.text label ]
    ]

-- ============================================================
-- FEATURE: NATIVE
-- ============================================================

featureNative :: forall w i. HH.HTML w i
featureNative =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "grid grid-cols-1 lg:grid-cols-2 gap-16 items-center" ] ]
        [ -- Left: content
          HH.div_
            [ badge "NO REACT"
            , HH.h2
                [ cls [ "text-3xl font-bold text-text mb-6" ] ]
                [ HH.text "Haskell + Brick TUI" ]
            , HH.p
                [ cls [ "text-muted-foreground mb-6" ] ]
                [ HH.text "Native terminal rendering. No Ink. No Electron. No virtual DOM rebuilding monospace text. Sub-millisecond rendering from a real compiled binary." ]
            , featureList
                [ "Pure Haskell with Brick terminal UI library"
                , "No Node.js runtime, no React reconciler overhead"
                , "Sub-millisecond render cycles"
                , "Static binary — no dependencies at runtime"
                , "10x smaller memory footprint than Electron alternatives"
                ]
            ]
        , -- Right: visual
          HH.div
            [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
            [ codeBlock
                [ HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text "-- weapon-server-hs/Main.hs" ]
                , HH.text "\n"
                , HH.span [ cls [ "text-blue-300" ] ] [ HH.text "main" ]
                , HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text " :: " ]
                , HH.span [ cls [ "text-text" ] ] [ HH.text "IO ()" ]
                , HH.text "\n"
                , HH.span [ cls [ "text-blue-300" ] ] [ HH.text "main" ]
                , HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text " = " ]
                , HH.span [ cls [ "text-text" ] ] [ HH.text "runEvring $ do" ]
                , HH.text "\n"
                , HH.span [ cls [ "text-text" ] ] [ HH.text "  server <- startWeaponServer" ]
                , HH.text "\n"
                , HH.span [ cls [ "text-text" ] ] [ HH.text "  runBrickApp server" ]
                ]
            ]
        ]
    ]

-- ============================================================
-- FEATURE: IO_URING
-- ============================================================

featureIoUring :: forall w i. HH.HTML w i
featureIoUring =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "grid grid-cols-1 lg:grid-cols-2 gap-16 items-center" ] ]
        [ -- Left: visual (reversed order on large screens)
          HH.div
            [ cls [ "order-2 lg:order-1" ] ]
            [ HH.div
                [ cls [ "bg-card border border-border rounded-lg p-6 space-y-4" ] ]
                [ throughputBar "evring-wai" 509 "text-blue-300"
                , throughputBar "Warp" 99 "text-muted-foreground"
                , HH.p
                    [ cls [ "text-sm text-muted-foreground text-center pt-2" ] ]
                    [ HH.text "req/s (thousands) — higher is better" ]
                ]
            ]
        , -- Right: content
          HH.div
            [ cls [ "order-1 lg:order-2" ] ]
            [ badge "EVRING"
            , HH.h2
                [ cls [ "text-3xl font-bold text-text mb-6" ] ]
                [ HH.text "io_uring event loop" ]
            , HH.p
                [ cls [ "text-muted-foreground mb-6" ] ]
                [ HH.text "evring-wai: 509k req/s vs Warp's 99k. Share-nothing per-core rings with SO_REUSEPORT. Warp shows negative multi-core scaling. We scale linearly." ]
            , featureList
                [ "Linux io_uring for async I/O"
                , "Share-nothing per-core architecture"
                , "SO_REUSEPORT load balancing"
                , "Zero-copy where possible"
                , "Deterministic state machines (testable without I/O)"
                ]
            ]
        ]
    ]

throughputBar :: forall w i. String -> Int -> String -> HH.HTML w i
throughputBar label value color =
  HH.div_
    [ HH.div
        [ cls [ "flex justify-between text-sm mb-2" ] ]
        [ HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text label ]
        , HH.span [ cls [ color, "font-mono" ] ] [ HH.text $ show value <> "k" ]
        ]
    , HH.div
        [ cls [ "h-4 bg-background rounded-full overflow-hidden" ] ]
        [ HH.div
            [ cls [ "h-full rounded-full transition-all duration-1000"
                  , if value > 200 then "bg-blue-300" else "bg-muted-foreground/50"
                  ]
            , HP.style $ "width: " <> show (value * 100 / 509) <> "%"
            ]
            []
        ]
    ]

-- ============================================================
-- FEATURE: SIGIL
-- ============================================================

featureSigil :: forall w i. HH.HTML w i
featureSigil =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "grid grid-cols-1 lg:grid-cols-2 gap-16 items-center" ] ]
        [ -- Left: content
          HH.div_
            [ badge "18 PROOFS"
            , HH.h2
                [ cls [ "text-3xl font-bold text-text mb-6" ] ]
                [ HH.text "SIGIL-native protocol" ]
            , HH.p
                [ cls [ "text-muted-foreground mb-6" ] ]
                [ HH.text "Semantic frames via jaylene-slide, not JSON string parsing. 18 Lean4-proven theorems, 0 sorry. Reset-on-ambiguity: corrupted parse cannot propagate to your agent." ]
            , featureList
                [ "Lean4-proven protocol semantics"
                , "18 theorems, 0 sorry (no incomplete proofs)"
                , "Reset-on-ambiguity prevents corruption propagation"
                , "jaylene-slide for streaming SSE → SIGIL"
                , "200–600% wire compression vs JSON"
                ]
            ]
        , -- Right: visual
          HH.div
            [ cls [ "grid grid-cols-2 gap-4" ] ]
            [ proofCard "18" "Lean4 theorems"
            , proofCard "0" "sorry (incomplete)"
            , proofCard "221" "property tests"
            , proofCard "95" "API endpoints"
            ]
        ]
    ]

proofCard :: forall w i. String -> String -> HH.HTML w i
proofCard value label =
  HH.div
    [ cls [ "bg-card border border-border rounded-lg p-6 text-center" ] ]
    [ HH.p [ cls [ "text-2xl font-bold text-blue-300 mb-1" ] ] [ HH.text value ]
    , HH.p [ cls [ "text-sm text-muted-foreground" ] ] [ HH.text label ]
    ]

-- ============================================================
-- FEATURE: CREW
-- ============================================================

featureCrew :: forall w i. HH.HTML w i
featureCrew =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "grid grid-cols-1 lg:grid-cols-2 gap-16 items-center" ] ]
        [ -- Left: visual
          HH.div
            [ cls [ "order-2 lg:order-1" ] ]
            [ HH.div
                [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
                [ HH.div
                    [ cls [ "font-mono text-xs text-muted-foreground mb-4" ] ]
                    [ HH.text "// crew orchestration" ]
                , HH.div
                    [ cls [ "space-y-3" ] ]
                    [ crewAgent "agent-1" "refactoring" "running"
                    , crewAgent "agent-2" "refactoring" "running"
                    , crewAgent "agent-3" "refactoring" "complete ✓"
                    ]
                , HH.div
                    [ cls [ "mt-4 pt-4 border-t border-border text-sm text-muted-foreground" ] ]
                    [ HH.text "best result wins · losers discarded · attestation on merge" ]
                ]
            ]
        , -- Right: content
          HH.div
            [ cls [ "order-1 lg:order-2" ] ]
            [ badge "COW"
            , HH.h2
                [ cls [ "text-3xl font-bold text-text mb-6" ] ]
                [ HH.text "Crew orchestration" ]
            , HH.p
                [ cls [ "text-muted-foreground mb-6" ] ]
                [ HH.text "Parallel competing agents on the same task. CoW filesystem isolation per agent via bwrap. Best result wins. Losers discarded. Attestation on merge." ]
            , featureList
                [ "Parallel agent execution"
                , "Copy-on-write filesystem isolation via bubblewrap"
                , "Automatic result comparison and selection"
                , "Attestation-first: every merge is cryptographically signed"
                , "Post-quantum hybrid signatures via Continuity kernel"
                ]
            ]
        ]
    ]

crewAgent :: forall w i. String -> String -> String -> HH.HTML w i
crewAgent name _task status =
  HH.div
    [ cls [ "flex items-center justify-between p-3 bg-background rounded" ] ]
    [ HH.div
        [ cls [ "flex items-center gap-3" ] ]
        [ HH.span 
            [ cls [ "w-2 h-2 rounded-full"
                  , if status == "complete ✓" then "bg-green-500" else "bg-blue-300 animate-pulse"
                  ] 
            ] 
            []
        , HH.span [ cls [ "font-mono text-sm text-text" ] ] [ HH.text name ]
        ]
    , HH.span [ cls [ "text-xs text-muted-foreground" ] ] [ HH.text status ]
    ]

-- ============================================================
-- ARCHITECTURE
-- ============================================================

architecture :: forall w i. HH.HTML w i
architecture =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "text-center mb-12" ] ]
        [ badge "RUNTIME"
        , HH.h2
            [ cls [ "text-3xl font-bold text-text mb-4" ] ]
            [ HH.text "Architecture" ]
        ]
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-8" ] ]
        [ HH.div
            [ cls [ "flex items-center justify-center gap-2 flex-wrap font-mono text-sm mb-6" ] ]
            [ archNode "LLM Provider" false
            , archArrow
            , archNode "jaylene-slide" true
            , archArrow
            , archNode "SIGIL / ZMQ" false
            , archArrow
            , archNode "weapon-server" true
            , archArrow
            , archNode "evring / io_uring" false
            , archArrow
            , archNode "Brick TUI" false
            ]
        , HH.div
            [ cls [ "flex justify-center gap-8 text-xs text-muted-foreground" ] ]
            [ archLegend "bg-green-500" "Haskell (weapon-server, slide, Brick)"
            , archLegend "bg-blue-400" "C++23 (libevring, io_uring)"
            , archLegend "bg-blue-300" "Lean4 (Cornell proofs, Continuity)"
            ]
        ]
    ]

archNode :: forall w i. String -> Boolean -> HH.HTML w i
archNode label highlight =
  HH.span
    [ cls [ "px-4 py-2 rounded-md border transition-colors"
          , if highlight 
              then "border-primary text-primary bg-primary/10" 
              else "border-border text-text hover:border-blue-300"
          ] 
    ]
    [ HH.text label ]

archArrow :: forall w i. HH.HTML w i
archArrow = HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text "→" ]

archLegend :: forall w i. String -> String -> HH.HTML w i
archLegend dotColor label =
  HH.span
    [ cls [ "flex items-center gap-2" ] ]
    [ HH.span [ cls [ "w-2 h-2 rounded-full", dotColor ] ] []
    , HH.text label
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
            [ HH.text "Ready to try it?" ]
        , HH.p
            [ cls [ "text-muted-foreground mb-8 max-w-xl mx-auto" ] ]
            [ HH.text "omega//code is in private beta. Join the waitlist or check out the source." ]
        , HH.div
            [ cls [ "flex flex-col sm:flex-row items-center justify-center gap-4" ] ]
            [ primaryButton "/waitlist" "Join waitlist"
            , secondaryButton "https://github.com/straylight-software" "View on GitHub"
            ]
        ]
    ]

-- ============================================================
-- HELPERS
-- ============================================================

badge :: forall w i. String -> HH.HTML w i
badge label =
  HH.span
    [ cls [ "inline-block px-3 py-1 bg-blue-300/10 border border-blue-300/20 rounded-full text-blue-300 text-sm font-medium mb-4" ] ]
    [ HH.text label ]

featureList :: forall w i. Array String -> HH.HTML w i
featureList items =
  HH.ul
    [ cls [ "space-y-3" ] ]
    (map featureItem items)

featureItem :: forall w i. String -> HH.HTML w i
featureItem text =
  HH.li
    [ cls [ "flex items-start gap-3" ] ]
    [ HH.span [ cls [ "text-blue-300 mt-1" ] ] [ HH.text "+" ]
    , HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text text ]
    ]

codeBlock :: forall w i. Array (HH.HTML w i) -> HH.HTML w i
codeBlock children =
  HH.pre
    [ cls [ "font-mono text-sm leading-relaxed" ] ]
    children

primaryButton :: forall w i. String -> String -> HH.HTML w i
primaryButton href label =
  HH.a
    [ HP.href href
    , cls [ "inline-flex items-center justify-center px-6 py-3 bg-blue-300 text-background font-medium rounded-md hover:bg-blue-300/90 transition-colors" ]
    ]
    [ HH.text label ]

secondaryButton :: forall w i. String -> String -> HH.HTML w i
secondaryButton href label =
  HH.a
    [ HP.href href
    , HP.target "_blank"
    , HP.rel "noopener noreferrer"
    , cls [ "inline-flex items-center justify-center px-6 py-3 border border-border text-text font-medium rounded-md hover:bg-card transition-colors" ]
    ]
    [ HH.text label ]
