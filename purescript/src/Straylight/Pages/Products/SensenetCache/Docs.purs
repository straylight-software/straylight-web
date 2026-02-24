-- | sensenet//cache Documentation
module Straylight.Pages.Products.SensenetCache.Docs 
  ( docsPage, renderContent, sidebar, renderStatic ) where

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
  { initialState: \input -> { path: input.path }, render
  , eval: H.mkEval H.defaultEval { handleAction = handleAction, receive = Just <<< Receive } }

handleAction :: forall o m. Action -> H.HalogenM { path :: String } Action () o m Unit
handleAction (Receive input) = H.modify_ _ { path = input.path }

render :: forall m. { path :: String } -> H.ComponentHTML Action () m
render state = HH.div [ cls [ "max-w-[1100px] mx-auto px-6 py-12" ] ]
    [ HH.div [ cls [ "grid grid-cols-1 lg:grid-cols-[250px_1fr] gap-12" ] ] [ sidebar state.path, renderContent state.path ] ]

sidebar :: forall w i. String -> HH.HTML w i
sidebar currentPath = HH.nav [ cls [ "lg:sticky lg:top-24 lg:self-start" ] ]
    [ HH.div [ cls [ "space-y-6" ] ]
        [ sidebarSection "Getting Started"
            [ sidebarLink "/sensenet/cache/docs" "Overview" currentPath
            , sidebarLink "/sensenet/cache/docs/quickstart" "Quick Start" currentPath ]
        , sidebarSection "Guides"
            [ sidebarLink "/sensenet/cache/docs/attestation" "Attestation" currentPath
            , sidebarLink "/sensenet/cache/docs/post-quantum" "Post-Quantum Signatures" currentPath ]
        , sidebarSection "Reference"
            [ sidebarLink "/sensenet/cache/docs/cli" "CLI Reference" currentPath
            , sidebarLink "/sensenet/cache/docs/api" "API Reference" currentPath ] ] ]

sidebarSection :: forall w i. String -> Array (HH.HTML w i) -> HH.HTML w i
sidebarSection title children = HH.div_
    [ HH.h3 [ cls [ "text-xs font-semibold text-muted-foreground uppercase tracking-wider mb-3" ] ] [ HH.text title ]
    , HH.ul [ cls [ "space-y-1" ] ] children ]

sidebarLink :: forall w i. String -> String -> String -> HH.HTML w i
sidebarLink href label currentPath = HH.li_ [ HH.a
    [ HP.href href, cls [ "block py-1.5 px-3 rounded text-sm transition-colors"
          , if href == currentPath then "bg-cyan-400/10 text-cyan-400 font-medium" else "text-muted-foreground hover:text-text hover:bg-card" ] ]
    [ HH.text label ] ]

renderStatic :: forall w i. String -> HH.HTML w i
renderStatic path = HH.div [ cls [ "max-w-[1100px] mx-auto px-6 py-12" ] ]
    [ HH.div [ cls [ "grid grid-cols-1 lg:grid-cols-[250px_1fr] gap-12" ] ] [ sidebar path, renderContent path ] ]

renderContent :: forall w i. String -> HH.HTML w i
renderContent path = case path of
  "/sensenet/cache/docs" -> overviewContent
  _ -> overviewContent

overviewContent :: forall w i. HH.HTML w i
overviewContent = HH.article [ cls [ "prose prose-invert max-w-none" ] ]
    [ HH.h1 [ cls [ "text-3xl font-bold text-text mb-6" ] ] [ HH.text "sensenet//cache Documentation" ]
    , HH.p [ cls [ "text-muted-foreground mb-4" ] ] [ HH.text "Attestation-aware binary cache with content-addressed storage and post-quantum signatures." ]
    , codeBlock [ HH.text "# Push with attestation\nsensenet-cache push --attest ./result" ] ]
