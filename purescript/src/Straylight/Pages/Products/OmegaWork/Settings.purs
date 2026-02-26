-- | omega//work Settings Page
module Straylight.Pages.Products.OmegaWork.Settings where

import Prelude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Straylight.UI (cls, sectionHeader, settingsGroup, settingsItem, settingsToggle, settingsInput, settingsButton)

type State = 
  { defaultWorkspaceName :: String
  , privateByDeault :: Boolean
  , enableCollaboration :: Boolean
  , saved :: Boolean
  }

data Action 
  = UpdateDefaultWorkspaceName String
  | TogglePrivateByDefault
  | ToggleEnableCollaboration
  | SaveChanges

settingsPage :: forall q i o m. H.Component q i o m
settingsPage = H.mkComponent
  { initialState: const 
      { defaultWorkspaceName: "new-workspace"
      , privateByDeault: true
      , enableCollaboration: true
      , saved: false
      }
  , render
  , eval: H.mkEval H.defaultEval
      { handleAction = handleAction
      }
  }

handleAction :: forall o m. Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
  UpdateDefaultWorkspaceName name -> do
    H.modify_ _ { defaultWorkspaceName = name, saved = false }
  
  TogglePrivateByDefault -> do
    H.modify_ \s -> s { privateByDeault = not s.privateByDeault, saved = false }
    handleAction SaveChanges
  
  ToggleEnableCollaboration -> do
    H.modify_ \s -> s { enableCollaboration = not s.enableCollaboration, saved = false }
    handleAction SaveChanges

  SaveChanges -> do
    H.modify_ _ { saved = true }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ sectionHeader "omega//work // settings"
    , HH.div [ cls [ "max-w-4xl" ] ]
        [ settingsGroup "Workspace Defaults"
            [ settingsItem "Default Name" "Name given to newly created workspaces" 
                (settingsInput state.defaultWorkspaceName "new-workspace" UpdateDefaultWorkspaceName)
            , settingsItem "Private by Default" "New workspaces are only visible to the creator" 
                (settingsToggle state.privateByDeault TogglePrivateByDefault)
            , settingsItem "Real-time Collaboration" "Enable multi-user editing in shared workspaces" 
                (settingsToggle state.enableCollaboration ToggleEnableCollaboration)
            ]
        , HH.div [ cls [ "flex items-center gap-4" ] ]
            [ settingsButton "Save Changes" SaveChanges
            , if state.saved 
                then HH.span [ cls [ "text-status text-xs animate-pulse" ] ] [ HH.text "Changes saved successfully" ]
                else HH.text ""
            ]
        ]
    ]
