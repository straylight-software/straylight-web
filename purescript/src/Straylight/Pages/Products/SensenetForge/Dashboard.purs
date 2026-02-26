-- | sensenet//forge Dashboard Page
module Straylight.Pages.Products.SensenetForge.Dashboard where

import Prelude

import Data.Array (length)
import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Straylight.UI (cls, sectionHeader, emptyDashboard, settingsButton, statusIndicator)

type Template = 
  { id :: String
  , name :: String
  , version :: String
  , lastUsed :: String
  , status :: String
  }

type State = 
  { templates :: Array Template
  , loading :: Boolean
  }

data Action 
  = Initialize
  | CreateTemplate
  | RefreshTemplates

dashboardPage :: forall q i o m. H.Component q i o m
dashboardPage = H.mkComponent
  { initialState: const 
      { templates: []
      , loading: false
      }
  , render
  , eval: H.mkEval H.defaultEval
      { handleAction = handleAction
      , initialize = Just Initialize
      }
  }

handleAction :: forall o m. Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
  Initialize -> do
    handleAction RefreshTemplates
  
  RefreshTemplates -> do
    H.modify_ _ { loading = true }
    let mockTemplates = 
          [ { id: "tmpl-a1", name: "Rust Service Base", version: "v1.2.4", lastUsed: "10 mins ago", status: "stable" }
          , { id: "tmpl-a2", name: "Next.js Frontend", version: "v2.0.0", lastUsed: "2 hours ago", status: "stable" }
          , { id: "tmpl-b1", name: "Python Data API", version: "v0.5.2", lastUsed: "Yesterday", status: "beta" }
          ]
    H.modify_ _ { templates = mockTemplates, loading = false }
  
  CreateTemplate -> do
    H.modify_ _ { loading = true }
    H.modify_ \s -> s { templates = s.templates <> [{ id: "tmpl-new", name: "New Template", version: "v0.1.0", lastUsed: "Just now", status: "draft" }], loading = false }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ sectionHeader "sensenet//forge // dashboard"
    , if length state.templates == 0 && not state.loading
        then emptyDashboard "sensenet//forge" CreateTemplate
        else HH.div_
            [ HH.div [ cls [ "flex justify-between items-center mb-6" ] ]
                [ HH.div_ [ statusIndicator (show (length state.templates) <> " TEMPLATES AVAILABLE") ]
                , settingsButton "create template" CreateTemplate
                ]
            , HH.div [ cls [ "bg-card border border-border rounded-lg overflow-hidden" ] ]
                [ HH.table [ cls [ "w-full text-left text-xs" ] ]
                    [ HH.thead [ cls [ "bg-muted/30 border-b border-border text-[10px] uppercase tracking-widest text-muted-foreground" ] ]
                        [ HH.tr_
                            [ HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "template id" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "name" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "version" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "last used" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "status" ]
                            ]
                        ]
                    , HH.tbody [ cls [ "divide-y divide-border" ] ]
                        (map renderTemplate state.templates)
                    ]
                ]
            ]
    ]

renderTemplate :: forall w i. Template -> HH.HTML w i
renderTemplate tmpl =
  HH.tr [ cls [ "hover:bg-muted/5 transition-colors group cursor-pointer" ] ]
    [ HH.td [ cls [ "px-6 py-4 font-mono text-primary" ] ] [ HH.text tmpl.id ]
    , HH.td [ cls [ "px-6 py-4 text-text font-medium" ] ] [ HH.text tmpl.name ]
    , HH.td [ cls [ "px-6 py-4 text-muted-foreground font-mono" ] ] [ HH.text tmpl.version ]
    , HH.td [ cls [ "px-6 py-4 text-muted-foreground" ] ] [ HH.text tmpl.lastUsed ]
    , HH.td [ cls [ "px-6 py-4" ] ] 
        [ HH.span 
            [ cls [ "px-2 py-0.5 rounded text-[10px] uppercase tracking-tighter"
                  , case tmpl.status of
                      "stable" -> "bg-status/20 text-status"
                      "beta" -> "bg-blue-500/20 text-blue-400"
                      "draft" -> "bg-muted text-muted-foreground"
                      _ -> "bg-muted text-muted-foreground"
                  ] 
            ] 
            [ HH.text tmpl.status ]
        ]
    ]
