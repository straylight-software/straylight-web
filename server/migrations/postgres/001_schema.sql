-- ═══════════════════════════════════════════════════════════════════════════════
-- STRAYLIGHT // WEB - PostgreSQL Schema
-- ═══════════════════════════════════════════════════════════════════════════════
--
-- Core relational data for all 10 Straylight products.
-- Analytics/time-series data stays in ClickHouse.
--
-- Products:
--   sensenet: cache, build, converge, confirm, forge, publish
--   omega: code, work, proxy, boost

-- ═══════════════════════════════════════════════════════════════════════════════
-- EXTENSIONS
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE EXTENSION IF NOT EXISTS "pgcrypto";  -- For gen_random_uuid()

-- ═══════════════════════════════════════════════════════════════════════════════
-- ENUM TYPES
-- ═══════════════════════════════════════════════════════════════════════════════

-- Common enums
CREATE TYPE team_role AS ENUM ('owner', 'admin', 'member');
CREATE TYPE api_scope AS ENUM ('read', 'write', 'admin');
CREATE TYPE subscription_tier AS ENUM ('free', 'starter', 'pro', 'enterprise');

-- sensenet//cache
CREATE TYPE cache_status AS ENUM ('active', 'maintenance', 'gc_running');

-- sensenet//build
CREATE TYPE build_status AS ENUM ('pending', 'running', 'success', 'failed', 'cancelled');

-- sensenet//converge
CREATE TYPE drift_status AS ENUM ('in_sync', 'drifted', 'applying', 'error');

-- sensenet//confirm
CREATE TYPE check_status AS ENUM ('pending', 'running', 'passed', 'failed', 'skipped');

-- sensenet//forge
CREATE TYPE review_status AS ENUM ('draft', 'pending_review', 'changes_requested', 'approved', 'merged', 'closed');

-- omega//code
CREATE TYPE agent_status AS ENUM ('idle', 'thinking', 'executing', 'awaiting_input', 'error');

-- omega//work
CREATE TYPE workspace_type AS ENUM ('personal', 'team', 'shared');

-- omega//proxy
CREATE TYPE model_provider AS ENUM ('anthropic', 'openai', 'google', 'mistral', 'local');

-- omega//boost
CREATE TYPE inference_status AS ENUM ('queued', 'running', 'completed', 'failed');

-- ═══════════════════════════════════════════════════════════════════════════════
-- CORE TABLES (shared across all products)
-- ═══════════════════════════════════════════════════════════════════════════════

-- Organizations (multi-tenant root)
CREATE TABLE organizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    tier subscription_tier NOT NULL DEFAULT 'free',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Users (Clerk-managed, we store minimal profile)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    clerk_id TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE,
    first_name TEXT,
    last_name TEXT,
    avatar_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Team memberships (org + user + role)
CREATE TABLE team_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role team_role NOT NULL DEFAULT 'member',
    joined_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    last_active TIMESTAMPTZ,
    UNIQUE(org_id, user_id)
);

-- API keys (shared across products)
CREATE TABLE api_keys (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    product TEXT NOT NULL,  -- 'cache', 'build', 'code', etc.
    name TEXT NOT NULL,
    key_hash TEXT NOT NULL,
    prefix TEXT NOT NULL,
    scopes api_scope[] NOT NULL DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    last_used TIMESTAMPTZ,
    expires_at TIMESTAMPTZ
);

-- Audit log (for compliance)
CREATE TABLE audit_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    product TEXT NOT NULL,
    actor_id TEXT NOT NULL,
    actor_email TEXT,
    action TEXT NOT NULL,
    target_type TEXT,
    target_id TEXT,
    details TEXT NOT NULL,
    metadata JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ═══════════════════════════════════════════════════════════════════════════════
-- sensenet//cache TABLES
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE caches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    is_private BOOLEAN NOT NULL DEFAULT true,
    status cache_status NOT NULL DEFAULT 'active',
    size_bytes BIGINT NOT NULL DEFAULT 0,
    path_count INTEGER NOT NULL DEFAULT 0,
    last_push TIMESTAMPTZ,
    public_key TEXT NOT NULL,
    signing_key_encrypted TEXT,
    substituter_url TEXT NOT NULL,
    retention_days INTEGER NOT NULL DEFAULT 30,
    max_size_bytes BIGINT NOT NULL DEFAULT 10737418240,
    gc_enabled BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(org_id, name)
);

CREATE TABLE store_paths (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cache_id UUID NOT NULL REFERENCES caches(id) ON DELETE CASCADE,
    hash TEXT NOT NULL,
    name TEXT NOT NULL,
    version TEXT NOT NULL DEFAULT '',
    size_bytes BIGINT NOT NULL,
    nar_size_bytes BIGINT NOT NULL,
    closure_size_bytes BIGINT NOT NULL DEFAULT 0,
    deriver TEXT,
    registration_time TIMESTAMPTZ NOT NULL DEFAULT now(),
    nar_hash TEXT NOT NULL,
    signatures TEXT[] NOT NULL DEFAULT '{}',
    ca TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(cache_id, hash)
);

CREATE TABLE store_path_refs (
    from_path_id UUID NOT NULL REFERENCES store_paths(id) ON DELETE CASCADE,
    to_path_id UUID NOT NULL REFERENCES store_paths(id) ON DELETE CASCADE,
    PRIMARY KEY (from_path_id, to_path_id)
);

-- ═══════════════════════════════════════════════════════════════════════════════
-- sensenet//build TABLES
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE builds (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    cache_id UUID REFERENCES caches(id) ON DELETE SET NULL,
    name TEXT NOT NULL,
    flake_ref TEXT,
    status build_status NOT NULL DEFAULT 'pending',
    duration_ms INTEGER,
    start_time TIMESTAMPTZ,
    end_time TIMESTAMPTZ,
    commit_sha TEXT,
    branch TEXT,
    paths_built INTEGER NOT NULL DEFAULT 0,
    paths_cached INTEGER NOT NULL DEFAULT 0,
    paths_uploaded INTEGER NOT NULL DEFAULT 0,
    exit_code INTEGER,
    error_message TEXT,
    triggered_by TEXT NOT NULL,
    log_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ═══════════════════════════════════════════════════════════════════════════════
-- sensenet//converge TABLES
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE resources (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    resource_type TEXT NOT NULL,
    name TEXT NOT NULL,
    desired_state JSONB NOT NULL,
    actual_state JSONB,
    drift_status drift_status NOT NULL DEFAULT 'in_sync',
    last_sync TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(org_id, resource_type, name)
);

CREATE TABLE deployments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    environment TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    config JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    completed_at TIMESTAMPTZ
);

-- ═══════════════════════════════════════════════════════════════════════════════
-- sensenet//confirm TABLES
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE pipelines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    repository TEXT NOT NULL,
    config JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE pipeline_runs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pipeline_id UUID NOT NULL REFERENCES pipelines(id) ON DELETE CASCADE,
    commit_sha TEXT NOT NULL,
    branch TEXT,
    status check_status NOT NULL DEFAULT 'pending',
    start_time TIMESTAMPTZ,
    end_time TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE checks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    run_id UUID NOT NULL REFERENCES pipeline_runs(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    status check_status NOT NULL DEFAULT 'pending',
    output TEXT,
    proof_hash TEXT,
    start_time TIMESTAMPTZ,
    end_time TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ═══════════════════════════════════════════════════════════════════════════════
-- sensenet//forge TABLES
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE repositories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    default_branch TEXT NOT NULL DEFAULT 'main',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(org_id, name)
);

CREATE TABLE stacks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    repo_id UUID NOT NULL REFERENCES repositories(id) ON DELETE CASCADE,
    author_id UUID NOT NULL REFERENCES users(id),
    title TEXT NOT NULL,
    description TEXT,
    base_branch TEXT NOT NULL,
    status review_status NOT NULL DEFAULT 'draft',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE diffs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    stack_id UUID NOT NULL REFERENCES stacks(id) ON DELETE CASCADE,
    sequence INTEGER NOT NULL,
    branch TEXT NOT NULL,
    title TEXT NOT NULL,
    commit_sha TEXT,
    status review_status NOT NULL DEFAULT 'draft',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(stack_id, sequence)
);

CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    diff_id UUID NOT NULL REFERENCES diffs(id) ON DELETE CASCADE,
    reviewer_id UUID NOT NULL REFERENCES users(id),
    status TEXT NOT NULL,
    body TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ═══════════════════════════════════════════════════════════════════════════════
-- sensenet//publish TABLES
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE doc_sites (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    subdomain TEXT NOT NULL UNIQUE,
    custom_domain TEXT,
    theme JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE doc_pages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    site_id UUID NOT NULL REFERENCES doc_sites(id) ON DELETE CASCADE,
    path TEXT NOT NULL,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    scope_graph JSONB,
    published BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(site_id, path)
);

-- ═══════════════════════════════════════════════════════════════════════════════
-- omega//code TABLES
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE agent_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id),
    name TEXT,
    directory TEXT NOT NULL,
    status agent_status NOT NULL DEFAULT 'idle',
    model TEXT NOT NULL DEFAULT 'claude-sonnet-4-20250514',
    total_tokens INTEGER NOT NULL DEFAULT 0,
    total_cost_cents INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    last_active TIMESTAMPTZ
);

CREATE TABLE agent_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES agent_sessions(id) ON DELETE CASCADE,
    role TEXT NOT NULL,
    content TEXT NOT NULL,
    tool_calls JSONB,
    token_count INTEGER,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ═══════════════════════════════════════════════════════════════════════════════
-- omega//work TABLES
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE workspaces (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    owner_id UUID NOT NULL REFERENCES users(id),
    name TEXT NOT NULL,
    workspace_type workspace_type NOT NULL DEFAULT 'personal',
    config JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID NOT NULL REFERENCES workspaces(id) ON DELETE CASCADE,
    title TEXT,
    model TEXT NOT NULL DEFAULT 'claude-sonnet-4-20250514',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
    role TEXT NOT NULL,
    content TEXT NOT NULL,
    attachments JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ═══════════════════════════════════════════════════════════════════════════════
-- omega//proxy TABLES
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE endpoints (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    provider model_provider NOT NULL,
    model TEXT NOT NULL,
    max_tokens INTEGER,
    temperature REAL,
    rate_limit_rpm INTEGER,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE proxy_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    endpoint_id UUID NOT NULL REFERENCES endpoints(id) ON DELETE CASCADE,
    input_tokens INTEGER NOT NULL,
    output_tokens INTEGER NOT NULL,
    latency_ms INTEGER NOT NULL,
    cached BOOLEAN NOT NULL DEFAULT false,
    verified BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ═══════════════════════════════════════════════════════════════════════════════
-- omega//boost TABLES
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE models (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    base_model TEXT NOT NULL,
    quantization TEXT,
    config JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(org_id, name)
);

CREATE TABLE inference_jobs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    model_id UUID NOT NULL REFERENCES models(id) ON DELETE CASCADE,
    status inference_status NOT NULL DEFAULT 'queued',
    input JSONB NOT NULL,
    output JSONB,
    input_tokens INTEGER,
    output_tokens INTEGER,
    latency_ms INTEGER,
    gpu_type TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    completed_at TIMESTAMPTZ
);

-- ═══════════════════════════════════════════════════════════════════════════════
-- INDEXES
-- ═══════════════════════════════════════════════════════════════════════════════

-- Organizations
CREATE INDEX idx_organizations_slug ON organizations(slug);

-- Users
CREATE INDEX idx_users_clerk_id ON users(clerk_id);
CREATE INDEX idx_users_email ON users(email);

-- Team members
CREATE INDEX idx_team_members_org_id ON team_members(org_id);
CREATE INDEX idx_team_members_user_id ON team_members(user_id);

-- API keys
CREATE INDEX idx_api_keys_org_id ON api_keys(org_id);
CREATE INDEX idx_api_keys_prefix ON api_keys(prefix);
CREATE INDEX idx_api_keys_product ON api_keys(product);

-- Audit log
CREATE INDEX idx_audit_log_org_id ON audit_log(org_id);
CREATE INDEX idx_audit_log_created_at ON audit_log(created_at DESC);
CREATE INDEX idx_audit_log_product ON audit_log(product);

-- Caches
CREATE INDEX idx_caches_org_id ON caches(org_id);
CREATE INDEX idx_caches_name ON caches(org_id, name);

-- Store paths
CREATE INDEX idx_store_paths_cache_id ON store_paths(cache_id);
CREATE INDEX idx_store_paths_hash ON store_paths(cache_id, hash);

-- Builds
CREATE INDEX idx_builds_org_id ON builds(org_id);
CREATE INDEX idx_builds_status ON builds(status);
CREATE INDEX idx_builds_created_at ON builds(created_at DESC);

-- Resources (converge)
CREATE INDEX idx_resources_org_id ON resources(org_id);
CREATE INDEX idx_resources_drift_status ON resources(drift_status);

-- Pipelines (confirm)
CREATE INDEX idx_pipelines_org_id ON pipelines(org_id);
CREATE INDEX idx_pipeline_runs_pipeline_id ON pipeline_runs(pipeline_id);

-- Stacks/diffs (forge)
CREATE INDEX idx_stacks_repo_id ON stacks(repo_id);
CREATE INDEX idx_diffs_stack_id ON diffs(stack_id);

-- Doc sites (publish)
CREATE INDEX idx_doc_sites_org_id ON doc_sites(org_id);
CREATE INDEX idx_doc_pages_site_id ON doc_pages(site_id);

-- Agent sessions (code)
CREATE INDEX idx_agent_sessions_org_id ON agent_sessions(org_id);
CREATE INDEX idx_agent_messages_session_id ON agent_messages(session_id);

-- Workspaces (work)
CREATE INDEX idx_workspaces_org_id ON workspaces(org_id);
CREATE INDEX idx_conversations_workspace_id ON conversations(workspace_id);

-- Endpoints (proxy)
CREATE INDEX idx_endpoints_org_id ON endpoints(org_id);
CREATE INDEX idx_proxy_requests_endpoint_id ON proxy_requests(endpoint_id);

-- Models (boost)
CREATE INDEX idx_models_org_id ON models(org_id);
CREATE INDEX idx_inference_jobs_model_id ON inference_jobs(model_id);

-- ═══════════════════════════════════════════════════════════════════════════════
-- TRIGGERS
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_organizations_updated_at
    BEFORE UPDATE ON organizations FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_users_updated_at
    BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_caches_updated_at
    BEFORE UPDATE ON caches FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_builds_updated_at
    BEFORE UPDATE ON builds FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_resources_updated_at
    BEFORE UPDATE ON resources FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_pipelines_updated_at
    BEFORE UPDATE ON pipelines FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_stacks_updated_at
    BEFORE UPDATE ON stacks FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_diffs_updated_at
    BEFORE UPDATE ON diffs FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_doc_sites_updated_at
    BEFORE UPDATE ON doc_sites FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_doc_pages_updated_at
    BEFORE UPDATE ON doc_pages FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_workspaces_updated_at
    BEFORE UPDATE ON workspaces FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_conversations_updated_at
    BEFORE UPDATE ON conversations FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_endpoints_updated_at
    BEFORE UPDATE ON endpoints FOR EACH ROW EXECUTE FUNCTION update_updated_at();
