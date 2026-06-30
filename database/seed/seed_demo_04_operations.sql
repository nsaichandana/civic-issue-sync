-- ============================================================
-- CivicTrust
-- seed_demo_04_operations.sql
-- Demo Seed: Assignments, Field Tasks, Resolution Evidence,
--            Notifications, Audit Logs
-- Depends on: seed_demo_03_issue_lifecycle.sql already executed
-- ============================================================

DO $$
DECLARE
    -- user ids
    v_officer_id  UUID;
    v_worker_id   UUID;
    v_citizen_id  UUID;

    -- issue ids (resolved by issue_number)
    i01 UUID; i02 UUID; i03 UUID; i04 UUID;
    i05 UUID; i06 UUID; i07 UUID; i08 UUID;

    -- assignment ids
    asn01 UUID; asn02 UUID; asn03 UUID; asn04 UUID;
    asn05 UUID; asn06 UUID; asn07 UUID; asn08 UUID; asn09 UUID;

BEGIN

    -- --------------------------------------------------------
    -- Resolve user IDs
    -- --------------------------------------------------------
    SELECT id INTO v_officer_id FROM users WHERE email = 'officer@civictrust.in';
    SELECT id INTO v_worker_id  FROM users WHERE email = 'worker@civictrust.in';
    SELECT id INTO v_citizen_id FROM users WHERE email = 'citizen@civictrust.in';

    -- --------------------------------------------------------
    -- Resolve issue IDs by issue_number
    -- --------------------------------------------------------
    SELECT id INTO i01 FROM issues WHERE issue_number = 'CIV-2026-000001';
    SELECT id INTO i02 FROM issues WHERE issue_number = 'CIV-2026-000002';
    SELECT id INTO i03 FROM issues WHERE issue_number = 'CIV-2026-000003';
    SELECT id INTO i04 FROM issues WHERE issue_number = 'CIV-2026-000004';
    SELECT id INTO i05 FROM issues WHERE issue_number = 'CIV-2026-000005';
    SELECT id INTO i06 FROM issues WHERE issue_number = 'CIV-2026-000006';
    SELECT id INTO i07 FROM issues WHERE issue_number = 'CIV-2026-000007';
    SELECT id INTO i08 FROM issues WHERE issue_number = 'CIV-2026-000008';

    -- --------------------------------------------------------
    -- Generate new UUIDs for assignments
    -- --------------------------------------------------------
    asn01 := gen_random_uuid(); asn02 := gen_random_uuid();
    asn03 := gen_random_uuid(); asn04 := gen_random_uuid();
    asn05 := gen_random_uuid(); asn06 := gen_random_uuid();
    asn07 := gen_random_uuid(); asn08 := gen_random_uuid();
    asn09 := gen_random_uuid();

    -- --------------------------------------------------------
    -- ASSIGNMENTS (9 — includes one cancel + reassign pair on i04)
    -- --------------------------------------------------------
    INSERT INTO assignments (
        id, issue_id, assigned_to, assigned_by, status, notes,
        assigned_at, due_date, accepted_at, completed_at,
        cancelled_at, cancellation_reason,
        created_at, updated_at
    ) VALUES

    -- asn01: i01 Alipiri pothole — COMPLETED
    (asn01, i01, v_worker_id, v_officer_id, 'COMPLETED',
     'Repair pothole with bitumen. Barricade area before starting work.',
     NOW() - INTERVAL '8 days', NOW() - INTERVAL '5 days',
     NOW() - INTERVAL '7 days', NOW() - INTERVAL '2 days',
     NULL, NULL,
     NOW() - INTERVAL '8 days', NOW() - INTERVAL '2 days'),

    -- asn02: i02 RC Road potholes — IN_PROGRESS
    (asn02, i02, v_worker_id, v_officer_id, 'IN_PROGRESS',
     'Fill all five potholes on RC Road stretch near SBI Bank.',
     NOW() - INTERVAL '5 days', NOW() - INTERVAL '2 days',
     NOW() - INTERVAL '4 days', NULL,
     NULL, NULL,
     NOW() - INTERVAL '5 days', NOW() - INTERVAL '4 days'),

    -- asn03: i03 Tiruchanoor garbage bin — ASSIGNED
    (asn03, i03, v_worker_id, v_officer_id, 'ASSIGNED',
     'Empty overflowing bin and arrange replacement bin if damaged.',
     NOW() - INTERVAL '2 days', NOW() + INTERVAL '1 day',
     NULL, NULL,
     NULL, NULL,
     NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),

    -- asn04: i04 Renigunta garbage — first attempt CANCELLED
    (asn04, i04, v_worker_id, v_officer_id, 'CANCELLED',
     'Initial assignment for Renigunta Road garbage clearance.',
     NOW() - INTERVAL '6 days', NOW() - INTERVAL '4 days',
     NULL, NULL,
     NOW() - INTERVAL '5 days', 'Field worker unavailable due to prior commitment on another site.',
     NOW() - INTERVAL '6 days', NOW() - INTERVAL '5 days'),

    -- asn05: i04 Renigunta garbage — REASSIGNED, now ACCEPTED
    (asn05, i04, v_worker_id, v_officer_id, 'ACCEPTED',
     'Reassigned after first attempt cancelled. Clear all waste from Renigunta Road including footpath debris.',
     NOW() - INTERVAL '5 days', NOW() - INTERVAL '2 days',
     NOW() - INTERVAL '4 days', NULL,
     NULL, NULL,
     NOW() - INTERVAL '5 days', NOW() - INTERVAL '4 days'),

    -- asn06: i05 Bhavani Nagar pipeline — COMPLETED
    (asn06, i05, v_worker_id, v_officer_id, 'COMPLETED',
     'Repair burst pipeline. Shut off main valve before starting work.',
     NOW() - INTERVAL '4 days', NOW() - INTERVAL '2 days',
     NOW() - INTERVAL '3 days', NOW() - INTERVAL '1 day',
     NULL, NULL,
     NOW() - INTERVAL '4 days', NOW() - INTERVAL '1 day'),

    -- asn07: i06 Korlagunta water leak — ASSIGNED
    (asn07, i06, v_worker_id, v_officer_id, 'ASSIGNED',
     'Inspect pipeline joint and repair leak on Korlagunta main street.',
     NOW() - INTERVAL '1 day', NOW() + INTERVAL '2 days',
     NULL, NULL,
     NULL, NULL,
     NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day'),

    -- asn08: i07 Srinivasapuram streetlights — IN_PROGRESS
    (asn08, i07, v_worker_id, v_officer_id, 'IN_PROGRESS',
     'Replace faulty bulbs and inspect wiring for all five streetlights.',
     NOW() - INTERVAL '4 days', NOW() - INTERVAL '1 day',
     NOW() - INTERVAL '3 days', NULL,
     NULL, NULL,
     NOW() - INTERVAL '4 days', NOW() - INTERVAL '3 days'),

    -- asn09: i08 Tiruchanoor drain — ASSIGNED
    (asn09, i08, v_worker_id, v_officer_id, 'ASSIGNED',
     'Clear drain blockage using high pressure flush equipment.',
     NOW() - INTERVAL '5 days', NOW() - INTERVAL '1 day',
     NULL, NULL,
     NULL, NULL,
     NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days');

    -- --------------------------------------------------------
    -- FIELD TASKS (20)
    -- --------------------------------------------------------
    INSERT INTO field_tasks (
        id, assignment_id, title, description, status,
        completed_by, completed_at, created_at, updated_at
    ) VALUES

    -- asn01: Alipiri pothole — 4 tasks, all COMPLETED
    (gen_random_uuid(), asn01, 'Site Inspection',
     'Inspect pothole dimensions and assess severity.',
     'COMPLETED', v_worker_id, NOW() - INTERVAL '7 days',
     NOW() - INTERVAL '8 days', NOW() - INTERVAL '7 days'),

    (gen_random_uuid(), asn01, 'Place Barricades',
     'Set up traffic barricades around the damaged area.',
     'COMPLETED', v_worker_id, NOW() - INTERVAL '6 days',
     NOW() - INTERVAL '8 days', NOW() - INTERVAL '6 days'),

    (gen_random_uuid(), asn01, 'Fill Pothole with Bitumen',
     'Apply hot bitumen mix and compact the surface properly.',
     'COMPLETED', v_worker_id, NOW() - INTERVAL '3 days',
     NOW() - INTERVAL '8 days', NOW() - INTERVAL '3 days'),

    (gen_random_uuid(), asn01, 'Final Quality Check',
     'Verify surface is level and safe for vehicle traffic.',
     'COMPLETED', v_worker_id, NOW() - INTERVAL '2 days',
     NOW() - INTERVAL '8 days', NOW() - INTERVAL '2 days'),

    -- asn02: RC Road potholes — 3 tasks, mixed status
    (gen_random_uuid(), asn02, 'Site Survey',
     'Map all five pothole locations on RC Road stretch.',
     'COMPLETED', v_worker_id, NOW() - INTERVAL '4 days',
     NOW() - INTERVAL '5 days', NOW() - INTERVAL '4 days'),

    (gen_random_uuid(), asn02, 'Material Procurement',
     'Arrange bitumen mix and tools for repair work.',
     'COMPLETED', v_worker_id, NOW() - INTERVAL '3 days',
     NOW() - INTERVAL '5 days', NOW() - INTERVAL '3 days'),

    (gen_random_uuid(), asn02, 'Pothole Repair Work',
     'Fill and compact all five identified potholes.',
     'IN_PROGRESS', NULL, NULL,
     NOW() - INTERVAL '5 days', NOW() - INTERVAL '4 days'),

    -- asn03: Tiruchanoor garbage bin — 1 task, PENDING
    (gen_random_uuid(), asn03, 'Empty Garbage Bin',
     'Empty overflowing bin and transport waste to municipal depot.',
     'PENDING', NULL, NULL,
     NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),

    -- asn05: Renigunta garbage — 3 tasks, mixed status
    (gen_random_uuid(), asn05, 'Assess Waste Volume',
     'Estimate total waste volume to arrange appropriate vehicles.',
     'COMPLETED', v_worker_id, NOW() - INTERVAL '3 days',
     NOW() - INTERVAL '4 days', NOW() - INTERVAL '3 days'),

    (gen_random_uuid(), asn05, 'Clear Primary Garbage Pile',
     'Remove the main garbage accumulation from the road.',
     'IN_PROGRESS', NULL, NULL,
     NOW() - INTERVAL '4 days', NOW() - INTERVAL '3 days'),

    (gen_random_uuid(), asn05, 'Disinfect Affected Area',
     'Spray disinfectant after garbage removal is complete.',
     'PENDING', NULL, NULL,
     NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days'),

    -- asn06: Bhavani Nagar pipeline — 4 tasks, all COMPLETED
    (gen_random_uuid(), asn06, 'Locate Burst Point',
     'Identify exact location of pipe burst using pressure testing.',
     'COMPLETED', v_worker_id, NOW() - INTERVAL '3 days',
     NOW() - INTERVAL '4 days', NOW() - INTERVAL '3 days'),

    (gen_random_uuid(), asn06, 'Shut Off Water Supply',
     'Close the main valve to stop water flow to affected section.',
     'COMPLETED', v_worker_id, NOW() - INTERVAL '3 days',
     NOW() - INTERVAL '4 days', NOW() - INTERVAL '3 days'),

    (gen_random_uuid(), asn06, 'Replace Pipe Section',
     'Cut out and replace the damaged pipe section.',
     'COMPLETED', v_worker_id, NOW() - INTERVAL '2 days',
     NOW() - INTERVAL '4 days', NOW() - INTERVAL '2 days'),

    (gen_random_uuid(), asn06, 'Restore Water Supply',
     'Reopen valve and test water flow and pressure.',
     'COMPLETED', v_worker_id, NOW() - INTERVAL '1 day',
     NOW() - INTERVAL '4 days', NOW() - INTERVAL '1 day'),

    -- asn08: Srinivasapuram streetlights — 2 tasks, mixed status
    (gen_random_uuid(), asn08, 'Inspect All Lights',
     'Check all five streetlights and identify specific faults.',
     'COMPLETED', v_worker_id, NOW() - INTERVAL '2 days',
     NOW() - INTERVAL '3 days', NOW() - INTERVAL '2 days'),

    (gen_random_uuid(), asn08, 'Replace Faulty Bulbs',
     'Replace faulty bulbs with new LED units and check wiring.',
     'IN_PROGRESS', NULL, NULL,
     NOW() - INTERVAL '3 days', NOW() - INTERVAL '2 days'),

    -- asn09: Tiruchanoor drain — 2 tasks, PENDING
    (gen_random_uuid(), asn09, 'Drain Inspection',
     'Inspect blockage point and estimate clearing effort required.',
     'PENDING', NULL, NULL,
     NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days'),

    (gen_random_uuid(), asn09, 'High Pressure Flush',
     'Use pressure flushing equipment to clear the blockage.',
     'PENDING', NULL, NULL,
     NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days'),

    -- asn07: Korlagunta water leak — 1 task, PENDING
    (gen_random_uuid(), asn07, 'Joint Inspection and Repair',
     'Inspect leaking pipeline joint and reseal or replace fitting.',
     'PENDING', NULL, NULL,
     NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day');

    -- --------------------------------------------------------
    -- RESOLUTION EVIDENCE (16)
    -- --------------------------------------------------------
    INSERT INTO resolution_evidence (
        id, assignment_id, submitted_by, media_type, evidence_stage,
        file_url, file_name, mime_type, file_size, caption,
        latitude, longitude, taken_at, created_at
    ) VALUES

    -- asn01: Alipiri pothole — BEFORE, IN_PROGRESS, AFTER (image) + AFTER (video)
    (gen_random_uuid(), asn01, v_worker_id, 'IMAGE', 'BEFORE',
     'https://storage.civictrust.in/evidence/asn01_before_01.jpg',
     'alipiri_before_01.jpg', 'image/jpeg', 312456,
     'Large pothole before repair work began.',
     13.62881, 79.41923, NOW() - INTERVAL '7 days', NOW() - INTERVAL '7 days'),

    (gen_random_uuid(), asn01, v_worker_id, 'IMAGE', 'IN_PROGRESS',
     'https://storage.civictrust.in/evidence/asn01_progress_01.jpg',
     'alipiri_progress_01.jpg', 'image/jpeg', 289120,
     'Barricades placed and bitumen being laid.',
     13.62881, 79.41923, NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days'),

    (gen_random_uuid(), asn01, v_worker_id, 'IMAGE', 'AFTER',
     'https://storage.civictrust.in/evidence/asn01_after_01.jpg',
     'alipiri_after_01.jpg', 'image/jpeg', 267840,
     'Pothole fully repaired with smooth road surface.',
     13.62881, 79.41923, NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),

    (gen_random_uuid(), asn01, v_worker_id, 'VIDEO', 'AFTER',
     'https://storage.civictrust.in/evidence/asn01_after_01.mp4',
     'alipiri_after_walkthrough.mp4', 'video/mp4', 5242880,
     'Video walkthrough of the repaired road stretch.',
     13.62881, 79.41923, NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),

    -- asn02: RC Road potholes — BEFORE + IN_PROGRESS
    (gen_random_uuid(), asn02, v_worker_id, 'IMAGE', 'BEFORE',
     'https://storage.civictrust.in/evidence/asn02_before_01.jpg',
     'rcroad_before_01.jpg', 'image/jpeg', 198432,
     'Multiple potholes visible on RC Road before repair.',
     13.63524, 79.41981, NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days'),

    (gen_random_uuid(), asn02, v_worker_id, 'IMAGE', 'IN_PROGRESS',
     'https://storage.civictrust.in/evidence/asn02_progress_01.jpg',
     'rcroad_progress_01.jpg', 'image/jpeg', 221504,
     'Repair work in progress on RC Road stretch.',
     13.63524, 79.41981, NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),

    -- asn05: Renigunta garbage — BEFORE (image + video)
    (gen_random_uuid(), asn05, v_worker_id, 'IMAGE', 'BEFORE',
     'https://storage.civictrust.in/evidence/asn05_before_01.jpg',
     'renigunta_before_01.jpg', 'image/jpeg', 334080,
     'Massive garbage pile before clearance work began.',
     13.64893, 79.40982, NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days'),

    (gen_random_uuid(), asn05, v_worker_id, 'VIDEO', 'BEFORE',
     'https://storage.civictrust.in/evidence/asn05_before_01.mp4',
     'renigunta_before_extent.mp4', 'video/mp4', 7077888,
     'Video showing full extent of garbage dump on Renigunta Road.',
     13.64893, 79.40982, NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days'),

    -- asn06: Bhavani pipeline — BEFORE, IN_PROGRESS, AFTER (image) + AFTER (video)
    (gen_random_uuid(), asn06, v_worker_id, 'IMAGE', 'BEFORE',
     'https://storage.civictrust.in/evidence/asn06_before_01.jpg',
     'bhavani_before_01.jpg', 'image/jpeg', 401280,
     'Burst pipe with water flooding the road surface.',
     13.64212, 79.42313, NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days'),

    (gen_random_uuid(), asn06, v_worker_id, 'IMAGE', 'IN_PROGRESS',
     'https://storage.civictrust.in/evidence/asn06_progress_01.jpg',
     'bhavani_progress_01.jpg', 'image/jpeg', 356096,
     'Pipe section being replaced after valve shutoff.',
     13.64212, 79.42313, NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),

    (gen_random_uuid(), asn06, v_worker_id, 'IMAGE', 'AFTER',
     'https://storage.civictrust.in/evidence/asn06_after_01.jpg',
     'bhavani_after_01.jpg', 'image/jpeg', 278720,
     'Pipeline repaired with dry road surface restored.',
     13.64212, 79.42313, NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day'),

    (gen_random_uuid(), asn06, v_worker_id, 'VIDEO', 'AFTER',
     'https://storage.civictrust.in/evidence/asn06_after_01.mp4',
     'bhavani_after_flow_test.mp4', 'video/mp4', 4823040,
     'Water flow restored and pressure tested successfully.',
     13.64212, 79.42313, NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day'),

    -- asn08: Srinivasapuram streetlights — BEFORE + IN_PROGRESS
    (gen_random_uuid(), asn08, v_worker_id, 'IMAGE', 'BEFORE',
     'https://storage.civictrust.in/evidence/asn08_before_01.jpg',
     'srinivasapuram_before_01.jpg', 'image/jpeg', 145280,
     'Dark street showing non-functional streetlights.',
     13.61984, 79.43124, NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),

    (gen_random_uuid(), asn08, v_worker_id, 'IMAGE', 'IN_PROGRESS',
     'https://storage.civictrust.in/evidence/asn08_progress_01.jpg',
     'srinivasapuram_progress_01.jpg', 'image/jpeg', 189440,
     'Technician replacing LED bulb on faulty streetlight.',
     13.61984, 79.43124, NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day'),

    -- asn09: Tiruchanoor drain — BEFORE (image + video)
    (gen_random_uuid(), asn09, v_worker_id, 'IMAGE', 'BEFORE',
     'https://storage.civictrust.in/evidence/asn09_before_01.jpg',
     'tiruchanoor_drain_before_01.jpg', 'image/jpeg', 234496,
     'Blocked drain overflowing onto residential road.',
     13.61824, 79.42714, NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days'),

    (gen_random_uuid(), asn09, v_worker_id, 'VIDEO', 'BEFORE',
     'https://storage.civictrust.in/evidence/asn09_before_01.mp4',
     'tiruchanoor_drain_overflow.mp4', 'video/mp4', 3984384,
     'Overflow situation captured during light rain.',
     13.61824, 79.42714, NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days');

    -- --------------------------------------------------------
    -- NOTIFICATIONS (25)
    -- --------------------------------------------------------
    INSERT INTO notifications (
        id, user_id, issue_id, title, body, type,
        is_read, read_at, is_sent, sent_at, sent_via, created_at
    ) VALUES

    (gen_random_uuid(), v_citizen_id, i01, 'Your report has been converted to an issue',
     'Your report about the pothole on Alipiri Main Road has been officially registered as Issue CIV-2026-000001.',
     'ISSUE_CREATED', TRUE, NOW() - INTERVAL '9 days', TRUE, NOW() - INTERVAL '9 days', 'IN_APP', NOW() - INTERVAL '9 days'),

    (gen_random_uuid(), v_citizen_id, i01, 'Issue CIV-2026-000001 has been assigned',
     'A field worker has been assigned to fix the pothole on Alipiri Main Road.',
     'ISSUE_ASSIGNED', TRUE, NOW() - INTERVAL '8 days', TRUE, NOW() - INTERVAL '8 days', 'IN_APP', NOW() - INTERVAL '8 days'),

    (gen_random_uuid(), v_citizen_id, i01, 'Issue CIV-2026-000001 has been resolved',
     'The pothole on Alipiri Main Road has been repaired. Please verify and confirm.',
     'ISSUE_RESOLVED', TRUE, NOW() - INTERVAL '2 days', TRUE, NOW() - INTERVAL '2 days', 'IN_APP', NOW() - INTERVAL '2 days'),

    (gen_random_uuid(), v_worker_id, i01, 'New assignment: Alipiri Pothole Repair',
     'You have been assigned to Issue CIV-2026-000001. Please begin site inspection.',
     'ASSIGNMENT_RECEIVED', TRUE, NOW() - INTERVAL '8 days', TRUE, NOW() - INTERVAL '8 days', 'IN_APP', NOW() - INTERVAL '8 days'),

    (gen_random_uuid(), v_officer_id, i01, 'Assignment completed: CIV-2026-000001',
     'Field worker has completed repair work on Alipiri Main Road.',
     'ASSIGNMENT_COMPLETED', TRUE, NOW() - INTERVAL '2 days', TRUE, NOW() - INTERVAL '2 days', 'IN_APP', NOW() - INTERVAL '2 days'),

    (gen_random_uuid(), v_citizen_id, i02, 'Your report has been converted to an issue',
     'Your report about potholes on RC Road has been registered as Issue CIV-2026-000002.',
     'ISSUE_CREATED', TRUE, NOW() - INTERVAL '6 days', TRUE, NOW() - INTERVAL '6 days', 'IN_APP', NOW() - INTERVAL '6 days'),

    (gen_random_uuid(), v_citizen_id, i02, 'Issue CIV-2026-000002 is now in progress',
     'Repair work has started on RC Road potholes. Expected completion in two days.',
     'ISSUE_UPDATED', TRUE, NOW() - INTERVAL '4 days', TRUE, NOW() - INTERVAL '4 days', 'IN_APP', NOW() - INTERVAL '4 days'),

    (gen_random_uuid(), v_officer_id, i02, 'SLA Warning: CIV-2026-000002 due soon',
     'Issue CIV-2026-000002 is approaching its SLA deadline. Please ensure timely completion.',
     'SLA_WARNING', FALSE, NULL, TRUE, NOW() - INTERVAL '1 day', 'IN_APP', NOW() - INTERVAL '1 day'),

    (gen_random_uuid(), v_citizen_id, i03, 'Your report has been converted to an issue',
     'Your report about the overflowing garbage bin on Tiruchanoor Road has been registered as Issue CIV-2026-000003.',
     'ISSUE_CREATED', TRUE, NOW() - INTERVAL '3 days', TRUE, NOW() - INTERVAL '3 days', 'IN_APP', NOW() - INTERVAL '3 days'),

    (gen_random_uuid(), v_worker_id, i03, 'New assignment: Tiruchanoor Garbage Bin',
     'You have been assigned to empty the overflowing garbage bin on Tiruchanoor Road.',
     'ASSIGNMENT_RECEIVED', FALSE, NULL, TRUE, NOW() - INTERVAL '2 days', 'IN_APP', NOW() - INTERVAL '2 days'),

    (gen_random_uuid(), v_citizen_id, i04, 'Your report has been converted to an issue',
     'Your report about garbage on Renigunta Road has been registered as Issue CIV-2026-000004.',
     'ISSUE_CREATED', TRUE, NOW() - INTERVAL '7 days', TRUE, NOW() - INTERVAL '7 days', 'IN_APP', NOW() - INTERVAL '7 days'),

    (gen_random_uuid(), v_citizen_id, i04, 'Issue CIV-2026-000004 has been assigned',
     'A sanitation worker has been assigned to clear the garbage on Renigunta Road.',
     'ISSUE_ASSIGNED', TRUE, NOW() - INTERVAL '5 days', TRUE, NOW() - INTERVAL '5 days', 'IN_APP', NOW() - INTERVAL '5 days'),

    (gen_random_uuid(), v_worker_id, i04, 'New assignment: Renigunta Road Garbage',
     'You have been reassigned to Issue CIV-2026-000004 after the previous worker was unavailable.',
     'ASSIGNMENT_RECEIVED', TRUE, NOW() - INTERVAL '5 days', TRUE, NOW() - INTERVAL '5 days', 'IN_APP', NOW() - INTERVAL '5 days'),

    (gen_random_uuid(), v_citizen_id, i05, 'Your report has been converted to an issue',
     'Critical pipe burst in Bhavani Nagar registered as Issue CIV-2026-000005. Emergency response initiated.',
     'ISSUE_CREATED', TRUE, NOW() - INTERVAL '5 days', TRUE, NOW() - INTERVAL '5 days', 'IN_APP', NOW() - INTERVAL '5 days'),

    (gen_random_uuid(), v_citizen_id, i05, 'Issue CIV-2026-000005 has been resolved',
     'The water pipeline in Bhavani Nagar has been repaired and water supply restored.',
     'ISSUE_RESOLVED', TRUE, NOW() - INTERVAL '1 day', TRUE, NOW() - INTERVAL '1 day', 'IN_APP', NOW() - INTERVAL '1 day'),

    (gen_random_uuid(), v_worker_id, i05, 'New assignment: Bhavani Nagar Pipeline',
     'You have been assigned to repair the burst pipeline in Bhavani Nagar. Urgent priority.',
     'ASSIGNMENT_RECEIVED', TRUE, NOW() - INTERVAL '4 days', TRUE, NOW() - INTERVAL '4 days', 'IN_APP', NOW() - INTERVAL '4 days'),

    (gen_random_uuid(), v_officer_id, i05, 'Assignment completed: CIV-2026-000005',
     'Field worker has completed pipeline repair in Bhavani Nagar. Issue ready to close.',
     'ASSIGNMENT_COMPLETED', TRUE, NOW() - INTERVAL '1 day', TRUE, NOW() - INTERVAL '1 day', 'IN_APP', NOW() - INTERVAL '1 day'),

    (gen_random_uuid(), v_citizen_id, i06, 'Your report has been converted to an issue',
     'Water pipeline leak on Korlagunta street registered as Issue CIV-2026-000006.',
     'ISSUE_CREATED', TRUE, NOW() - INTERVAL '2 days', TRUE, NOW() - INTERVAL '2 days', 'IN_APP', NOW() - INTERVAL '2 days'),

    (gen_random_uuid(), v_worker_id, i06, 'New assignment: Korlagunta Pipeline Leak',
     'You have been assigned to inspect and repair the pipeline leak on Korlagunta street.',
     'ASSIGNMENT_RECEIVED', FALSE, NULL, TRUE, NOW() - INTERVAL '1 day', 'IN_APP', NOW() - INTERVAL '1 day'),

    (gen_random_uuid(), v_citizen_id, i07, 'Your report has been converted to an issue',
     'Streetlight issue in Srinivasapuram registered as Issue CIV-2026-000007.',
     'ISSUE_CREATED', TRUE, NOW() - INTERVAL '5 days', TRUE, NOW() - INTERVAL '5 days', 'IN_APP', NOW() - INTERVAL '5 days'),

    (gen_random_uuid(), v_worker_id, i07, 'New assignment: Srinivasapuram Streetlights',
     'You have been assigned to repair streetlights in Srinivasapuram colony.',
     'ASSIGNMENT_RECEIVED', FALSE, NULL, TRUE, NOW() - INTERVAL '4 days', 'IN_APP', NOW() - INTERVAL '4 days'),

    (gen_random_uuid(), v_officer_id, i07, 'SLA Warning: CIV-2026-000007 due tomorrow',
     'Issue CIV-2026-000007 SLA deadline is tomorrow. Field worker has been notified.',
     'SLA_WARNING', FALSE, NULL, TRUE, NOW(), 'IN_APP', NOW()),

    (gen_random_uuid(), v_citizen_id, i08, 'Your report has been converted to an issue',
     'Drain blockage on Tiruchanoor Road registered as Issue CIV-2026-000008.',
     'ISSUE_CREATED', TRUE, NOW() - INTERVAL '6 days', TRUE, NOW() - INTERVAL '6 days', 'IN_APP', NOW() - INTERVAL '6 days'),

    (gen_random_uuid(), v_worker_id, i08, 'New assignment: Tiruchanoor Drain',
     'You have been assigned to clear the blocked drain on Tiruchanoor Road.',
     'ASSIGNMENT_RECEIVED', FALSE, NULL, TRUE, NOW() - INTERVAL '5 days', 'IN_APP', NOW() - INTERVAL '5 days'),

    (gen_random_uuid(), v_officer_id, NULL, 'System: Daily Summary',
     '8 active issues, 2 resolved today, 1 SLA warning pending. Review dashboard for full details.',
     'SYSTEM', FALSE, NULL, TRUE, NOW(), 'IN_APP', NOW()),

    (gen_random_uuid(), v_officer_id, NULL, 'System: Daily Summary',
     '3 issues currently assigned to field workers. 1 SLA breach is imminent.',
     'SYSTEM', FALSE, NULL, TRUE, NOW(), 'IN_APP', NOW());

    -- --------------------------------------------------------
    -- AUDIT LOGS (25)
    -- --------------------------------------------------------
    INSERT INTO audit_logs (
        id, actor_id, entity_type, entity_id, action,
        old_value, new_value, description, created_at
    ) VALUES

    (gen_random_uuid(), v_officer_id, 'ISSUE', i01, 'CREATED',
     NULL, '{"status":"OPEN","priority":"HIGH"}'::jsonb,
     'Issue CIV-2026-000001 created for Alipiri pothole.', NOW() - INTERVAL '9 days'),

    (gen_random_uuid(), v_officer_id, 'ASSIGNMENT', asn01, 'ASSIGNED',
     NULL, '{"assigned_to":"worker","status":"ASSIGNED"}'::jsonb,
     'Issue CIV-2026-000001 assigned to field worker.', NOW() - INTERVAL '8 days'),

    (gen_random_uuid(), v_worker_id, 'ISSUE', i01, 'STATUS_CHANGED',
     '{"status":"ASSIGNED"}'::jsonb, '{"status":"IN_PROGRESS"}'::jsonb,
     'Field worker started work on CIV-2026-000001.', NOW() - INTERVAL '7 days'),

    (gen_random_uuid(), v_worker_id, 'ISSUE', i01, 'STATUS_CHANGED',
     '{"status":"IN_PROGRESS"}'::jsonb, '{"status":"RESOLVED"}'::jsonb,
     'CIV-2026-000001 marked resolved by field worker.', NOW() - INTERVAL '2 days'),

    (gen_random_uuid(), v_officer_id, 'ISSUE', i01, 'STATUS_CHANGED',
     '{"status":"RESOLVED"}'::jsonb, '{"status":"CLOSED"}'::jsonb,
     'Officer closed CIV-2026-000001 after verification.', NOW() - INTERVAL '1 day'),

    (gen_random_uuid(), v_officer_id, 'ISSUE', i02, 'CREATED',
     NULL, '{"status":"OPEN","priority":"MEDIUM"}'::jsonb,
     'Issue CIV-2026-000002 created for RC Road potholes.', NOW() - INTERVAL '6 days'),

    (gen_random_uuid(), v_officer_id, 'ASSIGNMENT', asn02, 'ASSIGNED',
     NULL, '{"assigned_to":"worker","status":"ASSIGNED"}'::jsonb,
     'Issue CIV-2026-000002 assigned to field worker.', NOW() - INTERVAL '5 days'),

    (gen_random_uuid(), v_worker_id, 'ISSUE', i02, 'STATUS_CHANGED',
     '{"status":"ASSIGNED"}'::jsonb, '{"status":"IN_PROGRESS"}'::jsonb,
     'Field worker started repair work on CIV-2026-000002.', NOW() - INTERVAL '4 days'),

    (gen_random_uuid(), NULL, 'ISSUE', i02, 'ESCALATED',
     '{"priority":"MEDIUM"}'::jsonb, '{"priority":"MEDIUM","sla_warning":true}'::jsonb,
     'System triggered SLA warning for CIV-2026-000002.', NOW() - INTERVAL '1 day'),

    (gen_random_uuid(), v_officer_id, 'ISSUE', i03, 'CREATED',
     NULL, '{"status":"OPEN","priority":"MEDIUM"}'::jsonb,
     'Issue CIV-2026-000003 created for Tiruchanoor garbage bin.', NOW() - INTERVAL '3 days'),

    (gen_random_uuid(), v_officer_id, 'ASSIGNMENT', asn03, 'ASSIGNED',
     NULL, '{"assigned_to":"worker","status":"ASSIGNED"}'::jsonb,
     'Issue CIV-2026-000003 assigned to field worker.', NOW() - INTERVAL '2 days'),

    (gen_random_uuid(), v_officer_id, 'ISSUE', i04, 'CREATED',
     NULL, '{"status":"OPEN","priority":"HIGH"}'::jsonb,
     'Issue CIV-2026-000004 created for Renigunta Road garbage.', NOW() - INTERVAL '7 days'),

    (gen_random_uuid(), v_officer_id, 'ASSIGNMENT', asn04, 'CANCELLED',
     '{"status":"ASSIGNED"}'::jsonb, '{"status":"CANCELLED","reason":"Worker unavailable"}'::jsonb,
     'First assignment cancelled for Renigunta garbage clearance.', NOW() - INTERVAL '5 days'),

    (gen_random_uuid(), v_officer_id, 'ASSIGNMENT', asn05, 'REASSIGNED',
     '{"assigned_to":"none"}'::jsonb, '{"assigned_to":"worker","status":"ACCEPTED"}'::jsonb,
     'Issue CIV-2026-000004 reassigned to field worker.', NOW() - INTERVAL '5 days'),

    (gen_random_uuid(), v_officer_id, 'ISSUE', i05, 'CREATED',
     NULL, '{"status":"OPEN","priority":"CRITICAL"}'::jsonb,
     'Issue CIV-2026-000005 created for Bhavani Nagar pipe burst.', NOW() - INTERVAL '5 days'),

    (gen_random_uuid(), v_officer_id, 'ASSIGNMENT', asn06, 'ASSIGNED',
     NULL, '{"assigned_to":"worker","status":"ASSIGNED"}'::jsonb,
     'Issue CIV-2026-000005 assigned to field worker. Urgent priority.', NOW() - INTERVAL '4 days'),

    (gen_random_uuid(), v_worker_id, 'ISSUE', i05, 'STATUS_CHANGED',
     '{"status":"ASSIGNED"}'::jsonb, '{"status":"IN_PROGRESS"}'::jsonb,
     'Field worker started pipe repair on CIV-2026-000005.', NOW() - INTERVAL '3 days'),

    (gen_random_uuid(), v_worker_id, 'ISSUE', i05, 'STATUS_CHANGED',
     '{"status":"IN_PROGRESS"}'::jsonb, '{"status":"RESOLVED"}'::jsonb,
     'CIV-2026-000005 marked resolved after pipe repair.', NOW() - INTERVAL '1 day'),

    (gen_random_uuid(), v_officer_id, 'ISSUE', i05, 'STATUS_CHANGED',
     '{"status":"RESOLVED"}'::jsonb, '{"status":"CLOSED"}'::jsonb,
     'Officer closed CIV-2026-000005 after verification.', NOW() - INTERVAL '1 day'),

    (gen_random_uuid(), v_officer_id, 'ISSUE', i06, 'CREATED',
     NULL, '{"status":"OPEN","priority":"MEDIUM"}'::jsonb,
     'Issue CIV-2026-000006 created for Korlagunta water leak.', NOW() - INTERVAL '2 days'),

    (gen_random_uuid(), v_officer_id, 'ASSIGNMENT', asn07, 'ASSIGNED',
     NULL, '{"assigned_to":"worker","status":"ASSIGNED"}'::jsonb,
     'Issue CIV-2026-000006 assigned to field worker.', NOW() - INTERVAL '1 day'),

    (gen_random_uuid(), v_officer_id, 'ISSUE', i07, 'CREATED',
     NULL, '{"status":"OPEN","priority":"HIGH"}'::jsonb,
     'Issue CIV-2026-000007 created for Srinivasapuram streetlights.', NOW() - INTERVAL '5 days'),

    (gen_random_uuid(), v_officer_id, 'ASSIGNMENT', asn08, 'ASSIGNED',
     NULL, '{"assigned_to":"worker","status":"ASSIGNED"}'::jsonb,
     'Issue CIV-2026-000007 assigned to field worker.', NOW() - INTERVAL '4 days'),

    (gen_random_uuid(), v_officer_id, 'ISSUE', i08, 'CREATED',
     NULL, '{"status":"OPEN","priority":"HIGH"}'::jsonb,
     'Issue CIV-2026-000008 created for Tiruchanoor drain blockage.', NOW() - INTERVAL '6 days'),

    (gen_random_uuid(), v_officer_id, 'ASSIGNMENT', asn09, 'ASSIGNED',
     NULL, '{"assigned_to":"worker","status":"ASSIGNED"}'::jsonb,
     'Issue CIV-2026-000008 assigned to field worker.', NOW() - INTERVAL '5 days');

END $$;
