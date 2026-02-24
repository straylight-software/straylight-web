-- | omega//code Dashboard Page
-- | User dashboard for agent management
module Straylight.Pages.Products.OmegaCode.Dashboard where

import Prelude

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

import Straylight.UI (cls, codeBlock)

-- ============================================================
-- TYPES
-- ============================================================

type State =
  { activeTab :: String
  }

data Action
  = SetTab String

-- ============================================================
-- COMPONENT
-- ============================================================

dashboardPage :: forall q i o m. H.Component q i o m
dashboardPage = H.mkComponent
  { initialState: const { activeTab: "overview" }
  , render
  , eval: H.mkEval H.defaultEval
      { handleAction = handleAction
      }
  }

handleAction :: forall o m. Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
  SetTab tab -> H.modify_ _ { activeTab = tab }

-- ============================================================
-- RENDER
-- ============================================================

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div
    [ cls [ "max-w-[1100px] mx-auto px-6 py-8" ] ]
    [ header
    , tabs state
    , content state
    ]

header :: forall w i. HH.HTML w i
header =
  HH.div
    [ cls [ "mb-8" ] ]
    [ HH.h1
        [ cls [ "text-2xl font-bold text-text mb-2" ] ]
        [ HH.text "omega//code Dashboard" ]
    , HH.p
        [ cls [ "text-muted-foreground" ] ]
        [ HH.text "Manage your agents, sessions, and attestations." ]
    ]

tabs :: forall m. State -> H.ComponentHTML Action () m
tabs state =
  HH.div
    [ cls [ "flex gap-1 mb-8 border-b border-border" ] ]
    [ tabButton state "overview" "Overview"
    , tabButton state "sessions" "Sessions"
    , tabButton state "agents" "Agents"
    , tabButton state "attestations" "Attestations"
    , tabButton state "usage" "Usage"
    ]

tabButton :: forall m. State -> String -> String -> H.ComponentHTML Action () m
tabButton state value label =
  HH.button
    [ cls [ "px-4 py-2 text-sm font-medium transition-colors -mb-px cursor-pointer"
          , if state.activeTab == value 
              then "text-blue-300 border-b-2 border-blue-300" 
              else "text-muted-foreground hover:text-text"
          ]
    , HP.type_ HP.ButtonButton
    ]
    [ HH.text label ]

content :: forall m. State -> H.ComponentHTML Action () m
content state = case state.activeTab of
  "overview" -> overviewTab
  "sessions" -> sessionsTab
  "agents" -> agentsTab
  "attestations" -> attestationsTab
  "usage" -> usageTab
  _ -> overviewTab

-- ============================================================
-- OVERVIEW TAB
-- ============================================================

overviewTab :: forall w i. HH.HTML w i
overviewTab =
  HH.div_
    [ -- Stats grid
      HH.div
        [ cls [ "grid grid-cols-1 md:grid-cols-4 gap-4 mb-8" ] ]
        [ statCard "Active Sessions" "3" "running now"
        , statCard "Total Requests" "12,847" "this month"
        , statCard "Attestations" "1,234" "verified"
        , statCard "Crew Runs" "47" "completed"
        ]
    
      -- Quick start
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6 mb-8" ] ]
        [ HH.h3
            [ cls [ "text-lg font-semibold text-text mb-4" ] ]
            [ HH.text "Quick Start" ]
        , codeBlock
            [ codeLine "# " "Start omega//code"
            , codeLine "$ " "omega"
            , HH.text "\n"
            , codeLine "# " "Run a crew"
            , codeLine "$ " "omega crew -n 3 \"Refactor the auth module\""
            ]
        ]
    
      -- Recent activity
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.h3
            [ cls [ "text-lg font-semibold text-text mb-4" ] ]
            [ HH.text "Recent Activity" ]
        , HH.div
            [ cls [ "space-y-3" ] ]
            [ activityItem "Session" "Completed refactoring task" "2 min ago"
            , activityItem "Crew" "3 agents completed" "15 min ago"
            , activityItem "Attestation" "47 changes verified" "1 hour ago"
            , activityItem "Session" "Fixed type errors" "3 hours ago"
            ]
        ]
    ]

-- ============================================================
-- SESSIONS TAB
-- ============================================================

sessionsTab :: forall w i. HH.HTML w i
sessionsTab =
  HH.div_
    [ HH.div
        [ cls [ "flex items-center justify-between mb-6" ] ]
        [ HH.h2 [ cls [ "text-lg font-semibold text-text" ] ] [ HH.text "Sessions" ]
        , HH.button
            [ cls [ "px-4 py-2 bg-blue-300 text-background text-sm font-medium rounded-md hover:bg-blue-300/90 transition-colors cursor-pointer" ]
            , HP.type_ HP.ButtonButton
            ]
            [ HH.text "+ New Session" ]
        ]
    , HH.div
        [ cls [ "space-y-4" ] ]
        [ sessionCard "ses_abc123" "Active" "Refactoring auth module" "2 min ago" 47
        , sessionCard "ses_def456" "Active" "Adding unit tests" "15 min ago" 23
        , sessionCard "ses_ghi789" "Active" "Bug fix in parser" "1 hour ago" 12
        , sessionCard "ses_jkl012" "Completed" "Documentation update" "3 hours ago" 8
        ]
    ]

sessionCard :: forall w i. String -> String -> String -> String -> Int -> HH.HTML w i
sessionCard id status task time requests =
  HH.div
    [ cls [ "bg-card border border-border rounded-lg p-4" ] ]
    [ HH.div
        [ cls [ "flex items-center justify-between mb-2" ] ]
        [ HH.div
            [ cls [ "flex items-center gap-3" ] ]
            [ HH.code [ cls [ "text-sm text-muted-foreground" ] ] [ HH.text id ]
            , HH.span
                [ cls [ "text-xs px-2 py-0.5 rounded"
                      , if status == "Active" then "bg-blue-300/20 text-blue-300" else "bg-muted text-muted-foreground"
                      ]
                ]
                [ HH.text status ]
            ]
        , HH.span [ cls [ "text-sm text-muted-foreground" ] ] [ HH.text time ]
        ]
    , HH.p [ cls [ "text-text mb-2" ] ] [ HH.text task ]
    , HH.p [ cls [ "text-sm text-muted-foreground" ] ] [ HH.text $ show requests <> " requests" ]
    ]

-- ============================================================
-- AGENTS TAB
-- ============================================================

agentsTab :: forall w i. HH.HTML w i
agentsTab =
  HH.div_
    [ HH.div
        [ cls [ "flex items-center justify-between mb-6" ] ]
        [ HH.h2 [ cls [ "text-lg font-semibold text-text" ] ] [ HH.text "Active Agents" ]
        , HH.button
            [ cls [ "px-4 py-2 bg-blue-300 text-background text-sm font-medium rounded-md hover:bg-blue-300/90 transition-colors cursor-pointer" ]
            , HP.type_ HP.ButtonButton
            ]
            [ HH.text "+ Start Crew" ]
        ]
    , HH.div
        [ cls [ "grid grid-cols-1 md:grid-cols-3 gap-4" ] ]
        [ agentCard "Agent 1" "Running" "Reading codebase..." 45
        , agentCard "Agent 2" "Running" "Analyzing dependencies..." 32
        , agentCard "Agent 3" "Idle" "Waiting for task..." 0
        ]
    ]

agentCard :: forall w i. String -> String -> String -> Int -> HH.HTML w i
agentCard name status activity progress =
  HH.div
    [ cls [ "bg-card border border-border rounded-lg p-4" ] ]
    [ HH.div
        [ cls [ "flex items-center justify-between mb-3" ] ]
        [ HH.span [ cls [ "text-text font-medium" ] ] [ HH.text name ]
        , HH.span
            [ cls [ "text-xs px-2 py-0.5 rounded"
                  , if status == "Running" then "bg-blue-300/20 text-blue-300" else "bg-muted text-muted-foreground"
                  ]
            ]
            [ HH.text status ]
        ]
    , HH.p [ cls [ "text-sm text-muted-foreground mb-3" ] ] [ HH.text activity ]
    , if progress > 0
        then HH.div
          [ cls [ "h-2 bg-muted rounded-full overflow-hidden" ] ]
          [ HH.div
              [ cls [ "h-full bg-blue-300 rounded-full" ]
              , HP.style $ "width: " <> show progress <> "%"
              ]
              []
          ]
        else HH.text ""
    ]

-- ============================================================
-- ATTESTATIONS TAB
-- ============================================================

attestationsTab :: forall w i. HH.HTML w i
attestationsTab =
  HH.div_
    [ HH.div
        [ cls [ "flex items-center justify-between mb-6" ] ]
        [ HH.h2 [ cls [ "text-lg font-semibold text-text" ] ] [ HH.text "Attestations" ]
        , HH.button
            [ cls [ "px-4 py-2 border border-border text-text text-sm font-medium rounded-md hover:bg-card transition-colors cursor-pointer" ]
            , HP.type_ HP.ButtonButton
            ]
            [ HH.text "Export All" ]
        ]
    , HH.div
        [ cls [ "space-y-4" ] ]
        [ attestationCard "0x8f3a2b..." "Crew merge" "12 files" "2 min ago" "Verified"
        , attestationCard "0x7c1d4e..." "File changes" "3 files" "15 min ago" "Verified"
        , attestationCard "0x5a9b8c..." "Session end" "Session boundary" "1 hour ago" "Verified"
        , attestationCard "0x2e6f1a..." "Tool calls" "47 invocations" "3 hours ago" "Verified"
        ]
    ]

attestationCard :: forall w i. String -> String -> String -> String -> String -> HH.HTML w i
attestationCard hash action scope time status =
  HH.div
    [ cls [ "bg-card border border-border rounded-lg p-4" ] ]
    [ HH.div
        [ cls [ "flex items-center justify-between mb-2" ] ]
        [ HH.code [ cls [ "text-sm text-blue-300" ] ] [ HH.text hash ]
        , HH.span
            [ cls [ "text-xs px-2 py-0.5 rounded bg-green-500/20 text-green-400" ] ]
            [ HH.text status ]
        ]
    , HH.div
        [ cls [ "flex items-center gap-4 text-sm text-muted-foreground" ] ]
        [ HH.span_ [ HH.text action ]
        , HH.span_ [ HH.text scope ]
        , HH.span_ [ HH.text time ]
        ]
    ]

-- ============================================================
-- USAGE TAB
-- ============================================================

usageTab :: forall w i. HH.HTML w i
usageTab =
  HH.div_
    [ -- Usage bars
      HH.div
        [ cls [ "grid grid-cols-1 md:grid-cols-2 gap-6 mb-8" ] ]
        [ usageCard "Requests" 12847 25000 "this month"
        , usageCard "Agents" 3 10 "concurrent"
        ]
    
      -- Plan info
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.h3 [ cls [ "text-lg font-semibold text-text mb-4" ] ] [ HH.text "Current Plan: Pro" ]
        , HH.div
            [ cls [ "grid grid-cols-2 md:grid-cols-4 gap-4 mb-6" ] ]
            [ planStat "Requests" "Unlimited"
            , planStat "Agents" "10 concurrent"
            , planStat "Crew Mode" "Enabled"
            , planStat "Attestation" "Full history"
            ]
        , HH.a
            [ HP.href "/omega/code/settings"
            , cls [ "inline-block px-4 py-2 border border-border text-text text-sm font-medium rounded-md hover:bg-card transition-colors" ]
            ]
            [ HH.text "Manage Plan" ]
        ]
    ]

usageCard :: forall w i. String -> Int -> Int -> String -> HH.HTML w i
usageCard label current limit period =
  HH.div
    [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
    [ HH.div
        [ cls [ "flex items-center justify-between mb-4" ] ]
        [ HH.span [ cls [ "text-sm font-medium text-text" ] ] [ HH.text label ]
        , HH.span [ cls [ "text-sm text-muted-foreground" ] ] 
            [ HH.text $ show current <> " / " <> show limit <> " " <> period ]
        ]
    , HH.div
        [ cls [ "h-3 bg-muted rounded-full overflow-hidden" ] ]
        [ HH.div
            [ cls [ "h-full bg-blue-300 rounded-full" ]
            , HP.style $ "width: " <> show (current * 100 / limit) <> "%"
            ]
            []
        ]
    ]

planStat :: forall w i. String -> String -> HH.HTML w i
planStat label value =
  HH.div_
    [ HH.p [ cls [ "text-xs text-muted-foreground" ] ] [ HH.text label ]
    , HH.p [ cls [ "text-sm text-text font-medium" ] ] [ HH.text value ]
    ]

-- ============================================================
-- HELPERS
-- ============================================================

statCard :: forall w i. String -> String -> String -> HH.HTML w i
statCard label value subtitle =
  HH.div
    [ cls [ "bg-card border border-border rounded-lg p-4" ] ]
    [ HH.p
        [ cls [ "text-sm text-muted-foreground mb-1" ] ]
        [ HH.text label ]
    , HH.p
        [ cls [ "text-2xl font-bold text-text" ] ]
        [ HH.text value ]
    , HH.p
        [ cls [ "text-xs text-muted-foreground" ] ]
        [ HH.text subtitle ]
    ]

activityItem :: forall w i. String -> String -> String -> HH.HTML w i
activityItem category action time =
  HH.div
    [ cls [ "flex items-center justify-between py-2 border-b border-border last:border-0" ] ]
    [ HH.div
        [ cls [ "flex items-center gap-3" ] ]
        [ HH.span
            [ cls [ "text-xs px-2 py-0.5 rounded bg-blue-300/20 text-blue-300" ] ]
            [ HH.text category ]
        , HH.span [ cls [ "text-sm text-text" ] ] [ HH.text action ]
        ]
    , HH.span [ cls [ "text-sm text-muted-foreground" ] ] [ HH.text time ]
    ]

codeLine :: forall w i. String -> String -> HH.HTML w i
codeLine prompt content =
  HH.div_
    [ HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text prompt ]
    , HH.span [ cls [ "text-text" ] ] [ HH.text content ]
    ]
