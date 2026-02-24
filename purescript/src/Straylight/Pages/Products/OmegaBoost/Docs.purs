-- | omega//boost Documentation
-- | Complete docs for managed inference
module Straylight.Pages.Products.OmegaBoost.Docs 
  ( docsPage
  , renderContent
  , sidebar
  -- For SSG
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
            [ sidebarLink "/omega/boost/docs" "Overview" currentPath
            , sidebarLink "/omega/boost/docs/quickstart" "Quick Start" currentPath
            , sidebarLink "/omega/boost/docs/byok" "BYOK Setup" currentPath
            ]
        , sidebarSection "Integration"
            [ sidebarLink "/omega/boost/docs/openai" "OpenAI" currentPath
            , sidebarLink "/omega/boost/docs/anthropic" "Anthropic" currentPath
            , sidebarLink "/omega/boost/docs/streaming" "Streaming" currentPath
            ]
        , sidebarSection "Features"
            [ sidebarLink "/omega/boost/docs/batching" "Batching" currentPath
            , sidebarLink "/omega/boost/docs/caching" "KV Cache" currentPath
            , sidebarLink "/omega/boost/docs/analytics" "Analytics" currentPath
            ]
        , sidebarSection "Reference"
            [ sidebarLink "/omega/boost/docs/api" "API Reference" currentPath
            , sidebarLink "/omega/boost/docs/errors" "Error Handling" currentPath
            , sidebarLink "/omega/boost/docs/limits" "Rate Limits" currentPath
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
                  then "bg-orange-400/10 text-orange-400 font-medium" 
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
  "/omega/boost/docs" -> overviewContent
  "/omega/boost/docs/quickstart" -> quickstartContent
  "/omega/boost/docs/byok" -> byokContent
  "/omega/boost/docs/openai" -> openaiContent
  "/omega/boost/docs/anthropic" -> anthropicContent
  "/omega/boost/docs/streaming" -> streamingContent
  "/omega/boost/docs/batching" -> batchingContent
  "/omega/boost/docs/caching" -> cachingContent
  "/omega/boost/docs/analytics" -> analyticsContent
  "/omega/boost/docs/api" -> apiContent
  "/omega/boost/docs/errors" -> errorsContent
  "/omega/boost/docs/limits" -> limitsContent
  _ -> overviewContent

-- ============================================================
-- OVERVIEW
-- ============================================================

overviewContent :: forall w i. HH.HTML w i
overviewContent =
  article
    [ h1 "omega//boost Documentation"
    , p "Managed inference co-located with your BYOK vendor. evring HTTP stack for maximum throughput."
    
    , HH.div
        [ cls [ "grid grid-cols-1 md:grid-cols-2 gap-4 my-8" ] ]
        [ docCard "/omega/boost/docs/quickstart" "Quick Start" "Get up and running in under a minute."
        , docCard "/omega/boost/docs/byok" "BYOK Setup" "Configure your API keys securely."
        , docCard "/omega/boost/docs/openai" "OpenAI Integration" "Drop-in replacement for OpenAI API."
        , docCard "/omega/boost/docs/api" "API Reference" "Full endpoint documentation."
        ]
    
    , h2 "What is omega//boost?"
    , p "omega//boost is a managed inference proxy that sits between your application and your AI providers. Bring your own API keys, and we add a performance layer: automatic batching, KV cache sharing, and co-located infrastructure for minimal latency."
    
    , h2 "Key Features"
    , HH.ul
        [ cls [ "space-y-2 text-muted-foreground mb-6" ] ]
        [ li' "BYOK Architecture - Use your existing API keys, keep your billing relationship"
        , li' "evring HTTP Stack - 509k req/s throughput, <10ms p99 latency"
        , li' "Automatic Batching - Batch compatible requests for cost savings"
        , li' "KV Cache Sharing - Share prompt caches across requests"
        , li' "Full Observability - Request tracing, cost analytics, usage reports"
        ]
    
    , h2 "Quick example"
    , codeBlock
        [ codeLine "# " "Switch from OpenAI direct to omega//boost"
        , codeLine "" "client = OpenAI("
        , codeLine "" "    base_url=\"https://boost.omega.dev/v1\","
        , codeLine "" "    api_key=os.environ[\"OPENAI_API_KEY\"]"
        , codeLine "" ")"
        ]
    ]

-- ============================================================
-- QUICKSTART
-- ============================================================

quickstartContent :: forall w i. HH.HTML w i
quickstartContent =
  article
    [ h1 "Quick Start"
    , p "Get omega//boost working in under a minute."
    
    , h2 "1. Create an account"
    , p "Sign up at straylight.dev and navigate to the omega//boost dashboard."
    
    , h2 "2. Add your API key"
    , p "Add your OpenAI, Anthropic, or other provider API key through our secure vault."
    , codeBlock
        [ codeLine "# " "In your dashboard, add your key:"
        , codeLine "" "Provider: OpenAI"
        , codeLine "" "Key: sk-..."
        , codeLine "" "Label: production"
        ]
    
    , h2 "3. Update your base URL"
    , codeBlock
        [ codeLine "# " "Python with OpenAI SDK"
        , codeLine "" "from openai import OpenAI"
        , HH.text "\n"
        , codeLine "" "client = OpenAI("
        , codeLine "" "    base_url=\"https://boost.omega.dev/v1\","
        , codeLine "" "    api_key=\"your-openai-key\"  # or via env"
        , codeLine "" ")"
        , HH.text "\n"
        , codeLine "" "response = client.chat.completions.create("
        , codeLine "" "    model=\"gpt-4-turbo-preview\","
        , codeLine "" "    messages=[{\"role\": \"user\", \"content\": \"Hello!\"}]"
        , codeLine "" ")"
        ]
    
    , h2 "4. Verify it works"
    , codeBlock
        [ codeLine "$ " "curl https://boost.omega.dev/v1/models \\"
        , codeLine "" "  -H \"Authorization: Bearer $OPENAI_API_KEY\""
        ]
    
    , h2 "Next steps"
    , HH.ul
        [ cls [ "space-y-2 text-muted-foreground" ] ]
        [ li link "/omega/boost/docs/batching" "Configure automatic batching"
        , li link "/omega/boost/docs/caching" "Enable KV cache sharing"
        , li link "/omega/boost/docs/analytics" "View your analytics dashboard"
        ]
    ]

-- ============================================================
-- BYOK CONTENT
-- ============================================================

byokContent :: forall w i. HH.HTML w i
byokContent =
  article
    [ h1 "BYOK Setup"
    , p "Bring your own API keys from any supported provider."
    
    , h2 "Supported Providers"
    , HH.ul
        [ cls [ "space-y-2 text-muted-foreground mb-6" ] ]
        [ li' "OpenAI (GPT-4, GPT-3.5, embeddings)"
        , li' "Anthropic (Claude 3, Claude 2)"
        , li' "Google (Gemini Pro, Gemini Ultra)"
        , li' "Mistral AI"
        , li' "Cohere"
        , li' "Custom OpenAI-compatible endpoints"
        ]
    
    , h2 "Adding Keys"
    , p "Navigate to Dashboard > Settings > API Keys. Click 'Add Key' and enter:"
    , HH.ul
        [ cls [ "space-y-2 text-muted-foreground mb-6" ] ]
        [ li' "Provider - Select from the dropdown"
        , li' "Key - Your API key (we encrypt this immediately)"
        , li' "Label - A friendly name for this key"
        ]
    
    , h2 "Key Security"
    , p "Your API keys are encrypted at rest using AES-256-GCM. We never log or store raw keys. Keys are decrypted only at request time in isolated memory."
    
    , h2 "Key Rotation"
    , p "To rotate a key, add the new key first, then delete the old one. There's no downtime during rotation."
    ]

-- ============================================================
-- OPENAI CONTENT
-- ============================================================

openaiContent :: forall w i. HH.HTML w i
openaiContent =
  article
    [ h1 "OpenAI Integration"
    , p "omega//boost is a drop-in replacement for the OpenAI API."
    
    , h2 "Python SDK"
    , codeBlock
        [ codeLine "" "from openai import OpenAI"
        , HH.text "\n"
        , codeLine "" "client = OpenAI("
        , codeLine "" "    base_url=\"https://boost.omega.dev/v1\""
        , codeLine "" ")"
        , HH.text "\n"
        , codeLine "# " "Everything else works exactly the same"
        , codeLine "" "response = client.chat.completions.create("
        , codeLine "" "    model=\"gpt-4-turbo-preview\","
        , codeLine "" "    messages=[{\"role\": \"user\", \"content\": \"Hello!\"}]"
        , codeLine "" ")"
        ]
    
    , h2 "Node.js SDK"
    , codeBlock
        [ codeLine "" "import OpenAI from 'openai';"
        , HH.text "\n"
        , codeLine "" "const client = new OpenAI({"
        , codeLine "" "  baseURL: 'https://boost.omega.dev/v1'"
        , codeLine "" "});"
        ]
    
    , h2 "Supported Endpoints"
    , HH.ul
        [ cls [ "space-y-2 text-muted-foreground mb-6" ] ]
        [ li' "/v1/chat/completions"
        , li' "/v1/completions"
        , li' "/v1/embeddings"
        , li' "/v1/models"
        ]
    
    , h2 "Headers"
    , p "omega//boost passes through all OpenAI headers. Additional headers:"
    , codeBlock
        [ codeLine "" "X-Boost-Batch: true|false    # Force batch mode"
        , codeLine "" "X-Boost-Cache: true|false    # Enable KV caching"
        , codeLine "" "X-Boost-Priority: 1-10       # Request priority"
        ]
    ]

-- ============================================================
-- ANTHROPIC CONTENT
-- ============================================================

anthropicContent :: forall w i. HH.HTML w i
anthropicContent =
  article
    [ h1 "Anthropic Integration"
    , p "Full support for Claude models through omega//boost."
    
    , h2 "Python SDK"
    , codeBlock
        [ codeLine "" "import anthropic"
        , HH.text "\n"
        , codeLine "" "client = anthropic.Anthropic("
        , codeLine "" "    base_url=\"https://boost.omega.dev/anthropic\""
        , codeLine "" ")"
        , HH.text "\n"
        , codeLine "" "message = client.messages.create("
        , codeLine "" "    model=\"claude-3-opus-20240229\","
        , codeLine "" "    max_tokens=1024,"
        , codeLine "" "    messages=[{\"role\": \"user\", \"content\": \"Hello!\"}]"
        , codeLine "" ")"
        ]
    
    , h2 "Supported Models"
    , HH.ul
        [ cls [ "space-y-2 text-muted-foreground mb-6" ] ]
        [ li' "claude-3-opus-20240229"
        , li' "claude-3-sonnet-20240229"
        , li' "claude-3-haiku-20240307"
        , li' "claude-2.1"
        , li' "claude-2.0"
        ]
    ]

-- ============================================================
-- STREAMING CONTENT
-- ============================================================

streamingContent :: forall w i. HH.HTML w i
streamingContent =
  article
    [ h1 "Streaming"
    , p "omega//boost fully supports streaming responses."
    
    , h2 "OpenAI Streaming"
    , codeBlock
        [ codeLine "" "stream = client.chat.completions.create("
        , codeLine "" "    model=\"gpt-4-turbo-preview\","
        , codeLine "" "    messages=[{\"role\": \"user\", \"content\": \"Hello!\"}],"
        , codeLine "" "    stream=True"
        , codeLine "" ")"
        , HH.text "\n"
        , codeLine "" "for chunk in stream:"
        , codeLine "" "    print(chunk.choices[0].delta.content, end=\"\")"
        ]
    
    , h2 "Batching with Streaming"
    , p "Streaming requests can still be batched. We buffer the initial prompt processing and stream the response tokens. This means you get the same streaming experience with batching cost savings."
    ]

-- ============================================================
-- BATCHING CONTENT
-- ============================================================

batchingContent :: forall w i. HH.HTML w i
batchingContent =
  article
    [ h1 "Automatic Batching"
    , p "omega//boost automatically batches compatible requests for cost savings."
    
    , h2 "How It Works"
    , p "Requests with the same model and compatible parameters are grouped into batches. We hold requests for a configurable window (default: 10ms) to collect batch candidates."
    
    , h2 "Configuration"
    , codeBlock
        [ codeLine "# " "Via header"
        , codeLine "" "X-Boost-Batch-Window: 50  # milliseconds"
        , HH.text "\n"
        , codeLine "# " "Via dashboard"
        , codeLine "" "Settings > Batching > Window: 10-100ms"
        ]
    
    , h2 "Cost Savings"
    , p "Typical savings from batching:"
    , HH.ul
        [ cls [ "space-y-2 text-muted-foreground mb-6" ] ]
        [ li' "High traffic (>100 req/s): 40-60% savings"
        , li' "Medium traffic (10-100 req/s): 20-40% savings"
        , li' "Low traffic (<10 req/s): 0-10% savings"
        ]
    ]

-- ============================================================
-- CACHING CONTENT
-- ============================================================

cachingContent :: forall w i. HH.HTML w i
cachingContent =
  article
    [ h1 "KV Cache Sharing"
    , p "Share prompt caches across requests for significant cost reduction."
    
    , h2 "How It Works"
    , p "When multiple requests share the same prompt prefix (e.g., system prompt), we cache the KV states and reuse them. This reduces both latency and cost."
    
    , h2 "Enable Caching"
    , codeBlock
        [ codeLine "# " "Via header"
        , codeLine "" "X-Boost-Cache: true"
        , HH.text "\n"
        , codeLine "# " "Via dashboard"
        , codeLine "" "Settings > Caching > Enable: true"
        ]
    
    , h2 "Cache TTL"
    , p "Default cache TTL is 5 minutes. Configure via dashboard or header:"
    , codeBlock
        [ codeLine "" "X-Boost-Cache-TTL: 300  # seconds"
        ]
    ]

-- ============================================================
-- ANALYTICS CONTENT
-- ============================================================

analyticsContent :: forall w i. HH.HTML w i
analyticsContent =
  article
    [ h1 "Analytics"
    , p "Full visibility into your inference usage."
    
    , h2 "Dashboard"
    , p "Access your analytics at Dashboard > Analytics. View:"
    , HH.ul
        [ cls [ "space-y-2 text-muted-foreground mb-6" ] ]
        [ li' "Request volume over time"
        , li' "Latency percentiles (p50, p95, p99)"
        , li' "Cost breakdown by model"
        , li' "Batch efficiency metrics"
        , li' "Cache hit rates"
        ]
    
    , h2 "API Access"
    , codeBlock
        [ codeLine "" "GET /v1/analytics/usage"
        , codeLine "" "GET /v1/analytics/costs"
        , codeLine "" "GET /v1/analytics/latency"
        ]
    ]

-- ============================================================
-- API CONTENT
-- ============================================================

apiContent :: forall w i. HH.HTML w i
apiContent =
  article
    [ h1 "API Reference"
    , p "Complete API documentation for omega//boost."
    
    , h2 "Base URL"
    , codeBlock
        [ codeLine "" "https://boost.omega.dev"
        ]
    
    , h2 "Authentication"
    , p "Pass your provider API key in the Authorization header:"
    , codeBlock
        [ codeLine "" "Authorization: Bearer sk-your-api-key"
        ]
    
    , h2 "Endpoints"
    , p "omega//boost proxies all standard provider endpoints. Additional endpoints:"
    , codeBlock
        [ codeLine "" "GET  /v1/health          # Health check"
        , codeLine "" "GET  /v1/analytics/*     # Usage analytics"
        , codeLine "" "POST /v1/keys            # Manage API keys"
        ]
    ]

-- ============================================================
-- ERRORS CONTENT
-- ============================================================

errorsContent :: forall w i. HH.HTML w i
errorsContent =
  article
    [ h1 "Error Handling"
    , p "omega//boost passes through provider errors and adds boost-specific codes."
    
    , h2 "Boost Error Codes"
    , HH.ul
        [ cls [ "space-y-2 text-muted-foreground mb-6" ] ]
        [ li' "BOOST_RATE_LIMITED - omega//boost rate limit exceeded"
        , li' "BOOST_KEY_INVALID - Invalid or expired API key in vault"
        , li' "BOOST_PROVIDER_ERROR - Upstream provider error"
        , li' "BOOST_BATCH_TIMEOUT - Batch window exceeded"
        ]
    
    , h2 "Retries"
    , p "omega//boost automatically retries transient errors with exponential backoff. Configure via header:"
    , codeBlock
        [ codeLine "" "X-Boost-Retries: 3  # max retries (default: 3)"
        ]
    ]

-- ============================================================
-- LIMITS CONTENT
-- ============================================================

limitsContent :: forall w i. HH.HTML w i
limitsContent =
  article
    [ h1 "Rate Limits"
    , p "omega//boost rate limits by plan."
    
    , h2 "Limits by Plan"
    , HH.ul
        [ cls [ "space-y-2 text-muted-foreground mb-6" ] ]
        [ li' "Starter: 100 req/s, 100k req/month"
        , li' "Pro: 1000 req/s, 1M req/month included"
        , li' "Enterprise: Custom"
        ]
    
    , h2 "Headers"
    , p "Rate limit info is included in response headers:"
    , codeBlock
        [ codeLine "" "X-RateLimit-Limit: 1000"
        , codeLine "" "X-RateLimit-Remaining: 999"
        , codeLine "" "X-RateLimit-Reset: 1708012800"
        ]
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

li :: forall w i. (forall w' i'. String -> String -> HH.HTML w' i') -> String -> String -> HH.HTML w i
li f href text = HH.li_ [ f href text ]

link :: forall w i. String -> String -> HH.HTML w i
link href text = 
  HH.a 
    [ HP.href href
    , cls [ "text-orange-400 hover:text-orange-400/80" ]
    ] 
    [ HH.text text ]

docCard :: forall w i. String -> String -> String -> HH.HTML w i
docCard href title description =
  HH.a
    [ HP.href href
    , cls [ "block p-4 bg-card border border-border rounded-lg hover:border-orange-400/50 transition-colors" ]
    ]
    [ HH.h3
        [ cls [ "text-text font-medium mb-1" ] ]
        [ HH.text title ]
    , HH.p
        [ cls [ "text-muted-foreground text-sm" ] ]
        [ HH.text description ]
    ]

codeBlock :: forall w i. Array (HH.HTML w i) -> HH.HTML w i
codeBlock children =
  HH.pre
    [ cls [ "bg-card border border-border p-4 rounded-lg overflow-x-auto text-sm leading-relaxed mb-6" ] ]
    children

codeLine :: forall w i. String -> String -> HH.HTML w i
codeLine prefix content =
  HH.div_
    [ HH.span [ cls [ "text-muted-foreground" ] ] [ HH.text prefix ]
    , HH.span [ cls [ "text-text" ] ] [ HH.text content ]
    ]
