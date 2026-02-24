-- | omega//boost Legal Pages
-- | Privacy Policy, Terms of Service, Contact
module Straylight.Pages.Products.OmegaBoost.Legal 
  ( privacyPage
  , termsPage
  , contactPage
  -- For SSG
  , renderPrivacy
  , renderTerms
  , renderContact
  ) where

import Prelude

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

import Straylight.UI (cls)

-- ============================================================
-- PRIVACY PAGE
-- ============================================================

privacyPage :: forall q i o m. H.Component q i o m
privacyPage = H.mkComponent
  { initialState: const unit
  , render: const renderPrivacy
  , eval: H.mkEval H.defaultEval
  }

renderPrivacy :: forall w i. HH.HTML w i
renderPrivacy =
  HH.div
    [ cls [ "max-w-[800px] mx-auto px-6 py-12" ] ]
    [ HH.h1
        [ cls [ "text-3xl font-bold text-text mb-8" ] ]
        [ HH.text "Privacy Policy" ]
    , HH.div
        [ cls [ "prose prose-invert max-w-none space-y-6" ] ]
        [ section "Last updated" "February 2026"
        , section "Overview"
            "omega//boost is operated by Straylight Software. This privacy policy explains how we collect, use, and protect your information when you use our managed inference service."
        , section "Information We Collect"
            "We collect information you provide directly: email address, organization name, and billing information when you create an account. We also collect usage data: request volumes, latency metrics, and API usage for billing, analytics, and service improvement. We do NOT store or log the content of your API requests or responses."
        , section "API Keys and Credentials"
            "Your provider API keys (OpenAI, Anthropic, etc.) are encrypted at rest using AES-256-GCM. Keys are decrypted only at request time in isolated memory and are never logged or persisted in plaintext. We use a BYOK (bring your own key) model - your billing relationship remains directly with your providers."
        , section "How We Use Your Information"
            "We use your information to: provide and maintain the service, process payments, send service notifications, generate usage analytics, and improve our product. We do not sell your personal information."
        , section "Data Retention"
            "We retain account data while your account is active. Request metadata (timestamps, latencies, token counts) is retained for 90 days for analytics. You can request deletion of your data at any time."
        , section "Third-Party Services"
            "We use: Clerk for authentication, Stripe for payments, and various cloud providers for infrastructure. Each has their own privacy policy. Your API requests are proxied to your chosen providers (OpenAI, Anthropic, etc.) who have their own data practices."
        , section "Security"
            "We implement industry-standard security measures including encryption in transit (TLS 1.3), encryption at rest, and regular security audits. We do not store request/response content."
        , section "Contact"
            "Questions? Email privacy@straylight.dev"
        ]
    ]

-- ============================================================
-- TERMS PAGE
-- ============================================================

termsPage :: forall q i o m. H.Component q i o m
termsPage = H.mkComponent
  { initialState: const unit
  , render: const renderTerms
  , eval: H.mkEval H.defaultEval
  }

renderTerms :: forall w i. HH.HTML w i
renderTerms =
  HH.div
    [ cls [ "max-w-[800px] mx-auto px-6 py-12" ] ]
    [ HH.h1
        [ cls [ "text-3xl font-bold text-text mb-8" ] ]
        [ HH.text "Terms of Service" ]
    , HH.div
        [ cls [ "prose prose-invert max-w-none space-y-6" ] ]
        [ section "Last updated" "February 2026"
        , section "Acceptance"
            "By using omega//boost, you agree to these terms. If you don't agree, don't use the service."
        , section "Service Description"
            "omega//boost provides a managed inference proxy service. We route your AI API requests through our infrastructure to provide batching, caching, and performance optimizations. We do not provide AI models directly - you must bring your own API keys from supported providers."
        , section "BYOK Model"
            "omega//boost operates on a Bring Your Own Key (BYOK) model. You are responsible for: maintaining valid API keys with your providers, complying with your providers' terms of service, and paying your providers directly for API usage. We are responsible for: our infrastructure margin only."
        , section "Your Responsibilities"
            "You're responsible for: keeping your omega//boost API keys secure, keeping your provider API keys secure, not using the service for illegal purposes, and complying with applicable laws and your providers' acceptable use policies."
        , section "Acceptable Use"
            "Don't use the service to: distribute malware, violate laws, abuse our infrastructure, interfere with other users, or circumvent your providers' rate limits or terms. We may suspend accounts that violate these terms."
        , section "Billing"
            "Paid plans are billed monthly in advance. Overage charges are billed monthly in arrears. We'll notify you before charging. You can cancel anytime - access continues until the end of your billing period."
        , section "No Content Responsibility"
            "We do not control, endorse, or take responsibility for the content of requests or responses that pass through omega//boost. You are solely responsible for the content you send through the service and must comply with your providers' content policies."
        , section "Limitation of Liability"
            "We provide the service \"as is\". We're not liable for: data loss, service interruptions, provider outages, indirect damages, or issues arising from your providers. Our total liability is limited to the fees you paid in the preceding 12 months."
        , section "Changes"
            "We may update these terms. Continued use after changes means you accept them. We'll notify you of material changes."
        , section "Contact"
            "Questions? Email legal@straylight.dev"
        ]
    ]

-- ============================================================
-- CONTACT PAGE
-- ============================================================

contactPage :: forall q i o m. H.Component q i o m
contactPage = H.mkComponent
  { initialState: const unit
  , render: const renderContact
  , eval: H.mkEval H.defaultEval
  }

renderContact :: forall w i. HH.HTML w i
renderContact =
  HH.div
    [ cls [ "max-w-[800px] mx-auto px-6 py-24" ] ]
    [ HH.div
        [ cls [ "text-center mb-12" ] ]
        [ HH.h1
            [ cls [ "text-3xl font-bold text-text mb-4" ] ]
            [ HH.text "Get in touch" ]
        , HH.p
            [ cls [ "text-muted-foreground" ] ]
            [ HH.text "We'd love to hear from you." ]
        ]
    , HH.div
        [ cls [ "grid grid-cols-1 md:grid-cols-3 gap-8" ] ]
        [ contactCard "General" "hello@straylight.dev" "Questions, feedback, partnerships"
        , contactCard "Enterprise" "sales@straylight.dev" "Custom deployments, volume pricing, SLAs"
        , contactCard "Support" "support@straylight.dev" "Technical issues, billing questions"
        ]
    , HH.div
        [ cls [ "mt-16 text-center" ] ]
        [ HH.p
            [ cls [ "text-muted-foreground mb-4" ] ]
            [ HH.text "Or find us on:" ]
        , HH.div
            [ cls [ "flex justify-center gap-6" ] ]
            [ socialLink "https://github.com/straylight-software" "GitHub"
            , socialLink "https://discord.gg/straylight" "Discord"
            , socialLink "https://twitter.com/straylightsw" "Twitter"
            ]
        ]
    , HH.div
        [ cls [ "mt-16 p-6 bg-card border border-border rounded-lg text-center" ] ]
        [ HH.h3
            [ cls [ "text-lg font-semibold text-text mb-2" ] ]
            [ HH.text "Enterprise inquiries" ]
        , HH.p
            [ cls [ "text-muted-foreground mb-4" ] ]
            [ HH.text "Need custom integrations, dedicated support, or volume pricing?" ]
        , HH.a
            [ HP.href "mailto:sales@straylight.dev"
            , cls [ "inline-flex items-center justify-center px-6 py-3 bg-orange-400 text-background font-medium rounded-md hover:bg-orange-400/90 transition-colors" ]
            ]
            [ HH.text "Contact Sales" ]
        ]
    ]

contactCard :: forall w i. String -> String -> String -> HH.HTML w i
contactCard title email description =
  HH.div
    [ cls [ "bg-card border border-border rounded-lg p-6 text-center" ] ]
    [ HH.h3
        [ cls [ "text-lg font-semibold text-text mb-2" ] ]
        [ HH.text title ]
    , HH.a
        [ HP.href $ "mailto:" <> email
        , cls [ "text-orange-400 hover:text-orange-400/80 block mb-2" ]
        ]
        [ HH.text email ]
    , HH.p
        [ cls [ "text-sm text-muted-foreground" ] ]
        [ HH.text description ]
    ]

socialLink :: forall w i. String -> String -> HH.HTML w i
socialLink href label =
  HH.a
    [ HP.href href
    , HP.target "_blank"
    , HP.rel "noopener noreferrer"
    , cls [ "text-muted-foreground hover:text-text transition-colors" ]
    ]
    [ HH.text label ]

-- ============================================================
-- HELPERS
-- ============================================================

section :: forall w i. String -> String -> HH.HTML w i
section title content =
  HH.div_
    [ HH.h2
        [ cls [ "text-lg font-semibold text-text mb-2" ] ]
        [ HH.text title ]
    , HH.p
        [ cls [ "text-muted-foreground" ] ]
        [ HH.text content ]
    ]
