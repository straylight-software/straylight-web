-- | omega//boost Dashboard Page
-- | User dashboard for managing inference, API keys, and usage
module Straylight.Pages.Products.OmegaBoost.Dashboard where

import Prelude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

import Straylight.UI (cls)

-- ============================================================
-- TYPES
-- ============================================================

type State =
  { activeTab :: String
  , showNewKeyModal :: Boolean
  , newKeyName :: String
  , createdKey :: Maybe String
  }

data Action
  = SetActiveTab String
  | OpenNewKeyModal
  | CloseNewKeyModal
  | SetNewKeyName String
  | CreateApiKey

-- ============================================================
-- COMPONENT
-- ============================================================

dashboardPage :: forall q i o m. H.Component q i o m
dashboardPage = H.mkComponent
  { initialState: const initialState
  , render
  , eval: H.mkEval H.defaultEval
      { handleAction = handleAction
      }
  }

initialState :: State
initialState =
  { activeTab: "overview"
  , showNewKeyModal: false
  , newKeyName: ""
  , createdKey: Nothing
  }

handleAction :: forall o m. Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
  SetActiveTab tab -> H.modify_ _ { activeTab = tab }
  OpenNewKeyModal -> H.modify_ _ { showNewKeyModal = true, createdKey = Nothing }
  CloseNewKeyModal -> H.modify_ _ { showNewKeyModal = false, newKeyName = "", createdKey = Nothing }
  SetNewKeyName name -> H.modify_ _ { newKeyName = name }
  CreateApiKey -> do
    state <- H.get
    let fakeKey = "boost_live_" <> state.newKeyName <> "_abc123xyz789"
    H.modify_ _ { createdKey = Just fakeKey }

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
    , if state.showNewKeyModal then newKeyModal state else HH.text ""
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
        [ HH.text "Manage your omega//boost inference, API keys, and usage." ]
    ]

tabs :: forall m. State -> H.ComponentHTML Action () m
tabs state =
  HH.div
    [ cls [ "flex gap-1 border-b border-border mb-8" ] ]
    [ tabButton "overview" "Overview" state.activeTab
    , tabButton "keys" "API Keys" state.activeTab
    , tabButton "providers" "Providers" state.activeTab
    , tabButton "analytics" "Analytics" state.activeTab
    , tabButton "usage" "Usage" state.activeTab
    ]

tabButton :: forall m. String -> String -> String -> H.ComponentHTML Action () m
tabButton value label activeTab =
  HH.button
    [ cls [ "px-4 py-2 text-sm font-medium transition-colors -mb-px"
          , if value == activeTab 
              then "text-orange-400 border-b-2 border-orange-400" 
              else "text-muted-foreground hover:text-text"
          ]
    , HP.type_ HP.ButtonButton
    , HE.onClick \_ -> SetActiveTab value
    ]
    [ HH.text label ]

content :: forall m. State -> H.ComponentHTML Action () m
content state = case state.activeTab of
  "overview" -> overviewTab
  "keys" -> keysTab state
  "providers" -> providersTab
  "analytics" -> analyticsTab
  "usage" -> usageTab
  _ -> overviewTab

-- ============================================================
-- NEW KEY MODAL
-- ============================================================

newKeyModal :: forall m. State -> H.ComponentHTML Action () m
newKeyModal state =
  HH.div
    [ cls [ "fixed inset-0 bg-background/80 flex items-center justify-center z-50" ] ]
    [ HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6 w-full max-w-md" ] ]
        [ case state.createdKey of
            Nothing -> newKeyForm state
            Just key -> newKeySuccess key
        ]
    ]

newKeyForm :: forall m. State -> H.ComponentHTML Action () m
newKeyForm state =
  HH.div_
    [ HH.h3
        [ cls [ "text-lg font-semibold text-text mb-4" ] ]
        [ HH.text "Create API Key" ]
    , HH.p
        [ cls [ "text-sm text-muted-foreground mb-4" ] ]
        [ HH.text "Give your API key a name to help you identify it later." ]
    , HH.div
        [ cls [ "mb-4" ] ]
        [ HH.label
            [ cls [ "block text-sm font-medium text-text mb-2" ] ]
            [ HH.text "Key Name" ]
        , HH.input
            [ cls [ "w-full px-3 py-2 bg-background border border-border rounded-md text-text text-sm placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-orange-400" ]
            , HP.placeholder "e.g., Production, Development"
            , HP.value state.newKeyName
            , HE.onValueInput SetNewKeyName
            ]
        ]
    , HH.div
        [ cls [ "flex justify-end gap-3" ] ]
        [ HH.button
            [ cls [ "px-4 py-2 text-sm font-medium text-muted-foreground hover:text-text transition-colors cursor-pointer" ]
            , HP.type_ HP.ButtonButton
            , HE.onClick \_ -> CloseNewKeyModal
            ]
            [ HH.text "Cancel" ]
        , HH.button
            [ cls [ "px-4 py-2 bg-orange-400 text-background text-sm font-medium rounded-md hover:bg-orange-400/90 transition-colors cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed" ]
            , HP.type_ HP.ButtonButton
            , HP.disabled (state.newKeyName == "")
            , HE.onClick \_ -> CreateApiKey
            ]
            [ HH.text "Create Key" ]
        ]
    ]

newKeySuccess :: forall m. String -> H.ComponentHTML Action () m
newKeySuccess key =
  HH.div_
    [ HH.h3
        [ cls [ "text-lg font-semibold text-text mb-4" ] ]
        [ HH.text "API Key Created" ]
    , HH.p
        [ cls [ "text-sm text-muted-foreground mb-3" ] ]
        [ HH.text "Your API key has been created. Copy it now - you won't be able to see it again!" ]
    , HH.div
        [ cls [ "p-3 bg-background border border-orange-400/30 rounded-md mb-4" ] ]
        [ HH.code
            [ cls [ "text-sm font-mono text-orange-400 break-all" ] ]
            [ HH.text key ]
        ]
    , HH.p
        [ cls [ "text-xs text-muted-foreground mb-4" ] ]
        [ HH.text "Store this key securely. For security, it will only be shown once." ]
    , HH.div
        [ cls [ "flex justify-end" ] ]
        [ HH.button
            [ cls [ "px-4 py-2 bg-orange-400 text-background text-sm font-medium rounded-md hover:bg-orange-400/90 transition-colors cursor-pointer" ]
            , HP.type_ HP.ButtonButton
            , HE.onClick \_ -> CloseNewKeyModal
            ]
            [ HH.text "Done" ]
        ]
    ]

-- ============================================================
-- OVERVIEW TAB
-- ============================================================

overviewTab :: forall w i. HH.HTML w i
overviewTab =
  HH.div_
    [ -- Stats grid
      HH.div
        [ cls [ "grid grid-cols-1 md:grid-cols-4 gap-4 mb-8" ] ]
        [ statCard "Requests" "127,432" "This month"
        , statCard "Avg Latency" "8.3ms" "p99"
        , statCard "Cost Savings" "42%" "vs direct API"
        , statCard "Cache Hit Rate" "78%" "Last 24h"
        ]
    
      -- Quick start
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6 mb-8" ] ]
        [ HH.h3
            [ cls [ "text-lg font-semibold text-text mb-4" ] ]
            [ HH.text "Quick Start" ]
        , codeBlock
            [ codeLine "# " "Switch to omega//boost"
            , codeLine "" "client = OpenAI(base_url=\"https://boost.omega.dev/v1\")"
            , HH.text "\n"
            , codeLine "# " "Your existing code works unchanged"
            , codeLine "" "response = client.chat.completions.create(...)"
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
            [ activityItem "Request" "gpt-4-turbo-preview" "2 min ago" "batched"
            , activityItem "Request" "claude-3-opus" "5 min ago" "cached"
            , activityItem "Request" "gpt-4-turbo-preview" "8 min ago" "direct"
            , activityItem "Key Created" "Production API Key" "1 hour ago" ""
            ]
        ]
    ]

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

activityItem :: forall w i. String -> String -> String -> String -> HH.HTML w i
activityItem type_ description time status =
  HH.div
    [ cls [ "flex items-center justify-between py-2 border-b border-border last:border-0" ] ]
    [ HH.div
        [ cls [ "flex items-center gap-3" ] ]
        [ HH.span
            [ cls [ "text-xs px-2 py-0.5 rounded font-medium bg-orange-400/10 text-orange-400" ] ]
            [ HH.text type_ ]
        , HH.span [ cls [ "text-sm text-text" ] ] [ HH.text description ]
        , if status /= ""
            then HH.span
              [ cls [ "text-xs px-2 py-0.5 rounded"
                    , case status of
                        "batched" -> "bg-green-500/20 text-green-400"
                        "cached" -> "bg-blue-500/20 text-blue-400"
                        _ -> "bg-muted text-muted-foreground"
                    ]
              ]
              [ HH.text status ]
            else HH.text ""
        ]
    , HH.span [ cls [ "text-sm text-muted-foreground" ] ] [ HH.text time ]
    ]

-- ============================================================
-- KEYS TAB
-- ============================================================

keysTab :: forall m. State -> H.ComponentHTML Action () m
keysTab _ =
  HH.div_
    [ HH.div
        [ cls [ "flex items-center justify-between mb-6" ] ]
        [ HH.h2 [ cls [ "text-lg font-semibold text-text" ] ] [ HH.text "API Keys" ]
        , HH.button
            [ cls [ "px-4 py-2 bg-orange-400 text-background text-sm font-medium rounded-md hover:bg-orange-400/90 transition-colors cursor-pointer" ]
            , HP.type_ HP.ButtonButton
            , HE.onClick \_ -> OpenNewKeyModal
            ]
            [ HH.text "+ New Key" ]
        ]
    , HH.div
        [ cls [ "space-y-4" ] ]
        [ apiKeyCard "Production" "boost_live_prod_***abc" "push, pull" "2 hours ago"
        , apiKeyCard "Development" "boost_live_dev_***xyz" "push, pull" "Yesterday"
        , apiKeyCard "CI Pipeline" "boost_live_ci_***def" "push" "3 days ago"
        ]
    ]

apiKeyCard :: forall w i. String -> String -> String -> String -> HH.HTML w i
apiKeyCard name keyPrefix scopes lastUsed =
  HH.div
    [ cls [ "bg-card border border-border rounded-lg p-4" ] ]
    [ HH.div
        [ cls [ "flex items-center justify-between mb-2" ] ]
        [ HH.div
            [ cls [ "flex items-center gap-3" ] ]
            [ HH.span [ cls [ "text-text font-medium" ] ] [ HH.text name ]
            , HH.span
                [ cls [ "text-xs px-1.5 py-0.5 rounded bg-muted text-muted-foreground" ] ]
                [ HH.text scopes ]
            ]
        , HH.button
            [ cls [ "text-sm text-danger hover:text-danger/80 cursor-pointer" ]
            , HP.type_ HP.ButtonButton
            ]
            [ HH.text "Revoke" ]
        ]
    , HH.code
        [ cls [ "block text-sm font-mono text-muted-foreground mb-2" ] ]
        [ HH.text keyPrefix ]
    , HH.p
        [ cls [ "text-xs text-muted-foreground" ] ]
        [ HH.text $ "Last used: " <> lastUsed ]
    ]

-- ============================================================
-- PROVIDERS TAB
-- ============================================================

providersTab :: forall w i. HH.HTML w i
providersTab =
  HH.div_
    [ HH.div
        [ cls [ "flex items-center justify-between mb-6" ] ]
        [ HH.h2 [ cls [ "text-lg font-semibold text-text" ] ] [ HH.text "Connected Providers" ]
        , HH.button
            [ cls [ "px-4 py-2 bg-orange-400 text-background text-sm font-medium rounded-md hover:bg-orange-400/90 transition-colors cursor-pointer" ]
            , HP.type_ HP.ButtonButton
            ]
            [ HH.text "+ Add Provider" ]
        ]
    , HH.div
        [ cls [ "space-y-4" ] ]
        [ providerCard "OpenAI" "sk-***...abc" "active" "45,231 requests"
        , providerCard "Anthropic" "sk-ant-***...xyz" "active" "82,201 requests"
        , providerCard "Google AI" "AIza***...def" "pending" "0 requests"
        ]
    , HH.div
        [ cls [ "mt-8 p-4 bg-card border border-border rounded-lg" ] ]
        [ HH.h3 [ cls [ "text-sm font-medium text-text mb-2" ] ] [ HH.text "Security" ]
        , HH.p [ cls [ "text-sm text-muted-foreground" ] ] 
            [ HH.text "Your API keys are encrypted at rest using AES-256-GCM. We never log or store raw keys." ]
        ]
    ]

providerCard :: forall w i. String -> String -> String -> String -> HH.HTML w i
providerCard name keyPreview status usage =
  HH.div
    [ cls [ "bg-card border border-border rounded-lg p-4" ] ]
    [ HH.div
        [ cls [ "flex items-center justify-between mb-2" ] ]
        [ HH.div
            [ cls [ "flex items-center gap-3" ] ]
            [ HH.span [ cls [ "text-text font-medium" ] ] [ HH.text name ]
            , HH.span
                [ cls [ "text-xs px-2 py-0.5 rounded"
                      , if status == "active" then "bg-green-500/20 text-green-400" else "bg-yellow-500/20 text-yellow-400"
                      ]
                ]
                [ HH.text status ]
            ]
        , HH.button
            [ cls [ "text-sm text-muted-foreground hover:text-text cursor-pointer" ]
            , HP.type_ HP.ButtonButton
            ]
            [ HH.text "Edit" ]
        ]
    , HH.code
        [ cls [ "block text-sm font-mono text-muted-foreground mb-2" ] ]
        [ HH.text keyPreview ]
    , HH.p
        [ cls [ "text-xs text-muted-foreground" ] ]
        [ HH.text usage ]
    ]

-- ============================================================
-- ANALYTICS TAB
-- ============================================================

analyticsTab :: forall w i. HH.HTML w i
analyticsTab =
  HH.div_
    [ -- Metrics grid
      HH.div
        [ cls [ "grid grid-cols-1 md:grid-cols-2 gap-6 mb-8" ] ]
        [ metricsCard "Request Volume" "127,432" "+12% vs last month"
        , metricsCard "Average Latency" "8.3ms" "-15% vs direct API"
        ]
    
      -- Breakdown
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6 mb-8" ] ]
        [ HH.h3
            [ cls [ "text-lg font-semibold text-text mb-4" ] ]
            [ HH.text "Request Breakdown" ]
        , HH.div
            [ cls [ "space-y-4" ] ]
            [ breakdownRow "Batched" 54 "54% cost savings"
            , breakdownRow "Cached" 24 "100% cost savings"
            , breakdownRow "Direct" 22 "Standard pricing"
            ]
        ]
    
      -- By model
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.h3
            [ cls [ "text-lg font-semibold text-text mb-4" ] ]
            [ HH.text "Requests by Model" ]
        , HH.div
            [ cls [ "space-y-3" ] ]
            [ modelRow "gpt-4-turbo-preview" 68432 "54%"
            , modelRow "claude-3-opus" 45231 "35%"
            , modelRow "gpt-3.5-turbo" 13769 "11%"
            ]
        ]
    ]

metricsCard :: forall w i. String -> String -> String -> HH.HTML w i
metricsCard label value change =
  HH.div
    [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
    [ HH.p [ cls [ "text-sm text-muted-foreground mb-2" ] ] [ HH.text label ]
    , HH.p [ cls [ "text-3xl font-bold text-text mb-1" ] ] [ HH.text value ]
    , HH.p [ cls [ "text-sm text-green-400" ] ] [ HH.text change ]
    ]

breakdownRow :: forall w i. String -> Int -> String -> HH.HTML w i
breakdownRow label percentage note =
  HH.div_
    [ HH.div
        [ cls [ "flex items-center justify-between mb-1" ] ]
        [ HH.span [ cls [ "text-sm text-text" ] ] [ HH.text label ]
        , HH.span [ cls [ "text-sm text-muted-foreground" ] ] [ HH.text $ show percentage <> "%" ]
        ]
    , HH.div
        [ cls [ "h-2 bg-muted rounded-full overflow-hidden mb-1" ] ]
        [ HH.div
            [ cls [ "h-full bg-orange-400 rounded-full" ]
            , HP.style $ "width: " <> show percentage <> "%"
            ]
            []
        ]
    , HH.p [ cls [ "text-xs text-muted-foreground" ] ] [ HH.text note ]
    ]

modelRow :: forall w i. String -> Int -> String -> HH.HTML w i
modelRow name requests percentage =
  HH.div
    [ cls [ "flex items-center justify-between py-2 border-b border-border last:border-0" ] ]
    [ HH.span [ cls [ "text-sm text-text font-mono" ] ] [ HH.text name ]
    , HH.div
        [ cls [ "flex items-center gap-4" ] ]
        [ HH.span [ cls [ "text-sm text-muted-foreground" ] ] 
            [ HH.text $ formatNumber requests <> " requests" ]
        , HH.span [ cls [ "text-sm text-orange-400" ] ] [ HH.text percentage ]
        ]
    ]

formatNumber :: Int -> String
formatNumber n = show n -- TODO: add thousand separators

-- ============================================================
-- USAGE TAB
-- ============================================================

usageTab :: forall w i. HH.HTML w i
usageTab =
  HH.div_
    [ HH.div
        [ cls [ "grid grid-cols-1 md:grid-cols-2 gap-6 mb-8" ] ]
        [ usageCard "Requests" 127432 1000000 "this month"
        , usageCard "Overage" 0 0 "no overage"
        ]
    
      -- Cost breakdown
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6 mb-8" ] ]
        [ HH.h3
            [ cls [ "text-lg font-semibold text-text mb-4" ] ]
            [ HH.text "Cost Breakdown" ]
        , HH.div
            [ cls [ "space-y-4" ] ]
            [ costRow "omega//boost fee" "$63.72" "$0.0005/request"
            , costRow "Estimated vendor costs" "$1,847.23" "OpenAI + Anthropic"
            , costRow "Savings from batching" "-$432.18" "42% of requests batched"
            , costRow "Savings from caching" "-$287.45" "24% cache hit rate"
            ]
        , HH.div
            [ cls [ "mt-6 pt-4 border-t border-border flex items-center justify-between" ] ]
            [ HH.span [ cls [ "text-text font-medium" ] ] [ HH.text "Net savings" ]
            , HH.span [ cls [ "text-green-400 font-bold text-xl" ] ] [ HH.text "$655.91" ]
            ]
        ]
    
      -- Plan info
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.h3 [ cls [ "text-lg font-semibold text-text mb-4" ] ] [ HH.text "Current Plan: Pro" ]
        , HH.p [ cls [ "text-muted-foreground mb-4" ] ] 
            [ HH.text "1M requests/month included. $0.0005/request after." ]
        , HH.a
            [ HP.href "/omega/boost/settings"
            , cls [ "inline-block px-4 py-2 border border-border text-text text-sm font-medium rounded-md hover:bg-card transition-colors" ]
            ]
            [ HH.text "Manage Plan" ]
        ]
    ]

usageCard :: forall w i. String -> Int -> Int -> String -> HH.HTML w i
usageCard label current limit unit =
  HH.div
    [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
    [ HH.div
        [ cls [ "flex items-center justify-between mb-4" ] ]
        [ HH.span [ cls [ "text-sm font-medium text-text" ] ] [ HH.text label ]
        , HH.span [ cls [ "text-sm text-muted-foreground" ] ] 
            [ HH.text $ formatNumber current <> " / " <> formatNumber limit <> " " <> unit ]
        ]
    , HH.div
        [ cls [ "h-2 bg-muted rounded-full overflow-hidden" ] ]
        [ HH.div
            [ cls [ "h-full bg-orange-400 rounded-full" ]
            , HP.style $ "width: " <> show (if limit == 0 then 0 else (current * 100) / limit) <> "%"
            ]
            []
        ]
    ]

costRow :: forall w i. String -> String -> String -> HH.HTML w i
costRow label amount note =
  HH.div
    [ cls [ "flex items-center justify-between py-2 border-b border-border last:border-0" ] ]
    [ HH.div_
        [ HH.p [ cls [ "text-text" ] ] [ HH.text label ]
        , HH.p [ cls [ "text-xs text-muted-foreground" ] ] [ HH.text note ]
        ]
    , HH.span 
        [ cls [ "font-mono"
              , if (take 1 amount) == "-" then "text-green-400" else "text-text"
              ]
        ] 
        [ HH.text amount ]
    ]
  where
  take :: Int -> String -> String
  take _ "" = ""
  take n s = if n <= 0 then "" else s

-- ============================================================
-- HELPERS
-- ============================================================

codeBlock :: forall w i. Array (HH.HTML w i) -> HH.HTML w i
codeBlock children =
  HH.pre
    [ cls [ "bg-background border border-border p-4 rounded-lg overflow-x-auto text-sm leading-relaxed" ] ]
    children

codeLine :: forall w i. String -> String -> HH.HTML w i
codeLine prefix content =
  HH.div_
    [ HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text prefix ]
    , HH.span [ cls [ "text-text" ] ] [ HH.text content ]
    ]
