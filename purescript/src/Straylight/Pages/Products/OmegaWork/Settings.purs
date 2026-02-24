-- | omega//work Settings Page
-- | Account settings, billing, preferences
module Straylight.Pages.Products.OmegaWork.Settings where

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
    , sidebarButton "preferences" "Preferences" state.activeTab
    , sidebarButton "api-keys" "API Keys" state.activeTab
    , sidebarButton "security" "Security" state.activeTab
    ]

sidebarButton :: forall m. String -> String -> String -> H.ComponentHTML Action () m
sidebarButton value label activeTab =
  HH.button
    [ cls [ "w-full text-left px-3 py-2 rounded text-sm transition-colors"
          , if value == activeTab 
              then "bg-amber-400/10 text-amber-400 font-medium" 
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
  "preferences" -> preferencesTab
  "api-keys" -> apiKeysTab
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
            [ formField "Name" 
                (HH.input 
                    [ HP.type_ HP.InputText
                    , HP.value "Alex Johnson"
                    , cls [ "w-full px-3 py-2 bg-background border border-border rounded-md text-text text-sm focus:outline-none focus:ring-2 focus:ring-amber-400" ]
                    ])
            , formField "Email" 
                (HH.input 
                    [ HP.type_ HP.InputEmail
                    , HP.value "alex@example.com"
                    , HP.disabled true
                    , cls [ "w-full px-3 py-2 bg-background border border-border rounded-md text-muted-foreground text-sm" ]
                    ])
            ]
        , HH.div
            [ cls [ "mt-4" ] ]
            [ HH.button
                [ cls [ "px-4 py-2 bg-amber-400 text-background text-sm font-medium rounded-md hover:bg-amber-400/90 transition-colors cursor-pointer" ]
                , HP.type_ HP.ButtonButton
                ]
                [ HH.text "Save Changes" ]
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

formField :: forall w i. String -> HH.HTML w i -> HH.HTML w i
formField label input =
  HH.div_
    [ HH.label [ cls [ "block text-sm font-medium text-text mb-1" ] ] [ HH.text label ]
    , input
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
                [ HP.href "/omega/work/pricing"
                , cls [ "text-sm text-amber-400 hover:text-amber-400/80" ]
                ]
                [ HH.text "Change plan" ]
            ]
        , HH.div
            [ cls [ "flex items-center gap-4 mb-4" ] ]
            [ HH.span [ cls [ "text-2xl font-bold text-text" ] ] [ HH.text "Pro" ]
            , HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text "$39/month" ]
            ]
        , HH.div
            [ cls [ "grid grid-cols-2 md:grid-cols-4 gap-4" ] ]
            [ planDetail "Conversations" "Unlimited"
            , planDetail "Cloud Sync" "Included"
            , planDetail "Devices" "Unlimited"
            , planDetail "Support" "Priority"
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
                [ cls [ "text-sm text-amber-400 hover:text-amber-400/80 cursor-pointer" ]
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
            [ invoiceRow "Feb 1, 2026" "$39.00" "Paid"
            , invoiceRow "Jan 1, 2026" "$39.00" "Paid"
            , invoiceRow "Dec 1, 2025" "$39.00" "Paid"
            ]
        ]
    ]

planDetail :: forall w i. String -> String -> HH.HTML w i
planDetail label value =
  HH.div_
    [ HH.p [ cls [ "text-xs text-muted-foreground" ] ] [ HH.text label ]
    , HH.p [ cls [ "text-sm text-text font-medium" ] ] [ HH.text value ]
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
-- PREFERENCES TAB
-- ============================================================

preferencesTab :: forall w i. HH.HTML w i
preferencesTab =
  HH.div
    [ cls [ "space-y-6" ] ]
    [ HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.h3 [ cls [ "text-lg font-semibold text-text mb-4" ] ] [ HH.text "Appearance" ]
        , HH.div
            [ cls [ "space-y-4" ] ]
            [ preferenceToggle "Dark mode" "Use dark theme throughout the app" true
            , preferenceToggle "Compact view" "Reduce spacing in the interface" false
            ]
        ]
    , HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.h3 [ cls [ "text-lg font-semibold text-text mb-4" ] ] [ HH.text "Behavior" ]
        , HH.div
            [ cls [ "space-y-4" ] ]
            [ preferenceToggle "Auto-save" "Automatically save conversations" true
            , preferenceToggle "Sound effects" "Play sounds for notifications" false
            , preferenceToggle "Show diff preview" "Preview changes before accepting" true
            ]
        ]
    ]

preferenceToggle :: forall w i. String -> String -> Boolean -> HH.HTML w i
preferenceToggle label description enabled =
  HH.div
    [ cls [ "flex items-center justify-between py-2" ] ]
    [ HH.div_
        [ HH.p [ cls [ "text-sm text-text font-medium" ] ] [ HH.text label ]
        , HH.p [ cls [ "text-xs text-muted-foreground" ] ] [ HH.text description ]
        ]
    , HH.div
        [ cls [ "w-10 h-6 rounded-full cursor-pointer transition-colors"
              , if enabled then "bg-amber-400" else "bg-muted"
              ]
        ]
        [ HH.div
            [ cls [ "w-4 h-4 bg-white rounded-full mt-1 transition-transform"
                  , if enabled then "translate-x-5" else "translate-x-1"
                  ]
            ]
            []
        ]
    ]

-- ============================================================
-- API KEYS TAB
-- ============================================================

apiKeysTab :: forall w i. HH.HTML w i
apiKeysTab =
  HH.div
    [ cls [ "space-y-6" ] ]
    [ HH.div
        [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
        [ HH.h3 [ cls [ "text-lg font-semibold text-text mb-2" ] ] [ HH.text "Bring Your Own Key" ]
        , HH.p [ cls [ "text-sm text-muted-foreground mb-4" ] ] 
            [ HH.text "Use your own API keys instead of the included access. Keys are stored locally." ]
        , HH.div
            [ cls [ "space-y-4" ] ]
            [ apiKeyField "OpenAI" "sk-...xxxx" true
            , apiKeyField "Anthropic" "Not configured" false
            , apiKeyField "Azure OpenAI" "Not configured" false
            ]
        ]
    , HH.div
        [ cls [ "p-4 bg-amber-400/5 border border-amber-400/20 rounded-lg" ] ]
        [ HH.p
            [ cls [ "text-sm text-amber-400" ] ]
            [ HH.text "Your API keys are stored locally on your device and never sent to our servers." ]
        ]
    ]

apiKeyField :: forall w i. String -> String -> Boolean -> HH.HTML w i
apiKeyField provider value configured =
  HH.div
    [ cls [ "flex items-center justify-between py-2 border-b border-border last:border-0" ] ]
    [ HH.div_
        [ HH.p [ cls [ "text-sm text-text font-medium" ] ] [ HH.text provider ]
        , HH.p [ cls [ "text-xs font-mono", if configured then "text-muted-foreground" else "text-muted-foreground/50" ] ] 
            [ HH.text value ]
        ]
    , HH.button
        [ cls [ "text-sm text-amber-400 hover:text-amber-400/80 cursor-pointer" ]
        , HP.type_ HP.ButtonButton
        ]
        [ HH.text $ if configured then "Update" else "Add" ]
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
