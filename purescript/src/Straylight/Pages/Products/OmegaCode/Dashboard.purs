module Straylight.Pages.Products.OmegaCode.Dashboard where

import Prelude

import Data.Array (length, (..))
import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Straylight.UI (cls, sectionHeader, emptyDashboard, settingsButton, statusIndicator)

type AgentSession = 
  { id :: String
  , directory :: String
  , status :: String
  , model :: String
  , tokens :: Int
  }

type State = 
  { sessions :: Array AgentSession
  , loading :: Boolean
  }

data Action 
  = Initialize
  | StartNewSession
  | RefreshSessions

dashboardPage :: forall q i o m. H.Component q i o m
dashboardPage = H.mkComponent
  { initialState: const 
      { sessions: []
      , loading: false
      }
  , render
  , eval: H.mkEval H.defaultEval
      { handleAction = handleAction
      , initialize = Just Initialize
      }
  }

handleAction :: forall o m. Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
  Initialize -> do
    handleAction RefreshSessions
  
  RefreshSessions -> do
    H.modify_ _ { loading = true }
    -- Mock sessions
    let mockSessions = 
          [ { id: "a8f2-1234", directory: "/home/user/project-alpha", status: "idle", model: "claude-3-5", tokens: 1240 }
          , { id: "b2c1-5678", directory: "/home/user/straylight-web", status: "running", model: "gpt-4o", tokens: 8500 }
          ]
    H.modify_ _ { sessions = mockSessions, loading = false }
  
  StartNewSession -> do
    H.modify_ _ { loading = true }
    -- Simulation
    H.modify_ \s -> s { sessions = s.sessions <> [{ id: "new-session", directory: "/tmp/new", status: "initializing", model: "claude-3-5", tokens: 0 }], loading = false }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ sectionHeader "omega//code // dashboard"
    , if length state.sessions == 0 && not state.loading
        then emptyDashboard "omega//code" StartNewSession
        else HH.div_
            [ HH.div [ cls [ "flex justify-between items-center mb-6" ] ]
                [ HH.div_ [ statusIndicator "2 AGENTS ACTIVE" ]
                , settingsButton "new session" StartNewSession
                ]
            , HH.div [ cls [ "bg-card border border-border rounded-lg overflow-hidden" ] ]
                [ HH.table [ cls [ "w-full text-left text-xs" ] ]
                    [ HH.thead [ cls [ "bg-muted/30 border-b border-border text-[10px] uppercase tracking-widest text-muted-foreground" ] ]
                        [ HH.tr_
                            [ HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "session id" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "directory" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "model" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "tokens" ]
                            , HH.th [ cls [ "px-6 py-3 font-medium" ] ] [ HH.text "status" ]
                            ]
                        ]
                    , HH.tbody [ cls [ "divide-y divide-border" ] ]
                        (map renderSession state.sessions)
                    ]
                ]
            ]
    ]

renderSession :: forall w i. AgentSession -> HH.HTML w i
renderSession session =
  HH.tr [ cls [ "hover:bg-muted/5 transition-colors group cursor-pointer" ] ]
    [ HH.td [ cls [ "px-6 py-4 font-mono text-primary" ] ] [ HH.text session.id ]
    , HH.td [ cls [ "px-6 py-4 text-text" ] ] [ HH.text session.directory ]
    , HH.td [ cls [ "px-6 py-4 text-muted-foreground" ] ] [ HH.text session.model ]
    , HH.td [ cls [ "px-6 py-4 text-muted-foreground" ] ] [ HH.text $ show session.tokens ]
    , HH.td [ cls [ "px-6 py-4" ] ] 
        [ HH.span 
            [ cls [ "px-2 py-0.5 rounded text-[10px] uppercase tracking-tighter"
                  , if session.status == "running" then "bg-status/20 text-status" else "bg-muted text-muted-foreground"
                  ] 
            ] 
            [ HH.text session.status ]
        ]
    ]
