-- | omega//work Pricing Page
module Straylight.Pages.Products.OmegaWork.Pricing 
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
            [ HH.text "One app, one price. No hidden fees, no usage limits, no surprise bills." ]
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
                { name: "Personal"
                , price: "$19"
                , period: "/month"
                , description: "For individual creators and hobbyists."
                , features:
                    [ "Full desktop app"
                    , "Unlimited conversations"
                    , "All agent capabilities"
                    , "Local-first storage"
                    , "Email support"
                    ]
                , cta: "Join waitlist"
                , ctaHref: "/omega/work/waitlist?plan=personal"
                , highlighted: false
                }
            , pricingCard
                { name: "Pro"
                , price: "$39"
                , period: "/month"
                , description: "For professionals who rely on AI daily."
                , features:
                    [ "Everything in Personal"
                    , "Cloud sync across devices"
                    , "Priority model access"
                    , "Export to all formats"
                    , "Priority support"
                    , "Early access to features"
                    ]
                , cta: "Join waitlist"
                , ctaHref: "/omega/work/waitlist?plan=pro"
                , highlighted: true
                }
            , pricingCard
                { name: "Team"
                , price: "$29"
                , period: "/user/month"
                , description: "For teams working together."
                , features:
                    [ "Everything in Pro"
                    , "Shared workspaces"
                    , "Team management"
                    , "SSO/SAML"
                    , "Admin dashboard"
                    , "Dedicated support"
                    ]
                , cta: "Contact sales"
                , ctaHref: "/omega/work/contact"
                , highlighted: false
                }
            ]
        , HH.p
            [ cls [ "text-center text-muted-foreground text-sm mt-8" ] ]
            [ HH.text "All plans include: Native app for macOS, Windows, and Linux. BYOK (bring your own key) option available." ]
        ]
    ]

type PricingCardProps =
  { name :: String
  , price :: String
  , period :: String
  , description :: String
  , features :: Array String
  , cta :: String
  , ctaHref :: String
  , highlighted :: Boolean
  }

pricingCard :: forall w i. PricingCardProps -> HH.HTML w i
pricingCard props =
  HH.div
    [ cls [ "bg-card border rounded-lg p-6"
          , if props.highlighted then "border-amber-400" else "border-border"
          ]
    ]
    [ if props.highlighted
        then HH.div
            [ cls [ "text-xs text-amber-400 font-medium mb-4" ] ]
            [ HH.text "MOST POPULAR" ]
        else HH.text ""
    , HH.h3
        [ cls [ "text-lg font-semibold text-text mb-2" ] ]
        [ HH.text props.name ]
    , HH.div
        [ cls [ "mb-4" ] ]
        [ HH.span [ cls [ "text-3xl font-bold text-text" ] ] [ HH.text props.price ]
        , HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text props.period ]
        ]
    , HH.p
        [ cls [ "text-sm text-muted-foreground mb-6" ] ]
        [ HH.text props.description ]
    , HH.ul
        [ cls [ "space-y-2 mb-6" ] ]
        (map featureItem props.features)
    , HH.a
        [ HP.href props.ctaHref
        , cls [ "block w-full py-3 text-center font-medium rounded-md transition-colors"
              , if props.highlighted 
                  then "bg-amber-400 text-background hover:bg-amber-400/90" 
                  else "border border-border text-text hover:bg-card"
              ]
        ]
        [ HH.text props.cta ]
    ]

featureItem :: forall w i. String -> HH.HTML w i
featureItem feature =
  HH.li
    [ cls [ "flex items-start gap-2 text-sm" ] ]
    [ HH.span [ cls [ "text-amber-400" ] ] [ HH.text "+" ]
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
                "Do I need to pay for an AI API separately?"
                "omega//work includes AI access in the subscription. You can also bring your own API key (OpenAI, Anthropic, etc.) if you prefer."
            , faqItem
                "What platforms are supported?"
                "omega//work runs natively on macOS (Intel and Apple Silicon), Windows 10/11, and Linux (Ubuntu, Fedora, Arch)."
            , faqItem
                "Can I use it offline?"
                "The app works offline for viewing and organizing your projects. AI features require an internet connection."
            , faqItem
                "How is this different from omega//code?"
                "omega//code is a terminal-based tool for developers. omega//work is a GUI app for everyone. Both use the same agent engine."
            , faqItem
                "Is there a free trial?"
                "Yes! All plans include a 14-day free trial. No credit card required to start."
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
            [ HH.text "We work with enterprises on custom deployments, volume licensing, and dedicated support. Let's talk." ]
        , HH.a
            [ HP.href "mailto:enterprise@straylight.software"
            , cls [ "inline-flex items-center justify-center px-6 py-3 bg-amber-400 text-background font-medium rounded-md hover:bg-amber-400/90 transition-colors" ]
            ]
            [ HH.text "Contact sales" ]
        ]
    ]
