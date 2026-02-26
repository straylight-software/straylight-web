-- | sensenet//publish Settings Page
module Straylight.Pages.Products.SensenetPublish.Settings where

import Prelude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Straylight.UI (cls, sectionHeader, settingsGroup, settingsItem, settingsToggle, settingsInput, settingsButton)

type State = 
  { customDomain :: String
  , edgeCaching :: Boolean
  , autoDeploy :: Boolean
  , saved :: Boolean
  }

data Action 
  = UpdateCustomDomain String
  | ToggleEdgeCaching
  | ToggleAutoDeploy
  | SaveChanges

settingsPage :: forall q i o m. H.Component q i o m
settingsPage = H.mkComponent
  { initialState: const 
      { customDomain: "straylight.run"
      , edgeCaching: true
      , autoDeploy: true
      , saved: false
      }
  , render
  , eval: H.mkEval H.defaultEval
      { handleAction = handleAction
      }
  }

handleAction :: forall o m. Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
  UpdateCustomDomain domain -> do
    H.modify_ _ { customDomain = domain, saved = false }
  
  ToggleEdgeCaching -> do
    H.modify_ \s -> s { edgeCaching = not s.edgeCaching, saved = false }
    handleAction SaveChanges
  
  ToggleAutoDeploy -> do
    H.modify_ \s -> s { autoDeploy = not s.autoDeploy, saved = false }
    handleAction SaveChanges

  SaveChanges -> do
    H.modify_ _ { saved = true }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ sectionHeader "sensenet//publish // settings"
    , HH.div [ cls [ "max-w-4xl" ] ]
        [ settingsGroup "Deployment Settings"
            [ settingsItem "Custom Domain" "Primary domain for your published site" 
                (settingsInput state.customDomain "example.com" UpdateCustomDomain)
            , settingsItem "Edge Caching" "Enable global CDN caching for faster delivery" 
                (settingsToggle state.edgeCaching ToggleEdgeCaching)
            , settingsItem "Auto-deploy" "Deploy changes automatically on git push" 
                (settingsToggle state.autoDeploy ToggleAutoDeploy)
            ]
        , HH.div [ cls [ "flex items-center gap-4" ] ]
            [ settingsButton "Save Changes" SaveChanges
            , if state.saved 
                then HH.span [ cls [ "text-status text-xs animate-pulse" ] ] [ HH.text "Changes saved successfully" ]
                else HH.text ""
            ]
        ]
    ]
