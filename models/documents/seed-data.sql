-- =========================================================
-- SEED DATA: ROLES
-- =========================================================
INSERT INTO
    roles (name, description, is_system)
VALUES (
        'ADMIN',
        'Full system administration access',
        TRUE
    ),
    (
        'OPERATOR',
        'Can create, monitor, and manage own jobs',
        TRUE
    ),
    (
        'ANALYST',
        'Can create jobs and inspect own results',
        TRUE
    ),
    (
        'GUEST',
        'Limited access user',
        TRUE
    );

-- =========================================================
-- SEED DATA: PERMISSIONS
-- =========================================================
INSERT INTO
    permissions(
        code,
        name,
        description,
        module
    )
VALUES (
        'USER_CREATE',
        'Create users',
        'Allows creating new users',
        'SECURITY'
    ),
    (
        'USER_UPDATE',
        'Update users',
        'Allows updating user profiles',
        'SECURITY'
    ),
    (
        'USER_DISABLE',
        'Disable users',
        'Allows disabling users',
        'SECURITY'
    ),
    (
        'ROLE_ASSIGN',
        'Assign roles',
        'Allows assigning roles to users',
        'SECURITY'
    ),
    (
        'PERMISSION_MANAGE',
        'Manage permissions',
        'Allows managing role permissions',
        'SECURITY'
    ),
    (
        'SESSION_VIEW',
        'View sessions',
        'Allows viewing user sessions',
        'SECURITY'
    ),
    (
        'WORKER_VIEW',
        'View workers',
        'Allows viewing worker information',
        'WORKERS'
    ),
    (
        'WORKER_REGISTER',
        'Register workers',
        'Allows registering new workers',
        'WORKERS'
    ),
    (
        'WORKER_ENABLE',
        'Enable or disable workers',
        'Allows enabling or disabling workers',
        'WORKERS'
    ),
    (
        'WORKER_MONITOR',
        'Monitor workers',
        'Allows viewing detailed worker telemetry',
        'WORKERS'
    ),
    (
        'JOB_CREATE',
        'Create jobs',
        'Allows creating jobs',
        'JOBS'
    ),
    (
        'JOB_VIEW_OWN',
        'View own jobs',
        'Allows viewing own jobs',
        'JOBS'
    ),
    (
        'JOB_VIEW_ALL',
        'View all jobs',
        'Allows viewing all jobs',
        'JOBS'
    ),
    (
        'JOB_CANCEL_OWN',
        'Cancel own jobs',
        'Allows cancelling own jobs',
        'JOBS'
    ),
    (
        'JOB_CANCEL_ALL',
        'Cancel all jobs',
        'Allows cancelling any job',
        'JOBS'
    ),
    (
        'JOB_RETRY_OWN',
        'Retry own failed jobs',
        'Allows retrying own jobs',
        'JOBS'
    ),
    (
        'JOB_RETRY_ALL',
        'Retry all failed jobs',
        'Allows retrying any failed job',
        'JOBS'
    ),
    (
        'JOB_SCHEDULE',
        'Schedule jobs',
        'Allows scheduling jobs in time',
        'JOBS'
    ),
    (
        'JOB_RESULT_VIEW_OWN',
        'View own job results',
        'Allows viewing own job results',
        'JOBS'
    ),
    (
        'JOB_RESULT_VIEW_ALL',
        'View all job results',
        'Allows viewing any job results',
        'JOBS'
    ),
    (
        'AUDIT_VIEW',
        'View audit logs',
        'Allows viewing security audit logs',
        'AUDIT'
    ),
    (
        'SYSTEM_EVENT_VIEW',
        'View system events',
        'Allows viewing system events',
        'SYSTEM'
    ),
    (
        'NOTIFICATION_VIEW',
        'View notifications',
        'Allows viewing notifications',
        'SYSTEM'
    ),
    (
        'ALLOWED_PATH_MANAGE',
        'Manage allowed paths',
        'Allows managing allowed file paths',
        'FILES'
    ),
    (
        'FILE_DELETE_RESTRICTED',
        'Delete restricted files',
        'Allows destructive file operations',
        'FILES'
    );

-- =========================================================
-- SEED DATA: ROLE PERMISSIONS
-- =========================================================
-- ADMIN
INSERT INTO
    role_permissions (role_id, permission_id)
SELECT r.role_id, p.permission_id
FROM roles r
    CROSS JOIN permissions p
WHERE
    r.name = 'ADMIN';

-- OPERATOR
INSERT INTO
    role_permissions (role_id, permission_id)
SELECT r.role_id, p.permission_id
FROM roles r
    JOIN permissions p ON p.code IN (
        'WORKER_VIEW', 'WORKER_MONITOR', 'JOB_CREATE', 'JOB_VIEW_OWN', 'JOB_VIEW_ALL', 'JOB_CANCEL_OWN', 'JOB_RETRY_OWN', 'JOB_SCHEDULE', 'JOB_RESULT_VIEW_OWN', 'JOB_RESULT_VIEW_ALL', 'SYSTEM_EVENT_VIEW', 'NOTIFICATION_VIEW'
    )
WHERE
    r.name = 'OPERATOR';

-- ANALYST
INSERT INTO
    role_permissions (role_id, permission_id)
SELECT r.role_id, p.permission_id
FROM roles r
    JOIN permissions p ON p.code IN (
        'JOB_CREATE', 'JOB_VIEW_OWN', 'JOB_CANCEL_OWN', 'JOB_RETRY_OWN', 'JOB_SCHEDULE', 'JOB_RESULT_VIEW_OWN', 'NOTIFICATION_VIEW'
    )
WHERE
    r.name = 'ANALYST';

-- GUEST
INSERT INTO
    role_permissions (role_id, permission_id)
SELECT r.role_id, p.permission_id
FROM roles r
    JOIN permissions p ON p.code IN (
        'JOB_VIEW_OWN', 'JOB_RESULT_VIEW_OWN', 'NOTIFICATION_VIEW'
    )
WHERE
    r.name = 'GUEST';

-- =========================================================
-- SEED DATA: JOB TYPES
-- =========================================================
INSERT INTO
    job_types (
        code,
        name,
        worker_category,
        description,
        is_schedulable,
        is_active
    )
VALUES (
        'TEXT_UPPERCASE',
        'Uppercase Text Transformation',
        'TEXT_TRANSFORM',
        'Converts text to uppercase',
        TRUE,
        TRUE
    ),
    (
        'TEXT_NORMALIZE',
        'Normalize Text',
        'TEXT_TRANSFORM',
        'Normalizes text and removes invalid formatting',
        TRUE,
        TRUE
    ),
    (
        'TEXT_REPLACE',
        'Replace Text Pattern',
        'TEXT_TRANSFORM',
        'Replaces one text pattern with another',
        TRUE,
        TRUE
    ),
    (
        'REGEX_SCAN',
        'Regex Scan',
        'REGEX_SCAN',
        'Scans text or files using a regex pattern',
        TRUE,
        TRUE
    ),
    (
        'REGEX_EXTRACT_EMAILS',
        'Extract Emails',
        'REGEX_SCAN',
        'Extracts email addresses from text',
        TRUE,
        TRUE
    ),
    (
        'REGEX_EXTRACT_IPS',
        'Extract IP Addresses',
        'REGEX_SCAN',
        'Extracts IP addresses from text',
        TRUE,
        TRUE
    ),
    (
        'FILE_RENAME',
        'Rename Files',
        'FILE',
        'Renames files using pattern rules',
        TRUE,
        TRUE
    ),
    (
        'FILE_HASH',
        'Compute File Hash',
        'FILE',
        'Computes SHA-256 or MD5 hash',
        TRUE,
        TRUE
    ),
    (
        'FILE_SPLIT',
        'Split File',
        'FILE',
        'Splits large file into smaller chunks',
        TRUE,
        TRUE
    ),
    (
        'COMPUTE_PRIMES',
        'Prime Number Computation',
        'COMPUTE',
        'Computes prime numbers in a range',
        TRUE,
        TRUE
    ),
    (
        'COMPUTE_MATRIX_MULTIPLY',
        'Matrix Multiplication',
        'COMPUTE',
        'Executes matrix multiplication',
        TRUE,
        TRUE
    ),
    (
        'COMPUTE_MONTE_CARLO',
        'Monte Carlo Simulation',
        'COMPUTE',
        'Runs Monte Carlo simulation',
        TRUE,
        TRUE
    ),
    (
        'SCHEDULED_GENERIC',
        'Generic Scheduled Job',
        'SCHEDULED',
        'Runs a job under time-based conditions',
        TRUE,
        TRUE
    );