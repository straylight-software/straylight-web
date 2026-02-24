-- | sensenet//build Pricing Page
module Straylight.Pages.Products.SensenetBuild.Pricing 
  ( pricingPage
  , render
  ) where

import Prelude

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

import Straylight.UI (cls)

-- ============================================================
-- COMPONENT
-- ============================================================

pricingPage :: forall q i o m. H.Component q i o m
pricingPage = H.mkComponent
  { initialState: const unit
  , render: const render
  , eval: H.mkEval H.defaultEval
  }

-- ============================================================
-- RENDER
-- ============================================================

render :: forall w i. HH.HTML w i
render =
  HH.div_
    [ hero
    , plans
    , faq
    , enterprise
    ]

-- ============================================================
-- HERO
-- ============================================================

hero :: forall w i. HH.HTML w i
hero =
  HH.section
    [ cls [ "py-24" ] ]
    [ HH.div
        [ cls [ "max-w-[1100px] mx-auto px-6 text-center" ] ]
        [ HH.h1
            [ cls [ "text-4xl md:text-5xl font-bold text-text mb-6" ] ]
            [ HH.text "Simple, transparent pricing" ]
        , HH.p
            [ cls [ "text-xl text-muted-foreground max-w-2xl mx-auto" ] ]
            [ HH.text "Start free. Pay for remote execution when you need it. No hidden fees." ]
        ]
    ]

-- ============================================================
-- PLANS
-- ============================================================

plans :: forall w i. HH.HTML w i
plans =
  HH.section
    [ cls [ "pb-24" ] ]
    [ HH.div
        [ cls [ "max-w-[1100px] mx-auto px-6" ] ]
        [ HH.div
            [ cls [ "grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6" ] ]
            [ pricingCard
                { name: "Open Source"
                , price: "$0"
                , period: "/month"
                , description: "For open source projects."
                , features:
                    [ "Unlimited local builds"
                    , "Full Dhall support"
                    , "Lean4 verification"
                    , "Community support"
                    , "Public repos only"
                    ]
                , cta: "Get started"
                , ctaHref: "/sensenet/build/docs"
                , highlighted: false
                }
            , pricingCard
                { name: "Developer"
                , price: "$29"
                , period: "/month"
                , description: "For individual developers."
                , features:
                    [ "Everything in Open Source"
                    , "Private repositories"
                    , "100 remote build hours"
                    , "Build analytics"
                    , "Email support"
                    ]
                , cta: "Start free trial"
                , ctaHref: "/sensenet/build/dashboard"
                , highlighted: true
                }
            , pricingCard
                { name: "Team"
                , price: "$99"
                , period: "/month"
                , description: "For teams shipping production software."
                , features:
                    [ "Everything in Developer"
                    , "Unlimited remote builds"
                    , "5 team seats included"
                    , "Priority support"
                    , "SSO/SAML"
                    , "Audit logs"
                    ]
                , cta: "Start free trial"
                , ctaHref: "/sensenet/build/dashboard"
                , highlighted: false
                }
            , pricingCard
                { name: "Enterprise"
                , price: "Custom"
                , period: ""
                , description: "For organizations with compliance needs."
                , features:
                    [ "Everything in Team"
                    , "Unlimited seats"
                    , "Dedicated support"
                    , "SLA guarantee"
                    , "Self-hosted option"
                    , "Custom integrations"
                    ]
                , cta: "Contact sales"
                , ctaHref: "/sensenet/build/legal"
                , highlighted: false
                }
            ]
        , HH.p
            [ cls [ "text-center text-muted-foreground text-sm mt-8" ] ]
            [ HH.text "All plans include: Dhall configs, Lean4 proofs, hermetic builds, multi-language support" ]
        ]
    ]

type PricingCardConfig =
  { name :: String
  , price :: String
  , period :: String
  , description :: String
  , features :: Array String
  , cta :: String
  , ctaHref :: String
  , highlighted :: Boolean
  }

pricingCard :: forall w i. PricingCardConfig -> HH.HTML w i
pricingCard config =
  HH.div
    [ cls [ "p-6 rounded-lg border"
          , if config.highlighted 
              then "bg-card border-rose-400" 
              else "bg-card border-border"
          ]
    ]
    [ HH.h3
        [ cls [ "text-lg font-semibold text-text mb-2" ] ]
        [ HH.text config.name ]
    , HH.div
        [ cls [ "mb-4" ] ]
        [ HH.span
            [ cls [ "text-3xl font-bold text-text" ] ]
            [ HH.text config.price ]
        , HH.span
            [ cls [ "text-muted-foreground" ] ]
            [ HH.text config.period ]
        ]
    , HH.p
        [ cls [ "text-sm text-muted-foreground mb-6" ] ]
        [ HH.text config.description ]
    , HH.ul
        [ cls [ "space-y-2 mb-6" ] ]
        (map featureItem config.features)
    , HH.a
        [ HP.href config.ctaHref
        , cls [ "block text-center py-3 rounded-md font-medium transition-colors"
              , if config.highlighted
                  then "bg-rose-400 text-background hover:bg-rose-400/90"
                  else "border border-border text-text hover:bg-card"
              ]
        ]
        [ HH.text config.cta ]
    ]

featureItem :: forall w i. String -> HH.HTML w i
featureItem text =
  HH.li
    [ cls [ "flex items-center gap-2 text-sm text-muted-foreground" ] ]
    [ HH.span [ cls [ "text-rose-400" ] ] [ HH.text "+" ]
    , HH.text text
    ]

-- ============================================================
-- FAQ
-- ============================================================

faq :: forall w i. HH.HTML w i
faq =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "max-w-[800px] mx-auto px-6" ] ]
        [ HH.h2
            [ cls [ "text-2xl font-bold text-text mb-12 text-center" ] ]
            [ HH.text "Frequently asked questions" ]
        , HH.div
            [ cls [ "space-y-8" ] ]
            [ faqItem 
                "What are remote build hours?"
                "Remote build hours are compute time on our distributed build cluster. Local builds are always free and unlimited. Remote builds let you offload to cloud workers for faster CI."
            , faqItem
                "Can I use sensenet//build with my existing Nix setup?"
                "Yes. sensenet//build can consume Nix derivations and flakes. You can migrate incrementally - start with Dhall for new targets while keeping existing Nix expressions."
            , faqItem
                "What languages are supported?"
                "First-class support for Rust, Go, Haskell, PureScript, TypeScript, C++, and Python. Other languages work via custom rules."
            , faqItem
                "How does the Lean4 verification work?"
                "Core build semantics are formalized in Lean4. We've proven 47 theorems about derivation behavior. You can verify builds match the proven semantics with --verify."
            , faqItem
                "Can I self-host?"
                "Enterprise plans include self-hosted deployment options. Contact sales for details."
            ]
        ]
    ]

faqItem :: forall w i. String -> String -> HH.HTML w i
faqItem question answer =
  HH.div_
    [ HH.h3
        [ cls [ "text-text font-medium mb-2" ] ]
        [ HH.text question ]
    , HH.p
        [ cls [ "text-muted-foreground" ] ]
        [ HH.text answer ]
    ]

-- ============================================================
-- ENTERPRISE
-- ============================================================

enterprise :: forall w i. HH.HTML w i
enterprise =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "max-w-[800px] mx-auto px-6 text-center" ] ]
        [ HH.h2
            [ cls [ "text-2xl font-bold text-text mb-4" ] ]
            [ HH.text "Need something custom?" ]
        , HH.p
            [ cls [ "text-muted-foreground mb-8" ] ]
            [ HH.text "We work with enterprises on custom deployments, SLAs, and integrations. Let's talk." ]
        , HH.a
            [ HP.href "mailto:enterprise@straylight.software"
            , cls [ "inline-flex items-center justify-center px-6 py-3 bg-rose-400 text-background font-medium rounded-md hover:bg-rose-400/90 transition-colors" ]
            ]
            [ HH.text "Contact sales" ]
        ]
    ]
