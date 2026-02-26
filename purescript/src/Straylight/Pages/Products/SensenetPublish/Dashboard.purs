-- | sensenet//publish Dashboard Page
module Straylight.Pages.Products.SensenetPublish.Dashboard where

import Prelude

import Data.Array (length)
import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Straylight.UI (cls, sectionHeader, emptyDashboard, settingsButton, statusIndicator)

type Site = 
  { id :: String
  , domain :: String
  , branch :: String
  , lastDeploy :: String
  , status :: String
  }

type State = 
  { sites :: Array Site
  , loading :: Boolean
  }

data Action 
  = Initialize
  | DeploySite
  | RefreshSites

dashboardPage :: forall q i o m. H.Component q i o m
dashboardPage = H.mkComponent
  { initialState: const 
      { sites: []
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
    handleAction RefreshSites
  
  RefreshSites -> do
    H.modify_ _ { loading = true }
    let mockSites = 
          [ { id: "site-f21", domain: "straylight.run", branch: "main", lastDeploy: "12 mins ago", status: "live" }
          , { id: "site-f22", domain: "docs.straylight.run", branch: "main", lastDeploy: "1 hour ago", status: "live" }
          , { id: "site-f23", domain: "preview-feat-x.straylight.run", branch: "feat-x", lastDeploy: "2 mins ago", status: "building" }
          ]
    H.modify_ _ { sites = mockSites, loading = false }
  
  DeploySite -> do
    H.modify_ _ { loading = true }
    H.modify_ \s -> s { sites = s.sites <> [{ id: "site-new", domain: "new-site.run", branch: "main", lastDeploy: "Just now", status: "queued" }], loading = false }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ sectionHeader "sensenet//publish // dashboard"
    , if length state.sites == 0 && not state.loading
        then emptyDashboard "sensenet//publish" DeploySite
        else HH.div_
            [ HH.div [ cls [ "flex justify-between items-center mb-6" ] ]
                [ HH.div_ [ statusIndicator (show (length state.sites) <> " SITES LIVE") ]
                , settingsButton "deploy site" DeploySite
                ]
            , HH.div [ cls [ "bg-card border border-border rounded-lg overflow-hidden" ] ]
                [ HH.table [ cls [ "w-full text-left text-xs" ] ]
                    [ HH.thead [ cls [ "bg-muted/30 border-b border-border text-[10px] uppercase tracking-widest text-muted-foreground" ] ]
                        [ HH.tr_
                            [ HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "site id" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "domain" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "branch" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "last deploy" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "status" ]
                            ]
                        ]
                    , HH.tbody [ cls [ "divide-y divide-border" ] ]
                        (map renderSite state.sites)
                    ]
                ]
            ]
    ]

renderSite :: forall w i. Site -> HH.HTML w i
renderSite site =
  HH.tr [ cls [ "hover:bg-muted/5 transition-colors group cursor-pointer" ] ]
    [ HH.td [ cls [ "px-6 py-4 font-mono text-primary" ] ] [ HH.text site.id ]
    , HH.td [ cls [ "px-6 py-4 text-text font-medium" ] ] [ HH.text site.domain ]
    , HH.td [ cls [ "px-6 py-4 text-muted-foreground font-mono" ] ] [ HH.text site.branch ]
    , HH.td [ cls [ "px-6 py-4 text-muted-foreground" ] ] [ HH.text site.lastDeploy ]
    , HH.td [ cls [ "px-6 py-4" ] ] 
        [ HH.span 
            [ cls [ "px-2 py-0.5 rounded text-[10px] uppercase tracking-tighter"
                  , case site.status of
                      "live" -> "bg-status/20 text-status"
                      "building" -> "bg-blue-500/20 text-blue-400 status-pulse"
                      "queued" -> "bg-muted text-muted-foreground"
                      _ -> "bg-muted text-muted-foreground"
                  ] 
            ] 
            [ HH.text site.status ]
        ]
    ]
