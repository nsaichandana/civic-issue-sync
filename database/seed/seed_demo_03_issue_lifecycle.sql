-- ============================================================
-- CivicTrust
-- seed_demo_03_issue_lifecycle.sql
-- Demo Seed: Draft Issues, Issues, Issue Reports, Merge Records
-- Depends on: seed_demo_01_reports.sql, seed_demo_02_ai.sql
-- ============================================================

DO $$
DECLARE
    -- user ids
    v_officer_id  UUID;
    v_citizen_id  UUID;

    -- category ids
    c_pothole     UUID;
    c_garbage     UUID;
    c_water       UUID;
    c_streetlight UUID;
    c_drainage    UUID;
    c_tree        UUID;

    -- department ids
    d_roads       UUID;
    d_sanitation  UUID;
    d_water       UUID;
    d_electrical  UUID;

    -- ward ids
    w_alipiri     UUID;
    w_rc          UUID;
    w_balaji      UUID;
    w_bhavani     UUID;
    w_renigunta   UUID;
    w_tiruchanoor UUID;
    w_korlagunta  UUID;
    w_srini       UUID;

    -- sla rule ids
    sla_pothole_high      UUID;
    sla_pothole_medium    UUID;
    sla_garbage_high      UUID;
    sla_garbage_medium    UUID;
    sla_water_critical    UUID;
    sla_water_high        UUID;
    sla_streetlight_high  UUID;
    sla_drainage_high     UUID;
    sla_tree_high         UUID;

    -- report ids (resolved by unique title)
    r01 UUID; r02 UUID; r03 UUID; r04 UUID; r05 UUID;
    r06 UUID; r07 UUID; r08 UUID; r09 UUID; r10 UUID;
    r11 UUID; r12 UUID; r13 UUID; r14 UUID;

    -- ai_analysis ids (resolved via report_id)
    a01 UUID; a02 UUID; a03 UUID; a04 UUID; a05 UUID;
    a06 UUID; a07 UUID; a08 UUID; a09 UUID; a10 UUID;
    a11 UUID; a12 UUID; a13 UUID; a14 UUID;

    -- draft_issue ids
    d01 UUID; d02 UUID; d03 UUID; d04 UUID; d05 UUID;
    d06 UUID; d07 UUID; d08 UUID; d09 UUID; d10 UUID;

    -- issue ids
    i01 UUID; i02 UUID; i03 UUID; i04 UUID;
    i05 UUID; i06 UUID; i07 UUID; i08 UUID;

BEGIN

    -- --------------------------------------------------------
    -- Resolve user IDs
    -- --------------------------------------------------------
    SELECT id INTO v_officer_id FROM users WHERE email = 'officer@civictrust.in';
    SELECT id INTO v_citizen_id  FROM users WHERE email = 'citizen@civictrust.in';

    -- --------------------------------------------------------
    -- Resolve category IDs
    -- --------------------------------------------------------
    SELECT id INTO c_pothole     FROM categories WHERE category_name = 'Pothole';
    SELECT id INTO c_garbage     FROM categories WHERE category_name = 'Garbage';
    SELECT id INTO c_water       FROM categories WHERE category_name = 'Water Leakage';
    SELECT id INTO c_streetlight FROM categories WHERE category_name = 'Streetlight';
    SELECT id INTO c_drainage    FROM categories WHERE category_name = 'Drainage';
    SELECT id INTO c_tree        FROM categories WHERE category_name = 'Tree Fall';

    -- --------------------------------------------------------
    -- Resolve department IDs via category → department
    -- --------------------------------------------------------
    SELECT department_id INTO d_roads      FROM categories WHERE category_name = 'Pothole';
    SELECT department_id INTO d_sanitation FROM categories WHERE category_name = 'Garbage';
    SELECT department_id INTO d_water      FROM categories WHERE category_name = 'Water Leakage';
    SELECT department_id INTO d_electrical FROM categories WHERE category_name = 'Streetlight';

    -- --------------------------------------------------------
    -- Resolve ward IDs
    -- --------------------------------------------------------
    SELECT id INTO w_alipiri     FROM wards WHERE ward_name = 'Alipiri';
    SELECT id INTO w_rc          FROM wards WHERE ward_name = 'RC Road';
    SELECT id INTO w_balaji      FROM wards WHERE ward_name = 'Balaji Colony';
    SELECT id INTO w_bhavani     FROM wards WHERE ward_name = 'Bhavani Nagar';
    SELECT id INTO w_renigunta   FROM wards WHERE ward_name = 'Renigunta Road';
    SELECT id INTO w_tiruchanoor FROM wards WHERE ward_name = 'Tiruchanoor Road';
    SELECT id INTO w_korlagunta  FROM wards WHERE ward_name = 'Korlagunta';
    SELECT id INTO w_srini       FROM wards WHERE ward_name = 'Srinivasapuram';

    -- --------------------------------------------------------
    -- Resolve SLA rule IDs (category + priority)
    -- --------------------------------------------------------
    SELECT s.id INTO sla_pothole_high
      FROM sla_rules s WHERE s.category_id = c_pothole     AND s.priority = 'HIGH';

    SELECT s.id INTO sla_pothole_medium
      FROM sla_rules s WHERE s.category_id = c_pothole     AND s.priority = 'MEDIUM';

    SELECT s.id INTO sla_garbage_high
      FROM sla_rules s WHERE s.category_id = c_garbage     AND s.priority = 'HIGH';

    SELECT s.id INTO sla_garbage_medium
      FROM sla_rules s WHERE s.category_id = c_garbage     AND s.priority = 'MEDIUM';

    SELECT s.id INTO sla_water_critical
      FROM sla_rules s WHERE s.category_id = c_water       AND s.priority = 'CRITICAL';

    SELECT s.id INTO sla_water_high
      FROM sla_rules s WHERE s.category_id = c_water       AND s.priority = 'HIGH';

    SELECT s.id INTO sla_streetlight_high
      FROM sla_rules s WHERE s.category_id = c_streetlight AND s.priority = 'HIGH';

    SELECT s.id INTO sla_drainage_high
      FROM sla_rules s WHERE s.category_id = c_drainage    AND s.priority = 'HIGH';

    SELECT s.id INTO sla_tree_high
      FROM sla_rules s WHERE s.category_id = c_tree        AND s.priority = 'HIGH';

    -- --------------------------------------------------------
    -- Resolve report IDs by unique title
    -- --------------------------------------------------------
    SELECT id INTO r01 FROM reports WHERE title = 'Large pothole near Alipiri checkpost causing accidents';
    SELECT id INTO r02 FROM reports WHERE title = 'Deep road crater formed near Alipiri bus stop after rain';
    SELECT id INTO r03 FROM reports WHERE title = 'Multiple potholes on RC Road near SBI Bank branch';
    SELECT id INTO r04 FROM reports WHERE title = 'Road surface badly damaged in front of Balaji Colony park';
    SELECT id INTO r05 FROM reports WHERE title = 'Uncollected garbage pile near Renigunta Road bus stop';
    SELECT id INTO r06 FROM reports WHERE title = 'Construction waste illegally dumped on Renigunta Road footpath';
    SELECT id INTO r07 FROM reports WHERE title = 'Garbage bin overflowing near Tiruchanoor Road daily market';
    SELECT id INTO r08 FROM reports WHERE title = 'Water pipe burst near Bhavani Nagar main entrance';
    SELECT id INTO r09 FROM reports WHERE title = 'Underground water pipe leaking near Bhavani Nagar community park';
    SELECT id INTO r10 FROM reports WHERE title = 'Continuous water leakage from main pipeline on Korlagunta street';
    SELECT id INTO r11 FROM reports WHERE title = 'Five streetlights not working in Srinivasapuram colony';
    SELECT id INTO r12 FROM reports WHERE title = 'Broken lamp post fallen on footpath near RC Road college';
    SELECT id INTO r13 FROM reports WHERE title = 'Main drain completely blocked on Tiruchanoor Road causing flooding';
    SELECT id INTO r14 FROM reports WHERE title = 'Large tree branch fallen and blocking road near Korlagunta temple';

    -- --------------------------------------------------------
    -- Resolve ai_analysis IDs via report_id
    -- --------------------------------------------------------
    SELECT id INTO a01 FROM ai_analysis WHERE report_id = r01;
    SELECT id INTO a02 FROM ai_analysis WHERE report_id = r02;
    SELECT id INTO a03 FROM ai_analysis WHERE report_id = r03;
    SELECT id INTO a04 FROM ai_analysis WHERE report_id = r04;
    SELECT id INTO a05 FROM ai_analysis WHERE report_id = r05;
    SELECT id INTO a06 FROM ai_analysis WHERE report_id = r06;
    SELECT id INTO a07 FROM ai_analysis WHERE report_id = r07;
    SELECT id INTO a08 FROM ai_analysis WHERE report_id = r08;
    SELECT id INTO a09 FROM ai_analysis WHERE report_id = r09;
    SELECT id INTO a10 FROM ai_analysis WHERE report_id = r10;
    SELECT id INTO a11 FROM ai_analysis WHERE report_id = r11;
    SELECT id INTO a12 FROM ai_analysis WHERE report_id = r12;
    SELECT id INTO a13 FROM ai_analysis WHERE report_id = r13;
    SELECT id INTO a14 FROM ai_analysis WHERE report_id = r14;

    -- --------------------------------------------------------
    -- Generate new UUIDs for draft_issues
    -- --------------------------------------------------------
    d01 := gen_random_uuid(); d02 := gen_random_uuid();
    d03 := gen_random_uuid(); d04 := gen_random_uuid();
    d05 := gen_random_uuid(); d06 := gen_random_uuid();
    d07 := gen_random_uuid(); d08 := gen_random_uuid();
    d09 := gen_random_uuid(); d10 := gen_random_uuid();

    -- --------------------------------------------------------
    -- Generate new UUIDs for issues
    -- --------------------------------------------------------
    i01 := gen_random_uuid(); i02 := gen_random_uuid();
    i03 := gen_random_uuid(); i04 := gen_random_uuid();
    i05 := gen_random_uuid(); i06 := gen_random_uuid();
    i07 := gen_random_uuid(); i08 := gen_random_uuid();

    -- --------------------------------------------------------
    -- DRAFT ISSUES (10)
    -- 8 APPROVED, 2 REJECTED
    -- d01–d08 approved, d09 and d10 rejected
    -- d02 and d06 are MERGED (duplicates absorbed into d01 and d05)
    -- --------------------------------------------------------
    INSERT INTO draft_issues (
        id, report_id, ai_analysis_id,
        suggested_category_id, suggested_priority,
        officer_review_status, review_comments,
        approved_by, approved_at, rejection_reason,
        created_at, updated_at
    ) VALUES

    -- d01: Alipiri pothole — APPROVED
    (d01, r01, a01, c_pothole, 'HIGH',
     'APPROVED',
     'Verified on ground by Roads department. High priority confirmed. Pothole is hazardous to two-wheelers.',
     v_officer_id, NOW() - INTERVAL '9 days',
     NULL,
     NOW() - INTERVAL '9 days', NOW() - INTERVAL '9 days'),

    -- d02: Alipiri crater (duplicate of r01) — MERGED into d01's issue
    (d02, r02, a02, c_pothole, 'HIGH',
     'MERGED',
     'AI flagged 85% similarity with draft d01. GPS within 95 metres. Same road defect reported from different angle. Merging into CIV-2026-000001.',
     v_officer_id, NOW() - INTERVAL '8 days',
     NULL,
     NOW() - INTERVAL '8 days', NOW() - INTERVAL '8 days'),

    -- d03: RC Road potholes — APPROVED
    (d03, r03, a03, c_pothole, 'MEDIUM',
     'APPROVED',
     'RC Road pothole cluster confirmed. Medium priority assigned. Roads team to schedule repair within SLA.',
     v_officer_id, NOW() - INTERVAL '6 days',
     NULL,
     NOW() - INTERVAL '6 days', NOW() - INTERVAL '6 days'),

    -- d04: Renigunta garbage pile — APPROVED
    (d04, r05, a05, c_garbage, 'HIGH',
     'APPROVED',
     'Large garbage accumulation confirmed. Public health risk verified. High priority assigned to Sanitation team.',
     v_officer_id, NOW() - INTERVAL '7 days',
     NULL,
     NOW() - INTERVAL '7 days', NOW() - INTERVAL '7 days'),

    -- d05: Renigunta footpath waste (duplicate of r05) — MERGED into d04's issue
    (d05, r06, a06, c_garbage, 'MEDIUM',
     'MERGED',
     'AI flagged 80% similarity with draft d04. GPS within 48 metres. Construction debris and garbage pile are at the same dump site. Merging into CIV-2026-000004.',
     v_officer_id, NOW() - INTERVAL '6 days',
     NULL,
     NOW() - INTERVAL '6 days', NOW() - INTERVAL '6 days'),

    -- d06: Bhavani pipe burst — APPROVED CRITICAL
    (d06, r08, a08, c_water, 'CRITICAL',
     'APPROVED',
     'Critical pipe burst confirmed by video evidence. Continuous water loss and road flooding verified. Immediate action ordered. CRITICAL priority.',
     v_officer_id, NOW() - INTERVAL '5 days',
     NULL,
     NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days'),

    -- d07: Bhavani underground leak (duplicate of r08) — MERGED into d06's issue
    (d07, r09, a09, c_water, 'HIGH',
     'MERGED',
     'AI flagged 90% similarity with draft d06. GPS within 78 metres. Same Bhavani Nagar pipeline. Underground leak and burst are the same infrastructure failure. Merging into CIV-2026-000006.',
     v_officer_id, NOW() - INTERVAL '4 days',
     NULL,
     NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days'),

    -- d08: Srinivasapuram streetlights — APPROVED
    (d08, r11, a11, c_streetlight, 'HIGH',
     'APPROVED',
     'Five streetlight outages in Srinivasapuram confirmed. Night safety risk validated. Electrical department notified.',
     v_officer_id, NOW() - INTERVAL '5 days',
     NULL,
     NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days'),

    -- d09: Tiruchanoor drain blockage — APPROVED
    (d09, r13, a13, c_drainage, 'HIGH',
     'APPROVED',
     'Drain blockage on Tiruchanoor Road confirmed. Flood risk to residential area validated by field check. High priority.',
     v_officer_id, NOW() - INTERVAL '6 days',
     NULL,
     NOW() - INTERVAL '6 days', NOW() - INTERVAL '6 days'),

    -- d10: Balaji Colony road damage — REJECTED
    (d10, r04, a04, c_pothole, 'MEDIUM',
     'REJECTED',
     NULL,
     NULL, NULL,
     'Photo evidence insufficient. Damage extent unclear from submitted image. Citizen requested to resubmit with clearer photographs showing full road damage.',
     NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days');

    -- --------------------------------------------------------
    -- ISSUES (8 official issues from approved drafts)
    -- --------------------------------------------------------
    INSERT INTO issues (
        id, issue_number, draft_issue_id,
        department_id, category_id, ward_id,
        title, description, priority, status,
        sla_rule_id, created_by, approved_by, approved_at,
        resolved_at, closed_at,
        created_at, updated_at, deleted_at
    ) VALUES

    -- i01: Alipiri pothole (2 reports merged — r01 + r02)
    (i01, 'CIV-2026-000001', d01,
     d_roads, c_pothole, w_alipiri,
     'Pothole and Road Crater on Alipiri Main Road',
     'Large pothole and adjacent road crater near Alipiri checkpost confirmed hazardous. Two citizen reports merged after AI duplicate detection confirmed same defect. Accident risk to two-wheelers is high.',
     'HIGH', 'RESOLVED',
     sla_pothole_high,
     v_citizen_id, v_officer_id, NOW() - INTERVAL '9 days',
     NOW() - INTERVAL '2 days', NOW() - INTERVAL '1 day',
     NOW() - INTERVAL '9 days', NOW() - INTERVAL '1 day', NULL),

    -- i02: RC Road potholes
    (i02, 'CIV-2026-000002', d03,
     d_roads, c_pothole, w_rc,
     'Multiple Potholes on RC Road near SBI Bank',
     'Cluster of five potholes on RC Road in front of SBI Bank branch. Traffic disruption and tyre damage risk confirmed. Roads department assigned for repair.',
     'MEDIUM', 'IN_PROGRESS',
     sla_pothole_medium,
     v_citizen_id, v_officer_id, NOW() - INTERVAL '6 days',
     NULL, NULL,
     NOW() - INTERVAL '6 days', NOW() - INTERVAL '6 days', NULL),

    -- i03: Tiruchanoor garbage bin (standalone — r07)
    (i03, 'CIV-2026-000003', NULL,
     d_sanitation, c_garbage, w_tiruchanoor,
     'Overflowing Garbage Bin on Tiruchanoor Road',
     'Municipal garbage bin near Tiruchanoor Road daily market overflowing for five consecutive days. Sanitation team assigned for immediate clearance and bin replacement.',
     'MEDIUM', 'ASSIGNED',
     sla_garbage_medium,
     v_citizen_id, v_officer_id, NOW() - INTERVAL '3 days',
     NULL, NULL,
     NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days', NULL),

    -- i04: Renigunta garbage (2 reports merged — r05 + r06)
    (i04, 'CIV-2026-000004', d04,
     d_sanitation, c_garbage, w_renigunta,
     'Garbage Accumulation and Construction Waste on Renigunta Road',
     'Large garbage pile and construction waste dump on Renigunta Road confirmed as same location. Two citizen reports merged after AI duplicate detection at 80% similarity. Public health hazard confirmed.',
     'HIGH', 'IN_PROGRESS',
     sla_garbage_high,
     v_citizen_id, v_officer_id, NOW() - INTERVAL '7 days',
     NULL, NULL,
     NOW() - INTERVAL '7 days', NOW() - INTERVAL '7 days', NULL),

    -- i05: Bhavani Nagar pipeline (2 reports merged — r08 + r09)
    (i05, 'CIV-2026-000005', d06,
     d_water, c_water, w_bhavani,
     'Critical Water Pipeline Failure in Bhavani Nagar',
     'Major pipe burst and underground pipeline leak confirmed as same infrastructure failure in Bhavani Nagar. Two citizen reports merged after AI duplicate detection at 90% similarity. Continuous water loss and road flooding. CRITICAL priority.',
     'CRITICAL', 'RESOLVED',
     sla_water_critical,
     v_citizen_id, v_officer_id, NOW() - INTERVAL '5 days',
     NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day',
     NOW() - INTERVAL '5 days', NOW() - INTERVAL '1 day', NULL),

    -- i06: Korlagunta water leakage (standalone — r10)
    (i06, 'CIV-2026-000006', NULL,
     d_water, c_water, w_korlagunta,
     'Water Pipeline Leak on Korlagunta Main Street',
     'Confirmed water supply pipeline leaking at joint on Korlagunta main street near temple. Supply pressure drop in surrounding households. Water Supply department assigned.',
     'MEDIUM', 'OPEN',
     sla_water_high,
     v_citizen_id, v_officer_id, NOW() - INTERVAL '2 days',
     NULL, NULL,
     NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days', NULL),

    -- i07: Srinivasapuram streetlights (standalone — r11)
    (i07, 'CIV-2026-000007', d08,
     d_electrical, c_streetlight, w_srini,
     'Five Streetlights Non-Functional in Srinivasapuram Colony',
     'Five consecutive streetlights confirmed non-functional in Srinivasapuram colony. Night safety risk for women and children. Electrical department assigned for urgent repair.',
     'HIGH', 'IN_PROGRESS',
     sla_streetlight_high,
     v_citizen_id, v_officer_id, NOW() - INTERVAL '5 days',
     NULL, NULL,
     NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days', NULL),

    -- i08: Tiruchanoor drain blockage (standalone — r13)
    (i08, 'CIV-2026-000008', d09,
     d_water, c_drainage, w_tiruchanoor,
     'Stormwater Drain Blocked on Tiruchanoor Road',
     'Main stormwater drain completely blocked with silt and solid waste on Tiruchanoor Road. Residential flooding confirmed during light rain. High priority drain clearance ordered.',
     'HIGH', 'ASSIGNED',
     sla_drainage_high,
     v_citizen_id, v_officer_id, NOW() - INTERVAL '6 days',
     NULL, NULL,
     NOW() - INTERVAL '6 days', NOW() - INTERVAL '6 days', NULL);

    -- --------------------------------------------------------
    -- ISSUE REPORTS
    -- Maps every report to its official issue
    -- i01 ← r01, r02 (merged duplicate)
    -- i02 ← r03
    -- i03 ← r07
    -- i04 ← r05, r06 (merged duplicate)
    -- i05 ← r08, r09 (merged duplicate)
    -- i06 ← r10
    -- i07 ← r11
    -- i08 ← r13
    -- --------------------------------------------------------
    INSERT INTO issue_reports (id, issue_id, report_id, linked_at) VALUES

    (gen_random_uuid(), i01, r01, NOW() - INTERVAL '9 days'),
    (gen_random_uuid(), i01, r02, NOW() - INTERVAL '8 days'),

    (gen_random_uuid(), i02, r03, NOW() - INTERVAL '6 days'),

    (gen_random_uuid(), i03, r07, NOW() - INTERVAL '3 days'),

    (gen_random_uuid(), i04, r05, NOW() - INTERVAL '7 days'),
    (gen_random_uuid(), i04, r06, NOW() - INTERVAL '6 days'),

    (gen_random_uuid(), i05, r08, NOW() - INTERVAL '5 days'),
    (gen_random_uuid(), i05, r09, NOW() - INTERVAL '4 days'),

    (gen_random_uuid(), i06, r10, NOW() - INTERVAL '2 days'),

    (gen_random_uuid(), i07, r11, NOW() - INTERVAL '5 days'),

    (gen_random_uuid(), i08, r13, NOW() - INTERVAL '6 days');

    -- --------------------------------------------------------
    -- MERGE RECORDS (3 — one per duplicate pair absorbed)
    -- --------------------------------------------------------
    INSERT INTO merge_records (
        id, source_issue_id, target_issue_id,
        merged_by, merge_reason, merged_at
    ) VALUES

    -- Alipiri crater (would have been its own issue) absorbed into i01
    (gen_random_uuid(), i02, i01,
     v_officer_id,
     'AI duplicate detection flagged 85% similarity between reports. GPS coordinates within 95 metres on Alipiri Road. Same category, same ward, same predicted priority. Field officer confirmed same road defect viewed from different position. Absorbed into CIV-2026-000001.',
     NOW() - INTERVAL '8 days'),

    -- Renigunta footpath waste absorbed into i04
    (gen_random_uuid(), i03, i04,
     v_officer_id,
     'AI duplicate detection flagged 80% similarity. GPS within 48 metres on Renigunta Road. Construction debris and garbage pile confirmed at same dump site by sanitation officer. Absorbed into CIV-2026-000004.',
     NOW() - INTERVAL '6 days'),

    -- Bhavani underground leak absorbed into i05
    (gen_random_uuid(), i06, i05,
     v_officer_id,
     'AI duplicate detection flagged 90% similarity. GPS within 78 metres in Bhavani Nagar. Water Supply department confirmed underground leak and pipe burst are the same pipeline rupture. Absorbed into CIV-2026-000005.',
     NOW() - INTERVAL '4 days');

END $$;