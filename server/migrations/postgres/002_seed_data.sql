-- ═══════════════════════════════════════════════════════════════════════════════
-- STRAYLIGHT // WEB - Development Seed Data
-- ═══════════════════════════════════════════════════════════════════════════════

-- Default organization for development
INSERT INTO organizations (id, name, slug, tier) VALUES 
    ('00000000-0000-0000-0000-000000000001', 'Straylight', 'straylight', 'enterprise');

-- Default user (matches Clerk dev user)
INSERT INTO users (id, clerk_id, email, first_name, last_name) VALUES
    ('00000000-0000-0000-0000-000000000001', 'user_dev', 'dev@straylight.dev', 'Dev', 'User');

-- Team membership
INSERT INTO team_members (org_id, user_id, role) VALUES
    ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'owner');

-- ═══════════════════════════════════════════════════════════════════════════════
-- sensenet//cache seed data
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO caches (id, org_id, name, is_private, size_bytes, path_count, public_key, substituter_url) VALUES
    ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 
     'default', true, 2254857830, 1247,
     'default.cache.sensenet.digital:H+xYz1234567890abcdef==',
     'https://cache.sensenet.digital/default'),
    ('00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000001',
     'ci-builds', true, 152043520, 89,
     'ci-builds.cache.sensenet.digital:K+abc0987654321fedcba==',
     'https://cache.sensenet.digital/ci-builds');

-- ═══════════════════════════════════════════════════════════════════════════════
-- sensenet//build seed data
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO builds (id, org_id, cache_id, name, flake_ref, status, duration_ms, paths_built, paths_cached, triggered_by) VALUES
    ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001',
     '00000000-0000-0000-0000-000000000001', 'straylight-web', 'github:straylight/web#default',
     'success', 45000, 12, 148, 'user_dev');

-- ═══════════════════════════════════════════════════════════════════════════════
-- sensenet//converge seed data
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO resources (id, org_id, resource_type, name, desired_state, drift_status) VALUES
    ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001',
     'gcp:compute:instance', 'web-server-1', 
     '{"machineType": "e2-medium", "zone": "us-central1-a"}', 'in_sync');

-- ═══════════════════════════════════════════════════════════════════════════════
-- sensenet//confirm seed data
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO pipelines (id, org_id, name, repository, config) VALUES
    ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001',
     'main', 'github:straylight/web', '{"steps": ["build", "test", "deploy"]}');

-- ═══════════════════════════════════════════════════════════════════════════════
-- sensenet//forge seed data
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO repositories (id, org_id, name, default_branch) VALUES
    ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001',
     'straylight-web', 'main');

-- ═══════════════════════════════════════════════════════════════════════════════
-- sensenet//publish seed data
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO doc_sites (id, org_id, name, subdomain) VALUES
    ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001',
     'Straylight Docs', 'docs');

INSERT INTO doc_pages (id, site_id, path, title, content, published) VALUES
    ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001',
     '/', 'Welcome', '# Welcome to Straylight\n\nDocumentation for all products.', true);

-- ═══════════════════════════════════════════════════════════════════════════════
-- omega//code seed data
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO agent_sessions (id, org_id, user_id, name, directory, status, model) VALUES
    ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001',
     '00000000-0000-0000-0000-000000000001', 'straylight-web session', '/home/dev/straylight-web',
     'idle', 'claude-sonnet-4-20250514');

-- ═══════════════════════════════════════════════════════════════════════════════
-- omega//work seed data
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO workspaces (id, org_id, owner_id, name, workspace_type) VALUES
    ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001',
     '00000000-0000-0000-0000-000000000001', 'Default Workspace', 'personal');

-- ═══════════════════════════════════════════════════════════════════════════════
-- omega//proxy seed data
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO endpoints (id, org_id, name, provider, model, rate_limit_rpm) VALUES
    ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001',
     'claude-sonnet', 'anthropic', 'claude-sonnet-4-20250514', 1000),
    ('00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000001',
     'gpt-4o', 'openai', 'gpt-4o', 500);

-- ═══════════════════════════════════════════════════════════════════════════════
-- omega//boost seed data
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO models (id, org_id, name, base_model, quantization, config) VALUES
    ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001',
     'llama-3-70b-instruct', 'meta-llama/Llama-3-70b-instruct', 'fp8',
     '{"max_batch_size": 32, "max_seq_len": 8192}');

-- ═══════════════════════════════════════════════════════════════════════════════
-- API keys for all products
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO api_keys (id, org_id, product, name, key_hash, prefix, scopes) VALUES
    ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001',
     'cache', 'CI Pipeline', '$2a$10$placeholder', 'snc_live_', ARRAY['read', 'write']::api_scope[]),
    ('00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000001',
     'code', 'Local Dev', '$2a$10$placeholder', 'omc_live_', ARRAY['read', 'write', 'admin']::api_scope[]);
