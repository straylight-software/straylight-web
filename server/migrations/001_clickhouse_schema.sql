-- ═══════════════════════════════════════════════════════════════════════════════
-- STRAYLIGHT // WEB - ClickHouse Analytics Schema
-- ═══════════════════════════════════════════════════════════════════════════════
--
-- Analytics and time-series data for all 10 Straylight products.
-- Run against ClickHouse (local or cloud).

-- ═══════════════════════════════════════════════════════════════════════════════
-- COMMON EVENT TABLES
-- ═══════════════════════════════════════════════════════════════════════════════

-- API events (management API calls across all products)
CREATE TABLE IF NOT EXISTS api_events
(
    org_id       LowCardinality(String),
    product      LowCardinality(String),    -- cache, build, code, etc
    user_id      String,
    endpoint     LowCardinality(String),
    method       Enum8('GET' = 1, 'POST' = 2, 'PUT' = 3, 'PATCH' = 4, 'DELETE' = 5),
    status_code  UInt16,
    duration_ms  UInt32,
    client_ip    IPv4,
    timestamp    DateTime64(3, 'UTC'),
    event_id     UUID DEFAULT generateUUIDv4()
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(timestamp)
ORDER BY (org_id, product, timestamp, event_id)
TTL toDateTime(timestamp) + INTERVAL 90 DAY;

-- Audit events (compliance logging across all products)
CREATE TABLE IF NOT EXISTS audit_events
(
    org_id       LowCardinality(String),
    product      LowCardinality(String),
    actor_id     String,
    actor_email  String,
    action       LowCardinality(String),
    target_type  LowCardinality(String),
    target_id    String,
    metadata     String,
    timestamp    DateTime64(3, 'UTC'),
    event_id     UUID DEFAULT generateUUIDv4()
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(timestamp)
ORDER BY (org_id, timestamp, event_id)
TTL toDateTime(timestamp) + INTERVAL 2 YEAR;

-- ═══════════════════════════════════════════════════════════════════════════════
-- sensenet//cache EVENTS
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS cache_events
(
    org_id       LowCardinality(String),
    cache_id     String,
    event_type   Enum8('push' = 1, 'pull' = 2, 'hit' = 3, 'miss' = 4),
    store_path   String,
    nar_hash     String,
    nar_size     UInt64,
    client_ip    IPv4,
    user_agent   LowCardinality(String),
    region       LowCardinality(String),
    duration_ms  UInt32,
    timestamp    DateTime64(3, 'UTC'),
    event_id     UUID DEFAULT generateUUIDv4()
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(timestamp)
ORDER BY (org_id, cache_id, timestamp, event_id)
TTL toDateTime(timestamp) + INTERVAL 90 DAY;

-- Cache stats materialized views
CREATE MATERIALIZED VIEW IF NOT EXISTS cache_stats_hourly
ENGINE = SummingMergeTree()
PARTITION BY toYYYYMM(hour)
ORDER BY (org_id, cache_id, hour, event_type)
AS SELECT
    org_id,
    cache_id,
    toStartOfHour(timestamp) AS hour,
    event_type,
    count() AS event_count,
    sum(nar_size) AS total_bytes,
    avg(duration_ms) AS avg_duration_ms
FROM cache_events
GROUP BY org_id, cache_id, hour, event_type;

CREATE MATERIALIZED VIEW IF NOT EXISTS cache_stats_daily
ENGINE = SummingMergeTree()
PARTITION BY toYYYYMM(day)
ORDER BY (org_id, cache_id, day, event_type)
AS SELECT
    org_id,
    cache_id,
    toStartOfDay(timestamp) AS day,
    event_type,
    count() AS event_count,
    sum(nar_size) AS total_bytes,
    avg(duration_ms) AS avg_duration_ms
FROM cache_events
GROUP BY org_id, cache_id, day, event_type;

-- ═══════════════════════════════════════════════════════════════════════════════
-- sensenet//build EVENTS
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS build_events
(
    org_id         LowCardinality(String),
    build_id       String,
    cache_id       String,
    event_type     Enum8('queued' = 1, 'started' = 2, 'completed' = 3, 'failed' = 4, 'cancelled' = 5),
    name           String,
    flake_ref      Nullable(String),
    commit         Nullable(String),
    branch         Nullable(String),
    duration_ms    UInt32,
    paths_built    UInt32,
    paths_cached   UInt32,
    paths_uploaded UInt32,
    exit_code      Nullable(Int16),
    error_message  Nullable(String),
    triggered_by   LowCardinality(String),
    timestamp      DateTime64(3, 'UTC'),
    event_id       UUID DEFAULT generateUUIDv4()
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(timestamp)
ORDER BY (org_id, build_id, timestamp, event_id)
TTL toDateTime(timestamp) + INTERVAL 90 DAY;

CREATE MATERIALIZED VIEW IF NOT EXISTS build_stats_daily
ENGINE = SummingMergeTree()
PARTITION BY toYYYYMM(day)
ORDER BY (org_id, day, outcome)
AS SELECT
    org_id,
    toStartOfDay(timestamp) AS day,
    multiIf(event_type = 'completed', 'success', event_type = 'failed', 'failed', event_type = 'cancelled', 'cancelled', 'other') AS outcome,
    count() AS build_count,
    sum(duration_ms) AS total_duration_ms,
    sum(paths_built) AS total_paths_built,
    sum(paths_cached) AS total_paths_cached
FROM build_events
WHERE event_type IN ('completed', 'failed', 'cancelled')
GROUP BY org_id, day, outcome;

-- ═══════════════════════════════════════════════════════════════════════════════
-- omega//code EVENTS
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS agent_events
(
    org_id         LowCardinality(String),
    session_id     String,
    user_id        String,
    event_type     Enum8('message' = 1, 'tool_call' = 2, 'tool_result' = 3, 'error' = 4),
    model          LowCardinality(String),
    input_tokens   UInt32,
    output_tokens  UInt32,
    duration_ms    UInt32,
    tool_name      Nullable(String),
    timestamp      DateTime64(3, 'UTC'),
    event_id       UUID DEFAULT generateUUIDv4()
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(timestamp)
ORDER BY (org_id, session_id, timestamp, event_id)
TTL toDateTime(timestamp) + INTERVAL 90 DAY;

CREATE MATERIALIZED VIEW IF NOT EXISTS agent_usage_daily
ENGINE = SummingMergeTree()
PARTITION BY toYYYYMM(day)
ORDER BY (org_id, day, model)
AS SELECT
    org_id,
    toStartOfDay(timestamp) AS day,
    model,
    count() AS message_count,
    sum(input_tokens) AS total_input_tokens,
    sum(output_tokens) AS total_output_tokens,
    sum(duration_ms) AS total_duration_ms
FROM agent_events
WHERE event_type = 'message'
GROUP BY org_id, day, model;

-- ═══════════════════════════════════════════════════════════════════════════════
-- omega//proxy EVENTS
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS proxy_events
(
    org_id         LowCardinality(String),
    endpoint_id    String,
    provider       LowCardinality(String),
    model          LowCardinality(String),
    input_tokens   UInt32,
    output_tokens  UInt32,
    latency_ms     UInt32,
    cached         UInt8,
    verified       UInt8,
    status_code    UInt16,
    timestamp      DateTime64(3, 'UTC'),
    event_id       UUID DEFAULT generateUUIDv4()
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(timestamp)
ORDER BY (org_id, endpoint_id, timestamp, event_id)
TTL toDateTime(timestamp) + INTERVAL 90 DAY;

CREATE MATERIALIZED VIEW IF NOT EXISTS proxy_usage_hourly
ENGINE = SummingMergeTree()
PARTITION BY toYYYYMM(hour)
ORDER BY (org_id, hour, provider, model)
AS SELECT
    org_id,
    toStartOfHour(timestamp) AS hour,
    provider,
    model,
    count() AS request_count,
    sum(input_tokens) AS total_input_tokens,
    sum(output_tokens) AS total_output_tokens,
    avg(latency_ms) AS avg_latency_ms,
    countIf(cached = 1) AS cache_hits
FROM proxy_events
GROUP BY org_id, hour, provider, model;

-- ═══════════════════════════════════════════════════════════════════════════════
-- omega//boost EVENTS
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS inference_events
(
    org_id         LowCardinality(String),
    model_id       String,
    job_id         String,
    status         Enum8('queued' = 1, 'running' = 2, 'completed' = 3, 'failed' = 4),
    input_tokens   UInt32,
    output_tokens  UInt32,
    latency_ms     UInt32,
    gpu_type       LowCardinality(String),
    timestamp      DateTime64(3, 'UTC'),
    event_id       UUID DEFAULT generateUUIDv4()
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(timestamp)
ORDER BY (org_id, model_id, timestamp, event_id)
TTL toDateTime(timestamp) + INTERVAL 90 DAY;

CREATE MATERIALIZED VIEW IF NOT EXISTS inference_stats_hourly
ENGINE = SummingMergeTree()
PARTITION BY toYYYYMM(hour)
ORDER BY (org_id, hour, model_id, gpu_type)
AS SELECT
    org_id,
    toStartOfHour(timestamp) AS hour,
    model_id,
    gpu_type,
    count() AS job_count,
    countIf(status = 'completed') AS completed_count,
    countIf(status = 'failed') AS failed_count,
    sum(input_tokens) AS total_input_tokens,
    sum(output_tokens) AS total_output_tokens,
    avg(latency_ms) AS avg_latency_ms
FROM inference_events
WHERE status IN ('completed', 'failed')
GROUP BY org_id, hour, model_id, gpu_type;
