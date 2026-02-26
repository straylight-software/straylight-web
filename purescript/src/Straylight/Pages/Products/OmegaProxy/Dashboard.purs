-- | omega//proxy Dashboard Page
module Straylight.Pages.Products.OmegaProxy.Dashboard where

import Prelude

import Data.Array (length)
import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Straylight.UI (cls, sectionHeader, emptyDashboard, settingsButton, statusIndicator)

type Endpoint = 
  { id :: String
  , path :: String
  , target :: String
  , requests :: Int
  , latency :: String
  }

type State = 
  { endpoints :: Array Endpoint
  , loading :: Boolean
  }

data Action 
  = Initialize
  | AddEndpoint
  | RefreshEndpoints

dashboardPage :: forall q i o m. H.Component q i o m
dashboardPage = H.mkComponent
  { initialState: const 
      { endpoints: []
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
    handleAction RefreshEndpoints
  
  RefreshEndpoints -> do
    H.modify_ _ { loading = true }
    let mockEndpoints = 
          [ { id: "ep-1", path: "/api/v1", target: "http://backend-1:8080", requests: 12400, latency: "12ms" }
          , { id: "ep-2", path: "/auth", target: "http://auth-service:3000", requests: 5200, latency: "45ms" }
          , { id: "ep-3", path: "/socket.io", target: "ws://gateway:9000", requests: 850, latency: "2ms" }
          ]
    H.modify_ _ { endpoints = mockEndpoints, loading = false }
  
  AddEndpoint -> do
    H.modify_ _ { loading = true }
    H.modify_ \s -> s { endpoints = s.endpoints <> [{ id: "ep-new", path: "/new-route", target: "http://localhost:8000", requests: 0, latency: "-" }], loading = false }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ sectionHeader "omega//proxy // dashboard"
    , if length state.endpoints == 0 && not state.loading
        then emptyDashboard "omega//proxy" AddEndpoint
        else HH.div_
            [ HH.div [ cls [ "flex justify-between items-center mb-6" ] ]
                [ HH.div_ [ statusIndicator (show (length state.endpoints) <> " ENDPOINTS ACTIVE") ]
                , settingsButton "add endpoint" AddEndpoint
                ]
            , HH.div [ cls [ "bg-card border border-border rounded-lg overflow-hidden" ] ]
                [ HH.table [ cls [ "w-full text-left text-xs" ] ]
                    [ HH.thead [ cls [ "bg-muted/30 border-b border-border text-[10px] uppercase tracking-widest text-muted-foreground" ] ]
                        [ HH.tr_
                            [ HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "endpoint id" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "path" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "target" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "requests (24h)" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "avg latency" ]
                            ]
                        ]
                    , HH.tbody [ cls [ "divide-y divide-border" ] ]
                        (map renderEndpoint state.endpoints)
                    ]
                ]
            ]
    ]

renderEndpoint :: forall w i. Endpoint -> HH.HTML w i
renderEndpoint ep =
  HH.tr [ cls [ "hover:bg-muted/5 transition-colors group cursor-pointer" ] ]
    [ HH.td [ cls [ "px-6 py-4 font-mono text-primary" ] ] [ HH.text ep.id ]
    , HH.td [ cls [ "px-6 py-4 text-text font-medium" ] ] [ HH.text ep.path ]
    , HH.td [ cls [ "px-6 py-4 text-muted-foreground font-mono" ] ] [ HH.text ep.target ]
    , HH.td [ cls [ "px-6 py-4 text-muted-foreground font-mono" ] ] [ HH.text $ show ep.requests ]
    , HH.td [ cls [ "px-6 py-4 text-status font-mono" ] ] [ HH.text ep.latency ]
    ]
