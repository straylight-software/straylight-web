-- | Straylight UI Components for Halogen
-- | Extends Hydrogen.UI with the straylight aesthetic
module Straylight.UI 
  ( -- * Re-exports from Hydrogen.UI.Core
    module Hydrogen.UI.Core
    -- * Straylight-specific typography
  , sectionHeader
  , heading
  , text
  , quote
  , keyword
    -- * Straylight-specific decorative elements
  , rail
  , statusIndicator
  , scanlineOverlay
    -- * Straylight-specific links
  , navLink
  , externalLink
  , footerLink
    -- * Code blocks
  , codeBlock
  , inlineCode
  , blockCursor
    -- * Empty states
  , emptyState
  , emptyDashboard
  , emptySettings
  , connectPrompt
    -- * Settings components
  , settingsGroup
  , settingsItem
  , settingsToggle
  , settingsInput
  , settingsButton
  ) where

import Prelude

import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Hydrogen.UI.Core (classes, cls, svgCls, flex, row, column, box, container, section, svgNS)

-- ============================================================
-- TYPOGRAPHY
-- ============================================================

-- | Section header with code formatting
sectionHeader :: forall w i. String -> HH.HTML w i
sectionHeader title =
  HH.h2
    [ cls [ "text-primary text-[0.85rem] font-medium mb-6 lowercase section-header" ] ]
    [ HH.code_ [ HH.text $ "// " <> title ] ]

-- | Primary heading
heading :: forall w i. String -> Array (HH.HTML w i) -> HH.HTML w i
heading className = HH.h1 [ cls [ "text-text text-[2rem] font-medium", className ] ]

-- | Body text
text :: forall w i. String -> Array (HH.HTML w i) -> HH.HTML w i
text className = HH.p [ cls [ "text-muted-foreground", className ] ]

-- | Italic quote text
quote :: forall w i. String -> Array (HH.HTML w i) -> HH.HTML w i
quote className = HH.p [ cls [ "italic text-base02", className ] ]

-- | Keyword span with glow animation
keyword :: forall w i. Int -> String -> HH.HTML w i
keyword n content =
  HH.span
    [ cls [ "text-text keyword keyword-" <> show n ] ]
    [ HH.text content ]

-- ============================================================
-- DECORATIVE ELEMENTS
-- ============================================================

-- | Horizontal rail with shimmer effect
rail :: forall w i. HH.HTML w i
rail = HH.div [ cls [ "h-[3px] rail" ] ] []

-- | Status indicator
statusIndicator :: forall w i. String -> HH.HTML w i
statusIndicator label =
  HH.div
    [ cls [ "flex items-center gap-2 text-xs text-muted-foreground" ] ]
    [ HH.span [ cls [ "w-2 h-2 bg-status inline-block status-pulse" ] ] []
    , HH.text label
    ]

-- | Scanline overlay
scanlineOverlay :: forall w i. HH.HTML w i
scanlineOverlay = HH.div [ cls [ "scanline-overlay" ] ] []

-- ============================================================
-- LINKS
-- ============================================================

-- | Navigation link with trace animation
navLink :: forall w i. String -> String -> HH.HTML w i
navLink href label =
  HH.a
    [ HP.href href
    , cls [ "text-muted-foreground text-[13px] hover:text-text transition-colors link-trace" ]
    ]
    [ HH.text label ]

-- | External link
externalLink :: forall w i. String -> String -> HH.HTML w i
externalLink href label =
  HH.a
    [ HP.href href
    , HP.target "_blank"
    , HP.rel "noopener noreferrer"
    , cls [ "text-muted-foreground text-[13px] hover:text-text transition-colors link-trace" ]
    ]
    [ HH.text label ]

-- | Footer link with float animation
footerLink :: forall w i. String -> String -> HH.HTML w i
footerLink href label =
  HH.a
    [ HP.href href
    , HP.target "_blank"
    , HP.rel "noopener noreferrer"
    , cls [ "text-muted-foreground hover:text-text transition-colors ml-6 link-float inline-block" ]
    ]
    [ HH.text label ]

-- ============================================================
-- CODE BLOCKS
-- ============================================================

-- | Terminal-style code block
codeBlock :: forall w i. Array (HH.HTML w i) -> HH.HTML w i
codeBlock children =
  HH.pre
    [ cls [ "bg-card p-4 overflow-x-auto text-[0.9rem] leading-relaxed" ] ]
    children

-- | Inline code
inlineCode :: forall w i. String -> HH.HTML w i
inlineCode content =
  HH.code
    [ cls [ "text-muted-foreground" ] ]
    [ HH.text content ]

-- | Block cursor (blinking)
blockCursor :: forall w i. HH.HTML w i
blockCursor = HH.span [ cls [ "block-cursor" ] ] []

-- ============================================================
-- EMPTY STATES
-- ============================================================

-- | Generic empty state with icon, title, and description
emptyState :: forall w i. { icon :: String, title :: String, description :: String } -> HH.HTML w i
emptyState opts =
  HH.div
    [ cls [ "flex flex-col items-center justify-center py-16 px-8 text-center" ] ]
    [ HH.div 
        [ cls [ "text-4xl mb-4 opacity-30" ] ] 
        [ HH.text opts.icon ]
    , HH.h3 
        [ cls [ "text-lg font-medium text-text mb-2" ] ] 
        [ HH.text opts.title ]
    , HH.p 
        [ cls [ "text-sm text-muted-foreground max-w-md" ] ] 
        [ HH.text opts.description ]
    ]

-- | Empty dashboard state
emptyDashboard :: forall w i. String -> i -> HH.HTML w i
emptyDashboard productName action =
  HH.div
    [ cls [ "flex flex-col items-center justify-center py-24 px-8 text-center border border-dashed border-border rounded-lg w-full" ] ]
    [ HH.div 
        [ cls [ "text-5xl mb-6 opacity-20" ] ] 
        [ HH.text "◇" ]
    , HH.h3 
        [ cls [ "text-xl font-medium text-text mb-3" ] ] 
        [ HH.text $ "No data yet" ]
    , HH.p 
        [ cls [ "text-sm text-muted-foreground max-w-lg mb-6" ] ] 
        [ HH.text $ "Connect " <> productName <> " to your infrastructure to see metrics and activity here." ]
    , HH.button
        [ HE.onClick \_ -> action
        , cls [ "inline-flex items-center px-4 py-2 bg-primary text-background text-sm font-medium rounded hover:bg-primary/90 transition-colors cursor-pointer border-none" ]
        ]
        [ HH.text "Get Started" ]
    ]

-- | Empty settings state
emptySettings :: forall w i. HH.HTML w i
emptySettings =
  HH.div
    [ cls [ "flex flex-col items-center justify-center py-16 px-8 text-center" ] ]
    [ HH.div 
        [ cls [ "text-4xl mb-4 opacity-20" ] ] 
        [ HH.text "⚙" ]
    , HH.h3 
        [ cls [ "text-lg font-medium text-text mb-2" ] ] 
        [ HH.text "Sign in to configure" ]
    , HH.p 
        [ cls [ "text-sm text-muted-foreground max-w-md" ] ] 
        [ HH.text "Settings will appear here after you sign in and connect your account." ]
    ]

-- | Connect account prompt
connectPrompt :: forall w i. { title :: String, description :: String, buttonText :: String, buttonHref :: String } -> HH.HTML w i
connectPrompt opts =
  HH.div
    [ cls [ "bg-card border border-border rounded-lg p-6 text-center" ] ]
    [ HH.h4 
        [ cls [ "text-base font-medium text-text mb-2" ] ] 
        [ HH.text opts.title ]
    , HH.p 
        [ cls [ "text-sm text-muted-foreground mb-4" ] ] 
        [ HH.text opts.description ]
    , HH.a
        [ HP.href opts.buttonHref
        , cls [ "inline-flex items-center px-4 py-2 bg-primary text-background text-sm font-medium rounded hover:bg-primary/90 transition-colors border-none" ]
        ]
        [ HH.text opts.buttonText ]
    ]

-- ============================================================
-- SETTINGS COMPONENTS
-- ============================================================

-- | Group of settings with a title
settingsGroup :: forall w i. String -> Array (HH.HTML w i) -> HH.HTML w i
settingsGroup title children =
  HH.div
    [ cls [ "mb-8 bg-card border border-border rounded-lg overflow-hidden" ] ]
    [ HH.div 
        [ cls [ "px-6 py-4 border-b border-border bg-muted/30" ] ] 
        [ HH.h3 [ cls [ "text-[11px] font-medium text-text uppercase tracking-widest" ] ] [ HH.text title ] ]
    , HH.div 
        [ cls [ "divide-y divide-border" ] ] 
        children
    ]

-- | A single setting item with label and control
settingsItem :: forall w i. String -> String -> HH.HTML w i -> HH.HTML w i
settingsItem title description control =
  HH.div
    [ cls [ "px-6 py-4 flex items-center justify-between gap-8 hover:bg-muted/5 transition-colors" ] ]
    [ HH.div 
        [ cls [ "flex-1" ] ] 
        [ HH.h4 [ cls [ "text-sm font-medium text-text mb-1 lowercase" ] ] [ HH.text title ]
        , HH.p [ cls [ "text-[11px] text-muted-foreground" ] ] [ HH.text description ]
        ]
    , HH.div [ cls [ "flex-shrink-0" ] ] [ control ]
    ]

-- | A toggle switch for settings
settingsToggle :: forall w i. Boolean -> i -> HH.HTML w i
settingsToggle active action =
  HH.button
    [ cls [ "relative inline-flex h-5 w-10 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none focus:ring-1 focus:ring-primary focus:ring-offset-1 border-none outline-none"
          , if active then "bg-primary" else "bg-border"
          ]
    , HE.onClick \_ -> action
    ]
    [ HH.span 
        [ cls [ "pointer-events-none inline-block h-4 w-4 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out"
              , if active then "translate-x-5" else "translate-x-0"
              ] 
        ] []
    ]

-- | An input field for settings
settingsInput :: forall w i. String -> String -> (String -> i) -> HH.HTML w i
settingsInput val placeholder onChange =
  HH.input
    [ cls [ "bg-background border border-border rounded px-3 py-1.5 text-xs text-text focus:border-primary outline-none transition-colors w-64 font-mono" ]
    , HP.value val
    , HP.placeholder placeholder
    , HE.onValueInput onChange
    ]

-- | A button for settings actions
settingsButton :: forall w i. String -> i -> HH.HTML w i
settingsButton label action =
  HH.button
    [ cls [ "px-4 py-2 bg-primary text-background text-[11px] font-medium rounded hover:bg-primary/90 transition-colors cursor-pointer uppercase tracking-wider border-none" ]
    , HE.onClick \_ -> action
    ]
    [ HH.text label ]
