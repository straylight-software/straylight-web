-- | omega//proxy Settings Page
module Straylight.Pages.Products.OmegaProxy.Settings where

import Prelude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Straylight.UI (cls, sectionHeader, settingsGroup, settingsItem, settingsToggle, settingsInput, settingsButton)

type State = 
  { proxyName :: String
  , enableCompression :: Boolean
  , enableSsl :: Boolean
  , saved :: Boolean
  }

data Action 
  = UpdateProxyName String
  | ToggleCompression
  | ToggleSsl
  | SaveChanges

settingsPage :: forall q i o m. H.Component q i o m
settingsPage = H.mkComponent
  { initialState: const 
      { proxyName: "edge-proxy-01"
      , enableCompression: true
      , enableSsl: true
      , saved: false
      }
  , render
  , eval: H.mkEval H.defaultEval
      { handleAction = handleAction
      }
  }

handleAction :: forall o m. Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
  UpdateProxyName name -> do
    H.modify_ _ { proxyName = name, saved = false }
  
  ToggleCompression -> do
    H.modify_ \s -> s { enableCompression = not s.enableCompression, saved = false }
    handleAction SaveChanges
  
  ToggleSsl -> do
    H.modify_ \s -> s { enableSsl = not s.enableSsl, saved = false }
    handleAction SaveChanges

  SaveChanges -> do
    H.modify_ _ { saved = true }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ sectionHeader "omega//proxy // settings"
    , HH.div [ cls [ "max-w-4xl" ] ]
        [ settingsGroup "Network Settings"
            [ settingsItem "Proxy Name" "Custom name for this proxy instance" 
                (settingsInput state.proxyName "edge-proxy-01" UpdateProxyName)
            , settingsItem "Gzip Compression" "Compress responses to reduce bandwidth" 
                (settingsToggle state.enableCompression ToggleCompression)
            , settingsItem "Force SSL" "Redirect all HTTP traffic to HTTPS" 
                (settingsToggle state.enableSsl ToggleSsl)
            ]
        , HH.div [ cls [ "flex items-center gap-4" ] ]
            [ settingsButton "Save Changes" SaveChanges
            , if state.saved 
                then HH.span [ cls [ "text-status text-xs animate-pulse" ] ] [ HH.text "Changes saved successfully" ]
                else HH.text ""
            ]
        ]
    ]
