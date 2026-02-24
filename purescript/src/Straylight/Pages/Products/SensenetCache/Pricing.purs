-- | sensenet//cache Pricing Page
module Straylight.Pages.Products.SensenetCache.Pricing 
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
            [ HH.text "Simple, honest pricing" ]
        , HH.p
            [ cls [ "text-xl text-muted-foreground max-w-2xl mx-auto" ] ]
            [ HH.text "Pay for what you use. No hidden fees. Post-quantum security included at every tier." ]
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
                { name: "Free"
                , price: "$0"
                , period: "/month"
                , description: "For personal projects and experiments."
                , features:
                    [ "10GB storage"
                    , "100GB transfer/month"
                    , "1 private cache"
                    , "Community support"
                    , "Post-quantum signatures"
                    ]
                , cta: "Get started"
                , ctaHref: "/signup"
                , highlighted: false
                }
            , pricingCard
                { name: "Pro"
                , price: "$15"
                , period: "/month"
                , description: "For individual developers and small teams."
                , features:
                    [ "100GB storage"
                    , "500GB transfer/month"
                    , "5 private caches"
                    , "Email support"
                    , "Attestation reports"
                    , "Cache analytics"
                    ]
                , cta: "Start free trial"
                , ctaHref: "/signup?plan=pro"
                , highlighted: true
                }
            , pricingCard
                { name: "Team"
                , price: "$49"
                , period: "/month"
                , description: "For teams shipping production software."
                , features:
                    [ "500GB storage"
                    , "2TB transfer/month"
                    , "Unlimited private caches"
                    , "5 team seats included"
                    , "Priority support"
                    , "SSO/SAML"
                    , "Audit logs"
                    ]
                , cta: "Start free trial"
                , ctaHref: "/signup?plan=team"
                , highlighted: false
                }
            , pricingCard
                { name: "Enterprise"
                , price: "Custom"
                , period: ""
                , description: "For organizations with compliance needs."
                , features:
                    [ "Unlimited storage"
                    , "Unlimited transfer"
                    , "Unlimited seats"
                    , "Dedicated support"
                    , "SLA guarantee"
                    , "Self-hosted option"
                    , "Custom integrations"
                    ]
                , cta: "Contact sales"
                , ctaHref: "/discord"
                , highlighted: false
                }
            ]
        , HH.p
            [ cls [ "text-center text-muted-foreground text-sm mt-8" ] ]
            [ HH.text "All plans include: Post-quantum signatures, Blake3 hashing, attestation metadata, REST API access" ]
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
    [ cls [ "bg-card border rounded-lg p-6 flex flex-col"
          , if config.highlighted then "border-cyan-400" else "border-border"
          ]
    ]
    [ if config.highlighted
        then HH.div
          [ cls [ "text-center text-cyan-400 text-xs font-medium mb-4 -mt-2" ] ]
          [ HH.text "MOST POPULAR" ]
        else HH.text ""
    , HH.h3
        [ cls [ "text-lg font-semibold text-text mb-2" ] ]
        [ HH.text config.name ]
    , HH.div
        [ cls [ "mb-4" ] ]
        [ HH.span [ cls [ "text-3xl font-bold text-text" ] ] [ HH.text config.price ]
        , HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text config.period ]
        ]
    , HH.p
        [ cls [ "text-sm text-muted-foreground mb-6" ] ]
        [ HH.text config.description ]
    , HH.ul
        [ cls [ "space-y-2 flex-grow mb-6" ] ]
        (map featureItem config.features)
    , HH.a
        [ HP.href config.ctaHref
        , cls [ "block text-center py-3 rounded-md font-medium transition-colors"
              , if config.highlighted
                  then "bg-cyan-400 text-background hover:bg-cyan-400/90"
                  else "border border-border text-text hover:bg-card"
              ]
        ]
        [ HH.text config.cta ]
    ]

featureItem :: forall w i. String -> HH.HTML w i
featureItem feature =
  HH.li
    [ cls [ "flex items-start gap-2 text-sm" ] ]
    [ HH.span [ cls [ "text-cyan-400 mt-0.5" ] ] [ HH.text "+" ]
    , HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text feature ]
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
                "What are post-quantum signatures?"
                "SPHINCS+ is a hash-based signature algorithm that remains secure even against quantum computers. We use it to sign all artifacts, ensuring your supply chain is protected against future quantum threats."
            , faqItem
                "Can I migrate from Cachix?"
                "Yes. Our CLI includes a migration command that pulls your existing cache and re-uploads to sensenet//cache. Zero downtime, usually under an hour."
            , faqItem
                "How does content-addressed storage work?"
                "Every artifact is identified by its Blake3 hash. The same content always has the same address. This means automatic deduplication, immutability, and integrity verification."
            , faqItem
                "What happens if I exceed my limits?"
                "We don't cut you off. You'll get a notification and we'll work with you to either upgrade or optimize. No surprise bills."
            , faqItem
                "Is self-hosting available?"
                "Yes, on the Enterprise plan. Deploy sensenet//cache on your own infrastructure with full support."
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
            [ HP.href "mailto:enterprise@sensenet.dev"
            , cls [ "inline-flex items-center justify-center px-6 py-3 bg-cyan-400 text-background font-medium rounded-md hover:bg-cyan-400/90 transition-colors" ]
            ]
            [ HH.text "Contact sales" ]
        ]
    ]
