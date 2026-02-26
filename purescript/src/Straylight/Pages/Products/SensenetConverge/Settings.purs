-- | sensenet//converge Settings Page
module Straylight.Pages.Products.SensenetConverge.Settings where

import Prelude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Straylight.UI (cls, sectionHeader, settingsGroup, settingsItem, settingsToggle, settingsInput, settingsButton)

type State = 
  { defaultRegion :: String
  , autoConverge :: Boolean
  , driftDetection :: Boolean
  , saved :: Boolean
  }

data Action 
  = UpdateDefaultRegion String
  | ToggleAutoConverge
  | ToggleDriftDetection
  | SaveChanges

settingsPage :: forall q i o m. H.Component q i o m
settingsPage = H.mkComponent
  { initialState: const 
      { defaultRegion: "us-east-1"
      , autoConverge: true
      , driftDetection: true
      , saved: false
      }
  , render
  , eval: H.mkEval H.defaultEval
      { handleAction = handleAction
      }
  }

handleAction :: forall o m. Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
  UpdateDefaultRegion region -> do
    H.modify_ _ { defaultRegion = region, saved = false }
  
  ToggleAutoConverge -> do
    H.modify_ \s -> s { autoConverge = not s.autoConverge, saved = false }
    handleAction SaveChanges
  
  ToggleDriftDetection -> do
    H.modify_ \s -> s { driftDetection = not s.driftDetection, saved = false }
    handleAction SaveChanges

  SaveChanges -> do
    H.modify_ _ { saved = true }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ sectionHeader "sensenet//converge // settings"
    , HH.div [ cls [ "max-w-4xl" ] ]
        [ settingsGroup "Cluster Defaults"
            [ settingsItem "Default Region" "Primary region for new cluster provisioning" 
                (settingsInput state.defaultRegion "us-east-1" UpdateDefaultRegion)
            , settingsItem "Auto-converge" "Automatically reconcile state when drift is detected" 
                (settingsToggle state.autoConverge ToggleAutoConverge)
            , settingsItem "Drift Detection" "Monitor clusters for configuration drift" 
                (settingsToggle state.driftDetection ToggleDriftDetection)
            ]
        , HH.div [ cls [ "flex items-center gap-4" ] ]
            [ settingsButton "Save Changes" SaveChanges
            , if state.saved 
                then HH.span [ cls [ "text-status text-xs animate-pulse" ] ] [ HH.text "Changes saved successfully" ]
                else HH.text ""
            ]
        ]
    ]
