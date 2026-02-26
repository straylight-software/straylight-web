-- | sensenet//converge Dashboard Page
module Straylight.Pages.Products.SensenetConverge.Dashboard where

import Prelude

import Data.Array (length)
import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Straylight.UI (cls, sectionHeader, emptyDashboard, settingsButton, statusIndicator)

type Cluster = 
  { id :: String
  , name :: String
  , nodes :: Int
  , region :: String
  , status :: String
  }

type State = 
  { clusters :: Array Cluster
  , loading :: Boolean
  }

data Action 
  = Initialize
  | ProvisionCluster
  | RefreshClusters

dashboardPage :: forall q i o m. H.Component q i o m
dashboardPage = H.mkComponent
  { initialState: const 
      { clusters: []
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
    handleAction RefreshClusters
  
  RefreshClusters -> do
    H.modify_ _ { loading = true }
    let mockClusters = 
          [ { id: "cl-101", name: "Production Core", nodes: 24, region: "us-east-1", status: "converged" }
          , { id: "cl-102", name: "Staging Overlay", nodes: 8, region: "eu-west-1", status: "converged" }
          , { id: "cl-103", name: "Dev Sandbox", nodes: 3, region: "us-west-2", status: "drifting" }
          ]
    H.modify_ _ { clusters = mockClusters, loading = false }
  
  ProvisionCluster -> do
    H.modify_ _ { loading = true }
    H.modify_ \s -> s { clusters = s.clusters <> [{ id: "cl-new", name: "New Cluster", nodes: 1, region: "us-east-1", status: "provisioning" }], loading = false }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ sectionHeader "sensenet//converge // dashboard"
    , if length state.clusters == 0 && not state.loading
        then emptyDashboard "sensenet//converge" ProvisionCluster
        else HH.div_
            [ HH.div [ cls [ "flex justify-between items-center mb-6" ] ]
                [ HH.div_ [ statusIndicator (show (length state.clusters) <> " CLUSTERS CONVERGED") ]
                , settingsButton "provision cluster" ProvisionCluster
                ]
            , HH.div [ cls [ "bg-card border border-border rounded-lg overflow-hidden" ] ]
                [ HH.table [ cls [ "w-full text-left text-xs" ] ]
                    [ HH.thead [ cls [ "bg-muted/30 border-b border-border text-[10px] uppercase tracking-widest text-muted-foreground" ] ]
                        [ HH.tr_
                            [ HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "cluster id" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "name" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "nodes" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "region" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "status" ]
                            ]
                        ]
                    , HH.tbody [ cls [ "divide-y divide-border" ] ]
                        (map renderCluster state.clusters)
                    ]
                ]
            ]
    ]

renderCluster :: forall w i. Cluster -> HH.HTML w i
renderCluster cluster =
  HH.tr [ cls [ "hover:bg-muted/5 transition-colors group cursor-pointer" ] ]
    [ HH.td [ cls [ "px-6 py-4 font-mono text-primary" ] ] [ HH.text cluster.id ]
    , HH.td [ cls [ "px-6 py-4 text-text font-medium" ] ] [ HH.text cluster.name ]
    , HH.td [ cls [ "px-6 py-4 text-muted-foreground font-mono" ] ] [ HH.text $ show cluster.nodes ]
    , HH.td [ cls [ "px-6 py-4 text-muted-foreground" ] ] [ HH.text cluster.region ]
    , HH.td [ cls [ "px-6 py-4" ] ] 
        [ HH.span 
            [ cls [ "px-2 py-0.5 rounded text-[10px] uppercase tracking-tighter"
                  , case cluster.status of
                      "converged" -> "bg-status/20 text-status"
                      "provisioning" -> "bg-blue-500/20 text-blue-400 status-pulse"
                      "drifting" -> "bg-red-500/20 text-red-400"
                      _ -> "bg-muted text-muted-foreground"
                  ] 
            ] 
            [ HH.text cluster.status ]
        ]
    ]
