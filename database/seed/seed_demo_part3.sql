-- ============================================================
-- DRAFT ISSUES (10)
-- ============================================================

INSERT INTO draft_issues (report_id, ai_analysis_id, suggested_category_id, suggested_priority, officer_review_status, review_comments, approved_by, approved_at, rejection_reason, created_at)
SELECT
    r.id,
    aa.id,
    c.id,
    di.suggested_priority::priority_type,
    di.officer_review_status::review_status,
    di.review_comments,
    u.id,
    di.approved_at,
    di.rejection_reason,
    di.created_at
FROM (
    VALUES
    ('Large pothole on Alipiri Main Road', 'HIGH', 'APPROVED', 'Verified on ground. High priority confirmed. Dangerous for commuters.', 'officer@civictrust.in', NOW() - INTERVAL '9 days', NULL, NOW() - INTERVAL '9 days'),
    ('Deep crater near Alipiri junction', 'HIGH', 'MERGED', 'Merged into Issue CIV-2026-000001 as same location. Duplicate report.', 'officer@civictrust.in', NOW() - INTERVAL '8 days', NULL, NOW() - INTERVAL '8 days'),
    ('Pothole on RC Road near SBI Bank', 'MEDIUM', 'APPROVED', 'Confirmed. RC Road potholes verified. Need to schedule repair.', 'officer@civictrust.in', NOW() - INTERVAL '6 days', NULL, NOW() - INTERVAL '6 days'),
    ('Road damaged in Balaji Colony', 'MEDIUM', 'REJECTED', NULL, NULL, NULL, 'Location not verified. Photos unclear. Citizen asked to resubmit with clearer photo.', NOW() - INTERVAL '4 days'),
    ('Garbage pile near Renigunta Road bus stop', 'HIGH', 'APPROVED', 'Public health risk confirmed. Escalated to HIGH. Immediate action required.', 'officer@civictrust.in', NOW() - INTERVAL '7 days', NULL, NOW() - INTERVAL '7 days'),
    ('Waste dumped on Renigunta Road footpath', 'MEDIUM', 'MERGED', 'Merged into Issue CIV-2026-000004 as same dump site. Duplicate.', 'officer@civictrust.in', NOW() - INTERVAL '6 days', NULL, NOW() - INTERVAL '6 days'),
    ('Water pipe burst in Bhavani Nagar', 'CRITICAL', 'APPROVED', 'Critical pipe burst. Immediate action ordered. Water supply affected.', 'officer@civictrust.in', NOW() - INTERVAL '5 days', NULL, NOW() - INTERVAL '5 days'),
    ('Water leaking near Bhavani Nagar park', 'HIGH', 'MERGED', 'Merged into Issue CIV-2026-000006 — same pipeline. Same pipeline failure.', 'officer@civictrust.in', NOW() - INTERVAL '4 days', NULL, NOW() - INTERVAL '4 days'),
    ('Streetlights not working in Srinivasapuram', 'HIGH', 'APPROVED', 'Night safety risk confirmed. Urgent repair needed. 5 lights non-functional.', 'officer@civictrust.in', NOW() - INTERVAL '5 days', NULL, NOW() - INTERVAL '5 days'),
    ('Blocked drain on Tiruchanoor Road', 'HIGH', 'APPROVED', 'Drain blockage confirmed. Flood risk validated. Heavy rain expected.', 'officer@civictrust.in', NOW() - INTERVAL '6 days', NULL, NOW() - INTERVAL '6 days')
) AS di(title, suggested_priority, officer_review_status, review_comments, officer_email, approved_at, rejection_reason, created_at)
JOIN reports r ON r.title = di.title
JOIN ai_analysis aa ON aa.report_id = r.id
JOIN categories c ON c.id = r.category_id
LEFT JOIN users u ON u.email = di.officer_email;

-- ============================================================
-- ISSUES (8 approved issues)
-- ============================================================

INSERT INTO issues (issue_number, draft_issue_id, department_id, category_id, ward_id, title, description, priority, status, sla_rule_id, created_by, approved_by, approved_at, resolved_at, closed_at, created_at)
SELECT
    i.issue_number,
    di.id,
    d.id,
    c.id,
    w.id,
    i.title,
    i.description,
    i.priority::priority_type,
    i.status::issue_status,
    sr.id,
    creator.id,
    approver.id,
    i.approved_at,
    i.resolved_at,
    i.closed_at,
    i.created_at
FROM (
    VALUES
    ('CIV-2026-000001', 'Large pothole on Alipiri Main Road', 'Pothole', 'Alipiri', 'Pothole Damage on Alipiri Main Road', 'Large pothole and road crater near Alipiri checkpost causing accidents. Multiple reports merged into this issue. High traffic area.', 'HIGH', 'RESOLVED', 'officer@civictrust.in', NOW() - INTERVAL '9 days', NOW() - INTERVAL '2 days', NOW() - INTERVAL '1 day', NOW() - INTERVAL '9 days'),
    ('CIV-2026-000002', 'Pothole on RC Road near SBI Bank', 'Pothole', 'RC Road', 'Multiple Potholes on RC Road', 'Pothole cluster on RC Road near SBI bank. Traffic disruption reported. Medium severity, needs repair within 3 days.', 'MEDIUM', 'IN_PROGRESS', 'officer@civictrust.in', NOW() - INTERVAL '6 days', NULL, NULL, NOW() - INTERVAL '6 days'),
    ('CIV-2026-000004', 'Garbage pile near Renigunta Road bus stop', 'Garbage', 'Renigunta Road', 'Garbage Accumulation on Renigunta Road', 'Uncollected garbage and construction waste on Renigunta Road. Public health hazard confirmed. Multiple citizen complaints.', 'HIGH', 'ASSIGNED', 'officer@civictrust.in', NOW() - INTERVAL '7 days', NULL, NULL, NOW() - INTERVAL '7 days'),
    ('CIV-2026-000005', NULL, 'Garbage', 'Tiruchanoor Road', 'Overflowing Garbage Bin on Tiruchanoor Road', 'Garbage bin overflow on Tiruchanoor Road near market. Sanitation team notified. Not cleared in 5 days.', 'MEDIUM', 'OPEN', 'officer@civictrust.in', NOW() - INTERVAL '3 days', NULL, NULL, NOW() - INTERVAL '3 days'),
    ('CIV-2026-000006', 'Water pipe burst in Bhavani Nagar', 'Water Leakage', 'Bhavani Nagar', 'Water Pipeline Burst in Bhavani Nagar', 'Critical pipe burst and associated underground leak in Bhavani Nagar. Two reports merged into this issue. Emergency response required.', 'CRITICAL', 'RESOLVED', 'officer@civictrust.in', NOW() - INTERVAL '5 days', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day', NOW() - INTERVAL '5 days'),
    ('CIV-2026-000007', 'Streetlights not working in Srinivasapuram', 'Streetlight', 'Srinivasapuram', 'Streetlights Down in Srinivasapuram', 'Five streetlights non-functional in Srinivasapuram colony. Night safety hazard. Dark road conditions.', 'HIGH', 'IN_PROGRESS', 'officer@civictrust.in', NOW() - INTERVAL '5 days', NULL, NULL, NOW() - INTERVAL '5 days'),
    ('CIV-2026-000008', 'Blocked drain on Tiruchanoor Road', 'Drainage', 'Tiruchanoor Road', 'Blocked Drain on Tiruchanoor Road', 'Major drain blockage causing flood risk in Tiruchanoor Road residential area. Heavy rain forecast.', 'HIGH', 'ASSIGNED', 'officer@civictrust.in', NOW() - INTERVAL '6 days', NULL, NULL, NOW() - INTERVAL '6 days'),
    ('CIV-2026-000009', NULL, 'Public Property', 'Korlagunta', 'Park Benches Vandalised in Korlagunta', 'All benches in Korlagunta public park vandalised and broken. Children have no place to sit. Needs immediate repair.', 'LOW', 'OPEN', 'officer@civictrust.in', NOW() - INTERVAL '1 day', NULL, NULL, NOW() - INTERVAL '1 day')
) AS i(issue_number, draft_title, category_name, ward_name, title, description, priority, status, approver_email, approved_at, resolved_at, closed_at, created_at)
LEFT JOIN draft_issues di ON di.report_id = (SELECT id FROM reports WHERE title = i.draft_title)
JOIN categories c ON c.category_name = i.category_name
JOIN wards w ON w.ward_name = i.ward_name
JOIN departments d ON d.id = c.department_id
JOIN users creator ON creator.email = 'citizen@civictrust.in'
JOIN users approver ON approver.email = i.approver_email
JOIN sla_rules sr ON sr.category_id = c.id AND sr.priority = i.priority::priority_type;

-- ============================================================
-- ISSUE REPORTS (links reports to issues)
-- ============================================================

INSERT INTO issue_reports (issue_id, report_id, linked_at)
SELECT
    i.id,
    r.id,
    ir.linked_at
FROM (
    VALUES
    ('CIV-2026-000001', 'Large pothole on Alipiri Main Road', NOW() - INTERVAL '9 days'),
    ('CIV-2026-000001', 'Deep crater near Alipiri junction', NOW() - INTERVAL '8 days'),
    ('CIV-2026-000002', 'Pothole on RC Road near SBI Bank', NOW() - INTERVAL '6 days'),
    ('CIV-2026-000004', 'Garbage pile near Renigunta Road bus stop', NOW() - INTERVAL '7 days'),
    ('CIV-2026-000004', 'Waste dumped on Renigunta Road footpath', NOW() - INTERVAL '6 days'),
    ('CIV-2026-000005', 'Overflowing garbage bin on Tiruchanoor Road', NOW() - INTERVAL '3 days'),
    ('CIV-2026-000006', 'Water pipe burst in Bhavani Nagar', NOW() - INTERVAL '5 days'),
    ('CIV-2026-000006', 'Water leaking near Bhavani Nagar park', NOW() - INTERVAL '4 days'),
    ('CIV-2026-000007', 'Streetlights not working in Srinivasapuram', NOW() - INTERVAL '5 days'),
    ('CIV-2026-000008', 'Blocked drain on Tiruchanoor Road', NOW() - INTERVAL '6 days')
) AS ir(issue_number, report_title, linked_at)
JOIN issues i ON i.issue_number = ir.issue_number
JOIN reports r ON r.title = ir.report_title;

-- ============================================================
-- MERGE RECORDS
-- ============================================================

INSERT INTO merge_records (source_issue_id, target_issue_id, merged_by, merge_reason, merged_at)
SELECT
    source.id,
    target.id,
    u.id,
    mr.merge_reason,
    mr.merged_at
FROM (
    VALUES
    ('CIV-2026-000002', 'CIV-2026-000001', 'officer@civictrust.in', 'GPS proximity within 100m, same category, same ward. AI confidence 85%.', NOW() - INTERVAL '8 days'),
    ('CIV-2026-000005', 'CIV-2026-000004', 'officer@civictrust.in', 'Same dump site confirmed on ground. AI flagged 80% similarity.', NOW() - INTERVAL '6 days'),
    ('CIV-2026-000007', 'CIV-2026-000006', 'officer@civictrust.in', 'Same pipeline confirmed by water supply department. AI confidence 90%.', NOW() - INTERVAL '4 days')
) AS mr(source_number, target_number, merge_by_email, merge_reason, merged_at)
JOIN issues source ON source.issue_number = mr.source_number
JOIN issues target ON target.issue_number = mr.target_number
JOIN users u ON u.email = mr.merge_by_email;