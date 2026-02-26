-- | omega//boost Dashboard Page
module Straylight.Pages.Products.OmegaBoost.Dashboard where

import Prelude

import Data.Array (length)
import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Straylight.UI (cls, sectionHeader, emptyDashboard, settingsButton, statusIndicator)

type InferenceJob = 
  { id :: String
  , model :: String
  , latency :: String
  , cost :: String
  , status :: String
  }

type State = 
  { jobs :: Array InferenceJob
  , loading :: Boolean
  }

data Action 
  = Initialize
  | RunInference
  | RefreshJobs

dashboardPage :: forall q i o m. H.Component q i o m
dashboardPage = H.mkComponent
  { initialState: const 
      { jobs: []
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
    handleAction RefreshJobs
  
  RefreshJobs -> do
    H.modify_ _ { loading = true }
    let mockJobs = 
          [ { id: "job-8821", model: "llama-3-70b", latency: "142ms", cost: "$0.002", status: "completed" }
          , { id: "job-8822", model: "gpt-4o", latency: "890ms", cost: "$0.015", status: "completed" }
          , { id: "job-8823", model: "claude-3-5-sonnet", latency: "420ms", cost: "$0.008", status: "processing" }
          ]
    H.modify_ _ { jobs = mockJobs, loading = false }
  
  RunInference -> do
    H.modify_ _ { loading = true }
    H.modify_ \s -> s { jobs = s.jobs <> [{ id: "job-new", model: "llama-3-8b", latency: "-", cost: "-", status: "queued" }], loading = false }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ sectionHeader "omega//boost // dashboard"
    , if length state.jobs == 0 && not state.loading
        then emptyDashboard "omega//boost" RunInference
        else HH.div_
            [ HH.div [ cls [ "flex justify-between items-center mb-6" ] ]
                [ HH.div_ [ statusIndicator (show (length state.jobs) <> " JOBS RECORDED") ]
                , settingsButton "run inference" RunInference
                ]
            , HH.div [ cls [ "bg-card border border-border rounded-lg overflow-hidden" ] ]
                [ HH.table [ cls [ "w-full text-left text-xs" ] ]
                    [ HH.thead [ cls [ "bg-muted/30 border-b border-border text-[10px] uppercase tracking-widest text-muted-foreground" ] ]
                        [ HH.tr_
                            [ HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "job id" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "model" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "latency" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "cost" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "status" ]
                            ]
                        ]
                    , HH.tbody [ cls [ "divide-y divide-border" ] ]
                        (map renderJob state.jobs)
                    ]
                ]
            ]
    ]

renderJob :: forall w i. InferenceJob -> HH.HTML w i
renderJob job =
  HH.tr [ cls [ "hover:bg-muted/5 transition-colors group cursor-pointer" ] ]
    [ HH.td [ cls [ "px-6 py-4 font-mono text-primary" ] ] [ HH.text job.id ]
    , HH.td [ cls [ "px-6 py-4 text-text" ] ] [ HH.text job.model ]
    , HH.td [ cls [ "px-6 py-4 text-muted-foreground font-mono" ] ] [ HH.text job.latency ]
    , HH.td [ cls [ "px-6 py-4 text-muted-foreground font-mono" ] ] [ HH.text job.cost ]
    , HH.td [ cls [ "px-6 py-4" ] ] 
        [ HH.span 
            [ cls [ "px-2 py-0.5 rounded text-[10px] uppercase tracking-tighter"
                  , case job.status of
                      "completed" -> "bg-status/20 text-status"
                      "processing" -> "bg-blue-500/20 text-blue-400 status-pulse"
                      "queued" -> "bg-muted text-muted-foreground"
                      _ -> "bg-muted text-muted-foreground"
                  ] 
            ] 
            [ HH.text job.status ]
        ]
    ]
