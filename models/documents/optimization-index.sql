CREATE INDEX idx_users_status ON users (status);

CREATE INDEX idx_users_last_login_at ON users (last_login_at);

CREATE INDEX idx_user_sessions_user_id ON user_sessions (user_id);

CREATE INDEX idx_user_sessions_status ON user_sessions (status);

CREATE INDEX idx_workers_status ON workers (status);

CREATE
INDEX idx_workers_last_heartbeat_at ON workers (last_heartbeat_at);

CREATE
INDEX idx_worker_heartbeats_worker_id ON worker_heartbeats (worker_id);

CREATE
INDEX idx_worker_heartbeats_heartbeat_at ON worker_heartbeats (heartbeat_at);

CREATE INDEX idx_jobs_job_type_id ON jobs (job_type_id);

CREATE INDEX idx_jobs_created_by ON jobs (created_by);

CREATE INDEX idx_jobs_status ON jobs (status);

CREATE INDEX idx_jobs_priority ON jobs (priority);

CREATE INDEX idx_jobs_created_at ON jobs (created_at);

CREATE INDEX idx_jobs_scheduled_at ON jobs (scheduled_at);

CREATE INDEX idx_jobs_deadline_at ON jobs (deadline_at);

CREATE INDEX idx_job_parameters_job_id ON job_parameters (job_id);

CREATE INDEX idx_job_assignments_job_id ON job_assignments (job_id);

CREATE
INDEX idx_job_assignments_worker_id ON job_assignments (worker_id);

CREATE
INDEX idx_job_assignments_assigned_at ON job_assignments (assigned_at);

CREATE INDEX idx_job_executions_job_id ON job_executions (job_id);

CREATE
INDEX idx_job_executions_worker_id ON job_executions (worker_id);

CREATE
INDEX idx_job_executions_status ON job_executions (execution_status);

CREATE
INDEX idx_job_executions_started_at ON job_executions (started_at);

CREATE
INDEX idx_job_logs_execution_id ON job_logs (job_execution_id);

CREATE INDEX idx_job_logs_logged_at ON job_logs (logged_at);

CREATE
INDEX idx_scheduled_jobs_next_run_at ON scheduled_jobs (next_run_at);

CREATE
INDEX idx_scheduled_jobs_status ON scheduled_jobs (schedule_status);

CREATE
INDEX idx_job_status_history_job_id ON job_status_history (job_id);

CREATE
INDEX idx_job_status_history_changed_at ON job_status_history (changed_at);

CREATE INDEX idx_audit_logs_user_id ON audit_logs (user_id);

CREATE INDEX idx_audit_logs_created_at ON audit_logs (created_at);

CREATE INDEX idx_notifications_user_id ON notifications (user_id);

CREATE INDEX idx_notifications_is_read ON notifications (is_read);