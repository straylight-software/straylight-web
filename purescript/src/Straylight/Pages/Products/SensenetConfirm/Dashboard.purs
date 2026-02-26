-- | sensenet//confirm Dashboard Page
module Straylight.Pages.Products.SensenetConfirm.Dashboard where

import Prelude

import Data.Array (length)
import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Straylight.UI (cls, sectionHeader, emptyDashboard, settingsButton, statusIndicator)

type Proof = 
  { id :: String
  , pipeline :: String
  , status :: String
  , verifiedAt :: String
  }

type State = 
  { proofs :: Array Proof
  , loading :: Boolean
  }

data Action 
  = Initialize
  | CreateProof
  | RefreshProofs

dashboardPage :: forall q i o m. H.Component q i o m
dashboardPage = H.mkComponent
  { initialState: const 
      { proofs: []
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
    handleAction RefreshProofs
  
  RefreshProofs -> do
    H.modify_ _ { loading = true }
    let mockProofs = 
          [ { id: "proof-921", pipeline: "main-auth-flow", status: "verified", verifiedAt: "5 mins ago" }
          , { id: "proof-922", pipeline: "billing-v2", status: "verified", verifiedAt: "1 hour ago" }
          , { id: "proof-923", pipeline: "kernel-patch", status: "failing", verifiedAt: "2 mins ago" }
          ]
    H.modify_ _ { proofs = mockProofs, loading = false }
  
  CreateProof -> do
    H.modify_ _ { loading = true }
    H.modify_ \s -> s { proofs = s.proofs <> [{ id: "proof-new", pipeline: "manual-check", status: "pending", verifiedAt: "-" }], loading = false }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ sectionHeader "sensenet//confirm // dashboard"
    , if length state.proofs == 0 && not state.loading
        then emptyDashboard "sensenet//confirm" CreateProof
        else HH.div_
            [ HH.div [ cls [ "flex justify-between items-center mb-6" ] ]
                [ HH.div_ [ statusIndicator (show (length state.proofs) <> " PROOFS VERIFIED") ]
                , settingsButton "create proof" CreateProof
                ]
            , HH.div [ cls [ "bg-card border border-border rounded-lg overflow-hidden" ] ]
                [ HH.table [ cls [ "w-full text-left text-xs" ] ]
                    [ HH.thead [ cls [ "bg-muted/30 border-b border-border text-[10px] uppercase tracking-widest text-muted-foreground" ] ]
                        [ HH.tr_
                            [ HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "proof id" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "pipeline" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "status" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "verified at" ]
                            ]
                        ]
                    , HH.tbody [ cls [ "divide-y divide-border" ] ]
                        (map renderProof state.proofs)
                    ]
                ]
            ]
    ]

renderProof :: forall w i. Proof -> HH.HTML w i
renderProof proof =
  HH.tr [ cls [ "hover:bg-muted/5 transition-colors group cursor-pointer" ] ]
    [ HH.td [ cls [ "px-6 py-4 font-mono text-primary" ] ] [ HH.text proof.id ]
    , HH.td [ cls [ "px-6 py-4 text-text font-medium" ] ] [ HH.text proof.pipeline ]
    , HH.td [ cls [ "px-6 py-4" ] ] 
        [ HH.span 
            [ cls [ "px-2 py-0.5 rounded text-[10px] uppercase tracking-tighter"
                  , case proof.status of
                      "verified" -> "bg-status/20 text-status"
                      "pending" -> "bg-blue-500/20 text-blue-400 status-pulse"
                      "failing" -> "bg-red-500/20 text-red-400"
                      _ -> "bg-muted text-muted-foreground"
                  ] 
            ] 
            [ HH.text proof.status ]
        ]
    , HH.td [ cls [ "px-6 py-4 text-muted-foreground" ] ] [ HH.text proof.verifiedAt ]
    ]
