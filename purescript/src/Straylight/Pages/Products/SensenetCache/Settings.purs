-- | sensenet//cache Settings Page
module Straylight.Pages.Products.SensenetCache.Settings where

import Prelude
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Straylight.UI (cls)

type State = { activeTab :: String }
data Action = SetTab String

settingsPage :: forall q i o m. H.Component q i o m
settingsPage = H.mkComponent
  { initialState: const { activeTab: "account" }, render
  , eval: H.mkEval H.defaultEval { handleAction = handleAction } }

handleAction :: forall o m. Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
  SetTab tab -> H.modify_ _ { activeTab = tab }

render :: forall m. State -> H.ComponentHTML Action () m
render state = HH.div [ cls [ "max-w-[1100px] mx-auto px-6 py-8" ] ]
    [ HH.div [ cls [ "mb-8" ] ] [ HH.h1 [ cls [ "text-2xl font-bold text-text" ] ] [ HH.text "Settings" ] ]
    , HH.div [ cls [ "grid grid-cols-1 lg:grid-cols-[200px_1fr] gap-8" ] ] [ sidebar state, content state ] ]

sidebar :: forall m. State -> H.ComponentHTML Action () m
sidebar state = HH.nav [ cls [ "space-y-1" ] ]
    [ sidebarLink state "account" "Account", sidebarLink state "billing" "Billing"
    , sidebarLink state "team" "Team", sidebarLink state "security" "Security" ]

sidebarLink :: forall m. State -> String -> String -> H.ComponentHTML Action () m
sidebarLink state value label = HH.button
    [ cls [ "block w-full text-left px-3 py-2 rounded text-sm transition-colors cursor-pointer"
          , if state.activeTab == value then "bg-cyan-400/10 text-cyan-400 font-medium" else "text-muted-foreground hover:text-text hover:bg-card" ]
    , HP.type_ HP.ButtonButton, HE.onClick \_ -> SetTab value ] [ HH.text label ]

content :: forall m. State -> H.ComponentHTML Action () m
content state = case state.activeTab of
  "account" -> HH.div [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
      [ HH.h3 [ cls [ "text-lg font-semibold text-text mb-4" ] ] [ HH.text "Account Settings" ]
      , HH.p [ cls [ "text-muted-foreground" ] ] [ HH.text "Manage your sensenet//cache account." ] ]
  _ -> HH.div_ [ HH.text "Settings content" ]
