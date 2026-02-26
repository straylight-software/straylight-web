-- | sensenet//forge Settings Page
module Straylight.Pages.Products.SensenetForge.Settings where

import Prelude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Straylight.UI (cls, sectionHeader, settingsGroup, settingsItem, settingsToggle, settingsInput, settingsButton)

type State = 
  { templateRepo :: String
  , autoTag :: Boolean
  , strictValidation :: Boolean
  , saved :: Boolean
  }

data Action 
  = UpdateTemplateRepo String
  | ToggleAutoTag
  | ToggleStrictValidation
  | SaveChanges

settingsPage :: forall q i o m. H.Component q i o m
settingsPage = H.mkComponent
  { initialState: const 
      { templateRepo: "github:straylight/templates"
      , autoTag: true
      , strictValidation: false
      , saved: false
      }
  , render
  , eval: H.mkEval H.defaultEval
      { handleAction = handleAction
      }
  }

handleAction :: forall o m. Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
  UpdateTemplateRepo repo -> do
    H.modify_ _ { templateRepo = repo, saved = false }
  
  ToggleAutoTag -> do
    H.modify_ \s -> s { autoTag = not s.autoTag, saved = false }
    handleAction SaveChanges
  
  ToggleStrictValidation -> do
    H.modify_ \s -> s { strictValidation = not s.strictValidation, saved = false }
    handleAction SaveChanges

  SaveChanges -> do
    H.modify_ _ { saved = true }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ sectionHeader "sensenet//forge // settings"
    , HH.div [ cls [ "max-w-4xl" ] ]
        [ settingsGroup "Template Management"
            [ settingsItem "Template Repository" "Nix flake reference for base templates" 
                (settingsInput state.templateRepo "github:straylight/templates" UpdateTemplateRepo)
            , settingsItem "Auto-tag Versions" "Automatically tag new template releases" 
                (settingsToggle state.autoTag ToggleAutoTag)
            , settingsItem "Strict Validation" "Enforce schema validation on template creation" 
                (settingsToggle state.strictValidation ToggleStrictValidation)
            ]
        , HH.div [ cls [ "flex items-center gap-4" ] ]
            [ settingsButton "Save Changes" SaveChanges
            , if state.saved 
                then HH.span [ cls [ "text-status text-xs animate-pulse" ] ] [ HH.text "Changes saved successfully" ]
                else HH.text ""
            ]
        ]
    ]
