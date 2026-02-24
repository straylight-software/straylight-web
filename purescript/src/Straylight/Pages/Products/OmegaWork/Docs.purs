-- | omega//work Documentation
-- | User guide and reference for the desktop app
module Straylight.Pages.Products.OmegaWork.Docs 
  ( docsPage
  , renderContent
  , sidebar
  , renderStatic
  ) where

import Prelude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

import Straylight.UI (cls)

-- ============================================================
-- COMPONENT
-- ============================================================

type Input = { path :: String }

data Action = Receive Input

docsPage :: forall q o m. H.Component q Input o m
docsPage = H.mkComponent
  { initialState: \input -> { path: input.path }
  , render
  , eval: H.mkEval H.defaultEval
      { handleAction = handleAction
      , receive = Just <<< Receive
      }
  }

handleAction :: forall o m. Action -> H.HalogenM { path :: String } Action () o m Unit
handleAction (Receive input) = H.modify_ _ { path = input.path }

-- ============================================================
-- RENDER
-- ============================================================

render :: forall m. { path :: String } -> H.ComponentHTML Action () m
render state =
  HH.div
    [ cls [ "max-w-[1100px] mx-auto px-6 py-12" ] ]
    [ HH.div
        [ cls [ "grid grid-cols-1 lg:grid-cols-[250px_1fr] gap-12" ] ]
        [ sidebar state.path
        , renderContent state.path
        ]
    ]

-- ============================================================
-- SIDEBAR
-- ============================================================

sidebar :: forall w i. String -> HH.HTML w i
sidebar currentPath =
  HH.nav
    [ cls [ "lg:sticky lg:top-24 lg:self-start" ] ]
    [ HH.div
        [ cls [ "space-y-6" ] ]
        [ sidebarSection "Getting Started"
            [ sidebarLink "/omega/work/docs" "Overview" currentPath
            , sidebarLink "/omega/work/docs/quickstart" "Quick Start" currentPath
            , sidebarLink "/omega/work/docs/installation" "Installation" currentPath
            ]
        , sidebarSection "Using omega//work"
            [ sidebarLink "/omega/work/docs/interface" "Interface Guide" currentPath
            , sidebarLink "/omega/work/docs/projects" "Projects & Workspaces" currentPath
            , sidebarLink "/omega/work/docs/conversations" "Conversations" currentPath
            , sidebarLink "/omega/work/docs/files" "Working with Files" currentPath
            ]
        , sidebarSection "Advanced"
            [ sidebarLink "/omega/work/docs/keyboard" "Keyboard Shortcuts" currentPath
            , sidebarLink "/omega/work/docs/sync" "Cloud Sync" currentPath
            , sidebarLink "/omega/work/docs/byok" "Bring Your Own Key" currentPath
            ]
        ]
    ]

sidebarSection :: forall w i. String -> Array (HH.HTML w i) -> HH.HTML w i
sidebarSection title children =
  HH.div_
    [ HH.h3
        [ cls [ "text-xs font-semibold text-muted-foreground uppercase tracking-wider mb-3" ] ]
        [ HH.text title ]
    , HH.ul
        [ cls [ "space-y-1" ] ]
        children
    ]

sidebarLink :: forall w i. String -> String -> String -> HH.HTML w i
sidebarLink href label currentPath =
  HH.li_
    [ HH.a
        [ HP.href href
        , cls [ "block py-1.5 px-3 rounded text-sm transition-colors"
              , if href == currentPath
                  then "bg-amber-400/10 text-amber-400 font-medium" 
                  else "text-muted-foreground hover:text-text hover:bg-card"
              ]
        ]
        [ HH.text label ]
    ]

-- ============================================================
-- STATIC RENDER (for SSG)
-- ============================================================

renderStatic :: forall w i. String -> HH.HTML w i
renderStatic path =
  HH.div
    [ cls [ "max-w-[1100px] mx-auto px-6 py-12" ] ]
    [ HH.div
        [ cls [ "grid grid-cols-1 lg:grid-cols-[250px_1fr] gap-12" ] ]
        [ sidebar path
        , renderContent path
        ]
    ]

-- ============================================================
-- CONTENT ROUTER
-- ============================================================

renderContent :: forall w i. String -> HH.HTML w i
renderContent path = case path of
  "/omega/work/docs" -> overviewContent
  "/omega/work/docs/quickstart" -> quickstartContent
  "/omega/work/docs/installation" -> installationContent
  "/omega/work/docs/interface" -> interfaceContent
  "/omega/work/docs/projects" -> projectsContent
  "/omega/work/docs/conversations" -> conversationsContent
  "/omega/work/docs/files" -> filesContent
  "/omega/work/docs/keyboard" -> keyboardContent
  "/omega/work/docs/sync" -> syncContent
  "/omega/work/docs/byok" -> byokContent
  _ -> overviewContent

-- ============================================================
-- OVERVIEW
-- ============================================================

overviewContent :: forall w i. HH.HTML w i
overviewContent =
  article
    [ h1 "omega//work Documentation"
    , p "Welcome to omega//work, the AI assistant for everyone. This guide will help you get the most out of the app."
    
    , HH.div
        [ cls [ "grid grid-cols-1 md:grid-cols-2 gap-4 my-8" ] ]
        [ docCard "/omega/work/docs/quickstart" "Quick Start" "Get up and running in under 5 minutes."
        , docCard "/omega/work/docs/interface" "Interface Guide" "Learn the app layout and navigation."
        , docCard "/omega/work/docs/projects" "Projects" "Organize your work into projects."
        , docCard "/omega/work/docs/keyboard" "Keyboard Shortcuts" "Speed up your workflow."
        ]
    
    , h2 "What is omega//work?"
    , p "omega//work is a native desktop application that brings AI assistance to your everyday work. Unlike terminal-based tools, omega//work provides a visual interface that's intuitive for everyone."
    
    , h2 "Key Concepts"
    , HH.ul
        [ cls [ "space-y-2 text-muted-foreground mb-6" ] ]
        [ li' "Projects - Organize your work into separate projects, each with its own context"
        , li' "Conversations - Chat with the AI, ask questions, request changes"
        , li' "Context - Files and information you share with the AI to help it understand your needs"
        , li' "Actions - Changes the AI proposes, which you can preview, accept, or reject"
        ]
    ]

-- ============================================================
-- QUICKSTART
-- ============================================================

quickstartContent :: forall w i. HH.HTML w i
quickstartContent =
  article
    [ h1 "Quick Start"
    , p "Get started with omega//work in just a few steps."
    
    , h2 "1. Download and install"
    , p "Download omega//work for your platform from the downloads page. Run the installer and follow the prompts."
    
    , h2 "2. Sign in"
    , p "Open the app and sign in with your Straylight account. If you don't have one, you can create one for free."
    
    , h2 "3. Create your first project"
    , p "Click 'New Project' and select a folder on your computer. This folder becomes your project root."
    
    , h2 "4. Start a conversation"
    , p "Type a message in the conversation panel. For example: 'Help me write a README for this project.'"
    
    , h2 "5. Review and accept"
    , p "The AI will propose changes. Review them in the diff viewer and click 'Accept' to apply them, or 'Reject' to skip."
    
    , h2 "Next steps"
    , HH.ul
        [ cls [ "space-y-2 text-muted-foreground" ] ]
        [ li' "Learn the interface layout"
        , li' "Explore keyboard shortcuts"
        , li' "Set up cloud sync"
        ]
    ]

-- ============================================================
-- INSTALLATION
-- ============================================================

installationContent :: forall w i. HH.HTML w i
installationContent =
  article
    [ h1 "Installation"
    , p "omega//work is available for macOS, Windows, and Linux."
    
    , h2 "macOS"
    , p "Download the .dmg file, open it, and drag omega//work to your Applications folder. Works on both Intel and Apple Silicon Macs."
    
    , h2 "Windows"
    , p "Download the .exe installer and run it. Follow the installation wizard. Requires Windows 10 or later."
    
    , h2 "Linux"
    , p "Download the .AppImage file. Make it executable (chmod +x) and run it. Works on most distributions."
    
    , h2 "System Requirements"
    , HH.ul
        [ cls [ "space-y-2 text-muted-foreground mb-6" ] ]
        [ li' "4GB RAM minimum (8GB recommended)"
        , li' "500MB disk space"
        , li' "Internet connection for AI features"
        ]
    ]

-- ============================================================
-- INTERFACE
-- ============================================================

interfaceContent :: forall w i. HH.HTML w i
interfaceContent =
  article
    [ h1 "Interface Guide"
    , p "omega//work has a clean, focused interface designed for productivity."
    
    , h2 "Main Areas"
    , HH.ul
        [ cls [ "space-y-2 text-muted-foreground mb-6" ] ]
        [ li' "Sidebar - Project navigation and file browser"
        , li' "Conversation Panel - Chat with the AI"
        , li' "Editor/Preview - View files and proposed changes"
        , li' "Status Bar - Current project and connection status"
        ]
    
    , h2 "Conversation Panel"
    , p "The conversation panel is where you interact with the AI. Type messages, ask questions, and request changes. The AI responds with explanations and proposed actions."
    
    , h2 "Diff Viewer"
    , p "When the AI proposes file changes, they appear in the diff viewer. Green lines are additions, red lines are removals. Use Accept/Reject buttons to apply or skip changes."
    ]

-- ============================================================
-- PROJECTS
-- ============================================================

projectsContent :: forall w i. HH.HTML w i
projectsContent =
  article
    [ h1 "Projects & Workspaces"
    , p "Keep your work organized with projects."
    
    , h2 "Creating a Project"
    , p "Click 'New Project' in the sidebar. Select a folder on your computer to use as the project root. Give it a name and you're ready to go."
    
    , h2 "Project Context"
    , p "Each project maintains its own context. Files you share, conversation history, and AI understanding are all scoped to the project."
    
    , h2 "Switching Projects"
    , p "Click on any project in the sidebar to switch. Your current conversation is saved automatically."
    ]

-- ============================================================
-- CONVERSATIONS
-- ============================================================

conversationsContent :: forall w i. HH.HTML w i
conversationsContent =
  article
    [ h1 "Conversations"
    , p "Conversations are how you interact with the AI."
    
    , h2 "Starting a Conversation"
    , p "Type your message in the input field and press Enter. Be specific about what you want to accomplish."
    
    , h2 "Adding Context"
    , p "Drag files from the sidebar into the conversation to share them with the AI. The AI can read and modify shared files."
    
    , h2 "Conversation History"
    , p "All conversations are saved automatically. Use the history panel to revisit past conversations."
    ]

-- ============================================================
-- FILES
-- ============================================================

filesContent :: forall w i. HH.HTML w i
filesContent =
  article
    [ h1 "Working with Files"
    , p "omega//work can read, create, and modify files in your projects."
    
    , h2 "Sharing Files"
    , p "Drag files from the sidebar into the conversation to share them with the AI. You can also mention file paths in your messages."
    
    , h2 "Reviewing Changes"
    , p "When the AI proposes changes, they appear in the diff viewer. Review each change and click Accept or Reject."
    
    , h2 "Undo"
    , p "If you accept a change and want to undo it, use Cmd+Z (macOS) or Ctrl+Z (Windows/Linux). omega//work keeps a full history of changes."
    ]

-- ============================================================
-- KEYBOARD
-- ============================================================

keyboardContent :: forall w i. HH.HTML w i
keyboardContent =
  article
    [ h1 "Keyboard Shortcuts"
    , p "Speed up your workflow with keyboard shortcuts."
    
    , h2 "General"
    , shortcutTable
        [ { key: "Cmd/Ctrl + N", action: "New project" }
        , { key: "Cmd/Ctrl + O", action: "Open project" }
        , { key: "Cmd/Ctrl + W", action: "Close project" }
        , { key: "Cmd/Ctrl + ,", action: "Settings" }
        ]
    
    , h2 "Conversation"
    , shortcutTable
        [ { key: "Enter", action: "Send message" }
        , { key: "Shift + Enter", action: "New line" }
        , { key: "Cmd/Ctrl + L", action: "Clear conversation" }
        , { key: "Up/Down", action: "Navigate history" }
        ]
    
    , h2 "Changes"
    , shortcutTable
        [ { key: "Cmd/Ctrl + Enter", action: "Accept change" }
        , { key: "Escape", action: "Reject change" }
        , { key: "Cmd/Ctrl + Z", action: "Undo" }
        ]
    ]

shortcutTable :: forall w i. Array { key :: String, action :: String } -> HH.HTML w i
shortcutTable shortcuts =
  HH.table
    [ cls [ "w-full text-sm mb-6" ] ]
    [ HH.tbody_ (map shortcutRow shortcuts) ]

shortcutRow :: forall w i. { key :: String, action :: String } -> HH.HTML w i
shortcutRow { key, action } =
  HH.tr
    [ cls [ "border-b border-border" ] ]
    [ HH.td [ cls [ "py-2 text-amber-400 font-mono" ] ] [ HH.text key ]
    , HH.td [ cls [ "py-2 text-muted-foreground" ] ] [ HH.text action ]
    ]

-- ============================================================
-- SYNC
-- ============================================================

syncContent :: forall w i. HH.HTML w i
syncContent =
  article
    [ h1 "Cloud Sync"
    , p "Sync your projects and settings across devices (Pro and Team plans)."
    
    , h2 "What syncs"
    , HH.ul
        [ cls [ "space-y-2 text-muted-foreground mb-6" ] ]
        [ li' "Conversation history"
        , li' "Project settings"
        , li' "Preferences"
        ]
    
    , h2 "What doesn't sync"
    , p "Your actual project files stay on your local machine. omega//work only syncs metadata and conversation history."
    
    , h2 "Enabling sync"
    , p "Go to Settings > Sync and sign in to your Straylight account. Sync is automatic after that."
    ]

-- ============================================================
-- BYOK
-- ============================================================

byokContent :: forall w i. HH.HTML w i
byokContent =
  article
    [ h1 "Bring Your Own Key"
    , p "Use your own API keys for AI providers."
    
    , h2 "Supported providers"
    , HH.ul
        [ cls [ "space-y-2 text-muted-foreground mb-6" ] ]
        [ li' "OpenAI (GPT-4, GPT-3.5)"
        , li' "Anthropic (Claude)"
        , li' "Azure OpenAI"
        ]
    
    , h2 "Configuration"
    , p "Go to Settings > API Keys and enter your key. Your key is stored locally and never sent to Straylight servers."
    
    , h2 "Billing"
    , p "When using your own key, you're billed directly by the AI provider. omega//work subscription still applies for app features."
    ]

-- ============================================================
-- HELPERS
-- ============================================================

article :: forall w i. Array (HH.HTML w i) -> HH.HTML w i
article = HH.article [ cls [ "prose prose-invert max-w-none" ] ]

h1 :: forall w i. String -> HH.HTML w i
h1 text = HH.h1 [ cls [ "text-3xl font-bold text-text mb-6" ] ] [ HH.text text ]

h2 :: forall w i. String -> HH.HTML w i
h2 text = HH.h2 [ cls [ "text-2xl font-semibold text-text mt-12 mb-4" ] ] [ HH.text text ]

p :: forall w i. String -> HH.HTML w i
p text = HH.p [ cls [ "text-muted-foreground mb-4" ] ] [ HH.text text ]

li' :: forall w i. String -> HH.HTML w i
li' text = HH.li [ cls [ "text-muted-foreground" ] ] [ HH.text text ]

docCard :: forall w i. String -> String -> String -> HH.HTML w i
docCard href title description =
  HH.a
    [ HP.href href
    , cls [ "block p-4 bg-card border border-border rounded-lg hover:border-amber-400/50 transition-colors" ]
    ]
    [ HH.h3
        [ cls [ "text-text font-medium mb-1" ] ]
        [ HH.text title ]
    , HH.p
        [ cls [ "text-muted-foreground text-sm" ] ]
        [ HH.text description ]
    ]
