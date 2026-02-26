-- | sensenet//cache Settings Page
module Straylight.Pages.Products.SensenetCache.Settings where

import Prelude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Straylight.UI (cls, sectionHeader, settingsGroup, settingsItem, settingsToggle, settingsInput, settingsButton)

type State = 
  { maxCacheSize :: String
  , evictionPolicy :: String
  , compressionEnabled :: Boolean
  , saved :: Boolean
  }

data Action 
  = UpdateMaxCacheSize String
  | UpdateEvictionPolicy String
  | ToggleCompression
  | SaveChanges

settingsPage :: forall q i o m. H.Component q i o m
settingsPage = H.mkComponent
  { initialState: const 
      { maxCacheSize: "10GB"
      , evictionPolicy: "LRU"
      , compressionEnabled: true
      , saved: false
      }
  , render
  , eval: H.mkEval H.defaultEval
      { handleAction = handleAction
      }
  }

handleAction :: forall o m. Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
  UpdateMaxCacheSize size -> do
    H.modify_ _ { maxCacheSize = size, saved = false }
  
  UpdateEvictionPolicy policy -> do
    H.modify_ _ { evictionPolicy = policy, saved = false }

  ToggleCompression -> do
    H.modify_ \s -> s { compressionEnabled = not s.compressionEnabled, saved = false }
    handleAction SaveChanges

  SaveChanges -> do
    H.modify_ _ { saved = true }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ sectionHeader "sensenet//cache // settings"
    , HH.div [ cls [ "max-w-4xl" ] ]
        [ settingsGroup "Cache Configuration"
            [ settingsItem "Max Cache Size" "Maximum disk space allocated for caching" 
                (settingsInput state.maxCacheSize "10GB" UpdateMaxCacheSize)
            , settingsItem "Eviction Policy" "Algorithm used for cache eviction (LRU, LFU, FIFO)" 
                (settingsInput state.evictionPolicy "LRU" UpdateEvictionPolicy)
            , settingsItem "Enable Compression" "Compress cache entries to save space" 
                (settingsToggle state.compressionEnabled ToggleCompression)
            ]
        , HH.div [ cls [ "flex items-center gap-4" ] ]
            [ settingsButton "Save Changes" SaveChanges
            , if state.saved 
                then HH.span [ cls [ "text-status text-xs animate-pulse" ] ] [ HH.text "Changes saved successfully" ]
                else HH.text ""
            ]
        ]
    ]
