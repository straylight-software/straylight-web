-- | sensenet//publish Dashboard Page
module Straylight.Pages.Products.SensenetPublish.Dashboard where

import Prelude
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Straylight.UI (cls)

type State = { activeTab :: String }
data Action = SetTab String

dashboardPage :: forall q i o m. H.Component q i o m
dashboardPage = H.mkComponent
  { initialState: const { activeTab: "overview" }, render
  , eval: H.mkEval H.defaultEval { handleAction = handleAction } }

handleAction :: forall o m. Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
  SetTab tab -> H.modify_ _ { activeTab = tab }

render :: forall m. State -> H.ComponentHTML Action () m
render state = HH.div [ cls [ "max-w-[1100px] mx-auto px-6 py-8" ] ] [ header, tabs state, content state ]

header :: forall w i. HH.HTML w i
header = HH.div [ cls [ "mb-8" ] ]
    [ HH.h1 [ cls [ "text-2xl font-bold text-text mb-2" ] ] [ HH.text "sensenet//publish Dashboard" ]
    , HH.p [ cls [ "text-muted-foreground" ] ] [ HH.text "Manage documentation projects and scope graphs." ] ]

tabs :: forall m. State -> H.ComponentHTML Action () m
tabs state = HH.div [ cls [ "flex gap-1 mb-8 border-b border-border" ] ]
    [ tabButton state "overview" "Overview", tabButton state "projects" "Projects"
    , tabButton state "docs" "Docs", tabButton state "graphs" "Scope Graphs", tabButton state "usage" "Usage" ]

tabButton :: forall m. State -> String -> String -> H.ComponentHTML Action () m
tabButton state value label = HH.button
    [ cls [ "px-4 py-2 text-sm font-medium transition-colors -mb-px cursor-pointer"
          , if state.activeTab == value then "text-pink-400 border-b-2 border-pink-400" else "text-muted-foreground hover:text-text" ]
    , HP.type_ HP.ButtonButton ] [ HH.text label ]

content :: forall m. State -> H.ComponentHTML Action () m
content state = case state.activeTab of
  "overview" -> overviewTab
  _ -> HH.div_ [ HH.text "Content" ]

overviewTab :: forall w i. HH.HTML w i
overviewTab = HH.div_
    [ HH.div [ cls [ "grid grid-cols-1 md:grid-cols-4 gap-4 mb-8" ] ]
        [ statCard "Projects" "12" "active"
        , statCard "Docs Generated" "847" "this month"
        , statCard "References Resolved" "99.2%" "no broken links"
        , statCard "Languages" "7" "supported" ] ]

statCard :: forall w i. String -> String -> String -> HH.HTML w i
statCard label value subtitle = HH.div [ cls [ "bg-card border border-border rounded-lg p-4" ] ]
    [ HH.p [ cls [ "text-sm text-muted-foreground mb-1" ] ] [ HH.text label ]
    , HH.p [ cls [ "text-2xl font-bold text-text" ] ] [ HH.text value ]
    , HH.p [ cls [ "text-xs text-muted-foreground" ] ] [ HH.text subtitle ] ]
