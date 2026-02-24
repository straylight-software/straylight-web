-- | omega//work Features Page
-- | Complete feature showcase for the desktop app
module Straylight.Pages.Products.OmegaWork.Features 
  ( featuresPage
  , render
  ) where

import Prelude

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

import Straylight.UI (cls)

-- ============================================================
-- COMPONENT
-- ============================================================

featuresPage :: forall q i o m. H.Component q i o m
featuresPage = H.mkComponent
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
    , visualInterface
    , agentEngine
    , projectManagement
    , collaboration
    , security
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
        [ HH.h1
            [ cls [ "text-4xl md:text-6xl font-bold text-text mb-6 leading-tight" ] ]
            [ HH.text "Everything you need,"
            , HH.br_
            , HH.text "nothing you don't"
            ]
        , HH.p
            [ cls [ "text-xl text-muted-foreground max-w-2xl mx-auto" ] ]
            [ HH.text "omega//work combines a beautiful native interface with the same powerful agent engine that developers rely on. No terminal required." ]
        ]
    ]

-- ============================================================
-- VISUAL INTERFACE
-- ============================================================

visualInterface :: forall w i. HH.HTML w i
visualInterface =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "max-w-[1100px] mx-auto px-6" ] ]
        [ HH.div
            [ cls [ "grid grid-cols-1 lg:grid-cols-2 gap-16 items-center" ] ]
            [ -- Left: content
              HH.div_
                [ badge "Visual Interface"
                , HH.h2
                    [ cls [ "text-3xl font-bold text-text mb-6" ] ]
                    [ HH.text "Point, click, create" ]
                , HH.p
                    [ cls [ "text-muted-foreground mb-6" ] ]
                    [ HH.text "Select files visually, drag context into conversations, preview changes side-by-side. Everything you need is one click away, not buried in command flags." ]
                , featureList
                    [ "Drag-and-drop file context"
                    , "Visual file browser with search"
                    , "Side-by-side diff preview"
                    , "One-click accept or reject changes"
                    , "Syntax highlighting for all languages"
                    ]
                ]
              -- Right: visual placeholder
            , HH.div
                [ cls [ "bg-card border border-border rounded-lg p-6 aspect-video flex items-center justify-center" ] ]
                [ HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text "[Interface Preview]" ] ]
            ]
        ]
    ]

-- ============================================================
-- AGENT ENGINE
-- ============================================================

agentEngine :: forall w i. HH.HTML w i
agentEngine =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "max-w-[1100px] mx-auto px-6" ] ]
        [ HH.div
            [ cls [ "grid grid-cols-1 lg:grid-cols-2 gap-16 items-center" ] ]
            [ -- Left: visual
              HH.div
                [ cls [ "order-2 lg:order-1 bg-card border border-border rounded-lg p-6" ] ]
                [ HH.div
                    [ cls [ "space-y-4" ] ]
                    [ engineStat "Protocol" "SIGIL (proven)" "amber-400"
                    , engineStat "Proofs" "18 Lean4" "amber-400"
                    , engineStat "Reliability" "99.9%" "green-400"
                    ]
                ]
              -- Right: content
            , HH.div
                [ cls [ "order-1 lg:order-2" ] ]
                [ badge "Agent Engine"
                , HH.h2
                    [ cls [ "text-3xl font-bold text-text mb-6" ] ]
                    [ HH.text "Battle-tested reliability" ]
                , HH.p
                    [ cls [ "text-muted-foreground mb-6" ] ]
                    [ HH.text "omega//work runs the same SIGIL protocol engine as omega//code. 18 Lean4 proofs guarantee correct tool execution. Your AI assistant does exactly what you ask." ]
                , featureList
                    [ "Same engine as omega//code"
                    , "SIGIL protocol with formal verification"
                    , "Correct tool execution guaranteed"
                    , "No half-applied changes"
                    , "Automatic rollback on errors"
                    ]
                ]
            ]
        ]
    ]

engineStat :: forall w i. String -> String -> String -> HH.HTML w i
engineStat label value color =
  HH.div
    [ cls [ "flex items-center justify-between py-2 border-b border-border last:border-0" ] ]
    [ HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text label ]
    , HH.span [ cls [ "text-" <> color <> " font-semibold" ] ] [ HH.text value ]
    ]

-- ============================================================
-- PROJECT MANAGEMENT
-- ============================================================

projectManagement :: forall w i. HH.HTML w i
projectManagement =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "max-w-[1100px] mx-auto px-6" ] ]
        [ HH.div
            [ cls [ "text-center mb-16" ] ]
            [ badge "Project Management"
            , HH.h2
                [ cls [ "text-3xl font-bold text-text mb-4" ] ]
                [ HH.text "Organize your work" ]
            , HH.p
                [ cls [ "text-muted-foreground max-w-2xl mx-auto" ] ]
                [ HH.text "Keep projects separate, maintain context across sessions, and pick up exactly where you left off." ]
            ]
        , HH.div
            [ cls [ "grid grid-cols-1 md:grid-cols-3 gap-6" ] ]
            [ projectCard ">" "Workspaces" 
                "Create separate workspaces for different projects. Context stays isolated and organized."
            , projectCard "{}" "Session persistence"
                "Close the app, reopen later. Your conversation history and context are preserved."
            , projectCard "!" "Quick switch"
                "Jump between projects instantly. No reloading, no context loss."
            ]
        ]
    ]

projectCard :: forall w i. String -> String -> String -> HH.HTML w i
projectCard icon title description =
  HH.div
    [ cls [ "bg-card border border-border rounded-lg p-6 hover:border-amber-400/30 transition-colors" ] ]
    [ HH.div
        [ cls [ "flex items-center gap-3 mb-3" ] ]
        [ HH.span [ cls [ "text-amber-400 font-mono text-xl" ] ] [ HH.text icon ]
        , HH.h3 [ cls [ "text-text font-semibold" ] ] [ HH.text title ]
        ]
    , HH.p
        [ cls [ "text-muted-foreground text-sm" ] ]
        [ HH.text description ]
    ]

-- ============================================================
-- COLLABORATION
-- ============================================================

collaboration :: forall w i. HH.HTML w i
collaboration =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "max-w-[1100px] mx-auto px-6" ] ]
        [ HH.div
            [ cls [ "grid grid-cols-1 lg:grid-cols-2 gap-16 items-center" ] ]
            [ -- Left: content
              HH.div_
                [ badge "Collaboration"
                , HH.h2
                    [ cls [ "text-3xl font-bold text-text mb-6" ] ]
                    [ HH.text "Work with your team" ]
                , HH.p
                    [ cls [ "text-muted-foreground mb-6" ] ]
                    [ HH.text "Share conversations, export results, and integrate with your existing tools. omega//work fits into your workflow, not the other way around." ]
                , featureList
                    [ "Export conversations to Markdown"
                    , "Share results via link"
                    , "Git integration for version control"
                    , "Cloud sync across devices"
                    , "Team workspaces (coming soon)"
                    ]
                ]
              -- Right: visual
            , HH.div
                [ cls [ "bg-card border border-border rounded-lg p-6 aspect-video flex items-center justify-center" ] ]
                [ HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text "[Collaboration Preview]" ] ]
            ]
        ]
    ]

-- ============================================================
-- SECURITY
-- ============================================================

security :: forall w i. HH.HTML w i
security =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "max-w-[1100px] mx-auto px-6" ] ]
        [ HH.div
            [ cls [ "text-center mb-16" ] ]
            [ badge "Security"
            , HH.h2
                [ cls [ "text-3xl font-bold text-text mb-4" ] ]
                [ HH.text "Your data stays yours" ]
            , HH.p
                [ cls [ "text-muted-foreground max-w-2xl mx-auto" ] ]
                [ HH.text "omega//work is built with privacy first. Your code never leaves your machine unless you explicitly share it." ]
            ]
        , HH.div
            [ cls [ "grid grid-cols-2 md:grid-cols-4 gap-4" ] ]
            [ securityBadge "Local-first" "Code stays on device"
            , securityBadge "E2E encrypted" "Sync is encrypted"
            , securityBadge "No telemetry" "We don't track you"
            , securityBadge "Open protocol" "SIGIL is auditable"
            ]
        ]
    ]

securityBadge :: forall w i. String -> String -> HH.HTML w i
securityBadge title subtitle =
  HH.div
    [ cls [ "bg-card border border-border rounded-lg p-4 text-center" ] ]
    [ HH.p [ cls [ "text-amber-400 font-semibold mb-1" ] ] [ HH.text title ]
    , HH.p [ cls [ "text-xs text-muted-foreground" ] ] [ HH.text subtitle ]
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
            [ HH.text "Ready to see it in action?" ]
        , HH.p
            [ cls [ "text-muted-foreground mb-8" ] ]
            [ HH.text "Join the waitlist for early access to omega//work." ]
        , HH.div
            [ cls [ "flex flex-col sm:flex-row items-center justify-center gap-4" ] ]
            [ HH.a
                [ HP.href "/omega/work/pricing"
                , cls [ "inline-flex items-center justify-center px-8 py-4 bg-amber-400 text-background font-medium rounded-md hover:bg-amber-400/90 transition-colors" ]
                ]
                [ HH.text "Join the waitlist" ]
            , HH.a
                [ HP.href "/omega/work/pricing"
                , cls [ "inline-flex items-center justify-center px-8 py-4 border border-border text-text font-medium rounded-md hover:bg-card transition-colors" ]
                ]
                [ HH.text "View pricing" ]
            ]
        ]
    ]

-- ============================================================
-- HELPERS
-- ============================================================

badge :: forall w i. String -> HH.HTML w i
badge label =
  HH.span
    [ cls [ "inline-block px-3 py-1 bg-amber-400/10 border border-amber-400/20 rounded-full text-amber-400 text-sm font-medium mb-4" ] ]
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
    [ HH.span [ cls [ "text-amber-400 mt-1" ] ] [ HH.text "+" ]
    , HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text text ]
    ]
