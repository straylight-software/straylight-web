-- | omega//code Settings Page
-- | Account settings, billing, team management
module Straylight.Pages.Products.OmegaCode.Settings where

import Prelude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

import Straylight.UI (cls)

-- ============================================================
-- TYPES
-- ============================================================

type State =
  { activeTab :: String
  }

data Action
  = SetTab String

-- ============================================================
-- COMPONENT
-- ============================================================

settingsPage :: forall q i o m. H.Component q i o m
settingsPage = H.mkComponent
  { initialState: const { activeTab: "account" }
  , render
  , eval: H.mkEval H.defaultEval
      { handleAction = handleAction
      }
  }

handleAction :: forall o m. Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
  SetTab tab -> H.modify_ _ { activeTab = tab }

-- ============================================================
-- RENDER
-- ============================================================

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div
    [ cls [ "max-w-[1100px] mx-auto px-6 py-8" ] ]
    [ headerSection
    , HH.div
        [ cls [ "grid grid-cols-1 lg:grid-cols-[200px_1fr] gap-8" ] ]
        [ sidebar state
        , content state
        ]
    ]

headerSection :: forall w i. HH.HTML w i
headerSection =
  HH.div
    [ cls [ "mb-8" ] ]
    [ HH.h1
        [ cls [ "text-2xl font-bold text-text" ] ]
        [ HH.text "Settings" ]
    ]

sidebar :: forall m. State -> H.ComponentHTML Action () m
sidebar state =
  HH.nav
    [ cls [ "space-y-1" ] ]
    [ sidebarLink state "account" "Account"
    , sidebarLink state "billing" "Billing"
    , sidebarLink state "team" "Team"
    , sidebarLink state "security" "Security"
    ]

sidebarLink :: forall m. State -> String -> String -> H.ComponentHTML Action () m
sidebarLink state value label =
  HH.button
    [ cls [ "block w-full text-left px-3 py-2 rounded text-sm transition-colors cursor-pointer"
          , if state.activeTab == value
              then "bg-blue-300/10 text-blue-300 font-medium"
              else "text-muted-foreground hover:text-text hover:bg-card"
          ]
    , HP.type_ HP.ButtonButton
    , HE.onClick \_ -> SetTab value
    ]
    [ HH.text label ]

content :: forall m. State -> H.ComponentHTML Action () m
content state = case state.activeTab of
  "account" -> accountTab
  "billing" -> billingTab
  "team" -> teamTab
  "security" -> securityTab
  _ -> accountTab

-- ============================================================
-- ACCOUNT TAB
-- ============================================================

accountTab :: forall w i. HH.HTML w i
accountTab =
  HH.div
    [ cls [ "space-y-6" ] ]
    [ -- Profile section
      HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.h3 [ cls [ "text-lg font-semibold text-text mb-4" ] ] [ HH.text "Profile" ]
        , HH.div
            [ cls [ "flex items-center gap-4 mb-4" ] ]
            [ HH.div
                [ cls [ "w-16 h-16 rounded-full bg-blue-300/20 flex items-center justify-center" ] ]
                [ HH.span [ cls [ "text-blue-300 text-2xl font-bold" ] ] [ HH.text "U" ] ]
            , HH.div_
                [ HH.p [ cls [ "text-text font-medium" ] ] 
                    [ HH.text "User" ]
                , HH.p [ cls [ "text-sm text-muted-foreground" ] ] 
                    [ HH.text "user@example.com" ]
                ]
            ]
        , HH.button
            [ cls [ "px-4 py-2 border border-border text-text text-sm font-medium rounded-md hover:bg-card transition-colors cursor-pointer" ]
            , HP.type_ HP.ButtonButton
            ]
            [ HH.text "Edit Profile" ]
        ]
    
      -- API Key section
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.h3 [ cls [ "text-lg font-semibold text-text mb-4" ] ] [ HH.text "API Key" ]
        , HH.p [ cls [ "text-sm text-muted-foreground mb-4" ] ] 
            [ HH.text "Your API key for programmatic access to omega//code." ]
        , HH.div
            [ cls [ "flex items-center gap-3" ] ]
            [ HH.code
                [ cls [ "flex-1 bg-background border border-border rounded px-3 py-2 text-sm font-mono text-muted-foreground" ] ]
                [ HH.text "omega_key_•••••••••••••••••••" ]
            , HH.button
                [ cls [ "px-4 py-2 border border-border text-text text-sm font-medium rounded-md hover:bg-card transition-colors cursor-pointer" ]
                , HP.type_ HP.ButtonButton
                ]
                [ HH.text "Regenerate" ]
            ]
        ]
    
      -- Danger zone
    , HH.div
        [ cls [ "bg-card border border-red-500/30 rounded-lg p-6" ] ]
        [ HH.h3 [ cls [ "text-lg font-semibold text-red-400 mb-4" ] ] [ HH.text "Danger Zone" ]
        , HH.p [ cls [ "text-sm text-muted-foreground mb-4" ] ] 
            [ HH.text "Once you delete your account, there is no going back. Please be certain." ]
        , HH.button
            [ cls [ "px-4 py-2 border border-red-500 text-red-400 text-sm font-medium rounded-md hover:bg-red-500/10 transition-colors cursor-pointer" ]
            , HP.type_ HP.ButtonButton
            ]
            [ HH.text "Delete Account" ]
        ]
    ]

-- ============================================================
-- BILLING TAB
-- ============================================================

billingTab :: forall w i. HH.HTML w i
billingTab =
  HH.div
    [ cls [ "space-y-6" ] ]
    [ -- Current plan
      HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.div
            [ cls [ "flex items-center justify-between mb-4" ] ]
            [ HH.h3 [ cls [ "text-lg font-semibold text-text" ] ] [ HH.text "Current Plan" ]
            , HH.button
                [ cls [ "text-sm text-blue-300 hover:text-blue-300/80 cursor-pointer" ]
                , HP.type_ HP.ButtonButton
                ]
                [ HH.text "Manage Billing" ]
            ]
        , HH.div
            [ cls [ "inline-flex items-center gap-2 mb-4" ] ]
            [ HH.span [ cls [ "text-2xl font-bold text-text" ] ] [ HH.text "Pro" ]
            , HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text "$49/mo" ]
            ]
        , HH.div
            [ cls [ "grid grid-cols-2 md:grid-cols-4 gap-4" ] ]
            [ planStat "Agents" "10 concurrent"
            , planStat "Requests" "Unlimited"
            , planStat "Crew Mode" "Enabled"
            , planStat "Support" "Priority"
            ]
        ]
    
      -- Upgrade options
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.h3 [ cls [ "text-lg font-semibold text-text mb-4" ] ] [ HH.text "Upgrade" ]
        , HH.div
            [ cls [ "grid grid-cols-1 md:grid-cols-2 gap-4" ] ]
            [ upgradePlanCard "Team" "$199/mo" "Unlimited agents, team workspaces, SSO" false
            , upgradePlanCard "Enterprise" "Custom" "Air-gapped, custom integrations, SLA" true
            ]
        ]
    
      -- Billing history
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.h3 [ cls [ "text-lg font-semibold text-text mb-4" ] ] [ HH.text "Billing History" ]
        , HH.div
            [ cls [ "space-y-3" ] ]
            [ billingRow "Feb 1, 2026" "Pro Plan" "$49.00" "Paid"
            , billingRow "Jan 1, 2026" "Pro Plan" "$49.00" "Paid"
            , billingRow "Dec 1, 2025" "Pro Plan" "$49.00" "Paid"
            ]
        ]
    ]

planStat :: forall w i. String -> String -> HH.HTML w i
planStat label value =
  HH.div_
    [ HH.p [ cls [ "text-xs text-muted-foreground" ] ] [ HH.text label ]
    , HH.p [ cls [ "text-sm text-text font-medium" ] ] [ HH.text value ]
    ]

upgradePlanCard :: forall w i. String -> String -> String -> Boolean -> HH.HTML w i
upgradePlanCard name price description isContact =
  HH.div
    [ cls [ "border border-border rounded-lg p-4" ] ]
    [ HH.h4 [ cls [ "font-semibold text-text mb-1" ] ] [ HH.text name ]
    , HH.p [ cls [ "text-sm text-muted-foreground mb-3" ] ] [ HH.text price ]
    , HH.p [ cls [ "text-sm text-muted-foreground mb-4" ] ] [ HH.text description ]
    , HH.button
        [ cls [ "w-full py-2 text-sm font-medium rounded transition-colors cursor-pointer"
              , if isContact
                  then "border border-border text-text hover:bg-card"
                  else "bg-blue-300 text-background hover:bg-blue-300/90"
              ]
        , HP.type_ HP.ButtonButton
        ]
        [ HH.text $ if isContact then "Contact Sales" else "Upgrade" ]
    ]

billingRow :: forall w i. String -> String -> String -> String -> HH.HTML w i
billingRow date description amount status =
  HH.div
    [ cls [ "flex items-center justify-between py-2 border-b border-border last:border-0" ] ]
    [ HH.div_
        [ HH.p [ cls [ "text-sm text-text" ] ] [ HH.text description ]
        , HH.p [ cls [ "text-xs text-muted-foreground" ] ] [ HH.text date ]
        ]
    , HH.div
        [ cls [ "text-right" ] ]
        [ HH.p [ cls [ "text-sm text-text" ] ] [ HH.text amount ]
        , HH.span
            [ cls [ "text-xs px-2 py-0.5 rounded bg-green-500/20 text-green-400" ] ]
            [ HH.text status ]
        ]
    ]

-- ============================================================
-- TEAM TAB
-- ============================================================

teamTab :: forall w i. HH.HTML w i
teamTab =
  HH.div
    [ cls [ "space-y-6" ] ]
    [ HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.div
            [ cls [ "flex items-center justify-between mb-4" ] ]
            [ HH.h3 [ cls [ "text-lg font-semibold text-text" ] ] [ HH.text "Team Members" ]
            , HH.button
                [ cls [ "px-4 py-2 bg-blue-300 text-background text-sm font-medium rounded-md hover:bg-blue-300/90 transition-colors cursor-pointer" ]
                , HP.type_ HP.ButtonButton
                ]
                [ HH.text "+ Invite Member" ]
            ]
        , HH.div
            [ cls [ "space-y-3" ] ]
            [ teamMemberRow "You" "you@example.com" "Owner"
            ]
        , HH.p
            [ cls [ "text-sm text-muted-foreground mt-4" ] ]
            [ HH.text "Upgrade to Team plan for additional seats and team workspaces." ]
        ]
    ]

teamMemberRow :: forall w i. String -> String -> String -> HH.HTML w i
teamMemberRow name email role =
  HH.div
    [ cls [ "flex items-center justify-between py-3 border-b border-border last:border-0" ] ]
    [ HH.div
        [ cls [ "flex items-center gap-3" ] ]
        [ HH.div
            [ cls [ "w-8 h-8 rounded-full bg-blue-300/20 flex items-center justify-center" ] ]
            [ HH.span [ cls [ "text-blue-300 text-sm font-medium" ] ] [ HH.text "U" ] ]
        , HH.div_
            [ HH.p [ cls [ "text-sm text-text font-medium" ] ] [ HH.text name ]
            , HH.p [ cls [ "text-xs text-muted-foreground" ] ] [ HH.text email ]
            ]
        ]
    , HH.span
        [ cls [ "text-xs px-2 py-1 rounded bg-muted text-muted-foreground" ] ]
        [ HH.text role ]
    ]

-- ============================================================
-- SECURITY TAB
-- ============================================================

securityTab :: forall w i. HH.HTML w i
securityTab =
  HH.div
    [ cls [ "space-y-6" ] ]
    [ HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.h3 [ cls [ "text-lg font-semibold text-text mb-4" ] ] [ HH.text "Two-Factor Authentication" ]
        , HH.p [ cls [ "text-sm text-muted-foreground mb-4" ] ] 
            [ HH.text "Add an extra layer of security to your account." ]
        , HH.button
            [ cls [ "px-4 py-2 border border-border text-text text-sm font-medium rounded-md hover:bg-card transition-colors cursor-pointer" ]
            , HP.type_ HP.ButtonButton
            ]
            [ HH.text "Enable 2FA" ]
        ]
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.h3 [ cls [ "text-lg font-semibold text-text mb-4" ] ] [ HH.text "Active Sessions" ]
        , HH.p [ cls [ "text-sm text-muted-foreground mb-4" ] ] 
            [ HH.text "Manage your active sessions across devices." ]
        , HH.div
            [ cls [ "space-y-3 mb-4" ] ]
            [ sessionRow "Current session" "Linux • Chrome" "Active now"
            , sessionRow "MacBook Pro" "macOS • Safari" "2 hours ago"
            ]
        , HH.button
            [ cls [ "px-4 py-2 border border-border text-text text-sm font-medium rounded-md hover:bg-card transition-colors cursor-pointer" ]
            , HP.type_ HP.ButtonButton
            ]
            [ HH.text "Sign out all other sessions" ]
        ]
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.h3 [ cls [ "text-lg font-semibold text-text mb-4" ] ] [ HH.text "Attestation Keys" ]
        , HH.p [ cls [ "text-sm text-muted-foreground mb-4" ] ] 
            [ HH.text "Post-quantum keys used for change attestation." ]
        , HH.div
            [ cls [ "space-y-3" ] ]
            [ keyRow "ML-DSA (Primary)" "0x8f3a2b..." "Active"
            , keyRow "Ed25519 (Fallback)" "0x7c1d4e..." "Active"
            ]
        ]
    ]

sessionRow :: forall w i. String -> String -> String -> HH.HTML w i
sessionRow name device time =
  HH.div
    [ cls [ "flex items-center justify-between py-2 border-b border-border last:border-0" ] ]
    [ HH.div_
        [ HH.p [ cls [ "text-sm text-text" ] ] [ HH.text name ]
        , HH.p [ cls [ "text-xs text-muted-foreground" ] ] [ HH.text device ]
        ]
    , HH.span [ cls [ "text-xs text-muted-foreground" ] ] [ HH.text time ]
    ]

keyRow :: forall w i. String -> String -> String -> HH.HTML w i
keyRow name fingerprint status =
  HH.div
    [ cls [ "flex items-center justify-between py-2 border-b border-border last:border-0" ] ]
    [ HH.div_
        [ HH.p [ cls [ "text-sm text-text" ] ] [ HH.text name ]
        , HH.code [ cls [ "text-xs text-muted-foreground font-mono" ] ] [ HH.text fingerprint ]
        ]
    , HH.span
        [ cls [ "text-xs px-2 py-0.5 rounded bg-green-500/20 text-green-400" ] ]
        [ HH.text status ]
    ]
