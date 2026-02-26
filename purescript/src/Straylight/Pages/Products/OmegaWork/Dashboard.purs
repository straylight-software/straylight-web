module Straylight.Pages.Products.OmegaWork.Dashboard where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Array (length)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Straylight.UI (cls, sectionHeader, emptyDashboard, settingsButton, statusIndicator)

type Workspace = 
  { id :: String
  , name :: String
  , type_ :: String
  , members :: Int
  , lastActive :: String
  }

type State = 
  { workspaces :: Array Workspace
  , loading :: Boolean
  }

data Action 
  = Initialize
  | CreateWorkspace
  | RefreshWorkspaces

dashboardPage :: forall q i o m. H.Component q i o m
dashboardPage = H.mkComponent
  { initialState: const 
      { workspaces: []
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
    handleAction RefreshWorkspaces
  
  RefreshWorkspaces -> do
    H.modify_ _ { loading = true }
    let mockWorkspaces = 
          [ { id: "ws-1", name: "Engineering Team", type_: "shared", members: 12, lastActive: "2 mins ago" }
          , { id: "ws-2", name: "Product Design", type_: "shared", members: 5, lastActive: "1 hour ago" }
          , { id: "ws-3", name: "Personal Sandbox", type_: "private", members: 1, lastActive: "Yesterday" }
          ]
    H.modify_ _ { workspaces = mockWorkspaces, loading = false }
  
  CreateWorkspace -> do
    H.modify_ _ { loading = true }
    H.modify_ \s -> s { workspaces = s.workspaces <> [{ id: "ws-new", name: "New Workspace", type_: "private", members: 1, lastActive: "Just now" }], loading = false }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ sectionHeader "omega//work // dashboard"
    , if length state.workspaces == 0 && not state.loading
        then emptyDashboard "omega//work" CreateWorkspace
        else HH.div_
            [ HH.div [ cls [ "flex justify-between items-center mb-6" ] ]
                [ HH.div_ [ statusIndicator "3 WORKSPACES ACTIVE" ]
                , settingsButton "create workspace" CreateWorkspace
                ]
            , HH.div [ cls [ "bg-card border border-border rounded-lg overflow-hidden" ] ]
                [ HH.table [ cls [ "w-full text-left text-xs" ] ]
                    [ HH.thead [ cls [ "bg-muted/30 border-b border-border text-[10px] uppercase tracking-widest text-muted-foreground" ] ]
                        [ HH.tr_
                            [ HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "workspace id" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "name" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "type" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "members" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "last active" ]
                            ]
                        ]
                    , HH.tbody [ cls [ "divide-y divide-border" ] ]
                        (map renderWorkspace state.workspaces)
                    ]
                ]
            ]
    ]

renderWorkspace :: forall w i. Workspace -> HH.HTML w i
renderWorkspace ws =
  HH.tr [ cls [ "hover:bg-muted/5 transition-colors group cursor-pointer" ] ]
    [ HH.td [ cls [ "px-6 py-4 font-mono text-primary" ] ] [ HH.text ws.id ]
    , HH.td [ cls [ "px-6 py-4 text-text font-medium" ] ] [ HH.text ws.name ]
    , HH.td [ cls [ "px-6 py-4 text-muted-foreground" ] ] 
        [ HH.span [ cls [ "px-1.5 py-0.5 border border-border rounded text-[9px] uppercase tracking-tighter" ] ] [ HH.text ws.type_ ] ]
    , HH.td [ cls [ "px-6 py-4 text-muted-foreground font-mono" ] ] [ HH.text $ show ws.members ]
    , HH.td [ cls [ "px-6 py-4 text-muted-foreground" ] ] [ HH.text ws.lastActive ]
    ]
