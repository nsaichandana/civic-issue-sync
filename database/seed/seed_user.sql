-- ============================================================
-- CivicTrust - Seed Users
-- Only 4 users matching authenticated auth.users
-- ============================================================

-- ============================================================
-- ADMIN
-- ============================================================

INSERT INTO users (id, full_name, email, phone, designation, role_id, department_id, ward_id, is_active, email_verified)
SELECT
    'c30d183a-8d6c-4149-9253-6489c441c9c7',
    'Rajesh Kumar',
    'admin@civictrust.in',
    '9000000001',
    'System Administrator',
    r.id,
    NULL,
    NULL,
    TRUE,
    TRUE
FROM roles r
WHERE r.role_name = 'ADMIN';

-- ============================================================
-- OFFICER
-- ============================================================

INSERT INTO users (id, full_name, email, phone, designation, role_id, department_id, ward_id, is_active, email_verified)
SELECT
    'a6f2d66a-93c1-4a2e-b1ba-f2359bf6fc04',
    'Suresh Reddy',
    'officer@civictrust.in',
    '9000000002',
    'Municipal Officer - Roads',
    r.id,
    d.id,
    NULL,
    TRUE,
    TRUE
FROM roles r
CROSS JOIN departments d
WHERE r.role_name = 'OFFICER'
AND d.department_name = 'Roads & Infrastructure';

-- ============================================================
-- FIELD_WORKER
-- ============================================================

INSERT INTO users (id, full_name, email, phone, designation, role_id, department_id, ward_id, is_active, email_verified)
SELECT
    '5df2e687-100b-44bc-996c-af4a2289c0a6',
    'Ravi Shankar',
    'worker@civictrust.in',
    '9000000003',
    'Field Technician',
    r.id,
    d.id,
    w.id,
    TRUE,
    TRUE
FROM roles r
CROSS JOIN departments d
CROSS JOIN wards w
WHERE r.role_name = 'FIELD_WORKER'
AND d.department_name = 'Roads & Infrastructure'
AND w.ward_name = 'Alipiri';

-- ============================================================
-- CITIZEN
-- ============================================================

INSERT INTO users (id, full_name, email, phone, designation, role_id, department_id, ward_id, is_active, email_verified)
SELECT
    '86921650-7206-43ed-b610-d4267ca4454f',
    'Anitha Devi',
    'citizen@civictrust.in',
    '9000000004',
    NULL,
    r.id,
    NULL,
    w.id,
    TRUE,
    TRUE
FROM roles r
CROSS JOIN wards w
WHERE r.role_name = 'CITIZEN'
AND w.ward_name = 'Alipiri';