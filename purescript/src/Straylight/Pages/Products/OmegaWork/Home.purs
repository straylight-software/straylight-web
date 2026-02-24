-- | omega//work Landing Page
-- | Electron desktop app for non-coders. Same agent engine, GUI surface.
module Straylight.Pages.Products.OmegaWork.Home 
  ( homePage
  , render
  ) where

import Prelude

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

import Straylight.UI (cls, codeBlock)

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
    [ hero
    , features
    , comparison
    , quickstart
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
        [ cls [ "max-w-[1100px] mx-auto px-6 text-center" ] ]
        [ -- Badge
          HH.div
            [ cls [ "inline-flex items-center gap-2 px-3 py-1 bg-amber-400/10 border border-amber-400/20 rounded-full text-amber-400 text-sm mb-8" ] ]
            [ HH.span [ cls [ "w-2 h-2 bg-amber-400 rounded-full animate-pulse" ] ] []
            , HH.text "Coming soon"
            ]
          
          -- Headline
        , HH.h1
            [ cls [ "text-4xl md:text-6xl font-bold text-text mb-6 leading-tight" ] ]
            [ HH.text "AI coding"
            , HH.br_
            , HH.text "without the "
            , HH.span [ cls [ "text-amber-400" ] ] [ HH.text "terminal" ]
            ]
          
          -- Subheadline
        , HH.p
            [ cls [ "text-xl text-muted-foreground mb-10 max-w-2xl mx-auto" ] ]
            [ HH.text "omega//work brings the full power of our agent engine to a native desktop app. Same reliability, same speed, beautiful GUI. Built for creators who prefer visual interfaces." ]
          
          -- CTAs
        , HH.div
            [ cls [ "flex flex-col sm:flex-row items-center justify-center gap-4" ] ]
            [ primaryButton "/omega/work/pricing" "Join the waitlist"
            , secondaryButton "/omega/work/features" "Explore features"
            ]
          
          -- Platform badges
        , HH.div
            [ cls [ "mt-12 flex items-center justify-center gap-6 text-muted-foreground text-sm" ] ]
            [ platformBadge "macOS"
            , platformBadge "Windows"
            , platformBadge "Linux"
            ]
          
          -- Social proof
        , HH.p
            [ cls [ "mt-8 text-sm text-muted-foreground" ] ]
            [ HH.text "Same engine powering omega//code, with a GUI surface" ]
        ]
    ]

platformBadge :: forall w i. String -> HH.HTML w i
platformBadge platform =
  HH.span
    [ cls [ "flex items-center gap-2" ] ]
    [ HH.span [ cls [ "w-1.5 h-1.5 bg-amber-400/50 rounded-full" ] ] []
    , HH.text platform
    ]

-- ============================================================
-- FEATURES
-- ============================================================

features :: forall w i. HH.HTML w i
features =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "max-w-[1100px] mx-auto px-6" ] ]
        [ HH.div
            [ cls [ "text-center mb-16" ] ]
            [ HH.h2
                [ cls [ "text-3xl font-bold text-text mb-4" ] ]
                [ HH.text "Why omega//work?" ]
            , HH.p
                [ cls [ "text-muted-foreground max-w-xl mx-auto" ] ]
                [ HH.text "Built for non-coders who want AI assistance without learning command-line tools." ]
            ]
        , HH.div
            [ cls [ "grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6" ] ]
            [ featureCard ">" "Visual interface"
                "Point-and-click file selection, drag-and-drop context, visual diff previews. No terminal required."
            , featureCard "{}" "Same engine"
                "Powered by the same battle-tested agent engine as omega//code. SIGIL protocol, Lean4 proofs, full reliability."
            , featureCard "!" "Native performance"
                "Electron + Rust core. Smooth 60fps UI, instant file operations, minimal memory footprint."
            , featureCard "++" "Project workspaces"
                "Organize your work into projects. Context persists across sessions. Pick up where you left off."
            , featureCard "=" "Real-time preview"
                "See changes as they happen. Side-by-side diffs, syntax highlighting, instant rollback."
            , featureCard "$" "Conversation history"
                "Full history of every interaction. Search, filter, export. Your work is never lost."
            ]
        ]
    ]

featureCard :: forall w i. String -> String -> String -> HH.HTML w i
featureCard icon title description =
  HH.div
    [ cls [ "p-6 bg-card border border-border rounded-lg hover:border-amber-400/30 transition-colors" ] ]
    [ HH.div
        [ cls [ "text-2xl text-amber-400 mb-4 font-mono" ] ]
        [ HH.text icon ]
    , HH.h3
        [ cls [ "text-text text-lg font-semibold mb-2" ] ]
        [ HH.text title ]
    , HH.p
        [ cls [ "text-muted-foreground text-sm" ] ]
        [ HH.text description ]
    ]

-- ============================================================
-- COMPARISON
-- ============================================================

comparison :: forall w i. HH.HTML w i
comparison =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "max-w-[1100px] mx-auto px-6" ] ]
        [ HH.div
            [ cls [ "text-center mb-16" ] ]
            [ HH.h2
                [ cls [ "text-3xl font-bold text-text mb-4" ] ]
                [ HH.text "omega//code vs omega//work" ]
            , HH.p
                [ cls [ "text-muted-foreground max-w-2xl mx-auto" ] ]
                [ HH.text "Same engine, different interface. Choose what fits your workflow." ]
            ]
        , HH.div
            [ cls [ "overflow-x-auto -mx-6 px-6" ] ]
            [ HH.table
                [ cls [ "w-full min-w-[600px] text-sm" ] ]
                [ HH.thead_
                    [ HH.tr
                        [ cls [ "border-b border-border" ] ]
                        [ HH.th [ cls [ "py-4 text-left text-muted-foreground font-medium w-40" ] ] [ HH.text "" ]
                        , HH.th [ cls [ "py-4 text-center text-amber-400 font-bold" ] ] [ HH.text "omega//work" ]
                        , HH.th [ cls [ "py-4 text-center text-blue-300 font-medium" ] ] [ HH.text "omega//code" ]
                        ]
                    ]
                , HH.tbody_
                    [ comparisonRow "Interface" "Native GUI" "Terminal TUI"
                    , comparisonRow "Target user" "Creators, writers, designers" "Developers, engineers"
                    , comparisonRow "Learning curve" "Minimal" "Requires terminal familiarity"
                    , comparisonRow "Agent engine" "Same (SIGIL)" "Same (SIGIL)"
                    , comparisonRow "Performance" "Native + Rust" "Native Haskell"
                    , comparisonRow "File selection" "Visual browser" "Path patterns"
                    , comparisonRow "Diff preview" "Side-by-side GUI" "Inline terminal"
                    , comparisonRow "Platforms" "macOS, Windows, Linux" "macOS, Linux"
                    ]
                ]
            ]
        ]
    ]

comparisonRow :: forall w i. String -> String -> String -> HH.HTML w i
comparisonRow feature work code =
  HH.tr
    [ cls [ "border-b border-border" ] ]
    [ HH.td [ cls [ "py-3 text-muted-foreground font-medium" ] ] [ HH.text feature ]
    , HH.td [ cls [ "py-3 text-center text-amber-400 font-semibold" ] ] [ HH.text work ]
    , HH.td [ cls [ "py-3 text-center text-muted-foreground" ] ] [ HH.text code ]
    ]

-- ============================================================
-- QUICKSTART
-- ============================================================

quickstart :: forall w i. HH.HTML w i
quickstart =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "max-w-[800px] mx-auto px-6" ] ]
        [ HH.div
            [ cls [ "text-center mb-12" ] ]
            [ HH.h2
                [ cls [ "text-3xl font-bold text-text mb-4" ] ]
                [ HH.text "Getting started is simple" ]
            ]
        , HH.div
            [ cls [ "grid grid-cols-1 md:grid-cols-3 gap-8" ] ]
            [ stepCard "1" "Download" "Get the native app for your platform. One installer, no dependencies."
            , stepCard "2" "Sign in" "Use your Straylight account or create one. Sync across devices."
            , stepCard "3" "Start creating" "Open a project, describe what you want, watch it happen."
            ]
        , HH.div
            [ cls [ "mt-12 text-center" ] ]
            [ HH.a
                [ HP.href "/omega/work/docs"
                , cls [ "text-amber-400 hover:text-amber-400/80 transition-colors" ]
                ]
                [ HH.text "Read the documentation ->" ]
            ]
        ]
    ]

stepCard :: forall w i. String -> String -> String -> HH.HTML w i
stepCard number title description =
  HH.div
    [ cls [ "text-center" ] ]
    [ HH.div
        [ cls [ "w-10 h-10 rounded-full bg-amber-400/10 border border-amber-400/20 text-amber-400 font-bold flex items-center justify-center mx-auto mb-4" ] ]
        [ HH.text number ]
    , HH.h3
        [ cls [ "text-text font-semibold mb-2" ] ]
        [ HH.text title ]
    , HH.p
        [ cls [ "text-muted-foreground text-sm" ] ]
        [ HH.text description ]
    ]

-- ============================================================
-- CTA
-- ============================================================

cta :: forall w i. HH.HTML w i
cta =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "max-w-[800px] mx-auto px-6 text-center" ] ]
        [ HH.h2
            [ cls [ "text-3xl font-bold text-text mb-4" ] ]
            [ HH.text "Ready for AI without the terminal?" ]
        , HH.p
            [ cls [ "text-muted-foreground mb-8" ] ]
            [ HH.text "omega//work is coming soon. Join the waitlist for early access and updates." ]
        , HH.div
            [ cls [ "flex flex-col sm:flex-row items-center justify-center gap-4" ] ]
            [ primaryButton "/omega/work/pricing" "Join the waitlist"
            , secondaryButton "/omega/work/pricing" "See pricing"
            ]
        ]
    ]

-- ============================================================
-- HELPERS
-- ============================================================

primaryButton :: forall w i. String -> String -> HH.HTML w i
primaryButton href label =
  HH.a
    [ HP.href href
    , cls [ "inline-flex items-center justify-center px-6 py-3 bg-amber-400 text-background font-medium rounded-md hover:bg-amber-400/90 transition-colors" ]
    ]
    [ HH.text label ]

secondaryButton :: forall w i. String -> String -> HH.HTML w i
secondaryButton href label =
  HH.a
    [ HP.href href
    , cls [ "inline-flex items-center justify-center px-6 py-3 border border-border text-text font-medium rounded-md hover:bg-card transition-colors" ]
    ]
    [ HH.text label ]
