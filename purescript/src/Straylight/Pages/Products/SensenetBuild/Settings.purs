-- | sensenet//build Settings Page
module Straylight.Pages.Products.SensenetBuild.Settings where

import Prelude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Straylight.UI (cls, sectionHeader, settingsGroup, settingsItem, settingsToggle, settingsInput, settingsButton)

type State = 
  { concurrentBuilds :: String
  , useCache :: Boolean
  , notifyOnSuccess :: Boolean
  , saved :: Boolean
  }

data Action 
  = UpdateConcurrentBuilds String
  | ToggleUseCache
  | ToggleNotifyOnSuccess
  | SaveChanges

settingsPage :: forall q i o m. H.Component q i o m
settingsPage = H.mkComponent
  { initialState: const 
      { concurrentBuilds: "4"
      , useCache: true
      , notifyOnSuccess: false
      , saved: false
      }
  , render
  , eval: H.mkEval H.defaultEval
      { handleAction = handleAction
      }
  }

handleAction :: forall o m. Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
  UpdateConcurrentBuilds count -> do
    H.modify_ _ { concurrentBuilds = count, saved = false }
  
  ToggleUseCache -> do
    H.modify_ \s -> s { useCache = not s.useCache, saved = false }
    handleAction SaveChanges
  
  ToggleNotifyOnSuccess -> do
    H.modify_ \s -> s { notifyOnSuccess = not s.notifyOnSuccess, saved = false }
    handleAction SaveChanges

  SaveChanges -> do
    H.modify_ _ { saved = true }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ sectionHeader "sensenet//build // settings"
    , HH.div [ cls [ "max-w-4xl" ] ]
        [ settingsGroup "Build Execution"
            [ settingsItem "Concurrent Builds" "Maximum number of simultaneous builds" 
                (settingsInput state.concurrentBuilds "4" UpdateConcurrentBuilds)
            , settingsItem "Use Build Cache" "Cache intermediate build results to speed up builds" 
                (settingsToggle state.useCache ToggleUseCache)
            , settingsItem "Success Notifications" "Send alerts when a build completes successfully" 
                (settingsToggle state.notifyOnSuccess ToggleNotifyOnSuccess)
            ]
        , HH.div [ cls [ "flex items-center gap-4" ] ]
            [ settingsButton "Save Changes" SaveChanges
            , if state.saved 
                then HH.span [ cls [ "text-status text-xs animate-pulse" ] ] [ HH.text "Changes saved successfully" ]
                else HH.text ""
            ]
        ]
    ]
