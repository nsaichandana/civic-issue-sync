-- ============================================================
-- ASSIGNMENTS (8)
-- ============================================================

INSERT INTO assignments (issue_id, assigned_to, assigned_by, status, notes, assigned_at, due_date, accepted_at, completed_at, cancelled_at, cancellation_reason, created_at)
SELECT
    i.id,
    worker.id,
    officer.id,
    a.status::assignment_status,
    a.notes,
    a.assigned_at,
    a.due_date,
    a.accepted_at,
    a.completed_at,
    a.cancelled_at,
    a.cancellation_reason,
    a.created_at
FROM (
    VALUES
    ('CIV-2026-000001', 'worker@civictrust.in', 'officer@civictrust.in', 'COMPLETED', 'Repair the pothole with bitumen. Barricade first. High priority.', NOW() - INTERVAL '8 days', NOW() - INTERVAL '5 days', NOW() - INTERVAL '7 days', NOW() - INTERVAL '2 days', NULL::TIMESTAMPTZ, NULL::TEXT, NOW() - INTERVAL '8 days'),
    ('CIV-2026-000002', 'worker@civictrust.in', 'officer@civictrust.in', 'IN_PROGRESS', 'Fill all potholes on RC Road stretch. Multiple locations.', NOW() - INTERVAL '5 days', NOW() - INTERVAL '2 days', NOW() - INTERVAL '4 days', NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ, NULL::TEXT, NOW() - INTERVAL '5 days'),
    ('CIV-2026-000004', 'worker@civictrust.in', 'officer@civictrust.in', 'ACCEPTED', 'Clear all waste from Renigunta Road. Use heavy equipment.', NOW() - INTERVAL '5 days', NOW() - INTERVAL '2 days', NOW() - INTERVAL '4 days', NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ, NULL::TEXT, NOW() - INTERVAL '5 days'),
    ('CIV-2026-000005', 'worker@civictrust.in', 'officer@civictrust.in', 'ASSIGNED', 'Empty and clean the overflow garbage bin on Tiruchanoor Road.', NOW() - INTERVAL '2 days', NOW() + INTERVAL '1 day', NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ, NULL::TEXT, NOW() - INTERVAL '2 days'),
    ('CIV-2026-000006', 'worker@civictrust.in', 'officer@civictrust.in', 'COMPLETED', 'Repair burst pipeline. Stop water flow first. Critical emergency.', NOW() - INTERVAL '4 days', NOW() - INTERVAL '2 days', NOW() - INTERVAL '3 days', NOW() - INTERVAL '1 day', NULL::TIMESTAMPTZ, NULL::TEXT, NOW() - INTERVAL '4 days'),
    ('CIV-2026-000007', 'worker@civictrust.in', 'officer@civictrust.in', 'IN_PROGRESS', 'Replace faulty bulbs and check wiring. 5 lights need repair.', NOW() - INTERVAL '4 days', NOW() - INTERVAL '1 day', NOW() - INTERVAL '3 days', NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ, NULL::TEXT, NOW() - INTERVAL '4 days'),
    ('CIV-2026-000008', 'worker@civictrust.in', 'officer@civictrust.in', 'ASSIGNED', 'Clear drain blockage. Use high pressure flush. Inspect entire stretch.', NOW() - INTERVAL '5 days', NOW() - INTERVAL '1 day', NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ, NULL::TEXT, NOW() - INTERVAL '5 days'),
    ('CIV-2026-000009', 'worker@civictrust.in', 'officer@civictrust.in', 'ASSIGNED', 'Survey damage and estimate repair cost first. Then repair all benches.', NOW() - INTERVAL '1 day', NOW() + INTERVAL '3 days', NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ, NULL::TEXT, NOW() - INTERVAL '1 day')
) AS a(issue_number, worker_email, officer_email, status, notes, assigned_at, due_date, accepted_at, completed_at, cancelled_at, cancellation_reason, created_at)
JOIN issues i ON i.issue_number = a.issue_number
JOIN users worker ON worker.email = a.worker_email
JOIN users officer ON officer.email = a.officer_email;

-- ============================================================
-- FIELD TASKS (16 tasks)
-- ============================================================

INSERT INTO field_tasks (assignment_id, title, description, status, completed_by, completed_at, created_at)
SELECT
    ass.id,
    ft.title,
    ft.description,
    ft.status::task_status,
    u.id,
    ft.completed_at,
    ft.created_at
FROM (
    VALUES
    ('CIV-2026-000001', 'Site Inspection', 'Inspect pothole dimensions and severity at Alipiri', 'COMPLETED', 'worker@civictrust.in', NOW() - INTERVAL '7 days', NOW() - INTERVAL '8 days'),
    ('CIV-2026-000001', 'Place Barricades', 'Set up traffic barricades around damaged area', 'COMPLETED', 'worker@civictrust.in', NOW() - INTERVAL '6 days', NOW() - INTERVAL '8 days'),
    ('CIV-2026-000001', 'Fill Pothole with Bitumen', 'Apply hot bitumen mix and compact properly', 'COMPLETED', 'worker@civictrust.in', NOW() - INTERVAL '3 days', NOW() - INTERVAL '8 days'),
    ('CIV-2026-000001', 'Final Quality Check', 'Verify surface is level and safe for traffic', 'COMPLETED', 'worker@civictrust.in', NOW() - INTERVAL '2 days', NOW() - INTERVAL '8 days'),
    ('CIV-2026-000002', 'Site Survey', 'Map all pothole locations on RC Road stretch', 'COMPLETED', 'worker@civictrust.in', NOW() - INTERVAL '4 days', NOW() - INTERVAL '5 days'),
    ('CIV-2026-000002', 'Material Procurement', 'Arrange bitumen and tools for repair', 'COMPLETED', 'worker@civictrust.in', NOW() - INTERVAL '3 days', NOW() - INTERVAL '5 days'),
    ('CIV-2026-000002', 'Pothole Repair', 'Fill and compact all identified potholes on RC Road', 'IN_PROGRESS', NULL, NULL, NOW() - INTERVAL '5 days'),
    ('CIV-2026-000004', 'Assess Waste Volume', 'Estimate amount of waste to arrange vehicles', 'COMPLETED', 'worker@civictrust.in', NOW() - INTERVAL '3 days', NOW() - INTERVAL '4 days'),
    ('CIV-2026-000004', 'Clear Primary Garbage', 'Remove the main garbage pile from Renigunta Road', 'IN_PROGRESS', NULL, NULL, NOW() - INTERVAL '4 days'),
    ('CIV-2026-000004', 'Disinfect Area', 'Spray disinfectant after garbage removal', 'PENDING', NULL, NULL, NOW() - INTERVAL '4 days'),
    ('CIV-2026-000006', 'Locate Burst Point', 'Identify exact location of pipe burst in Bhavani Nagar', 'COMPLETED', 'worker@civictrust.in', NOW() - INTERVAL '3 days', NOW() - INTERVAL '4 days'),
    ('CIV-2026-000006', 'Shut Off Water Supply', 'Close main valve to stop water flow', 'COMPLETED', 'worker@civictrust.in', NOW() - INTERVAL '3 days', NOW() - INTERVAL '4 days'),
    ('CIV-2026-000006', 'Replace Pipe Section', 'Cut and replace the burst pipe section', 'COMPLETED', 'worker@civictrust.in', NOW() - INTERVAL '2 days', NOW() - INTERVAL '4 days'),
    ('CIV-2026-000006', 'Restore Water Supply', 'Reopen valve and test water flow', 'COMPLETED', 'worker@civictrust.in', NOW() - INTERVAL '1 day', NOW() - INTERVAL '4 days'),
    ('CIV-2026-000007', 'Inspect All Lights', 'Check all 5 streetlights and identify faults', 'COMPLETED', 'worker@civictrust.in', NOW() - INTERVAL '2 days', NOW() - INTERVAL '3 days'),
    ('CIV-2026-000007', 'Replace Bulbs', 'Replace faulty bulbs with LED units in Srinivasapuram', 'IN_PROGRESS', NULL, NULL, NOW() - INTERVAL '3 days')
) AS ft(issue_number, title, description, status, worker_email, completed_at, created_at)
JOIN assignments ass ON ass.issue_id = (SELECT id FROM issues WHERE issue_number = ft.issue_number)
LEFT JOIN users u ON u.email = ft.worker_email;

-- ============================================================
-- RESOLUTION EVIDENCE (16 records)
-- ============================================================

INSERT INTO resolution_evidence (assignment_id, submitted_by, media_type, evidence_stage, file_url, file_name, mime_type, file_size, caption, latitude, longitude, taken_at, created_at)
SELECT
    ass.id,
    u.id,
    re.media_type::media_type,
    re.evidence_stage,
    re.file_url,
    re.file_name,
    re.mime_type,
    re.file_size,
    re.caption,
    re.latitude,
    re.longitude,
    re.taken_at,
    re.created_at
FROM (
    VALUES
    ('CIV-2026-000001', 'worker@civictrust.in', 'IMAGE', 'BEFORE', 'https://storage.civictrust.in/evidence/a1_before1.jpg', 'alipiri_before_1.jpg', 'image/jpeg', 312000, 'Large pothole before repair at Alipiri Main Road', 13.6288, 79.4192, NOW() - INTERVAL '7 days', NOW() - INTERVAL '7 days'),
    ('CIV-2026-000001', 'worker@civictrust.in', 'IMAGE', 'IN_PROGRESS', 'https://storage.civictrust.in/evidence/a1_progress1.jpg', 'alipiri_progress_1.jpg', 'image/jpeg', 289000, 'Barricades placed, bitumen being laid on Alipiri Road', 13.6288, 79.4192, NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days'),
    ('CIV-2026-000001', 'worker@civictrust.in', 'IMAGE', 'AFTER', 'https://storage.civictrust.in/evidence/a1_after1.jpg', 'alipiri_after_1.jpg', 'image/jpeg', 267000, 'Pothole fully repaired, smooth road surface', 13.6288, 79.4192, NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),
    ('CIV-2026-000001', 'worker@civictrust.in', 'VIDEO', 'AFTER', 'https://storage.civictrust.in/evidence/a1_after.mp4', 'alipiri_after.mp4', 'video/mp4', 5200000, 'Video walkthrough of repaired Alipiri stretch', 13.6288, 79.4192, NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),
    ('CIV-2026-000002', 'worker@civictrust.in', 'IMAGE', 'BEFORE', 'https://storage.civictrust.in/evidence/a2_before1.jpg', 'rcroad_before_1.jpg', 'image/jpeg', 198000, 'Multiple potholes on RC Road before repair', 13.6352, 79.4198, NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days'),
    ('CIV-2026-000002', 'worker@civictrust.in', 'IMAGE', 'IN_PROGRESS', 'https://storage.civictrust.in/evidence/a2_progress1.jpg', 'rcroad_progress_1.jpg', 'image/jpeg', 221000, 'Repair in progress on RC Road with bitumen', 13.6352, 79.4198, NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),
    ('CIV-2026-000004', 'worker@civictrust.in', 'IMAGE', 'BEFORE', 'https://storage.civictrust.in/evidence/a4_before1.jpg', 'renigunta_before_1.jpg', 'image/jpeg', 334000, 'Massive garbage pile before clearance at Renigunta Road', 13.6489, 79.4098, NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days'),
    ('CIV-2026-000004', 'worker@civictrust.in', 'VIDEO', 'BEFORE', 'https://storage.civictrust.in/evidence/a4_before.mp4', 'renigunta_before.mp4', 'video/mp4', 7100000, 'Video showing extent of garbage dump at Renigunta', 13.6489, 79.4098, NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days'),
    ('CIV-2026-000006', 'worker@civictrust.in', 'IMAGE', 'BEFORE', 'https://storage.civictrust.in/evidence/a5_before1.jpg', 'bhavani_before_1.jpg', 'image/jpeg', 401000, 'Burst pipe with water flooding Bhavani Nagar road', 13.6421, 79.4231, NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days'),
    ('CIV-2026-000006', 'worker@civictrust.in', 'IMAGE', 'IN_PROGRESS', 'https://storage.civictrust.in/evidence/a5_progress1.jpg', 'bhavani_progress_1.jpg', 'image/jpeg', 356000, 'Pipe section being replaced in Bhavani Nagar', 13.6421, 79.4231, NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),
    ('CIV-2026-000006', 'worker@civictrust.in', 'IMAGE', 'AFTER', 'https://storage.civictrust.in/evidence/a5_after1.jpg', 'bhavani_after_1.jpg', 'image/jpeg', 278000, 'Pipeline repaired, dry road in Bhavani Nagar', 13.6421, 79.4231, NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day'),
    ('CIV-2026-000006', 'worker@civictrust.in', 'VIDEO', 'AFTER', 'https://storage.civictrust.in/evidence/a5_after.mp4', 'bhavani_after.mp4', 'video/mp4', 4800000, 'Water flow restored and tested in Bhavani Nagar', 13.6421, 79.4231, NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day'),
    ('CIV-2026-000007', 'worker@civictrust.in', 'IMAGE', 'BEFORE', 'https://storage.civictrust.in/evidence/a6_before1.jpg', 'lights_before_1.jpg', 'image/jpeg', 145000, 'Dark street showing broken lights in Srinivasapuram', 13.6198, 79.4312, NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),
    ('CIV-2026-000007', 'worker@civictrust.in', 'IMAGE', 'IN_PROGRESS', 'https://storage.civictrust.in/evidence/a6_progress1.jpg', 'lights_progress_1.jpg', 'image/jpeg', 189000, 'Technician replacing LED bulb in Srinivasapuram', 13.6198, 79.4312, NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day'),
    ('CIV-2026-000008', 'worker@civictrust.in', 'IMAGE', 'BEFORE', 'https://storage.civictrust.in/evidence/a7_before1.jpg', 'drain_before_1.jpg', 'image/jpeg', 234000, 'Blocked drain overflowing onto Tiruchanoor Road', 13.6178, 79.4267, NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days'),
    ('CIV-2026-000008', 'worker@civictrust.in', 'VIDEO', 'BEFORE', 'https://storage.civictrust.in/evidence/a7_before.mp4', 'drain_before.mp4', 'video/mp4', 3900000, 'Overflow situation during light rain on Tiruchanoor Road', 13.6178, 79.4267, NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days')
) AS re(issue_number, worker_email, media_type, evidence_stage, file_url, file_name, mime_type, file_size, caption, latitude, longitude, taken_at, created_at)
JOIN assignments ass ON ass.issue_id = (SELECT id FROM issues WHERE issue_number = re.issue_number)
JOIN users u ON u.email = re.worker_email;