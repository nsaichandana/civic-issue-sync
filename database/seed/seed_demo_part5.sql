-- ============================================================
-- NOTIFICATIONS (20)
-- ============================================================

INSERT INTO notifications (user_id, issue_id, title, body, type, is_read, read_at, is_sent, sent_at, sent_via, created_at)
SELECT
    u.id,
    i.id,
    n.title,
    n.body,
    n.type,
    n.is_read,
    n.read_at,
    n.is_sent,
    n.sent_at,
    n.sent_via,
    n.created_at
FROM (
    VALUES
    ('citizen@civictrust.in', 'CIV-2026-000001', 'Your report has been converted to an issue', 'Your report about pothole on Alipiri Main Road has been officially registered as Issue CIV-2026-000001.', 'ISSUE_CREATED', TRUE, NOW() - INTERVAL '9 days', TRUE, NOW() - INTERVAL '9 days', 'IN_APP', NOW() - INTERVAL '9 days'),
    ('citizen@civictrust.in', 'CIV-2026-000001', 'Issue CIV-2026-000001 has been assigned', 'A field worker has been assigned to fix the pothole on Alipiri Main Road.', 'ISSUE_ASSIGNED', TRUE, NOW() - INTERVAL '8 days', TRUE, NOW() - INTERVAL '8 days', 'IN_APP', NOW() - INTERVAL '8 days'),
    ('citizen@civictrust.in', 'CIV-2026-000001', 'Issue CIV-2026-000001 has been resolved', 'The pothole on Alipiri Main Road has been repaired. Please verify and confirm.', 'ISSUE_RESOLVED', TRUE, NOW() - INTERVAL '2 days', TRUE, NOW() - INTERVAL '2 days', 'IN_APP', NOW() - INTERVAL '2 days'),
    ('worker@civictrust.in', 'CIV-2026-000001', 'New assignment: Alipiri Pothole Repair', 'You have been assigned to Issue CIV-2026-000001. Please begin site inspection.', 'ASSIGNMENT_RECEIVED', TRUE, NOW() - INTERVAL '8 days', TRUE, NOW() - INTERVAL '8 days', 'IN_APP', NOW() - INTERVAL '8 days'),
    ('officer@civictrust.in', 'CIV-2026-000001', 'Assignment completed: CIV-2026-000001', 'Field worker Ravi Shankar has completed the repair work on Alipiri Main Road.', 'ASSIGNMENT_COMPLETED', TRUE, NOW() - INTERVAL '2 days', TRUE, NOW() - INTERVAL '2 days', 'IN_APP', NOW() - INTERVAL '2 days'),
    ('citizen@civictrust.in', 'CIV-2026-000002', 'Your report has been converted to an issue', 'Your report about potholes on RC Road has been registered as Issue CIV-2026-000002.', 'ISSUE_CREATED', TRUE, NOW() - INTERVAL '6 days', TRUE, NOW() - INTERVAL '6 days', 'IN_APP', NOW() - INTERVAL '6 days'),
    ('citizen@civictrust.in', 'CIV-2026-000002', 'Issue CIV-2026-000002 is now in progress', 'Repair work has started on RC Road potholes. Expected completion in 2 days.', 'ISSUE_UPDATED', TRUE, NOW() - INTERVAL '4 days', TRUE, NOW() - INTERVAL '4 days', 'IN_APP', NOW() - INTERVAL '4 days'),
    ('officer@civictrust.in', 'CIV-2026-000002', 'SLA Warning: CIV-2026-000002 due soon', 'Issue CIV-2026-000002 is approaching its SLA deadline. Please ensure timely completion.', 'SLA_WARNING', FALSE, NULL, TRUE, NOW() - INTERVAL '1 day', 'IN_APP', NOW() - INTERVAL '1 day'),
    ('citizen@civictrust.in', 'CIV-2026-000004', 'Your report has been converted to an issue', 'Your garbage report on Renigunta Road has been registered as Issue CIV-2026-000004.', 'ISSUE_CREATED', TRUE, NOW() - INTERVAL '7 days', TRUE, NOW() - INTERVAL '7 days', 'IN_APP', NOW() - INTERVAL '7 days'),
    ('citizen@civictrust.in', 'CIV-2026-000004', 'Issue CIV-2026-000004 has been assigned', 'A sanitation worker has been assigned to clear the garbage on Renigunta Road.', 'ISSUE_ASSIGNED', TRUE, NOW() - INTERVAL '5 days', TRUE, NOW() - INTERVAL '5 days', 'IN_APP', NOW() - INTERVAL '5 days'),
    ('worker@civictrust.in', 'CIV-2026-000004', 'New assignment: Renigunta Road Garbage', 'You have been assigned to Issue CIV-2026-000004. Clear all waste from Renigunta Road.', 'ASSIGNMENT_RECEIVED', TRUE, NOW() - INTERVAL '5 days', TRUE, NOW() - INTERVAL '5 days', 'IN_APP', NOW() - INTERVAL '5 days'),
    ('citizen@civictrust.in', 'CIV-2026-000006', 'Your report has been converted to an issue', 'Critical pipe burst in Bhavani Nagar registered as Issue CIV-2026-000006. Emergency response initiated.', 'ISSUE_CREATED', TRUE, NOW() - INTERVAL '5 days', TRUE, NOW() - INTERVAL '5 days', 'IN_APP', NOW() - INTERVAL '5 days'),
    ('citizen@civictrust.in', 'CIV-2026-000006', 'Issue CIV-2026-000006 has been resolved', 'The water pipeline in Bhavani Nagar has been repaired and water supply restored.', 'ISSUE_RESOLVED', TRUE, NOW() - INTERVAL '1 day', TRUE, NOW() - INTERVAL '1 day', 'IN_APP', NOW() - INTERVAL '1 day'),
    ('worker@civictrust.in', 'CIV-2026-000006', 'New assignment: Bhavani Nagar Pipeline', 'You have been assigned to repair the burst pipeline in Bhavani Nagar. Urgent.', 'ASSIGNMENT_RECEIVED', TRUE, NOW() - INTERVAL '4 days', TRUE, NOW() - INTERVAL '4 days', 'IN_APP', NOW() - INTERVAL '4 days'),
    ('officer@civictrust.in', 'CIV-2026-000006', 'Assignment completed: CIV-2026-000006', 'Ravi Shankar has completed pipeline repair in Bhavani Nagar. Issue ready to close.', 'ASSIGNMENT_COMPLETED', TRUE, NOW() - INTERVAL '1 day', TRUE, NOW() - INTERVAL '1 day', 'IN_APP', NOW() - INTERVAL '1 day'),
    ('citizen@civictrust.in', 'CIV-2026-000007', 'Your report has been converted to an issue', 'Streetlight issue in Srinivasapuram registered as Issue CIV-2026-000007.', 'ISSUE_CREATED', TRUE, NOW() - INTERVAL '5 days', TRUE, NOW() - INTERVAL '5 days', 'IN_APP', NOW() - INTERVAL '5 days'),
    ('worker@civictrust.in', 'CIV-2026-000007', 'New assignment: Srinivasapuram Streetlights', 'You have been assigned to repair streetlights in Srinivasapuram colony.', 'ASSIGNMENT_RECEIVED', FALSE, NULL, TRUE, NOW() - INTERVAL '4 days', 'IN_APP', NOW() - INTERVAL '4 days'),
    ('citizen@civictrust.in', 'CIV-2026-000008', 'Your report has been converted to an issue', 'Drain blockage on Tiruchanoor Road registered as Issue CIV-2026-000008.', 'ISSUE_CREATED', TRUE, NOW() - INTERVAL '6 days', TRUE, NOW() - INTERVAL '6 days', 'IN_APP', NOW() - INTERVAL '6 days'),
    ('worker@civictrust.in', 'CIV-2026-000008', 'New assignment: Tiruchanoor Drain', 'You have been assigned to clear the blocked drain on Tiruchanoor Road.', 'ASSIGNMENT_RECEIVED', FALSE, NULL, TRUE, NOW() - INTERVAL '5 days', 'IN_APP', NOW() - INTERVAL '5 days'),
    ('officer@civictrust.in', NULL, 'System: Daily Summary', '8 active issues, 3 assigned, 2 in progress, 2 resolved today. Review dashboard.', 'SYSTEM', FALSE, NULL, TRUE, NOW(), 'IN_APP', NOW())
) AS n(user_email, issue_number, title, body, type, is_read, read_at, is_sent, sent_at, sent_via, created_at)
JOIN users u ON u.email = n.user_email
LEFT JOIN issues i ON i.issue_number = n.issue_number;

-- ============================================================
-- AUDIT LOGS (30)
-- ============================================================

INSERT INTO audit_logs (actor_id, entity_type, entity_id, action, old_value, new_value, description, created_at)
SELECT
    u.id,
    al.entity_type,
    al.entity_id,
    al.action,
    al.old_value,
    al.new_value,
    al.description,
    al.created_at
FROM (
    VALUES
    ('citizen@civictrust.in', 'REPORT', (SELECT id FROM reports WHERE title = 'Large pothole on Alipiri Main Road'), 'CREATED', NULL, '{"status":"SUBMITTED"}', 'Citizen submitted pothole report on Alipiri Road', NOW() - INTERVAL '10 days'),
    ('citizen@civictrust.in', 'REPORT', (SELECT id FROM reports WHERE title = 'Deep crater near Alipiri junction'), 'CREATED', NULL, '{"status":"SUBMITTED"}', 'Citizen submitted road crater report on Alipiri Road', NOW() - INTERVAL '9 days'),
    ('citizen@civictrust.in', 'REPORT', (SELECT id FROM reports WHERE title = 'Garbage pile near Renigunta Road bus stop'), 'CREATED', NULL, '{"status":"SUBMITTED"}', 'Citizen submitted garbage report on Renigunta Road', NOW() - INTERVAL '8 days'),
    ('citizen@civictrust.in', 'REPORT', (SELECT id FROM reports WHERE title = 'Water pipe burst in Bhavani Nagar'), 'CREATED', NULL, '{"status":"SUBMITTED"}', 'Citizen submitted pipe burst report in Bhavani Nagar', NOW() - INTERVAL '6 days'),
    (NULL, 'REPORT', (SELECT id FROM reports WHERE title = 'Large pothole on Alipiri Main Road'), 'STATUS_CHANGED', '{"status":"SUBMITTED"}', '{"status":"UNDER_AI_ANALYSIS"}', 'System triggered AI analysis for report R001', NOW() - INTERVAL '10 days'),
    (NULL, 'REPORT', (SELECT id FROM reports WHERE title = 'Deep crater near Alipiri junction'), 'STATUS_CHANGED', '{"status":"SUBMITTED"}', '{"status":"UNDER_AI_ANALYSIS"}', 'System triggered AI analysis for report R002', NOW() - INTERVAL '9 days'),
    (NULL, 'REPORT', (SELECT id FROM reports WHERE title = 'Water pipe burst in Bhavani Nagar'), 'STATUS_CHANGED', '{"status":"SUBMITTED"}', '{"status":"UNDER_AI_ANALYSIS"}', 'System triggered AI analysis for report R008', NOW() - INTERVAL '6 days'),
    (NULL, 'DRAFT_ISSUE', (SELECT id FROM draft_issues WHERE report_id = (SELECT id FROM reports WHERE title = 'Large pothole on Alipiri Main Road')), 'CREATED', NULL, '{"status":"PENDING","priority":"HIGH"}', 'AI created draft issue from report R001', NOW() - INTERVAL '9 days'),
    (NULL, 'DRAFT_ISSUE', (SELECT id FROM draft_issues WHERE report_id = (SELECT id FROM reports WHERE title = 'Water pipe burst in Bhavani Nagar')), 'CREATED', NULL, '{"status":"PENDING","priority":"CRITICAL"}', 'AI created draft issue from report R008 — CRITICAL flag', NOW() - INTERVAL '5 days'),
    ('officer@civictrust.in', 'DRAFT_ISSUE', (SELECT id FROM draft_issues WHERE report_id = (SELECT id FROM reports WHERE title = 'Large pothole on Alipiri Main Road')), 'APPROVED', '{"status":"PENDING"}', '{"status":"APPROVED"}', 'Officer Suresh approved draft issue for Alipiri pothole', NOW() - INTERVAL '9 days'),
    ('officer@civictrust.in', 'DRAFT_ISSUE', (SELECT id FROM draft_issues WHERE report_id = (SELECT id FROM reports WHERE title = 'Pothole on RC Road near SBI Bank')), 'APPROVED', '{"status":"PENDING"}', '{"status":"APPROVED"}', 'Officer Suresh approved draft issue for RC Road', NOW() - INTERVAL '6 days'),
    ('officer@civictrust.in', 'DRAFT_ISSUE', (SELECT id FROM draft_issues WHERE report_id = (SELECT id FROM reports WHERE title = 'Water pipe burst in Bhavani Nagar')), 'APPROVED', '{"status":"PENDING"}', '{"status":"APPROVED"}', 'Officer Suresh approved CRITICAL pipe burst issue', NOW() - INTERVAL '5 days'),
    ('officer@civictrust.in', 'DRAFT_ISSUE', (SELECT id FROM draft_issues WHERE report_id = (SELECT id FROM reports WHERE title = 'Road damaged in Balaji Colony')), 'REJECTED', '{"status":"PENDING"}', '{"status":"REJECTED"}', 'Officer rejected Balaji Colony report — unclear photo', NOW() - INTERVAL '4 days'),
    ('officer@civictrust.in', 'ISSUE', (SELECT id FROM issues WHERE issue_number = 'CIV-2026-000001'), 'CREATED', NULL, '{"status":"OPEN","priority":"HIGH"}', 'Issue CIV-2026-000001 created for Alipiri pothole', NOW() - INTERVAL '9 days'),
    ('officer@civictrust.in', 'ISSUE', (SELECT id FROM issues WHERE issue_number = 'CIV-2026-000006'), 'CREATED', NULL, '{"status":"OPEN","priority":"CRITICAL"}', 'Issue CIV-2026-000006 created for Bhavani Nagar pipe burst', NOW() - INTERVAL '5 days'),
    ('officer@civictrust.in', 'ASSIGNMENT', (SELECT id FROM assignments WHERE issue_id = (SELECT id FROM issues WHERE issue_number = 'CIV-2026-000001')), 'ASSIGNED', NULL, '{"assigned_to":"Ravi Shankar","status":"ASSIGNED"}', 'Issue CIV-2026-000001 assigned to Ravi Shankar', NOW() - INTERVAL '8 days'),
    ('officer@civictrust.in', 'ASSIGNMENT', (SELECT id FROM assignments WHERE issue_id = (SELECT id FROM issues WHERE issue_number = 'CIV-2026-000006')), 'ASSIGNED', NULL, '{"assigned_to":"Ravi Shankar","status":"ASSIGNED"}', 'Issue CIV-2026-000006 assigned to Ravi Shankar', NOW() - INTERVAL '4 days'),
    ('worker@civictrust.in', 'ISSUE', (SELECT id FROM issues WHERE issue_number = 'CIV-2026-000001'), 'STATUS_CHANGED', '{"status":"ASSIGNED"}', '{"status":"IN_PROGRESS"}', 'Field worker started work on CIV-2026-000001', NOW() - INTERVAL '7 days'),
    ('worker@civictrust.in', 'ISSUE', (SELECT id FROM issues WHERE issue_number = 'CIV-2026-000001'), 'STATUS_CHANGED', '{"status":"IN_PROGRESS"}', '{"status":"RESOLVED"}', 'CIV-2026-000001 marked resolved by field worker', NOW() - INTERVAL '2 days'),
    ('officer@civictrust.in', 'ISSUE', (SELECT id FROM issues WHERE issue_number = 'CIV-2026-000001'), 'STATUS_CHANGED', '{"status":"RESOLVED"}', '{"status":"CLOSED"}', 'Officer closed CIV-2026-000001 after verification', NOW() - INTERVAL '1 day'),
    ('worker@civictrust.in', 'ISSUE', (SELECT id FROM issues WHERE issue_number = 'CIV-2026-000006'), 'STATUS_CHANGED', '{"status":"ASSIGNED"}', '{"status":"IN_PROGRESS"}', 'Field worker started pipe repair on CIV-2026-000006', NOW() - INTERVAL '3 days'),
    ('worker@civictrust.in', 'ISSUE', (SELECT id FROM issues WHERE issue_number = 'CIV-2026-000006'), 'STATUS_CHANGED', '{"status":"IN_PROGRESS"}', '{"status":"RESOLVED"}', 'CIV-2026-000006 marked resolved after pipe repair', NOW() - INTERVAL '1 day'),
    ('officer@civictrust.in', 'ISSUE', (SELECT id FROM issues WHERE issue_number = 'CIV-2026-000006'), 'STATUS_CHANGED', '{"status":"RESOLVED"}', '{"status":"CLOSED"}', 'Officer closed CIV-2026-000006 after verification', NOW() - INTERVAL '1 day'),
    ('worker@civictrust.in', 'FIELD_TASK', (SELECT id FROM field_tasks WHERE title = 'Site Inspection' AND assignment_id = (SELECT id FROM assignments WHERE issue_id = (SELECT id FROM issues WHERE issue_number = 'CIV-2026-000001'))), 'COMPLETED', '{"status":"PENDING"}', '{"status":"COMPLETED"}', 'Site inspection completed for Alipiri assignment', NOW() - INTERVAL '7 days'),
    ('worker@civictrust.in', 'FIELD_TASK', (SELECT id FROM field_tasks WHERE title = 'Fill Pothole with Bitumen' AND assignment_id = (SELECT id FROM assignments WHERE issue_id = (SELECT id FROM issues WHERE issue_number = 'CIV-2026-000001'))), 'COMPLETED', '{"status":"PENDING"}', '{"status":"COMPLETED"}', 'Pothole filled with bitumen on Alipiri Road', NOW() - INTERVAL '3 days'),
    ('worker@civictrust.in', 'FIELD_TASK', (SELECT id FROM field_tasks WHERE title = 'Replace Pipe Section' AND assignment_id = (SELECT id FROM assignments WHERE issue_id = (SELECT id FROM issues WHERE issue_number = 'CIV-2026-000006'))), 'COMPLETED', '{"status":"IN_PROGRESS"}', '{"status":"COMPLETED"}', 'Pipe section replaced in Bhavani Nagar', NOW() - INTERVAL '2 days'),
    ('worker@civictrust.in', 'RESOLUTION_EVIDENCE', (SELECT id FROM resolution_evidence WHERE caption = 'Large pothole before repair at Alipiri Main Road'), 'CREATED', NULL, '{"stage":"BEFORE","type":"IMAGE"}', 'Before evidence submitted for Alipiri pothole', NOW() - INTERVAL '7 days'),
    ('worker@civictrust.in', 'RESOLUTION_EVIDENCE', (SELECT id FROM resolution_evidence WHERE caption = 'Pothole fully repaired, smooth road surface'), 'CREATED', NULL, '{"stage":"AFTER","type":"IMAGE"}', 'After evidence submitted for Alipiri pothole', NOW() - INTERVAL '2 days'),
    ('worker@civictrust.in', 'RESOLUTION_EVIDENCE', (SELECT id FROM resolution_evidence WHERE caption = 'Burst pipe with water flooding Bhavani Nagar road'), 'CREATED', NULL, '{"stage":"BEFORE","type":"IMAGE"}', 'Before evidence submitted for Bhavani Nagar pipe', NOW() - INTERVAL '3 days'),
    ('worker@civictrust.in', 'RESOLUTION_EVIDENCE', (SELECT id FROM resolution_evidence WHERE caption = 'Pipeline repaired, dry road in Bhavani Nagar'), 'CREATED', NULL, '{"stage":"AFTER","type":"IMAGE"}', 'After evidence submitted for Bhavani Nagar pipe', NOW() - INTERVAL '1 day')
) AS al(actor_email, entity_type, entity_id, action, old_value, new_value, description, created_at)
LEFT JOIN users u ON u.email = al.actor_email;