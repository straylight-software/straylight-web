-- | omega//boost Features Page
-- | Complete feature showcase for managed inference
module Straylight.Pages.Products.OmegaBoost.Features 
  ( featuresPage
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

featuresPage :: forall q i o m. H.Component q i o m
featuresPage = H.mkComponent
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
    , byokArchitecture
    , evringStack
    , batching
    , caching
    , observability
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
        [ HH.h1
            [ cls [ "text-4xl md:text-6xl font-bold text-text mb-6 leading-tight" ] ]
            [ HH.text "Everything you need"
            , HH.br_
            , HH.text "for managed inference"
            ]
        , HH.p
            [ cls [ "text-xl text-muted-foreground max-w-2xl mx-auto" ] ]
            [ HH.text "BYOK architecture. evring HTTP stack. Intelligent batching. KV cache sharing. Enterprise-grade observability." ]
        ]
    ]

-- ============================================================
-- BYOK ARCHITECTURE
-- ============================================================

byokArchitecture :: forall w i. HH.HTML w i
byokArchitecture =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "max-w-[1100px] mx-auto px-6" ] ]
        [ HH.div
            [ cls [ "grid grid-cols-1 lg:grid-cols-2 gap-16 items-center" ] ]
            [ -- Left: content
              HH.div_
                [ badge "BYOK Architecture"
                , HH.h2
                    [ cls [ "text-3xl font-bold text-text mb-6" ] ]
                    [ HH.text "Your keys, your billing" ]
                , HH.p
                    [ cls [ "text-muted-foreground mb-6" ] ]
                    [ HH.text "Bring your existing API keys from OpenAI, Anthropic, Google, or any provider. omega//boost never stores your raw credentials - we use encrypted key references through our secure vault." ]
                , featureList
                    [ "Zero vendor lock-in - switch providers anytime"
                    , "Your billing stays with your vendor"
                    , "Encrypted key storage in secure vault"
                    , "Per-key usage tracking and analytics"
                    , "Automatic key rotation support"
                    ]
                ]
            , -- Right: visual
              HH.div
                [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
                [ HH.div
                    [ cls [ "space-y-4" ] ]
                    [ vendorRow "OpenAI" "sk-***...abc" "active"
                    , vendorRow "Anthropic" "sk-ant-***...xyz" "active"
                    , vendorRow "Google" "AIza***...def" "pending"
                    ]
                , HH.p
                    [ cls [ "text-sm text-muted-foreground mt-6 text-center" ] ]
                    [ HH.text "Manage all your keys in one place" ]
                ]
            ]
        ]
    ]

vendorRow :: forall w i. String -> String -> String -> HH.HTML w i
vendorRow vendor key status =
  HH.div
    [ cls [ "flex items-center justify-between p-3 bg-background rounded-md" ] ]
    [ HH.div
        [ cls [ "flex items-center gap-3" ] ]
        [ HH.span [ cls [ "text-text font-medium" ] ] [ HH.text vendor ]
        , HH.code [ cls [ "text-xs text-muted-foreground font-mono" ] ] [ HH.text key ]
        ]
    , HH.span
        [ cls [ "text-xs px-2 py-0.5 rounded"
              , if status == "active" then "bg-green-500/20 text-green-400" else "bg-yellow-500/20 text-yellow-400"
              ]
        ]
        [ HH.text status ]
    ]

-- ============================================================
-- EVRING STACK
-- ============================================================

evringStack :: forall w i. HH.HTML w i
evringStack =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "max-w-[1100px] mx-auto px-6" ] ]
        [ HH.div
            [ cls [ "grid grid-cols-1 lg:grid-cols-2 gap-16 items-center" ] ]
            [ -- Left: visual (code)
              HH.div
                [ cls [ "order-2 lg:order-1" ] ]
                [ codeBlock
                    [ codeLine "// " "evring HTTP stack"
                    , codeLine "" "io_uring event loop"
                    , codeLine "" "zero-copy buffers"
                    , codeLine "" "linear multi-core scaling"
                    , HH.text "\n"
                    , codeLine "// " "Performance"
                    , codeLine "" "509,000 req/s per core"
                    , codeLine "" "< 10ms p99 latency"
                    , codeLine "" "99.99% uptime SLA"
                    ]
                ]
            , -- Right: content
              HH.div
                [ cls [ "order-1 lg:order-2" ] ]
                [ badge "evring HTTP Stack"
                , HH.h2
                    [ cls [ "text-3xl font-bold text-text mb-6" ] ]
                    [ HH.text "509k requests per second" ]
                , HH.p
                    [ cls [ "text-muted-foreground mb-6" ] ]
                    [ HH.text "omega//boost is built on evring, our high-performance HTTP stack. io_uring event loop, zero-copy buffers, and linear multi-core scaling. The same infrastructure powering omega//proxy." ]
                , featureList
                    [ "io_uring for async I/O without syscall overhead"
                    , "Zero-copy request/response handling"
                    , "Linear scaling across all available cores"
                    , "Co-located with major inference providers"
                    , "Global anycast routing for optimal latency"
                    ]
                ]
            ]
        ]
    ]

-- ============================================================
-- BATCHING
-- ============================================================

batching :: forall w i. HH.HTML w i
batching =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "max-w-[1100px] mx-auto px-6" ] ]
        [ HH.div
            [ cls [ "grid grid-cols-1 lg:grid-cols-2 gap-16 items-center" ] ]
            [ -- Left: content
              HH.div_
                [ badge "Intelligent Batching"
                , HH.h2
                    [ cls [ "text-3xl font-bold text-text mb-6" ] ]
                    [ HH.text "Automatic request batching" ]
                , HH.p
                    [ cls [ "text-muted-foreground mb-6" ] ]
                    [ HH.text "omega//boost automatically batches compatible requests to maximize throughput and minimize costs. Works seamlessly with streaming responses - you get the same latency with better efficiency." ]
                , featureList
                    [ "Automatic batching of compatible requests"
                    , "Streaming-compatible batch processing"
                    , "Configurable batch windows (1-100ms)"
                    , "Per-request priority support"
                    , "Detailed batch analytics"
                    ]
                ]
            , -- Right: visual
              HH.div
                [ cls [ "bg-card border border-border rounded-lg p-6" ] ]
                [ HH.div
                    [ cls [ "space-y-3" ] ]
                    [ batchVisual "Request 1" 50 "batched"
                    , batchVisual "Request 2" 75 "batched"
                    , batchVisual "Request 3" 25 "batched"
                    ]
                , HH.div
                    [ cls [ "mt-4 pt-4 border-t border-border text-center" ] ]
                    [ HH.span [ cls [ "text-sm text-muted-foreground" ] ] [ HH.text "3 requests -> 1 batch" ]
                    , HH.span [ cls [ "text-sm text-orange-400 ml-2" ] ] [ HH.text "67% cost reduction" ]
                    ]
                ]
            ]
        ]
    ]

batchVisual :: forall w i. String -> Int -> String -> HH.HTML w i
batchVisual label size status =
  HH.div
    [ cls [ "flex items-center gap-3" ] ]
    [ HH.div
        [ cls [ "flex-1 h-8 bg-background rounded overflow-hidden" ] ]
        [ HH.div
            [ cls [ "h-full bg-orange-400/30 rounded" ]
            , HP.style $ "width: " <> show size <> "%"
            ]
            []
        ]
    , HH.span [ cls [ "text-xs text-muted-foreground w-20" ] ] [ HH.text label ]
    , HH.span [ cls [ "text-xs text-green-400" ] ] [ HH.text status ]
    ]

-- ============================================================
-- CACHING
-- ============================================================

caching :: forall w i. HH.HTML w i
caching =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "max-w-[1100px] mx-auto px-6" ] ]
        [ HH.div
            [ cls [ "grid grid-cols-1 lg:grid-cols-2 gap-16 items-center" ] ]
            [ -- Left: visual
              HH.div
                [ cls [ "order-2 lg:order-1 bg-card border border-border rounded-lg p-6" ] ]
                [ HH.div
                    [ cls [ "space-y-4" ] ]
                    [ cacheRow "System prompt" "2.1k tokens" "cached"
                    , cacheRow "Few-shot examples" "1.8k tokens" "cached"
                    , cacheRow "User message" "156 tokens" "new"
                    ]
                , HH.div
                    [ cls [ "mt-4 pt-4 border-t border-border" ] ]
                    [ HH.div
                        [ cls [ "flex justify-between text-sm" ] ]
                        [ HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text "Tokens cached" ]
                        , HH.span [ cls [ "text-orange-400" ] ] [ HH.text "3.9k (95%)" ]
                        ]
                    , HH.div
                        [ cls [ "flex justify-between text-sm mt-1" ] ]
                        [ HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text "Cost savings" ]
                        , HH.span [ cls [ "text-green-400" ] ] [ HH.text "~$0.008/request" ]
                        ]
                    ]
                ]
            , -- Right: content
              HH.div
                [ cls [ "order-1 lg:order-2" ] ]
                [ badge "KV Cache Sharing"
                , HH.h2
                    [ cls [ "text-3xl font-bold text-text mb-6" ] ]
                    [ HH.text "Share caches across requests" ]
                , HH.p
                    [ cls [ "text-muted-foreground mb-6" ] ]
                    [ HH.text "Repeated system prompts? Few-shot examples? omega//boost shares KV caches across requests, dramatically reducing costs and latency for common patterns." ]
                , featureList
                    [ "Automatic prompt prefix matching"
                    , "Cross-request cache sharing"
                    , "Compatible with OpenAI and Anthropic caching"
                    , "Per-organization cache isolation"
                    , "Configurable cache TTL"
                    ]
                ]
            ]
        ]
    ]

cacheRow :: forall w i. String -> String -> String -> HH.HTML w i
cacheRow label tokens status =
  HH.div
    [ cls [ "flex items-center justify-between p-3 bg-background rounded-md" ] ]
    [ HH.div_
        [ HH.span [ cls [ "text-text text-sm" ] ] [ HH.text label ]
        , HH.span [ cls [ "text-xs text-muted-foreground ml-2" ] ] [ HH.text tokens ]
        ]
    , HH.span
        [ cls [ "text-xs px-2 py-0.5 rounded"
              , if status == "cached" then "bg-green-500/20 text-green-400" else "bg-blue-500/20 text-blue-400"
              ]
        ]
        [ HH.text status ]
    ]

-- ============================================================
-- OBSERVABILITY
-- ============================================================

observability :: forall w i. HH.HTML w i
observability =
  HH.section
    [ cls [ "py-24 border-t border-border" ] ]
    [ HH.div
        [ cls [ "max-w-[1100px] mx-auto px-6" ] ]
        [ HH.div
            [ cls [ "text-center mb-16" ] ]
            [ badge "Observability"
            , HH.h2
                [ cls [ "text-3xl font-bold text-text mb-4" ] ]
                [ HH.text "Full visibility into your inference" ]
            , HH.p
                [ cls [ "text-muted-foreground max-w-2xl mx-auto" ] ]
                [ HH.text "Real-time metrics, request tracing, and cost analytics. Know exactly what's happening with every request." ]
            ]
        , HH.div
            [ cls [ "grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6" ] ]
            [ observabilityCard ">" "Request tracing" "End-to-end traces for every request"
            , observabilityCard "$" "Cost analytics" "Per-request and aggregate cost tracking"
            , observabilityCard "!" "Real-time metrics" "Latency, throughput, error rates"
            , observabilityCard "=" "Usage reports" "Daily, weekly, monthly breakdowns"
            ]
        ]
    ]

observabilityCard :: forall w i. String -> String -> String -> HH.HTML w i
observabilityCard icon title description =
  HH.div
    [ cls [ "bg-card border border-border rounded-lg p-6 text-center hover:border-orange-400/30 transition-colors" ] ]
    [ HH.div [ cls [ "text-2xl text-orange-400 mb-3 font-mono" ] ] [ HH.text icon ]
    , HH.p [ cls [ "text-text font-medium mb-1" ] ] [ HH.text title ]
    , HH.p [ cls [ "text-sm text-muted-foreground" ] ] [ HH.text description ]
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
            [ HH.a
                [ HP.href "/omega/boost/dashboard"
                , cls [ "inline-flex items-center justify-center px-8 py-4 bg-orange-400 text-background font-medium rounded-md hover:bg-orange-400/90 transition-colors" ]
                ]
                [ HH.text "Get started" ]
            , HH.a
                [ HP.href "/omega/boost/docs"
                , cls [ "inline-flex items-center justify-center px-8 py-4 border border-border text-text font-medium rounded-md hover:bg-card transition-colors" ]
                ]
                [ HH.text "Read the docs" ]
            ]
        ]
    ]

-- ============================================================
-- HELPERS
-- ============================================================

badge :: forall w i. String -> HH.HTML w i
badge label =
  HH.span
    [ cls [ "inline-block px-3 py-1 bg-orange-400/10 border border-orange-400/20 rounded-full text-orange-400 text-sm font-medium mb-4" ] ]
    [ HH.text label ]

featureList :: forall w i. Array String -> HH.HTML w i
featureList items =
  HH.ul
    [ cls [ "space-y-3" ] ]
    (map featureItem items)

featureItem :: forall w i. String -> HH.HTML w i
featureItem text =
  HH.li
    [ cls [ "flex items-start gap-3" ] ]
    [ HH.span [ cls [ "text-orange-400 mt-1" ] ] [ HH.text "+" ]
    , HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text text ]
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
