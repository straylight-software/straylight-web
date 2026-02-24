-- | omega//boost Pricing Page
-- | Transparent pricing for managed inference
module Straylight.Pages.Products.OmegaBoost.Pricing 
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
    , calculator
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
            [ HH.text "Pay only for our infrastructure margin. Your API costs stay with your vendor. No hidden fees." ]
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
            [ cls [ "grid grid-cols-1 md:grid-cols-3 gap-6" ] ]
            [ pricingCard
                { name: "Starter"
                , price: "$0"
                , period: "/month"
                , description: "Perfect for trying omega//boost"
                , features:
                    [ "100k requests/month"
                    , "$0.001/request after"
                    , "2 API key slots"
                    , "Basic analytics"
                    , "Community support"
                    ]
                , cta: "Get started"
                , ctaHref: "/omega/boost/dashboard"
                , highlighted: false
                }
            , pricingCard
                { name: "Pro"
                , price: "$49"
                , period: "/month"
                , description: "For teams building with AI"
                , features:
                    [ "1M requests/month included"
                    , "$0.0005/request after"
                    , "Unlimited API keys"
                    , "Advanced analytics"
                    , "Priority routing"
                    , "Email support"
                    , "99.9% uptime SLA"
                    ]
                , cta: "Start Pro trial"
                , ctaHref: "/omega/boost/dashboard?plan=pro"
                , highlighted: true
                }
            , pricingCard
                { name: "Enterprise"
                , price: "Custom"
                , period: ""
                , description: "For organizations at scale"
                , features:
                    [ "Unlimited requests"
                    , "Volume discounts"
                    , "Dedicated support"
                    , "99.99% uptime SLA"
                    , "Custom integrations"
                    , "SOC 2 compliance"
                    , "On-prem option"
                    ]
                , cta: "Contact sales"
                , ctaHref: "/discord"
                , highlighted: false
                }
            ]
        , HH.p
            [ cls [ "text-center text-muted-foreground text-sm mt-8" ] ]
            [ HH.text "All plans include: BYOK support, automatic batching, KV cache sharing, real-time metrics" ]
        ]
    ]

type PricingTier =
  { name :: String
  , price :: String
  , period :: String
  , description :: String
  , features :: Array String
  , cta :: String
  , ctaHref :: String
  , highlighted :: Boolean
  }

pricingCard :: forall w i. PricingTier -> HH.HTML w i
pricingCard t =
  HH.div
    [ cls [ "p-6 bg-card border rounded-lg flex flex-col"
          , if t.highlighted then "border-orange-400" else "border-border"
          ]
    ]
    [ -- Tier badge
      HH.div
        [ cls [ "mb-4" ] ]
        [ HH.span
            [ cls [ "text-sm font-medium"
                  , if t.highlighted then "text-orange-400" else "text-muted-foreground"
                  ]
            ]
            [ HH.text t.name ]
        ]
    , -- Price
      HH.div
        [ cls [ "mb-4" ] ]
        [ HH.span [ cls [ "text-4xl font-bold text-text" ] ] [ HH.text t.price ]
        , HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text t.period ]
        ]
    , -- Description
      HH.p
        [ cls [ "text-muted-foreground text-sm mb-6" ] ]
        [ HH.text t.description ]
    , -- Features
      HH.ul
        [ cls [ "space-y-3 mb-8 flex-grow" ] ]
        (map pricingFeature t.features)
    , -- CTA
      HH.a
        [ HP.href t.ctaHref
        , cls [ "inline-flex items-center justify-center px-6 py-3 font-medium rounded-md transition-colors text-center"
              , if t.highlighted 
                  then "bg-orange-400 text-background hover:bg-orange-400/90"
                  else "border border-border text-text hover:bg-card"
              ]
        ]
        [ HH.text t.cta ]
    ]

pricingFeature :: forall w i. String -> HH.HTML w i
pricingFeature feature =
  HH.li
    [ cls [ "flex items-start gap-2 text-sm" ] ]
    [ HH.span [ cls [ "text-orange-400 mt-0.5" ] ] [ HH.text "+" ]
    , HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text feature ]
    ]

-- ============================================================
-- CALCULATOR
-- ============================================================

calculator :: forall w i. HH.HTML w i
calculator =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "max-w-[800px] mx-auto px-6" ] ]
        [ HH.h2
            [ cls [ "text-2xl font-bold text-text mb-8 text-center" ] ]
            [ HH.text "Cost breakdown" ]
        , HH.div
            [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
            [ HH.div
                [ cls [ "space-y-4" ] ]
                [ costRow "Your vendor costs" "Pay directly to OpenAI, Anthropic, etc." "$X"
                , costRow "omega//boost fee" "Our infrastructure margin" "+ $0.0005/req"
                , costRow "Savings from batching" "Automatic request batching" "- 30-60%"
                , costRow "Savings from caching" "KV cache sharing" "- 20-50%"
                ]
            , HH.div
                [ cls [ "mt-6 pt-6 border-t border-border" ] ]
                [ HH.div
                    [ cls [ "flex justify-between items-center" ] ]
                    [ HH.span [ cls [ "text-text font-medium" ] ] [ HH.text "Net result" ]
                    , HH.span [ cls [ "text-green-400 font-bold" ] ] [ HH.text "Often lower than direct API" ]
                    ]
                ]
            ]
        , HH.p
            [ cls [ "text-center text-muted-foreground text-sm mt-4" ] ]
            [ HH.text "Actual savings vary based on usage patterns. Contact us for a detailed analysis." ]
        ]
    ]

costRow :: forall w i. String -> String -> String -> HH.HTML w i
costRow label description amount =
  HH.div
    [ cls [ "flex items-center justify-between" ] ]
    [ HH.div_
        [ HH.p [ cls [ "text-text" ] ] [ HH.text label ]
        , HH.p [ cls [ "text-sm text-muted-foreground" ] ] [ HH.text description ]
        ]
    , HH.span [ cls [ "text-text font-mono" ] ] [ HH.text amount ]
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
                "Do I still pay my API provider?"
                "Yes. omega//boost is a BYOK (bring your own key) service. You continue to pay OpenAI, Anthropic, or your other providers directly. We only charge for our infrastructure margin."
            , faqItem
                "How does batching reduce costs?"
                "We automatically batch compatible requests together before sending to your provider. This can reduce your per-request costs by 30-60% depending on your traffic patterns."
            , faqItem
                "What's included in the free tier?"
                "100k requests per month through omega//boost, 2 API key slots, basic analytics, and community support. Perfect for trying us out or small projects."
            , faqItem
                "Can I switch plans anytime?"
                "Yes. Upgrade or downgrade at any time. Changes take effect immediately. We prorate refunds for downgrades."
            , faqItem
                "What happens if I exceed my request limit?"
                "On Starter, you're billed $0.001/request over the limit. On Pro, it's $0.0005/request. We'll notify you before any overage charges."
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
            [ HH.text "We work with enterprises on custom deployments, volume pricing, and integrations. Let's talk." ]
        , HH.a
            [ HP.href "mailto:sales@straylight.dev"
            , cls [ "inline-flex items-center justify-center px-6 py-3 bg-orange-400 text-background font-medium rounded-md hover:bg-orange-400/90 transition-colors" ]
            ]
            [ HH.text "Contact sales" ]
        ]
    ]
