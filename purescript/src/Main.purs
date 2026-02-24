-- | Straylight Web Entry Point
module Main where

import Prelude

import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Type.Proxy (Proxy(..))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (liftEffect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH

import Halogen.Subscription as HS
import Halogen.VDom.Driver (runUI)
import Web.DOM.ParentNode (QuerySelector(..), querySelector)
import Web.HTML (window)
import Web.HTML.HTMLDocument as HTMLDocument
import Web.HTML.HTMLElement as HTMLElement
import Web.HTML.Window (document)
import Web.Event.Event (preventDefault)
import Web.UIEvent.MouseEvent (MouseEvent, toEvent)

import Straylight.UI (cls, scanlineOverlay)
import Straylight.Router (Route(..), parseRoute, routeToPath, pushState, getPathname, onPopState)
import Straylight.Layout.Header as Header
import Straylight.Layout.Footer as Footer
-- Product pages
import Straylight.Pages.Home as Home
import Straylight.Pages.Products.OmegaCode as OmegaCode
import Straylight.Pages.Products.OmegaWork as OmegaWork
import Straylight.Pages.Products.OmegaProxy as OmegaProxy
import Straylight.Pages.Products.OmegaBoost as OmegaBoost
-- Team pages
import Straylight.Pages.Team.About as TeamAbout
import Straylight.Pages.Plan as Plan
import Straylight.Pages.Lean as Lean
import Straylight.Pages.Razorgirl as Razorgirl
import Straylight.Pages.Software as Software
-- Community
import Straylight.Pages.Irc as Irc
import Straylight.Pages.Discord as Discord

-- ============================================================
-- MAIN ENTRY
-- ============================================================

main :: Effect Unit
main = launchAff_ do
  HA.awaitLoad
  doc <- liftEffect $ window >>= document
  let parent = HTMLDocument.toParentNode doc
  mbContainer <- liftEffect $ querySelector (QuerySelector "#straylight-app") parent
  case mbContainer >>= HTMLElement.fromElement of
    Nothing -> pure unit
    Just container -> void $ runUI appComponent unit container

-- ============================================================
-- APP COMPONENT
-- ============================================================

type AppState = { route :: Route }

data AppAction
  = Initialize
  | Navigate Route MouseEvent
  | RouteChanged String

type AppSlots =
  ( header :: H.Slot (Const Void) Void Unit
  , footer :: H.Slot (Const Void) Void Unit
  -- Product pages
  , home :: H.Slot (Const Void) Void Unit
  , omegaCode :: H.Slot (Const Void) Void Unit
  , omegaWork :: H.Slot (Const Void) Void Unit
  , omegaProxy :: H.Slot (Const Void) Void Unit
  , omegaBoost :: H.Slot (Const Void) Void Unit
  -- Team pages
  , team :: H.Slot (Const Void) Void Unit
  , plan :: H.Slot (Const Void) Void Unit
  , lean :: H.Slot (Const Void) Void Unit
  , razorgirl :: H.Slot (Const Void) Void Unit
  , software :: H.Slot (Const Void) Void Unit
  -- Community
  , irc :: H.Slot (Const Void) Void Unit
  , discord :: H.Slot (Const Void) Void Unit
  )

_header :: Proxy "header"
_header = Proxy

_footer :: Proxy "footer"
_footer = Proxy

_home :: Proxy "home"
_home = Proxy

_omegaCode :: Proxy "omegaCode"
_omegaCode = Proxy

_omegaWork :: Proxy "omegaWork"
_omegaWork = Proxy

_omegaProxy :: Proxy "omegaProxy"
_omegaProxy = Proxy

_omegaBoost :: Proxy "omegaBoost"
_omegaBoost = Proxy

_team :: Proxy "team"
_team = Proxy

_plan :: Proxy "plan"
_plan = Proxy

_lean :: Proxy "lean"
_lean = Proxy

_razorgirl :: Proxy "razorgirl"
_razorgirl = Proxy

_software :: Proxy "software"
_software = Proxy

_irc :: Proxy "irc"
_irc = Proxy

_discord :: Proxy "discord"
_discord = Proxy

appComponent :: forall q i o m. MonadAff m => H.Component q i o m
appComponent = H.mkComponent
  { initialState: const { route: Home }
  , render
  , eval: H.mkEval H.defaultEval
      { handleAction = handleAction
      , initialize = Just Initialize
      }
  }

handleAction :: forall o m. MonadAff m => AppAction -> H.HalogenM AppState AppAction AppSlots o m Unit
handleAction = case _ of
  Initialize -> do
    -- Get initial route
    path <- liftEffect getPathname
    H.modify_ _ { route = parseRoute path }
    -- Subscribe to popstate
    { emitter, listener } <- liftEffect HS.create
    liftEffect $ onPopState (\p -> HS.notify listener (RouteChanged p))
    void $ H.subscribe emitter
  
  Navigate route event -> do
    liftEffect $ preventDefault (toEvent event)
    liftEffect $ pushState $ routeToPath route
    H.modify_ _ { route = route }
  
  RouteChanged path -> do
    H.modify_ _ { route = parseRoute path }

render :: forall m. MonadAff m => AppState -> H.ComponentHTML AppAction AppSlots m
render state =
  HH.div
    [ cls [ "min-h-screen bg-background text-muted-foreground text-[15px] leading-relaxed" ] ]
    [ scanlineOverlay
    , renderHeader state
    , HH.main
        [ cls [ mainMaxWidth state.route ] ]
        [ renderPage state.route ]
    , HH.slot_ _footer unit Footer.footer unit
    ]

-- | Product pages get wider container
mainMaxWidth :: Route -> String
mainMaxWidth = case _ of
  Home -> "max-w-[1100px] mx-auto px-8 py-12"
  OmegaCode -> "max-w-[1100px] mx-auto px-8 py-12"
  OmegaWork -> "max-w-[1100px] mx-auto px-8 py-12"
  OmegaProxy -> "max-w-[1100px] mx-auto px-8 py-12"
  OmegaBoost -> "max-w-[1100px] mx-auto px-8 py-12"
  _ -> "max-w-[900px] mx-auto px-8 py-12"

renderPage :: forall m. MonadAff m => Route -> H.ComponentHTML AppAction AppSlots m
renderPage = case _ of
  -- Product pages
  Home -> HH.slot_ _home unit Home.homePage unit
  OmegaCode -> HH.slot_ _omegaCode unit OmegaCode.omegaCodePage unit
  OmegaWork -> HH.slot_ _omegaWork unit OmegaWork.omegaWorkPage unit
  OmegaProxy -> HH.slot_ _omegaProxy unit OmegaProxy.omegaProxyPage unit
  OmegaBoost -> HH.slot_ _omegaBoost unit OmegaBoost.omegaBoostPage unit
  -- Team pages
  Team -> HH.slot_ _team unit TeamAbout.aboutPage unit
  Plan -> HH.slot_ _plan unit Plan.planPage unit
  Lean -> HH.slot_ _lean unit Lean.leanPage unit
  Razorgirl -> HH.slot_ _razorgirl unit Razorgirl.razorgirlPage unit
  Software -> HH.slot_ _software unit Software.softwarePage unit
  -- Community
  Irc -> HH.slot_ _irc unit Irc.ircPage unit
  Discord -> HH.slot_ _discord unit Discord.discordPage unit

comingSoon :: forall w i. String -> HH.HTML w i
comingSoon name =
  HH.div
    [ cls [ "py-24 text-center" ] ]
    [ HH.h1
        [ cls [ "text-2xl font-bold text-text mb-4" ] ]
        [ HH.text name ]
    , HH.p
        [ cls [ "text-muted-foreground" ] ]
        [ HH.text "Coming soon." ]
    ]

-- ============================================================
-- HEADER (inline for nav actions)
-- ============================================================

renderHeader :: forall m. MonadAff m => AppState -> H.ComponentHTML AppAction AppSlots m
renderHeader state =
  HH.slot_ _header unit Header.header 
    { currentPath: routeToPath state.route
    , themeLock: routeThemeLock state.route
    }

-- | Pages that lock the theme (ultraviolence mode)
routeThemeLock :: Route -> Maybe String
routeThemeLock = case _ of
  -- Villa Straylight papers lock to memphis black
  Plan -> Just "ono-memphis"
  Lean -> Just "ono-memphis"
  _ -> Nothing
