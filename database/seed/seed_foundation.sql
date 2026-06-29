-- ============================================================
-- CivicTrust - Seed Foundation Data
-- Master/reference data only
-- ============================================================

-- ============================================================
-- ROLES
-- ============================================================

INSERT INTO roles (role_name, description) VALUES
('CITIZEN', 'Registered citizen who can submit reports'),
('OFFICER', 'Municipal officer who reviews and approves issues'),
('FIELD_WORKER', 'On-ground staff who resolves issues'),
('DEPARTMENT_HEAD', 'Head of a municipal department'),
('ADMIN', 'System administrator');

-- ============================================================
-- DEPARTMENTS
-- ============================================================

INSERT INTO departments (department_name, description, is_active) VALUES
('Roads & Infrastructure', 'Handles road maintenance, construction, and public property', TRUE),
('Water Supply', 'Manages water distribution, pipelines, and drainage systems', TRUE),
('Sanitation', 'Garbage collection, public cleanliness, and waste management', TRUE),
('Electrical', 'Street lighting and electrical infrastructure maintenance', TRUE);

-- ============================================================
-- WARDS
-- ============================================================

INSERT INTO wards (ward_number, ward_name, municipality_name, district, state, pincode) VALUES
(1, 'Alipiri', 'Tirupati Municipal Corporation', 'Tirupati', 'Andhra Pradesh', '517501'),
(2, 'RC Road', 'Tirupati Municipal Corporation', 'Tirupati', 'Andhra Pradesh', '517501'),
(3, 'Balaji Colony', 'Tirupati Municipal Corporation', 'Tirupati', 'Andhra Pradesh', '517502'),
(4, 'Bhavani Nagar', 'Tirupati Municipal Corporation', 'Tirupati', 'Andhra Pradesh', '517502'),
(5, 'Renigunta Road', 'Tirupati Municipal Corporation', 'Tirupati', 'Andhra Pradesh', '517520'),
(6, 'Tiruchanoor Road', 'Tirupati Municipal Corporation', 'Tirupati', 'Andhra Pradesh', '517503'),
(7, 'Korlagunta', 'Tirupati Municipal Corporation', 'Tirupati', 'Andhra Pradesh', '517501'),
(8, 'Srinivasapuram', 'Tirupati Municipal Corporation', 'Tirupati', 'Andhra Pradesh', '517507');

-- ============================================================
-- CATEGORIES
-- ============================================================

INSERT INTO categories (category_name, description, icon, color, ai_keywords, display_order, department_id, is_active)
SELECT
    c.category_name,
    c.description,
    c.icon,
    c.color,
    c.ai_keywords,
    c.display_order,
    d.id,
    c.is_active
FROM (
    VALUES
    ('Pothole', 'Road surface damage and potholes', 'road', '#E53E3E', 'pothole,road damage,crater,broken road', 1, 'Roads & Infrastructure', TRUE),
    ('Garbage', 'Uncollected waste and illegal dumping', 'trash', '#D69E2E', 'garbage,waste,dump,trash,litter', 2, 'Sanitation', TRUE),
    ('Water Leakage', 'Pipe bursts and water supply issues', 'droplet', '#3182CE', 'water leak,pipe burst,flooding,waterlogging', 3, 'Water Supply', TRUE),
    ('Streetlight', 'Non-functional or damaged street lights', 'zap', '#805AD5', 'streetlight,light,dark road,lamp post', 4, 'Electrical', TRUE),
    ('Drainage', 'Blocked or overflowing drains', 'git-merge', '#2F855A', 'drain,blocked,overflow,sewage,stormwater', 5, 'Water Supply', TRUE),
    ('Public Property', 'Damaged parks, benches, or public assets', 'home', '#744210', 'park,bench,public property,vandalism,broken', 6, 'Roads & Infrastructure', TRUE),
    ('Tree Fall', 'Fallen trees blocking roads or paths', 'tree', '#276749', 'tree,fallen,branch,blocked path,uprooted', 7, 'Roads & Infrastructure', TRUE),
    ('Encroachment', 'Illegal construction or land encroachment', 'alert-triangle', '#C53030', 'encroachment,illegal,construction,footpath block', 8, 'Roads & Infrastructure', TRUE)
) AS c(category_name, description, icon, color, ai_keywords, display_order, department_name, is_active)
JOIN departments d ON d.department_name = c.department_name;

-- ============================================================
-- SLA RULES
-- ============================================================

INSERT INTO sla_rules (category_id, priority, resolution_hours, warning_hours, escalation_hours, auto_escalate)
SELECT
    cat.id,
    sla.priority::priority_type,
    sla.resolution_hours,
    sla.warning_hours,
    sla.escalation_hours,
    sla.auto_escalate
FROM categories cat
CROSS JOIN LATERAL (
    VALUES
    ('LOW', 168, 120, 144, TRUE),
    ('MEDIUM', 72, 48, 60, TRUE),
    ('HIGH', 24, 16, 20, TRUE),
    ('CRITICAL', 8, 4, 6, TRUE)
) AS sla(priority, resolution_hours, warning_hours, escalation_hours, auto_escalate)
WHERE cat.category_name = 'Pothole';

INSERT INTO sla_rules (category_id, priority, resolution_hours, warning_hours, escalation_hours, auto_escalate)
SELECT
    cat.id,
    sla.priority,
    sla.resolution_hours,
    sla.warning_hours,
    sla.escalation_hours,
    sla.auto_escalate
FROM categories cat
CROSS JOIN LATERAL (
    VALUES
    ('LOW', 48, 36, 42, TRUE),
    ('MEDIUM', 24, 18, 21, TRUE),
    ('HIGH', 12, 8, 10, TRUE),
    ('CRITICAL', 4, 2, 3, TRUE)
) AS sla(priority, resolution_hours, warning_hours, escalation_hours, auto_escalate)
WHERE cat.category_name = 'Garbage';

INSERT INTO sla_rules (category_id, priority, resolution_hours, warning_hours, escalation_hours, auto_escalate)
SELECT
    cat.id,
    sla.priority,
    sla.resolution_hours,
    sla.warning_hours,
    sla.escalation_hours,
    sla.auto_escalate
FROM categories cat
CROSS JOIN LATERAL (
    VALUES
    ('LOW', 48, 36, 42, TRUE),
    ('MEDIUM', 24, 18, 21, TRUE),
    ('HIGH', 8, 5, 6, TRUE),
    ('CRITICAL', 4, 2, 3, TRUE)
) AS sla(priority, resolution_hours, warning_hours, escalation_hours, auto_escalate)
WHERE cat.category_name = 'Water Leakage';

INSERT INTO sla_rules (category_id, priority, resolution_hours, warning_hours, escalation_hours, auto_escalate)
SELECT
    cat.id,
    sla.priority,
    sla.resolution_hours,
    sla.warning_hours,
    sla.escalation_hours,
    sla.auto_escalate
FROM categories cat
CROSS JOIN LATERAL (
    VALUES
    ('LOW', 72, 48, 60, TRUE),
    ('MEDIUM', 48, 36, 42, TRUE),
    ('HIGH', 24, 16, 20, TRUE),
    ('CRITICAL', 12, 8, 10, TRUE)
) AS sla(priority, resolution_hours, warning_hours, escalation_hours, auto_escalate)
WHERE cat.category_name = 'Streetlight';

INSERT INTO sla_rules (category_id, priority, resolution_hours, warning_hours, escalation_hours, auto_escalate)
SELECT
    cat.id,
    sla.priority,
    sla.resolution_hours,
    sla.warning_hours,
    sla.escalation_hours,
    sla.auto_escalate
FROM categories cat
CROSS JOIN LATERAL (
    VALUES
    ('LOW', 72, 48, 60, TRUE),
    ('MEDIUM', 36, 24, 30, TRUE),
    ('HIGH', 12, 8, 10, TRUE),
    ('CRITICAL', 6, 3, 4, TRUE)
) AS sla(priority, resolution_hours, warning_hours, escalation_hours, auto_escalate)
WHERE cat.category_name = 'Drainage';

INSERT INTO sla_rules (category_id, priority, resolution_hours, warning_hours, escalation_hours, auto_escalate)
SELECT
    cat.id,
    sla.priority,
    sla.resolution_hours,
    sla.warning_hours,
    sla.escalation_hours,
    sla.auto_escalate
FROM categories cat
CROSS JOIN LATERAL (
    VALUES
    ('LOW', 168, 120, 144, TRUE),
    ('MEDIUM', 72, 48, 60, TRUE),
    ('HIGH', 48, 32, 40, TRUE),
    ('CRITICAL', 24, 16, 20, TRUE)
) AS sla(priority, resolution_hours, warning_hours, escalation_hours, auto_escalate)
WHERE cat.category_name = 'Public Property';

INSERT INTO sla_rules (category_id, priority, resolution_hours, warning_hours, escalation_hours, auto_escalate)
SELECT
    cat.id,
    sla.priority,
    sla.resolution_hours,
    sla.warning_hours,
    sla.escalation_hours,
    sla.auto_escalate
FROM categories cat
CROSS JOIN LATERAL (
    VALUES
    ('LOW', 48, 36, 42, TRUE),
    ('MEDIUM', 24, 16, 20, TRUE),
    ('HIGH', 8, 5, 6, TRUE),
    ('CRITICAL', 4, 2, 3, TRUE)
) AS sla(priority, resolution_hours, warning_hours, escalation_hours, auto_escalate)
WHERE cat.category_name = 'Tree Fall';

INSERT INTO sla_rules (category_id, priority, resolution_hours, warning_hours, escalation_hours, auto_escalate)
SELECT
    cat.id,
    sla.priority,
    sla.resolution_hours,
    sla.warning_hours,
    sla.escalation_hours,
    sla.auto_escalate
FROM categories cat
CROSS JOIN LATERAL (
    VALUES
    ('LOW', 240, 180, 210, TRUE),
    ('MEDIUM', 120, 90, 105, TRUE),
    ('HIGH', 72, 48, 60, TRUE),
    ('CRITICAL', 48, 32, 40, TRUE)
) AS sla(priority, resolution_hours, warning_hours, escalation_hours, auto_escalate)
WHERE cat.category_name = 'Encroachment';