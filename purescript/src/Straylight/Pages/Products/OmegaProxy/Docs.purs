-- | omega//proxy Documentation
module Straylight.Pages.Products.OmegaProxy.Docs 
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

import Straylight.UI (cls, codeBlock)

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

sidebar :: forall w i. String -> HH.HTML w i
sidebar currentPath =
  HH.nav
    [ cls [ "lg:sticky lg:top-24 lg:self-start" ] ]
    [ HH.div
        [ cls [ "space-y-6" ] ]
        [ sidebarSection "Getting Started"
            [ sidebarLink "/omega/proxy/docs" "Overview" currentPath
            , sidebarLink "/omega/proxy/docs/quickstart" "Quick Start" currentPath
            , sidebarLink "/omega/proxy/docs/installation" "Installation" currentPath
            ]
        , sidebarSection "Guides"
            [ sidebarLink "/omega/proxy/docs/sigil" "SIGIL Protocol" currentPath
            , sidebarLink "/omega/proxy/docs/zeromq" "ZeroMQ Transport" currentPath
            , sidebarLink "/omega/proxy/docs/sse" "SSE Translation" currentPath
            , sidebarLink "/omega/proxy/docs/ambiguity" "Reset-on-Ambiguity" currentPath
            ]
        , sidebarSection "Reference"
            [ sidebarLink "/omega/proxy/docs/cli" "CLI Reference" currentPath
            , sidebarLink "/omega/proxy/docs/api" "API Reference" currentPath
            , sidebarLink "/omega/proxy/docs/config" "Configuration" currentPath
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
                  then "bg-purple-400/10 text-purple-400 font-medium" 
                  else "text-muted-foreground hover:text-text hover:bg-card"
              ]
        ]
        [ HH.text label ]
    ]

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

renderContent :: forall w i. String -> HH.HTML w i
renderContent path = case path of
  "/omega/proxy/docs" -> overviewContent
  "/omega/proxy/docs/quickstart" -> quickstartContent
  _ -> overviewContent

overviewContent :: forall w i. HH.HTML w i
overviewContent =
  HH.article
    [ cls [ "prose prose-invert max-w-none" ] ]
    [ HH.h1 [ cls [ "text-3xl font-bold text-text mb-6" ] ] [ HH.text "omega//proxy Documentation" ]
    , HH.p [ cls [ "text-muted-foreground mb-4" ] ] 
        [ HH.text "Verified inference proxy with SSE to SIGIL protocol translation over ZeroMQ." ]
    , HH.h2 [ cls [ "text-2xl font-semibold text-text mt-12 mb-4" ] ] [ HH.text "What is omega//proxy?" ]
    , HH.p [ cls [ "text-muted-foreground mb-4" ] ] 
        [ HH.text "omega//proxy sits between your LLM provider and your applications, translating Server-Sent Events (SSE) into the SIGIL protocol over ZeroMQ. It provides verified inference with reset-on-ambiguity semantics." ]
    ]

quickstartContent :: forall w i. HH.HTML w i
quickstartContent =
  HH.article
    [ cls [ "prose prose-invert max-w-none" ] ]
    [ HH.h1 [ cls [ "text-3xl font-bold text-text mb-6" ] ] [ HH.text "Quick Start" ]
    , HH.p [ cls [ "text-muted-foreground mb-4" ] ] [ HH.text "Get omega//proxy running in under a minute." ]
    , codeBlock
        [ HH.text "# Install omega//proxy\n"
        , HH.text "nix profile install github:straylight-software/omega-proxy\n\n"
        , HH.text "# Start the proxy\n"
        , HH.text "omega-proxy --listen tcp://127.0.0.1:5555 --upstream https://api.anthropic.com"
        ]
    ]
