-- | omega//work Dashboard Page
-- | User dashboard for managing account and usage
module Straylight.Pages.Products.OmegaWork.Dashboard where

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
  }

data Action
  = SetActiveTab String

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
  }

handleAction :: forall o m. Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
  SetActiveTab tab -> H.modify_ _ { activeTab = tab }

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
        [ HH.text "Dashboard" ]
    , HH.p
        [ cls [ "text-muted-foreground" ] ]
        [ HH.text "Manage your omega//work account and usage." ]
    ]

tabs :: forall m. State -> H.ComponentHTML Action () m
tabs state =
  HH.div
    [ cls [ "flex gap-1 border-b border-border mb-8" ] ]
    [ tabButton "overview" "Overview" state.activeTab
    , tabButton "downloads" "Downloads" state.activeTab
    , tabButton "usage" "Usage" state.activeTab
    , tabButton "devices" "Devices" state.activeTab
    ]

tabButton :: forall m. String -> String -> String -> H.ComponentHTML Action () m
tabButton value label activeTab =
  HH.button
    [ cls [ "px-4 py-2 text-sm font-medium transition-colors -mb-px"
          , if value == activeTab 
              then "text-amber-400 border-b-2 border-amber-400" 
              else "text-muted-foreground hover:text-text"
          ]
    , HP.type_ HP.ButtonButton
    , HE.onClick \_ -> SetActiveTab value
    ]
    [ HH.text label ]

content :: forall m. State -> H.ComponentHTML Action () m
content state = case state.activeTab of
  "overview" -> overviewTab
  "downloads" -> downloadsTab
  "usage" -> usageTab
  "devices" -> devicesTab
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
        [ statCard "Plan" "Pro" "Active"
        , statCard "Conversations" "247" "This month"
        , statCard "Projects" "12" "Active"
        , statCard "Devices" "3" "Synced"
        ]
    
      -- Quick actions
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6 mb-8" ] ]
        [ HH.h3
            [ cls [ "text-lg font-semibold text-text mb-4" ] ]
            [ HH.text "Quick Actions" ]
        , HH.div
            [ cls [ "flex flex-wrap gap-3" ] ]
            [ actionButton "Download App" "/omega/work/download"
            , actionButton "View Docs" "/omega/work/docs"
            , actionButton "Manage Billing" "/omega/work/settings#billing"
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
            [ activityItem "Conversation" "Updated README.md in my-project" "2 hours ago"
            , activityItem "Project" "Created new-website project" "Yesterday"
            , activityItem "Sync" "Synced from MacBook Pro" "Yesterday"
            , activityItem "Conversation" "Refactored utils.ts" "2 days ago"
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

actionButton :: forall w i. String -> String -> HH.HTML w i
actionButton label href =
  HH.a
    [ HP.href href
    , cls [ "px-4 py-2 bg-amber-400/10 text-amber-400 text-sm font-medium rounded-md hover:bg-amber-400/20 transition-colors" ]
    ]
    [ HH.text label ]

activityItem :: forall w i. String -> String -> String -> HH.HTML w i
activityItem type_ description time =
  HH.div
    [ cls [ "flex items-center justify-between py-2 border-b border-border last:border-0" ] ]
    [ HH.div
        [ cls [ "flex items-center gap-3" ] ]
        [ HH.span
            [ cls [ "text-xs px-2 py-0.5 rounded font-medium bg-amber-400/10 text-amber-400" ] ]
            [ HH.text type_ ]
        , HH.span [ cls [ "text-sm text-text" ] ] [ HH.text description ]
        ]
    , HH.span [ cls [ "text-sm text-muted-foreground" ] ] [ HH.text time ]
    ]

-- ============================================================
-- DOWNLOADS TAB
-- ============================================================

downloadsTab :: forall w i. HH.HTML w i
downloadsTab =
  HH.div_
    [ HH.div
        [ cls [ "grid grid-cols-1 md:grid-cols-3 gap-6" ] ]
        [ downloadCard "macOS" "Universal (Intel + Apple Silicon)" "omega-work-1.0.0.dmg" "45 MB"
        , downloadCard "Windows" "Windows 10/11 (64-bit)" "omega-work-1.0.0.exe" "52 MB"
        , downloadCard "Linux" "AppImage (64-bit)" "omega-work-1.0.0.AppImage" "48 MB"
        ]
    , HH.div
        [ cls [ "mt-8 p-4 bg-card border border-border rounded-lg" ] ]
        [ HH.h3 [ cls [ "text-sm font-medium text-text mb-2" ] ] [ HH.text "Previous Versions" ]
        , HH.a
            [ HP.href "/omega/work/docs"
            , cls [ "text-sm text-amber-400 hover:text-amber-400/80" ]
            ]
            [ HH.text "View all releases ->" ]
        ]
    ]

downloadCard :: forall w i. String -> String -> String -> String -> HH.HTML w i
downloadCard platform description filename size =
  HH.div
    [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
    [ HH.h3
        [ cls [ "text-lg font-semibold text-text mb-2" ] ]
        [ HH.text platform ]
    , HH.p
        [ cls [ "text-sm text-muted-foreground mb-4" ] ]
        [ HH.text description ]
    , HH.div
        [ cls [ "flex items-center justify-between" ] ]
        [ HH.span [ cls [ "text-xs text-muted-foreground" ] ] [ HH.text size ]
        , HH.a
            [ HP.href $ "/downloads/" <> filename
            , cls [ "px-4 py-2 bg-amber-400 text-background text-sm font-medium rounded-md hover:bg-amber-400/90 transition-colors" ]
            ]
            [ HH.text "Download" ]
        ]
    ]

-- ============================================================
-- USAGE TAB
-- ============================================================

usageTab :: forall w i. HH.HTML w i
usageTab =
  HH.div_
    [ HH.div
        [ cls [ "grid grid-cols-1 md:grid-cols-2 gap-6 mb-8" ] ]
        [ usageCard "Conversations" 247 500 "this month"
        , usageCard "Cloud Storage" 128 1000 "MB used"
        ]
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.h3
            [ cls [ "text-lg font-semibold text-text mb-4" ] ]
            [ HH.text "Usage by Project" ]
        , HH.div
            [ cls [ "space-y-4" ] ]
            [ projectUsageRow "my-project" 89 35
            , projectUsageRow "new-website" 67 27
            , projectUsageRow "docs-site" 45 18
            , projectUsageRow "Other" 46 20
            ]
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
            [ HH.text $ show current <> " / " <> show limit <> " " <> unit ]
        ]
    , HH.div
        [ cls [ "h-2 bg-muted rounded-full overflow-hidden" ] ]
        [ HH.div
            [ cls [ "h-full bg-amber-400 rounded-full" ]
            , HP.style $ "width: " <> show ((current * 100) / limit) <> "%"
            ]
            []
        ]
    ]

projectUsageRow :: forall w i. String -> Int -> Int -> HH.HTML w i
projectUsageRow name conversations percentage =
  HH.div
    [ cls [ "flex items-center justify-between py-2 border-b border-border last:border-0" ] ]
    [ HH.span [ cls [ "text-sm text-text" ] ] [ HH.text name ]
    , HH.div
        [ cls [ "flex items-center gap-4" ] ]
        [ HH.span [ cls [ "text-sm text-muted-foreground" ] ] 
            [ HH.text $ show conversations <> " conversations" ]
        , HH.span [ cls [ "text-sm text-amber-400" ] ] 
            [ HH.text $ show percentage <> "%" ]
        ]
    ]

-- ============================================================
-- DEVICES TAB
-- ============================================================

devicesTab :: forall w i. HH.HTML w i
devicesTab =
  HH.div_
    [ HH.div
        [ cls [ "space-y-4" ] ]
        [ deviceCard "MacBook Pro" "macOS 14.2" "Active now" true
        , deviceCard "Windows Desktop" "Windows 11" "2 hours ago" true
        , deviceCard "Linux Laptop" "Ubuntu 22.04" "3 days ago" false
        ]
    , HH.div
        [ cls [ "mt-8 p-4 bg-card border border-border rounded-lg" ] ]
        [ HH.p
            [ cls [ "text-sm text-muted-foreground" ] ]
            [ HH.text "Your Pro plan includes sync across unlimited devices." ]
        ]
    ]

deviceCard :: forall w i. String -> String -> String -> Boolean -> HH.HTML w i
deviceCard name os lastActive current =
  HH.div
    [ cls [ "bg-card border rounded-lg p-4 flex items-center justify-between"
          , if current then "border-amber-400/30" else "border-border"
          ]
    ]
    [ HH.div_
        [ HH.div
            [ cls [ "flex items-center gap-2" ] ]
            [ HH.span [ cls [ "text-text font-medium" ] ] [ HH.text name ]
            , if current
                then HH.span [ cls [ "text-xs px-2 py-0.5 rounded bg-amber-400/10 text-amber-400" ] ] 
                    [ HH.text "Current" ]
                else HH.text ""
            ]
        , HH.p [ cls [ "text-sm text-muted-foreground" ] ] [ HH.text os ]
        ]
    , HH.div
        [ cls [ "text-right" ] ]
        [ HH.p [ cls [ "text-sm text-muted-foreground" ] ] [ HH.text lastActive ]
        , if not current
            then HH.button
                [ cls [ "text-xs text-danger hover:text-danger/80 cursor-pointer" ]
                , HP.type_ HP.ButtonButton
                ]
                [ HH.text "Remove" ]
            else HH.text ""
        ]
    ]
