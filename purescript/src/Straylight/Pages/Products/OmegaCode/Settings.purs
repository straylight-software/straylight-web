-- | omega//code Settings Page
module Straylight.Pages.Products.OmegaCode.Settings where

import Prelude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Straylight.UI (cls, sectionHeader, settingsGroup, settingsItem, settingsToggle, settingsInput, settingsButton)

type State = 
  { autoSave :: Boolean
  , preferredModel :: String
  , agentName :: String
  , saved :: Boolean
  }

data Action 
  = Initialize
  | ToggleAutoSave
  | SetModel String
  | SetAgentName String
  | SaveChanges

settingsPage :: forall q i o m. H.Component q i o m
settingsPage = H.mkComponent
  { initialState: const 
      { autoSave: true
      , preferredModel: "claude-3-5-sonnet"
      , agentName: "straylight-agent-01"
      , saved: false
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
  
  ToggleAutoSave -> do
    H.modify_ \s -> s { autoSave = not s.autoSave, saved = false }
    handleAction SaveChanges
  
  SetModel model -> do
    H.modify_ _ { preferredModel = model, saved = false }
  
  SetAgentName name -> do
    H.modify_ _ { agentName = name, saved = false }
  
  SaveChanges -> do
    H.modify_ _ { saved = true }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ sectionHeader "omega//code // settings"
    , HH.div [ cls [ "max-w-4xl" ] ]
        [ settingsGroup "Agent Configuration"
            [ settingsItem "Agent Name" "Custom identifier for this instance" 
                (settingsInput state.agentName "agent-xyz" SetAgentName)
            , settingsItem "Preferred Model" "Default LLM for agent reasoning" 
                (settingsInput state.preferredModel "model-id" SetModel)
            , settingsItem "Auto-save" "Persist session state automatically" 
                (settingsToggle state.autoSave ToggleAutoSave)
            ]
        , HH.div [ cls [ "flex items-center gap-4 mt-6" ] ]
            [ settingsButton "Save Changes" SaveChanges
            , if state.saved 
                then HH.span [ cls [ "text-status text-xs animate-pulse" ] ] [ HH.text "Changes saved successfully" ]
                else HH.text ""
            ]
        ]
    ]
