module Straylight.Pages.Products.SensenetBuild.Dashboard where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Array (length)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Straylight.UI (cls, sectionHeader, emptyDashboard, settingsButton, statusIndicator)

type Build = 
  { id :: String
  , flakeRef :: String
  , status :: String
  , duration :: String
  , finishedAt :: String
  }

type State = 
  { builds :: Array Build
  , loading :: Boolean
  }

data Action 
  = Initialize
  | TriggerBuild
  | RefreshBuilds

dashboardPage :: forall q i o m. H.Component q i o m
dashboardPage = H.mkComponent
  { initialState: const 
      { builds: []
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
    handleAction RefreshBuilds
  
  RefreshBuilds -> do
    H.modify_ _ { loading = true }
    let mockBuilds = 
          [ { id: "build-1234", flakeRef: "github:straylight/armory", status: "success", duration: "4m 12s", finishedAt: "10 mins ago" }
          , { id: "build-1235", flakeRef: "github:straylight/sdk", status: "running", duration: "1m 30s", finishedAt: "ongoing" }
          ]
    H.modify_ _ { builds = mockBuilds, loading = false }
  
  TriggerBuild -> do
    H.modify_ _ { loading = true }
    H.modify_ \s -> s { builds = s.builds <> [{ id: "build-new", flakeRef: "github:user/repo", status: "queued", duration: "-", finishedAt: "-" }], loading = false }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ sectionHeader "sensenet//build // dashboard"
    , if length state.builds == 0 && not state.loading
        then emptyDashboard "sensenet//build" TriggerBuild
        else HH.div_
            [ HH.div [ cls [ "flex justify-between items-center mb-6" ] ]
                [ HH.div_ [ statusIndicator "1 BUILD RUNNING" ]
                , settingsButton "trigger build" TriggerBuild
                ]
            , HH.div [ cls [ "bg-card border border-border rounded-lg overflow-hidden" ] ]
                [ HH.table [ cls [ "w-full text-left text-xs" ] ]
                    [ HH.thead [ cls [ "bg-muted/30 border-b border-border text-[10px] uppercase tracking-widest text-muted-foreground" ] ]
                        [ HH.tr_
                            [ HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "build id" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "flake ref" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "status" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "duration" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "finished" ]
                            ]
                        ]
                    , HH.tbody [ cls [ "divide-y divide-border" ] ]
                        (map renderBuild state.builds)
                    ]
                ]
            ]
    ]

renderBuild :: forall w i. Build -> HH.HTML w i
renderBuild build =
  HH.tr [ cls [ "hover:bg-muted/5 transition-colors group cursor-pointer" ] ]
    [ HH.td [ cls [ "px-6 py-4 font-mono text-primary" ] ] [ HH.text build.id ]
    , HH.td [ cls [ "px-6 py-4 text-text" ] ] [ HH.text build.flakeRef ]
    , HH.td [ cls [ "px-6 py-4" ] ] 
        [ HH.span 
            [ cls [ "px-2 py-0.5 rounded text-[10px] uppercase tracking-tighter"
                  , case build.status of
                      "success" -> "bg-status/20 text-status"
                      "running" -> "bg-blue-500/20 text-blue-400 status-pulse"
                      "failed" -> "bg-red-500/20 text-red-400"
                      _ -> "bg-muted text-muted-foreground"
                  ] 
            ] 
            [ HH.text build.status ]
        ]
    , HH.td [ cls [ "px-6 py-4 text-muted-foreground font-mono" ] ] [ HH.text build.duration ]
    , HH.td [ cls [ "px-6 py-4 text-muted-foreground" ] ] [ HH.text build.finishedAt ]
    ]
