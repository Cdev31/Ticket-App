CREATE EXTENSION IF NOT EXISTS "pgcrypto";

--Create type with enums
CREATE
TYPE user_status AS ENUM (
    'ACTIVE',
    'LOCKED',
    'DISABLED'
);

CREATE
TYPE worker_status AS ENUM (
    'ONLINE',
    'OFFLINE',
    'BUSY',
    'DISABLED',
    'MAINTENANCE'
);

CREATE
TYPE job_priority AS ENUM (
    'LOW',
    'MEDIUM',
    'HIGH',
    'CRITICAL'
);

CREATE
TYPE job_status AS ENUM (
    'CREATED',
    'VALIDATED',
    'QUEUED',
    'ASSIGNED',
    'RUNNING',
    'PAUSED',
    'COMPLETED',
    'FAILED',
    'CANCELLED',
    'RESCHEDULED',
    'EXPIRED'
);

CREATE
TYPE execution_status AS ENUM (
    'STARTED',
    'RUNNING',
    'COMPLETED',
    'FAILED',
    'CANCELLED',
    'TIMED_OUT'
);

CREATE
TYPE schedule_type AS ENUM (
    'ONCE',
    'RECURRING',
    'INTERVAL'
);

CREATE
TYPE schedule_status AS ENUM (
    'SCHEDULED',
    'RUNNING',
    'COMPLETED',
    'CANCELLED',
    'EXPIRED'
);

CREATE
TYPE log_level AS ENUM (
    'DEBUG',
    'INFO',
    'WARN',
    'ERROR'
);

CREATE
TYPE result_type AS ENUM (
    'TEXT',
    'JSON',
    'FILE',
    'NUMBER',
    'BOOLEAN'
);

CREATE
TYPE event_severity AS ENUM (
    'INFO',
    'WARNING',
    'ERROR',
    'CRITICAL'
);

CREATE
TYPE notification_type AS ENUM (
    'INFO',
    'SUCCESS',
    'WARNING',
    'ERROR'
);

CREATE
TYPE path_type AS ENUM (
    'INPUT',
    'OUTPUT',
    'TEMP',
    'GENERAL'
);

CREATE
TYPE source_type AS ENUM (
    'MANUAL',
    'SCHEDULED',
    'SYSTEM',
    'API'
);

CREATE
TYPE assignment_status AS ENUM (
    'ASSIGNED',
    'UNASSIGNED',
    'REASSIGNED',
    'REJECTED'
);

CREATE
TYPE dependency_type AS ENUM (
    'FINISH_TO_START',
    'START_TO_START'
);

CREATE
TYPE parameter_type AS ENUM (
    'STRING',
    'INTEGER',
    'LONG',
    'DOUBLE',
    'BOOLEAN',
    'DATE',
    'DATETIME',
    'JSON',
    'FILE_PATH',
    'REGEX'
);

CREATE
TYPE session_status AS ENUM (
    'ACTIVE',
    'EXPIRED',
    'REVOKED',
    'CLOSED'
);

-- =========================================================
-- TABLES: SECURITY / USERS
-- =========================================================
CREATE TABLE roles (
    role_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    is_system BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW ()
);

CREATE TABLE permissions(
    permission_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    module VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW ()
);

CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    status user_status NOT NULL DEFAULT 'ACTIVE',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    failed_login_attempts INTEGER NOT NULL DEFAULT 0,
    locked_until TIMESTAMPTZ,
    last_login_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    CONSTRAINT chk_failed_login_attempts_non_negative CHECK (failed_login_attempts >= 0)
);

CREATE TABLE user_roles (
    user_id UUID NOT NULL,
    role_id UUID NOT NULL,
    assigned_by UUID,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    PRIMARY KEY (user_id, role_id),
    CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
    CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES roles (role_id) ON DELETE CASCADE,
    CONSTRAINT fk_user_roles_assigned_by FOREIGN KEY (assigned_by) REFERENCES users (user_id) ON DELETE SET NULL
);

CREATE TABLE role_permissions (
    role_id UUID NOT NULL,
    permission_id UUID NOT NULL,
    granted_by UUID,
    granted_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    PRIMARY KEY (role_id, permission_id),
    CONSTRAINT fk_role_permissions_role FOREIGN KEY (role_id) REFERENCES roles (role_id) ON DELETE CASCADE,
    CONSTRAINT fk_role_permissions_permission FOREIGN KEY (permission_id) REFERENCES permissions(permission_id) ON DELETE CASCADE,
    CONSTRAINT fk_role_permissions_granted_by FOREIGN KEY (granted_by) REFERENCES users (user_id) ON DELETE SET NULL
);

CREATE TABLE user_sessions (
    session_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    user_id UUID NOT NULL,
    session_token TEXT NOT NULL UNIQUE,
    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    last_seen_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    expires_at TIMESTAMPTZ NOT NULL,
    ended_at TIMESTAMPTZ,
    ip_address VARCHAR(64),
    user_agent TEXT,
    status session_status NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_user_sessions_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
    CONSTRAINT chk_session_dates CHECK (expires_at > started_at)
);

-- =========================================================
-- TABLES: WORKERS
-- =========================================================
CREATE TABLE workers (
    worker_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    worker_code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    host VARCHAR(255) NOT NULL,
    port INTEGER NOT NULL,
    status worker_status NOT NULL DEFAULT 'OFFLINE',
    max_concurrent_jobs INTEGER NOT NULL DEFAULT 1,
    current_load INTEGER NOT NULL DEFAULT 0,
    registered_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    last_heartbeat_at TIMESTAMPTZ,
    version VARCHAR(50),
    is_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    CONSTRAINT chk_worker_port CHECK (
        port > 0
        AND port <= 65535
    ),
    CONSTRAINT chk_worker_max_concurrent_jobs CHECK (max_concurrent_jobs > 0),
    CONSTRAINT chk_worker_current_load_non_negative CHECK (current_load >= 0)
);

CREATE TABLE worker_capabilities (
    worker_id UUID NOT NULL,
    capability_code VARCHAR(50) NOT NULL,
    priority_weight INTEGER NOT NULL DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    PRIMARY KEY (worker_id, capability_code),
    CONSTRAINT fk_worker_capabilities_worker FOREIGN KEY (worker_id) REFERENCES workers (worker_id) ON DELETE CASCADE,
    CONSTRAINT chk_priority_weight_positive CHECK (priority_weight > 0)
);

CREATE TABLE worker_heartbeats (
    heartbeat_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    worker_id UUID NOT NULL,
    heartbeat_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    status_snapshot worker_status NOT NULL,
    current_load INTEGER NOT NULL DEFAULT 0,
    active_jobs_count INTEGER NOT NULL DEFAULT 0,
    memory_usage_mb INTEGER,
    cpu_usage_percent NUMERIC(5, 2),
    CONSTRAINT fk_worker_heartbeats_worker FOREIGN KEY (worker_id) REFERENCES workers (worker_id) ON DELETE CASCADE,
    CONSTRAINT chk_heartbeat_current_load_non_negative CHECK (current_load >= 0),
    CONSTRAINT chk_heartbeat_active_jobs_non_negative CHECK (active_jobs_count >= 0),
    CONSTRAINT chk_heartbeat_memory_non_negative CHECK (
        memory_usage_mb IS NULL
        OR memory_usage_mb >= 0
    ),
    CONSTRAINT chk_cpu_usage_range CHECK (
        cpu_usage_percent IS NULL
        OR (
            cpu_usage_percent >= 0
            AND cpu_usage_percent <= 100
        )
    )
);

CREATE TABLE worker_status_history (
    worker_status_history_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    worker_id UUID NOT NULL,
    old_status worker_status,
    new_status worker_status NOT NULL,
    changed_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    reason TEXT,
    CONSTRAINT fk_worker_status_history_worker FOREIGN KEY (worker_id) REFERENCES workers (worker_id) ON DELETE CASCADE
);

-- =========================================================
-- TABLES: JOB CATALOG
-- =========================================================
CREATE TABLE job_types (
    job_type_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    worker_category VARCHAR(50) NOT NULL,
    description TEXT,
    is_schedulable BOOLEAN NOT NULL DEFAULT TRUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW ()
);

CREATE TABLE jobs (
    job_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    job_code VARCHAR(100) NOT NULL UNIQUE,
    job_type_id UUID NOT NULL,
    created_by UUID NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    priority job_priority NOT NULL DEFAULT 'MEDIUM',
    status job_status NOT NULL DEFAULT 'CREATED',
    source_type source_type NOT NULL DEFAULT 'MANUAL',
    scheduled_at TIMESTAMPTZ,
    deadline_at TIMESTAMPTZ,
    queued_at TIMESTAMPTZ,
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    canceled_at TIMESTAMPTZ,
    failed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    CONSTRAINT fk_jobs_job_type FOREIGN KEY (job_type_id) REFERENCES job_types (job_type_id) ON DELETE RESTRICT,
    CONSTRAINT fk_jobs_created_by FOREIGN KEY (created_by) REFERENCES users (user_id) ON DELETE RESTRICT,
    CONSTRAINT chk_job_deadline_after_created CHECK (
        deadline_at IS NULL
        OR deadline_at >= created_at
    ),
    CONSTRAINT chk_job_scheduled_after_created CHECK (
        scheduled_at IS NULL
        OR scheduled_at >= created_at
    )
);

CREATE TABLE job_parameters (
    job_parameter_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    job_id UUID NOT NULL,
    param_key VARCHAR(100) NOT NULL,
    param_value TEXT,
    param_type parameter_type NOT NULL DEFAULT 'STRING',
    is_sensitive BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    CONSTRAINT fk_job_parameters_job FOREIGN KEY (job_id) REFERENCES jobs (job_id) ON DELETE CASCADE,
    CONSTRAINT uq_job_param_key UNIQUE (job_id, param_key)
);

CREATE TABLE job_dependencies (
    job_id UUID NOT NULL,
    depends_on_job_id UUID NOT NULL,
    dependency_type dependency_type NOT NULL DEFAULT 'FINISH_TO_START',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    PRIMARY KEY (job_id, depends_on_job_id),
    CONSTRAINT fk_job_dependencies_job FOREIGN KEY (job_id) REFERENCES jobs (job_id) ON DELETE CASCADE,
    CONSTRAINT fk_job_dependencies_depends_on_job FOREIGN KEY (depends_on_job_id) REFERENCES jobs (job_id) ON DELETE CASCADE,
    CONSTRAINT chk_job_dependency_not_self CHECK (job_id <> depends_on_job_id)
);

CREATE TABLE scheduled_jobs (
    scheduled_job_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    job_id UUID NOT NULL UNIQUE,
    schedule_type schedule_type NOT NULL,
    run_at TIMESTAMPTZ,
    cron_expression VARCHAR(120),
    repeat_interval_seconds INTEGER,
    next_run_at TIMESTAMPTZ,
    last_run_at TIMESTAMPTZ,
    schedule_status schedule_status NOT NULL DEFAULT 'SCHEDULED',
    created_by UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    CONSTRAINT fk_scheduled_jobs_job FOREIGN KEY (job_id) REFERENCES jobs (job_id) ON DELETE CASCADE,
    CONSTRAINT fk_scheduled_jobs_created_by FOREIGN KEY (created_by) REFERENCES users (user_id) ON DELETE RESTRICT,
    CONSTRAINT chk_schedule_once_requires_run_at CHECK (
        schedule_type <> 'ONCE'
        OR run_at IS NOT NULL
    ),
    CONSTRAINT chk_schedule_interval_requires_repeat CHECK (
        schedule_type <> 'INTERVAL'
        OR (
            repeat_interval_seconds IS NOT NULL
            AND repeat_interval_seconds > 0
        )
    ),
    CONSTRAINT chk_schedule_recurrence_has_reference CHECK (
        schedule_type <> 'RECURRING'
        OR cron_expression IS NOT NULL
        OR repeat_interval_seconds IS NOT NULL
    )
);

-- =========================================================
-- TABLES: ASSIGNMENT / EXECUTION
-- =========================================================
CREATE TABLE job_assignments (
    job_assignment_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    job_id UUID NOT NULL,
    worker_id UUID NOT NULL,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    assigned_by_strategy VARCHAR(100),
    assignment_status assignment_status NOT NULL DEFAULT 'ASSIGNED',
    unassigned_at TIMESTAMPTZ,
    notes TEXT,
    CONSTRAINT fk_job_assignments_job FOREIGN KEY (job_id) REFERENCES jobs (job_id) ON DELETE CASCADE,
    CONSTRAINT fk_job_assignments_worker FOREIGN KEY (worker_id) REFERENCES workers (worker_id) ON DELETE RESTRICT
);

CREATE TABLE job_executions (
    job_execution_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    job_id UUID NOT NULL,
    worker_id UUID NOT NULL,
    attempt_number INTEGER NOT NULL DEFAULT 1,
    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    ended_at TIMESTAMPTZ,
    duration_ms BIGINT,
    execution_status execution_status NOT NULL DEFAULT 'STARTED',
    progress_percent NUMERIC(5, 2) NOT NULL DEFAULT 0,
    exit_message TEXT,
    cpu_time_ms BIGINT,
    memory_used_mb INTEGER,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    CONSTRAINT fk_job_executions_job FOREIGN KEY (job_id) REFERENCES jobs (job_id) ON DELETE CASCADE,
    CONSTRAINT fk_job_executions_worker FOREIGN KEY (worker_id) REFERENCES workers (worker_id) ON DELETE RESTRICT,
    CONSTRAINT uq_job_attempt UNIQUE (job_id, attempt_number),
    CONSTRAINT chk_attempt_number_positive CHECK (attempt_number > 0),
    CONSTRAINT chk_duration_non_negative CHECK (
        duration_ms IS NULL
        OR duration_ms >= 0
    ),
    CONSTRAINT chk_progress_percent_range CHECK (
        progress_percent >= 0
        AND progress_percent <= 100
    ),
    CONSTRAINT chk_cpu_time_non_negative CHECK (
        cpu_time_ms IS NULL
        OR cpu_time_ms >= 0
    ),
    CONSTRAINT chk_memory_used_non_negative CHECK (
        memory_used_mb IS NULL
        OR memory_used_mb >= 0
    )
);

CREATE TABLE job_results (
    job_result_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    job_execution_id UUID NOT NULL UNIQUE,
    result_type result_type NOT NULL,
    result_summary TEXT,
    result_data JSONB,
    result_path TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    CONSTRAINT fk_job_results_execution FOREIGN KEY (job_execution_id) REFERENCES job_executions (job_execution_id) ON DELETE CASCADE
);

CREATE TABLE job_logs (
    job_log_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    job_execution_id UUID NOT NULL,
    log_level log_level NOT NULL DEFAULT 'INFO',
    message TEXT NOT NULL,
    logged_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    CONSTRAINT fk_job_logs_execution FOREIGN KEY (job_execution_id) REFERENCES job_executions (job_execution_id) ON DELETE CASCADE
);

CREATE TABLE file_artifacts (
    file_artifact_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    job_id UUID NOT NULL,
    job_execution_id UUID,
    original_name VARCHAR(255) NOT NULL,
    stored_name VARCHAR(255) NOT NULL,
    file_path TEXT NOT NULL,
    mime_type VARCHAR(150),
    extension VARCHAR(20),
    size_bytes BIGINT NOT NULL,
    checksum_sha256 VARCHAR(64),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    CONSTRAINT fk_file_artifacts_job FOREIGN KEY (job_id) REFERENCES jobs (job_id) ON DELETE CASCADE,
    CONSTRAINT fk_file_artifacts_execution FOREIGN KEY (job_execution_id) REFERENCES job_executions (job_execution_id) ON DELETE SET NULL,
    CONSTRAINT chk_file_size_non_negative CHECK (size_bytes >= 0)
);

CREATE TABLE job_status_history (
    job_status_history_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    job_id UUID NOT NULL,
    old_status job_status,
    new_status job_status NOT NULL,
    changed_by UUID,
    changed_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    reason TEXT,
    CONSTRAINT fk_job_status_history_job FOREIGN KEY (job_id) REFERENCES jobs (job_id) ON DELETE CASCADE,
    CONSTRAINT fk_job_status_history_changed_by FOREIGN KEY (changed_by) REFERENCES users (user_id) ON DELETE SET NULL
);

-- =========================================================
-- TABLES: OPERATIONS / SECURITY / SYSTEM
-- =========================================================
CREATE TABLE allowed_paths (
    allowed_path_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    path_value TEXT NOT NULL UNIQUE,
    path_type path_type NOT NULL DEFAULT 'GENERAL',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    CONSTRAINT fk_allowed_paths_created_by FOREIGN KEY (created_by) REFERENCES users (user_id) ON DELETE SET NULL
);

CREATE TABLE system_events (
    event_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    event_type VARCHAR(100) NOT NULL,
    severity event_severity NOT NULL DEFAULT 'INFO',
    source VARCHAR(100) NOT NULL,
    reference_id UUID,
    message TEXT NOT NULL,
    event_time TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW ()
);

CREATE TABLE audit_logs (
    audit_log_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    user_id UUID,
    action VARCHAR(100) NOT NULL,
    target_type VARCHAR(100),
    target_id UUID,
    description TEXT,
    ip_address VARCHAR(64),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    CONSTRAINT fk_audit_logs_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE SET NULL
);

CREATE TABLE notifications (
    notification_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    user_id UUID NOT NULL,
    title VARCHAR(150) NOT NULL,
    message TEXT NOT NULL,
    type notification_type NOT NULL DEFAULT 'INFO',
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    read_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
);