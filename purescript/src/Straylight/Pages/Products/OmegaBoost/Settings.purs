-- | omega//boost Settings Page
module Straylight.Pages.Products.OmegaBoost.Settings where

import Prelude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Straylight.UI (cls, sectionHeader, settingsGroup, settingsItem, settingsToggle, settingsInput, settingsButton)

type State = 
  { instanceName :: String
  , autoUpdate :: Boolean
  , debugMode :: Boolean
  , saved :: Boolean
  }

data Action 
  = UpdateInstanceName String
  | ToggleAutoUpdate
  | ToggleDebugMode
  | SaveChanges

settingsPage :: forall q i o m. H.Component q i o m
settingsPage = H.mkComponent
  { initialState: const 
      { instanceName: "primary-boost-instance"
      , autoUpdate: true
      , debugMode: false
      , saved: false
      }
  , render
  , eval: H.mkEval H.defaultEval
      { handleAction = handleAction
      }
  }

handleAction :: forall o m. Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
  UpdateInstanceName name -> do
    H.modify_ _ { instanceName = name, saved = false }
  
  ToggleAutoUpdate -> do
    H.modify_ \s -> s { autoUpdate = not s.autoUpdate, saved = false }
    handleAction SaveChanges
  
  ToggleDebugMode -> do
    H.modify_ \s -> s { debugMode = not s.debugMode, saved = false }
    handleAction SaveChanges

  SaveChanges -> do
    -- Simulation
    H.modify_ _ { saved = true }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ sectionHeader "omega//boost // settings"
    , HH.div [ cls [ "max-w-4xl" ] ]
        [ settingsGroup "General Settings"
            [ settingsItem "Instance Name" "Unique identifier for this boost instance" 
                (settingsInput state.instanceName "primary-boost-instance" UpdateInstanceName)
            , settingsItem "Auto-update" "Automatically apply performance patches" 
                (settingsToggle state.autoUpdate ToggleAutoUpdate)
            , settingsItem "Debug Mode" "Enable verbose logging for inference calls" 
                (settingsToggle state.debugMode ToggleDebugMode)
            ]
        , HH.div [ cls [ "flex items-center gap-4" ] ]
            [ settingsButton "Save Changes" SaveChanges
            , if state.saved 
                then HH.span [ cls [ "text-status text-xs animate-pulse" ] ] [ HH.text "Changes saved successfully" ]
                else HH.text ""
            ]
        ]
    ]
