-- | sensenet//confirm Settings Page
module Straylight.Pages.Products.SensenetConfirm.Settings where

import Prelude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Straylight.UI (cls, sectionHeader, settingsGroup, settingsItem, settingsToggle, settingsInput, settingsButton)

type State = 
  { pipelinePrefix :: String
  , autoVerify :: Boolean
  , notifyOnFailure :: Boolean
  , saved :: Boolean
  }

data Action 
  = UpdatePipelinePrefix String
  | ToggleAutoVerify
  | ToggleNotifyOnFailure
  | SaveChanges

settingsPage :: forall q i o m. H.Component q i o m
settingsPage = H.mkComponent
  { initialState: const 
      { pipelinePrefix: "ci-confirm-"
      , autoVerify: true
      , notifyOnFailure: true
      , saved: false
      }
  , render
  , eval: H.mkEval H.defaultEval
      { handleAction = handleAction
      }
  }

handleAction :: forall o m. Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
  UpdatePipelinePrefix prefix -> do
    H.modify_ _ { pipelinePrefix = prefix, saved = false }
  
  ToggleAutoVerify -> do
    H.modify_ \s -> s { autoVerify = not s.autoVerify, saved = false }
    handleAction SaveChanges
  
  ToggleNotifyOnFailure -> do
    H.modify_ \s -> s { notifyOnFailure = not s.notifyOnFailure, saved = false }
    handleAction SaveChanges

  SaveChanges -> do
    H.modify_ _ { saved = true }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ sectionHeader "sensenet//confirm // settings"
    , HH.div [ cls [ "max-w-4xl" ] ]
        [ settingsGroup "Pipeline Verification"
            [ settingsItem "Pipeline Prefix" "Prefix for automatically discovered pipelines" 
                (settingsInput state.pipelinePrefix "ci-confirm-" UpdatePipelinePrefix)
            , settingsItem "Auto-verify" "Verify proofs automatically on pipeline completion" 
                (settingsToggle state.autoVerify ToggleAutoVerify)
            , settingsItem "Failure Notifications" "Send alerts when a proof fails verification" 
                (settingsToggle state.notifyOnFailure ToggleNotifyOnFailure)
            ]
        , HH.div [ cls [ "flex items-center gap-4" ] ]
            [ settingsButton "Save Changes" SaveChanges
            , if state.saved 
                then HH.span [ cls [ "text-status text-xs animate-pulse" ] ] [ HH.text "Changes saved successfully" ]
                else HH.text ""
            ]
        ]
    ]
