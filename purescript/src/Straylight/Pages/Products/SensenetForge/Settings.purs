-- | sensenet//forge Settings Page
-- | Account settings, billing, team management
module Straylight.Pages.Products.SensenetForge.Settings where

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
  = SetActiveTab String

-- ============================================================
-- COMPONENT
-- ============================================================

settingsPage :: forall q i o m. H.Component q i o m
settingsPage = H.mkComponent
  { initialState: const initialState
  , render
  , eval: H.mkEval H.defaultEval
      { handleAction = handleAction
      }
  }

initialState :: State
initialState =
  { activeTab: "account"
  }

handleAction :: forall o m. Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
  SetActiveTab tab -> H.modify_ _ { activeTab = tab }

-- ============================================================
-- RENDER
-- ============================================================

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div
    [ cls [ "max-w-[1100px] mx-auto px-6 py-8" ] ]
    [ header
    , HH.div
        [ cls [ "grid grid-cols-1 lg:grid-cols-[200px_1fr] gap-8" ] ]
        [ sidebar state
        , content state
        ]
    ]

header :: forall w i. HH.HTML w i
header =
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
    [ sidebarButton "account" "Account" state.activeTab
    , sidebarButton "billing" "Billing" state.activeTab
    , sidebarButton "team" "Team" state.activeTab
    , sidebarButton "security" "Security" state.activeTab
    ]

sidebarButton :: forall m. String -> String -> String -> H.ComponentHTML Action () m
sidebarButton value label activeTab =
  HH.button
    [ cls [ "w-full text-left px-3 py-2 rounded text-sm transition-colors"
          , if value == activeTab 
              then "bg-violet-400/10 text-violet-400 font-medium" 
              else "text-muted-foreground hover:text-text hover:bg-card"
          ]
    , HP.type_ HP.ButtonButton
    , HE.onClick \_ -> SetActiveTab value
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
            [ cls [ "space-y-4" ] ]
            [ formField "Username" 
                (HH.input 
                    [ HP.type_ HP.InputText
                    , HP.value "alice"
                    , cls [ "w-full px-3 py-2 bg-background border border-border rounded-md text-text text-sm focus:outline-none focus:ring-2 focus:ring-violet-400" ]
                    ])
            , formField "Display Name" 
                (HH.input 
                    [ HP.type_ HP.InputText
                    , HP.value "Alice Chen"
                    , cls [ "w-full px-3 py-2 bg-background border border-border rounded-md text-text text-sm focus:outline-none focus:ring-2 focus:ring-violet-400" ]
                    ])
            , formField "Email" 
                (HH.input 
                    [ HP.type_ HP.InputEmail
                    , HP.value "alice@example.com"
                    , HP.disabled true
                    , cls [ "w-full px-3 py-2 bg-background border border-border rounded-md text-muted-foreground text-sm" ]
                    ])
            ]
        , HH.div
            [ cls [ "mt-4" ] ]
            [ HH.button
                [ cls [ "px-4 py-2 bg-violet-400 text-background text-sm font-medium rounded-md hover:bg-violet-400/90 transition-colors cursor-pointer" ]
                , HP.type_ HP.ButtonButton
                ]
                [ HH.text "Save Changes" ]
            ]
        ]
    
      -- SSH Keys
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.div
            [ cls [ "flex items-center justify-between mb-4" ] ]
            [ HH.h3 [ cls [ "text-lg font-semibold text-text" ] ] [ HH.text "SSH Keys" ]
            , HH.button
                [ cls [ "px-3 py-1.5 bg-violet-400 text-background text-sm font-medium rounded-md hover:bg-violet-400/90 transition-colors cursor-pointer" ]
                , HP.type_ HP.ButtonButton
                ]
                [ HH.text "+ Add Key" ]
            ]
        , HH.div
            [ cls [ "space-y-2" ] ]
            [ sshKeyRow "MacBook Pro" "SHA256:abc123..." "Added Feb 10, 2026"
            , sshKeyRow "Work Desktop" "SHA256:def456..." "Added Jan 5, 2026"
            ]
        ]
    
      -- Danger zone
    , HH.div
        [ cls [ "bg-card border border-red-500/30 rounded-lg p-6" ] ]
        [ HH.h3 [ cls [ "text-lg font-semibold text-red-400 mb-4" ] ] [ HH.text "Danger Zone" ]
        , HH.p [ cls [ "text-sm text-muted-foreground mb-4" ] ] 
            [ HH.text "Once you delete your account, all your repositories and diffs will be permanently deleted." ]
        , HH.button
            [ cls [ "px-4 py-2 border border-red-500 text-red-400 text-sm font-medium rounded-md hover:bg-red-500/10 transition-colors cursor-pointer" ]
            , HP.type_ HP.ButtonButton
            ]
            [ HH.text "Delete Account" ]
        ]
    ]

formField :: forall w i. String -> HH.HTML w i -> HH.HTML w i
formField label input =
  HH.div_
    [ HH.label [ cls [ "block text-sm font-medium text-text mb-1" ] ] [ HH.text label ]
    , input
    ]

sshKeyRow :: forall w i. String -> String -> String -> HH.HTML w i
sshKeyRow name fingerprint added =
  HH.div
    [ cls [ "flex items-center justify-between py-2 border-b border-border last:border-0" ] ]
    [ HH.div_
        [ HH.p [ cls [ "text-sm text-text font-medium" ] ] [ HH.text name ]
        , HH.p [ cls [ "text-xs text-muted-foreground font-mono" ] ] [ HH.text fingerprint ]
        ]
    , HH.div
        [ cls [ "flex items-center gap-4" ] ]
        [ HH.span [ cls [ "text-xs text-muted-foreground" ] ] [ HH.text added ]
        , HH.button
            [ cls [ "text-sm text-red-400 hover:text-red-400/80 cursor-pointer" ]
            , HP.type_ HP.ButtonButton
            ]
            [ HH.text "Remove" ]
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
            , HH.a
                [ HP.href "/sensenet/forge/pricing"
                , cls [ "text-sm text-violet-400 hover:text-violet-400/80" ]
                ]
                [ HH.text "Change plan" ]
            ]
        , HH.div
            [ cls [ "flex items-center gap-4 mb-4" ] ]
            [ HH.span [ cls [ "text-2xl font-bold text-text" ] ] [ HH.text "Pro" ]
            , HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text "$15/user/month" ]
            ]
        , HH.div
            [ cls [ "grid grid-cols-2 md:grid-cols-4 gap-4" ] ]
            [ planDetail "Private Repos" "Unlimited"
            , planDetail "Collaborators" "Unlimited"
            , planDetail "Attestation" "Included"
            , planDetail "Support" "Email"
            ]
        ]
    
      -- Usage
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.h3 [ cls [ "text-lg font-semibold text-text mb-4" ] ] [ HH.text "Usage This Month" ]
        , HH.div
            [ cls [ "grid grid-cols-2 md:grid-cols-4 gap-4" ] ]
            [ usageStat "Diffs Created" "127"
            , usageStat "Stacks Landed" "42"
            , usageStat "Reviews Completed" "89"
            , usageStat "Search Queries" "1.2k"
            ]
        ]
    
      -- Payment method
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.h3 [ cls [ "text-lg font-semibold text-text mb-4" ] ] [ HH.text "Payment Method" ]
        , HH.div
            [ cls [ "flex items-center justify-between p-3 border border-border rounded-md" ] ]
            [ HH.div
                [ cls [ "flex items-center gap-3" ] ]
                [ HH.span [ cls [ "text-text" ] ] [ HH.text "Visa ending in 4242" ]
                , HH.span [ cls [ "text-xs text-muted-foreground" ] ] [ HH.text "Expires 12/26" ]
                ]
            , HH.button
                [ cls [ "text-sm text-violet-400 hover:text-violet-400/80 cursor-pointer" ]
                , HP.type_ HP.ButtonButton
                ]
                [ HH.text "Update" ]
            ]
        ]
    
      -- Billing history
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.h3 [ cls [ "text-lg font-semibold text-text mb-4" ] ] [ HH.text "Billing History" ]
        , HH.div
            [ cls [ "space-y-2" ] ]
            [ invoiceRow "Feb 1, 2026" "$45.00" "Paid"
            , invoiceRow "Jan 1, 2026" "$45.00" "Paid"
            , invoiceRow "Dec 1, 2025" "$30.00" "Paid"
            ]
        ]
    ]

planDetail :: forall w i. String -> String -> HH.HTML w i
planDetail label value =
  HH.div_
    [ HH.p [ cls [ "text-xs text-muted-foreground" ] ] [ HH.text label ]
    , HH.p [ cls [ "text-sm text-text font-medium" ] ] [ HH.text value ]
    ]

usageStat :: forall w i. String -> String -> HH.HTML w i
usageStat label value =
  HH.div_
    [ HH.p [ cls [ "text-xs text-muted-foreground" ] ] [ HH.text label ]
    , HH.p [ cls [ "text-xl font-bold text-violet-400" ] ] [ HH.text value ]
    ]

invoiceRow :: forall w i. String -> String -> String -> HH.HTML w i
invoiceRow date amount status =
  HH.div
    [ cls [ "flex items-center justify-between py-2 border-b border-border last:border-0" ] ]
    [ HH.span [ cls [ "text-sm text-muted-foreground" ] ] [ HH.text date ]
    , HH.span [ cls [ "text-sm text-text" ] ] [ HH.text amount ]
    , HH.span [ cls [ "text-xs px-2 py-0.5 rounded bg-green-500/10 text-green-400" ] ] [ HH.text status ]
    ]

-- ============================================================
-- TEAM TAB
-- ============================================================

teamTab :: forall w i. HH.HTML w i
teamTab =
  HH.div
    [ cls [ "space-y-6" ] ]
    [ -- Team members
      HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.div
            [ cls [ "flex items-center justify-between mb-4" ] ]
            [ HH.h3 [ cls [ "text-lg font-semibold text-text" ] ] [ HH.text "Team Members" ]
            , HH.button
                [ cls [ "px-3 py-1.5 bg-violet-400 text-background text-sm font-medium rounded-md hover:bg-violet-400/90 transition-colors cursor-pointer" ]
                , HP.type_ HP.ButtonButton
                ]
                [ HH.text "+ Invite Member" ]
            ]
        , HH.div
            [ cls [ "space-y-2" ] ]
            [ teamMemberRow "Alice Chen" "alice@example.com" "Owner"
            , teamMemberRow "Bob Wilson" "bob@example.com" "Admin"
            , teamMemberRow "Carol Davis" "carol@example.com" "Member"
            ]
        ]
    
      -- Pending invites
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.h3 [ cls [ "text-lg font-semibold text-text mb-4" ] ] [ HH.text "Pending Invites" ]
        , HH.div
            [ cls [ "space-y-2" ] ]
            [ pendingInviteRow "dave@example.com" "Sent 2 days ago"
            ]
        ]
    
      -- Organization settings
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.h3 [ cls [ "text-lg font-semibold text-text mb-4" ] ] [ HH.text "Organization" ]
        , HH.div
            [ cls [ "space-y-4" ] ]
            [ formField "Organization Name" 
                (HH.input 
                    [ HP.type_ HP.InputText
                    , HP.value "straylight"
                    , cls [ "w-full px-3 py-2 bg-background border border-border rounded-md text-text text-sm focus:outline-none focus:ring-2 focus:ring-violet-400" ]
                    ])
            , formField "Organization URL" 
                (HH.input 
                    [ HP.type_ HP.InputText
                    , HP.value "forge.sensenet.dev/straylight"
                    , HP.disabled true
                    , cls [ "w-full px-3 py-2 bg-background border border-border rounded-md text-muted-foreground text-sm" ]
                    ])
            ]
        , HH.div
            [ cls [ "mt-4" ] ]
            [ HH.button
                [ cls [ "px-4 py-2 bg-violet-400 text-background text-sm font-medium rounded-md hover:bg-violet-400/90 transition-colors cursor-pointer" ]
                , HP.type_ HP.ButtonButton
                ]
                [ HH.text "Save Changes" ]
            ]
        ]
    ]

teamMemberRow :: forall w i. String -> String -> String -> HH.HTML w i
teamMemberRow name email role =
  HH.div
    [ cls [ "flex items-center justify-between py-2 border-b border-border last:border-0" ] ]
    [ HH.div_
        [ HH.p [ cls [ "text-sm text-text font-medium" ] ] [ HH.text name ]
        , HH.p [ cls [ "text-xs text-muted-foreground" ] ] [ HH.text email ]
        ]
    , HH.div
        [ cls [ "flex items-center gap-4" ] ]
        [ HH.span [ cls [ "text-xs px-2 py-0.5 rounded bg-muted text-muted-foreground" ] ] [ HH.text role ]
        , if role /= "Owner"
            then HH.button
                [ cls [ "text-sm text-muted-foreground hover:text-text cursor-pointer" ]
                , HP.type_ HP.ButtonButton
                ]
                [ HH.text "Edit" ]
            else HH.text ""
        ]
    ]

pendingInviteRow :: forall w i. String -> String -> HH.HTML w i
pendingInviteRow email sentTime =
  HH.div
    [ cls [ "flex items-center justify-between py-2 border-b border-border last:border-0" ] ]
    [ HH.div_
        [ HH.p [ cls [ "text-sm text-text" ] ] [ HH.text email ]
        , HH.p [ cls [ "text-xs text-muted-foreground" ] ] [ HH.text sentTime ]
        ]
    , HH.div
        [ cls [ "flex items-center gap-2" ] ]
        [ HH.button
            [ cls [ "text-sm text-violet-400 hover:text-violet-400/80 cursor-pointer" ]
            , HP.type_ HP.ButtonButton
            ]
            [ HH.text "Resend" ]
        , HH.button
            [ cls [ "text-sm text-red-400 hover:text-red-400/80 cursor-pointer" ]
            , HP.type_ HP.ButtonButton
            ]
            [ HH.text "Revoke" ]
        ]
    ]

-- ============================================================
-- SECURITY TAB
-- ============================================================

securityTab :: forall w i. HH.HTML w i
securityTab =
  HH.div
    [ cls [ "space-y-6" ] ]
    [ -- Two-factor auth
      HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.h3 [ cls [ "text-lg font-semibold text-text mb-4" ] ] [ HH.text "Two-Factor Authentication" ]
        , HH.p [ cls [ "text-sm text-muted-foreground mb-4" ] ] 
            [ HH.text "Add an extra layer of security to your account." ]
        , HH.div
            [ cls [ "flex items-center gap-4" ] ]
            [ HH.span [ cls [ "text-sm text-green-400" ] ] [ HH.text "Enabled" ]
            , HH.button
                [ cls [ "px-4 py-2 border border-border text-text text-sm font-medium rounded-md hover:bg-card transition-colors cursor-pointer" ]
                , HP.type_ HP.ButtonButton
                ]
                [ HH.text "Manage" ]
            ]
        ]
    
      -- Signing keys
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.div
            [ cls [ "flex items-center justify-between mb-4" ] ]
            [ HH.h3 [ cls [ "text-lg font-semibold text-text" ] ] [ HH.text "Signing Keys" ]
            , HH.button
                [ cls [ "px-3 py-1.5 bg-violet-400 text-background text-sm font-medium rounded-md hover:bg-violet-400/90 transition-colors cursor-pointer" ]
                , HP.type_ HP.ButtonButton
                ]
                [ HH.text "+ Generate Key" ]
            ]
        , HH.p [ cls [ "text-sm text-muted-foreground mb-4" ] ] 
            [ HH.text "Keys used to sign your commits and diffs for attestation." ]
        , HH.div
            [ cls [ "space-y-2" ] ]
            [ signingKeyRow "ed25519" "SHA256:xyz789..." "Primary" true
            ]
        ]
    
      -- Active sessions
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.h3 [ cls [ "text-lg font-semibold text-text mb-4" ] ] [ HH.text "Active Sessions" ]
        , HH.p [ cls [ "text-sm text-muted-foreground mb-4" ] ] 
            [ HH.text "Manage your active sessions across devices." ]
        , HH.div
            [ cls [ "space-y-2" ] ]
            [ sessionRow "MacBook Pro" "San Francisco, US" "Active now" true
            , sessionRow "Windows Desktop" "San Francisco, US" "2 hours ago" false
            ]
        , HH.button
            [ cls [ "mt-4 text-sm text-red-400 hover:text-red-400/80 cursor-pointer" ]
            , HP.type_ HP.ButtonButton
            ]
            [ HH.text "Sign out all other sessions" ]
        ]
    
      -- Audit log
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.h3 [ cls [ "text-lg font-semibold text-text mb-4" ] ] [ HH.text "Audit Log" ]
        , HH.p [ cls [ "text-sm text-muted-foreground mb-4" ] ] 
            [ HH.text "Recent security events for your account." ]
        , HH.div
            [ cls [ "space-y-2" ] ]
            [ auditRow "Login" "MacBook Pro" "2 hours ago"
            , auditRow "SSH key added" "Work Desktop" "3 days ago"
            , auditRow "Password changed" "MacBook Pro" "1 week ago"
            ]
        ]
    ]

signingKeyRow :: forall w i. String -> String -> String -> Boolean -> HH.HTML w i
signingKeyRow keyType fingerprint label isPrimary =
  HH.div
    [ cls [ "flex items-center justify-between py-2 border-b border-border last:border-0" ] ]
    [ HH.div_
        [ HH.div
            [ cls [ "flex items-center gap-2" ] ]
            [ HH.span [ cls [ "text-sm text-text font-medium" ] ] [ HH.text keyType ]
            , if isPrimary 
                then HH.span [ cls [ "text-xs px-1.5 py-0.5 rounded bg-violet-400/10 text-violet-400" ] ] 
                    [ HH.text label ]
                else HH.text ""
            ]
        , HH.p [ cls [ "text-xs text-muted-foreground font-mono" ] ] [ HH.text fingerprint ]
        ]
    , HH.button
        [ cls [ "text-sm text-muted-foreground hover:text-text cursor-pointer" ]
        , HP.type_ HP.ButtonButton
        ]
        [ HH.text "Revoke" ]
    ]

sessionRow :: forall w i. String -> String -> String -> Boolean -> HH.HTML w i
sessionRow device location time current =
  HH.div
    [ cls [ "flex items-center justify-between py-2 border-b border-border last:border-0" ] ]
    [ HH.div_
        [ HH.div
            [ cls [ "flex items-center gap-2" ] ]
            [ HH.span [ cls [ "text-sm text-text" ] ] [ HH.text device ]
            , if current 
                then HH.span [ cls [ "text-xs px-1.5 py-0.5 rounded bg-green-500/10 text-green-400" ] ] 
                    [ HH.text "Current" ]
                else HH.text ""
            ]
        , HH.p [ cls [ "text-xs text-muted-foreground" ] ] [ HH.text location ]
        ]
    , HH.span [ cls [ "text-sm text-muted-foreground" ] ] [ HH.text time ]
    ]

auditRow :: forall w i. String -> String -> String -> HH.HTML w i
auditRow action device time =
  HH.div
    [ cls [ "flex items-center justify-between py-2 border-b border-border last:border-0" ] ]
    [ HH.div_
        [ HH.p [ cls [ "text-sm text-text" ] ] [ HH.text action ]
        , HH.p [ cls [ "text-xs text-muted-foreground" ] ] [ HH.text device ]
        ]
    , HH.span [ cls [ "text-xs text-muted-foreground" ] ] [ HH.text time ]
    ]
