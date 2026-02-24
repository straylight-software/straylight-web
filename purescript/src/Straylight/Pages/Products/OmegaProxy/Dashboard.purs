-- | omega//proxy Dashboard Page
module Straylight.Pages.Products.OmegaProxy.Dashboard where

import Prelude

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

import Straylight.UI (cls)

type State = { activeTab :: String }
data Action = SetTab String

dashboardPage :: forall q i o m. H.Component q i o m
dashboardPage = H.mkComponent
  { initialState: const { activeTab: "overview" }
  , render
  , eval: H.mkEval H.defaultEval { handleAction = handleAction }
  }

handleAction :: forall o m. Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
  SetTab tab -> H.modify_ _ { activeTab = tab }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div
    [ cls [ "max-w-[1100px] mx-auto px-6 py-8" ] ]
    [ header, tabs state, content state ]

header :: forall w i. HH.HTML w i
header =
  HH.div
    [ cls [ "mb-8" ] ]
    [ HH.h1 [ cls [ "text-2xl font-bold text-text mb-2" ] ] [ HH.text "omega//proxy Dashboard" ]
    , HH.p [ cls [ "text-muted-foreground" ] ] [ HH.text "Manage your endpoints, traffic, and API keys." ]
    ]

tabs :: forall m. State -> H.ComponentHTML Action () m
tabs state =
  HH.div
    [ cls [ "flex gap-1 mb-8 border-b border-border" ] ]
    [ tabButton state "overview" "Overview"
    , tabButton state "endpoints" "Endpoints"
    , tabButton state "traffic" "Traffic"
    , tabButton state "apikeys" "API Keys"
    , tabButton state "usage" "Usage"
    ]

tabButton :: forall m. State -> String -> String -> H.ComponentHTML Action () m
tabButton state value label =
  HH.button
    [ cls [ "px-4 py-2 text-sm font-medium transition-colors -mb-px cursor-pointer"
          , if state.activeTab == value 
              then "text-purple-400 border-b-2 border-purple-400" 
              else "text-muted-foreground hover:text-text"
          ]
    , HP.type_ HP.ButtonButton
    ]
    [ HH.text label ]

content :: forall m. State -> H.ComponentHTML Action () m
content state = case state.activeTab of
  "overview" -> overviewTab
  "endpoints" -> endpointsTab
  "traffic" -> trafficTab
  "apikeys" -> apiKeysTab
  "usage" -> usageTab
  _ -> overviewTab

overviewTab :: forall w i. HH.HTML w i
overviewTab =
  HH.div_
    [ HH.div
        [ cls [ "grid grid-cols-1 md:grid-cols-4 gap-4 mb-8" ] ]
        [ statCard "Requests Today" "12,847" "↑ 8% from yesterday"
        , statCard "Avg Latency" "23ms" "p99: 89ms"
        , statCard "Error Rate" "0.02%" "Last 24 hours"
        , statCard "Ambiguity Resets" "3" "Last 24 hours"
        ]
    ]

endpointsTab :: forall w i. HH.HTML w i
endpointsTab = HH.div_ [ HH.text "Endpoints management" ]

trafficTab :: forall w i. HH.HTML w i
trafficTab = HH.div_ [ HH.text "Traffic analytics" ]

apiKeysTab :: forall w i. HH.HTML w i
apiKeysTab = HH.div_ [ HH.text "API keys management" ]

usageTab :: forall w i. HH.HTML w i
usageTab = HH.div_ [ HH.text "Usage statistics" ]

statCard :: forall w i. String -> String -> String -> HH.HTML w i
statCard label value subtitle =
  HH.div
    [ cls [ "bg-card border border-border rounded-lg p-4" ] ]
    [ HH.p [ cls [ "text-sm text-muted-foreground mb-1" ] ] [ HH.text label ]
    , HH.p [ cls [ "text-2xl font-bold text-text" ] ] [ HH.text value ]
    , HH.p [ cls [ "text-xs text-muted-foreground" ] ] [ HH.text subtitle ]
    ]
