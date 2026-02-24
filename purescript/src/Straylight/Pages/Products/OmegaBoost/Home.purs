-- | omega//boost Home Page
-- | Managed inference co-located with BYOK vendor. evring HTTP stack.
module Straylight.Pages.Products.OmegaBoost.Home 
  ( homePage
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

homePage :: forall q i o m. H.Component q i o m
homePage = H.mkComponent
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
    , features
    , howItWorks
    , integration
    , cta
    ]

-- ============================================================
-- HERO
-- ============================================================

hero :: forall w i. HH.HTML w i
hero =
  HH.section
    [ cls [ "py-24 md:py-32" ] ]
    [ HH.div
        [ cls [ "max-w-[1100px] mx-auto px-6 text-center" ] ]
        [ -- Badge
          HH.div
            [ cls [ "inline-flex items-center gap-2 px-3 py-1 bg-orange-400/10 border border-orange-400/20 rounded-full text-orange-400 text-sm mb-8" ] ]
            [ HH.span [ cls [ "w-2 h-2 bg-orange-400 rounded-full animate-pulse" ] ] []
            , HH.text "Co-located inference"
            ]
        , -- Headline
          HH.h1
            [ cls [ "text-4xl md:text-6xl font-bold text-text mb-6 leading-tight" ] ]
            [ HH.text "BYOK inference,"
            , HH.br_
            , HH.text "zero "
            , HH.span [ cls [ "text-orange-400" ] ] [ HH.text "latency" ]
            ]
        , -- Subheadline
          HH.p
            [ cls [ "text-xl text-muted-foreground mb-10 max-w-2xl mx-auto" ] ]
            [ HH.text "Bring your own API keys. We co-locate inference with your vendor. evring HTTP stack for 509k req/s throughput. Managed batching, caching, and routing." ]
        , -- CTAs
          HH.div
            [ cls [ "flex flex-col sm:flex-row items-center justify-center gap-4" ] ]
            [ primaryButton "/omega/boost/pricing" "View pricing"
            , secondaryButton "/omega/boost/docs" "Read the docs"
            ]
        , -- Key metrics
          HH.div
            [ cls [ "mt-12 flex flex-col sm:flex-row items-center justify-center gap-8" ] ]
            [ metricBadge "509k" "req/s"
            , metricBadge "BYOK" "your keys"
            , metricBadge "<10ms" "p99 latency"
            ]
        , -- Social proof
          HH.p
            [ cls [ "mt-8 font-mono text-sm text-muted-foreground" ] ]
            [ HH.span [ cls [ "text-orange-400/60" ] ] [ HH.text "powered by " ]
            , HH.text "evring HTTP stack"
            ]
        ]
    ]

metricBadge :: forall w i. String -> String -> HH.HTML w i
metricBadge value label =
  HH.div
    [ cls [ "flex items-baseline gap-2" ] ]
    [ HH.span [ cls [ "text-3xl font-bold text-orange-400" ] ] [ HH.text value ]
    , HH.span [ cls [ "text-muted-foreground text-sm" ] ] [ HH.text label ]
    ]

-- ============================================================
-- FEATURES
-- ============================================================

features :: forall w i. HH.HTML w i
features =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "max-w-[1100px] mx-auto px-6" ] ]
        [ HH.div
            [ cls [ "text-center mb-16" ] ]
            [ HH.h2
                [ cls [ "text-3xl font-bold text-text mb-4" ] ]
                [ HH.text "Why omega//boost?" ]
            , HH.p
                [ cls [ "text-muted-foreground max-w-xl mx-auto" ] ]
                [ HH.text "Keep your existing API keys. We add the performance layer." ]
            ]
        , HH.div
            [ cls [ "grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6" ] ]
            [ featureCard "~" "BYOK architecture"
                "Bring your own API keys from OpenAI, Anthropic, or any provider. Your credentials, your billing, our infrastructure."
            , featureCard ">>" "Co-located inference"
                "We run evring proxies in the same regions as your vendors. Minimal network hops, maximum throughput."
            , featureCard "!!" "evring HTTP stack"
                "io_uring event loop. Zero-copy buffers. 509k req/s per core. The same stack powering omega//proxy."
            , featureCard "&&" "Automatic batching"
                "We batch requests intelligently. Same latency, lower costs. Compatible with all streaming responses."
            , featureCard "==" "KV cache sharing"
                "Share prompt caches across requests. Significant cost reduction for repeated system prompts."
            , featureCard "$" "Transparent pricing"
                "Pay only for our infrastructure margin. Your API costs stay with your vendor."
            ]
        ]
    ]

featureCard :: forall w i. String -> String -> String -> HH.HTML w i
featureCard icon title description =
  HH.div
    [ cls [ "p-6 bg-card border border-border rounded-lg hover:border-orange-400/30 transition-colors" ] ]
    [ HH.div
        [ cls [ "text-2xl text-orange-400 mb-4 font-mono" ] ]
        [ HH.text icon ]
    , HH.h3
        [ cls [ "text-text text-lg font-semibold mb-2" ] ]
        [ HH.text title ]
    , HH.p
        [ cls [ "text-muted-foreground text-sm" ] ]
        [ HH.text description ]
    ]

-- ============================================================
-- HOW IT WORKS
-- ============================================================

howItWorks :: forall w i. HH.HTML w i
howItWorks =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "max-w-[1100px] mx-auto px-6" ] ]
        [ HH.div
            [ cls [ "text-center mb-16" ] ]
            [ HH.h2
                [ cls [ "text-3xl font-bold text-text mb-4" ] ]
                [ HH.text "How it works" ]
            , HH.p
                [ cls [ "text-muted-foreground max-w-xl mx-auto" ] ]
                [ HH.text "Three steps to co-located inference." ]
            ]
        , HH.div
            [ cls [ "grid grid-cols-1 md:grid-cols-3 gap-8" ] ]
            [ stepCard "01" "Connect your keys"
                "Add your OpenAI, Anthropic, or other provider API keys through our secure vault. We never see your raw keys."
            , stepCard "02" "Point to our endpoint"
                "Replace api.openai.com with boost.omega.dev. Same API, same responses, better performance."
            , stepCard "03" "Scale automatically"
                "We handle batching, caching, retries, and failover. You focus on building."
            ]
        ]
    ]

stepCard :: forall w i. String -> String -> String -> HH.HTML w i
stepCard step title description =
  HH.div
    [ cls [ "text-center" ] ]
    [ HH.div
        [ cls [ "text-5xl font-bold text-orange-400/20 mb-4 font-mono" ] ]
        [ HH.text step ]
    , HH.h3
        [ cls [ "text-text text-lg font-semibold mb-2" ] ]
        [ HH.text title ]
    , HH.p
        [ cls [ "text-muted-foreground text-sm" ] ]
        [ HH.text description ]
    ]

-- ============================================================
-- INTEGRATION
-- ============================================================

integration :: forall w i. HH.HTML w i
integration =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "max-w-[800px] mx-auto px-6" ] ]
        [ HH.div
            [ cls [ "text-center mb-12" ] ]
            [ HH.h2
                [ cls [ "text-3xl font-bold text-text mb-4" ] ]
                [ HH.text "One line to switch" ]
            ]
        , codeBlock
            [ codeLine "# " "Before: direct to OpenAI"
            , codeLine "" "client = OpenAI(base_url=\"https://api.openai.com/v1\")"
            , HH.text "\n"
            , codeLine "# " "After: through omega//boost"
            , codeLine "" "client = OpenAI(base_url=\"https://boost.omega.dev/v1\")"
            , HH.text "\n"
            , codeLine "# " "Same API, same responses, better performance"
            ]
        , HH.div
            [ cls [ "mt-8 text-center" ] ]
            [ HH.a
                [ HP.href "/omega/boost/docs"
                , cls [ "text-orange-400 hover:text-orange-400/80 transition-colors" ]
                ]
                [ HH.text "View full integration guide ->" ]
            ]
        ]
    ]

codeBlock :: forall w i. Array (HH.HTML w i) -> HH.HTML w i
codeBlock children =
  HH.pre
    [ cls [ "bg-card border border-border p-4 rounded-lg overflow-x-auto text-sm leading-relaxed" ] ]
    children

codeLine :: forall w i. String -> String -> HH.HTML w i
codeLine prefix content =
  HH.div_
    [ HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text prefix ]
    , HH.span [ cls [ "text-text" ] ] [ HH.text content ]
    ]

-- ============================================================
-- CTA
-- ============================================================

cta :: forall w i. HH.HTML w i
cta =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "max-w-[800px] mx-auto px-6 text-center" ] ]
        [ HH.h2
            [ cls [ "text-3xl font-bold text-text mb-4" ] ]
            [ HH.text "Ready to boost your inference?" ]
        , HH.p
            [ cls [ "text-muted-foreground mb-8" ] ]
            [ HH.text "Keep your API keys. Add our performance layer. Start in minutes." ]
        , HH.div
            [ cls [ "flex flex-col sm:flex-row items-center justify-center gap-4" ] ]
            [ primaryButton "/omega/boost/dashboard" "Get started"
            , secondaryButton "/omega/boost/pricing" "View pricing"
            ]
        ]
    ]

-- ============================================================
-- HELPERS
-- ============================================================

primaryButton :: forall w i. String -> String -> HH.HTML w i
primaryButton href label =
  HH.a
    [ HP.href href
    , cls [ "inline-flex items-center justify-center px-6 py-3 bg-orange-400 text-background font-medium rounded-md hover:bg-orange-400/90 transition-colors" ]
    ]
    [ HH.text label ]

secondaryButton :: forall w i. String -> String -> HH.HTML w i
secondaryButton href label =
  HH.a
    [ HP.href href
    , cls [ "inline-flex items-center justify-center px-6 py-3 border border-border text-text font-medium rounded-md hover:bg-card transition-colors" ]
    ]
    [ HH.text label ]
