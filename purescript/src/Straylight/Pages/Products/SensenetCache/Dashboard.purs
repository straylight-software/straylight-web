-- | sensenet//cache Dashboard Page
module Straylight.Pages.Products.SensenetCache.Dashboard where

import Prelude

import Data.Array (length)
import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Straylight.UI (cls, sectionHeader, emptyDashboard, settingsButton, statusIndicator)

type CacheEntry = 
  { key :: String
  , size :: String
  , ttl :: String
  , lastAccessed :: String
  }

type State = 
  { entries :: Array CacheEntry
  , loading :: Boolean
  , hasData :: Boolean
  }

data Action 
  = Initialize
  | Connect
  | RefreshEntries

dashboardPage :: forall q i o m. H.Component q i o m
dashboardPage = H.mkComponent
  { initialState: const 
      { entries: []
      , loading: false
      , hasData: false
      }
  , render
  , eval: H.mkEval H.defaultEval
      { handleAction = handleAction
      , initialize = Just Initialize
      }
  }

handleAction :: forall o m. Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
  Initialize -> pure unit
  
  Connect -> do
    H.modify_ _ { loading = true }
    let mockEntries = 
          [ { key: "user:session:a8f2", size: "1.2KB", ttl: "24m", lastAccessed: "Just now" }
          , { key: "pkg:nix:armory", size: "450MB", ttl: "6d", lastAccessed: "12 mins ago" }
          , { key: "api:cache:v1:results", size: "45KB", ttl: "1h", lastAccessed: "2 mins ago" }
          ]
    H.modify_ _ { entries = mockEntries, loading = false, hasData = true }

  RefreshEntries -> do
    handleAction Connect

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ sectionHeader "sensenet//cache // dashboard"
    , if not state.hasData && not state.loading
        then emptyDashboard "sensenet//cache" Connect
        else HH.div_
            [ HH.div [ cls [ "flex justify-between items-center mb-6" ] ]
                [ HH.div_ [ statusIndicator (show (length state.entries) <> " ENTRIES CACHED") ]
                , settingsButton "purge cache" RefreshEntries
                ]
            , HH.div [ cls [ "bg-card border border-border rounded-lg overflow-hidden" ] ]
                [ HH.table [ cls [ "w-full text-left text-xs" ] ]
                    [ HH.thead [ cls [ "bg-muted/30 border-b border-border text-[10px] uppercase tracking-widest text-muted-foreground" ] ]
                        [ HH.tr_
                            [ HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "cache key" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "size" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "ttl" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "last accessed" ]
                            ]
                        ]
                    , HH.tbody [ cls [ "divide-y divide-border" ] ]
                        (map renderEntry state.entries)
                    ]
                ]
            ]
    ]

renderEntry :: forall w i. CacheEntry -> HH.HTML w i
renderEntry entry =
  HH.tr [ cls [ "hover:bg-muted/5 transition-colors group cursor-pointer" ] ]
    [ HH.td [ cls [ "px-6 py-4 font-mono text-primary truncate max-w-xs" ] ] [ HH.text entry.key ]
    , HH.td [ cls [ "px-6 py-4 text-muted-foreground font-mono" ] ] [ HH.text entry.size ]
    , HH.td [ cls [ "px-6 py-4 text-muted-foreground font-mono" ] ] [ HH.text entry.ttl ]
    , HH.td [ cls [ "px-6 py-4 text-muted-foreground" ] ] [ HH.text entry.lastAccessed ]
    ]
