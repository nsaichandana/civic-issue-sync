-- ============================================================
-- CivicTrust
-- seed_demo_02_ai.sql
-- Demo Seed: AI Analysis, Processing Logs,
--            Duplicate Candidates, Related Candidates
-- Depends on: seed_demo_01_reports.sql already executed
-- ============================================================

DO $$
DECLARE
    -- category ids
    c_pothole     UUID;
    c_garbage     UUID;
    c_water       UUID;
    c_streetlight UUID;
    c_drainage    UUID;
    c_public      UUID;
    c_tree        UUID;
    c_encroach    UUID;

    -- report ids (resolved by unique title)
    r01 UUID; r02 UUID; r03 UUID; r04 UUID; r05 UUID;
    r06 UUID; r07 UUID; r08 UUID; r09 UUID; r10 UUID;
    r11 UUID; r12 UUID; r13 UUID; r14 UUID; r15 UUID;

    -- ai_analysis ids
    a01 UUID; a02 UUID; a03 UUID; a04 UUID; a05 UUID;
    a06 UUID; a07 UUID; a08 UUID; a09 UUID; a10 UUID;
    a11 UUID; a12 UUID; a13 UUID; a14 UUID; a15 UUID;

BEGIN

    -- --------------------------------------------------------
    -- Resolve category IDs
    -- --------------------------------------------------------
    SELECT id INTO c_pothole     FROM categories WHERE category_name = 'Pothole';
    SELECT id INTO c_garbage     FROM categories WHERE category_name = 'Garbage';
    SELECT id INTO c_water       FROM categories WHERE category_name = 'Water Leakage';
    SELECT id INTO c_streetlight FROM categories WHERE category_name = 'Streetlight';
    SELECT id INTO c_drainage    FROM categories WHERE category_name = 'Drainage';
    SELECT id INTO c_public      FROM categories WHERE category_name = 'Public Property';
    SELECT id INTO c_tree        FROM categories WHERE category_name = 'Tree Fall';
    SELECT id INTO c_encroach    FROM categories WHERE category_name = 'Encroachment';

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
    SELECT id INTO r15 FROM reports WHERE title = 'Illegal temporary shop blocking footpath on RC Road';

    -- --------------------------------------------------------
    -- Generate ai_analysis UUIDs
    -- --------------------------------------------------------
    a01 := gen_random_uuid(); a02 := gen_random_uuid(); a03 := gen_random_uuid();
    a04 := gen_random_uuid(); a05 := gen_random_uuid(); a06 := gen_random_uuid();
    a07 := gen_random_uuid(); a08 := gen_random_uuid(); a09 := gen_random_uuid();
    a10 := gen_random_uuid(); a11 := gen_random_uuid(); a12 := gen_random_uuid();
    a13 := gen_random_uuid(); a14 := gen_random_uuid(); a15 := gen_random_uuid();

    -- --------------------------------------------------------
    -- AI ANALYSIS (15 — one per report)
    -- --------------------------------------------------------
    INSERT INTO ai_analysis (
        id, report_id, model_name, analysis_version, summary,
        predicted_category_id, predicted_priority,
        severity_score, confidence_score, duplicate_score, risk_score,
        processing_time_ms, created_at
    ) VALUES

    (a01, r01, 'gemini-1.5-pro', 'v1.0',
     'Large pothole detected near Alipiri checkpost. High accident risk confirmed by image analysis. Multiple citizen upvotes indicate widespread community impact. Immediate repair recommended.',
     c_pothole, 'HIGH',
     85.00, 92.00, 78.00, 88.00, 1242,
     NOW() - INTERVAL '10 days'),

    (a02, r02, 'gemini-1.5-pro', 'v1.0',
     'Road crater near Alipiri bus stop identified. GPS coordinates are within 100 metres of Report r01. Same ward, same category, submitted within 24 hours. High probability of being the same defect.',
     c_pothole, 'HIGH',
     80.00, 88.00, 85.00, 82.00, 1184,
     NOW() - INTERVAL '9 days'),

    (a03, r03, 'gemini-1.5-pro', 'v1.0',
     'Multiple potholes detected on RC Road near SBI Bank. Medium severity. Location is distinct from Alipiri cluster. Independent issue confirmed. Traffic disruption risk noted.',
     c_pothole, 'MEDIUM',
     65.00, 87.00, 15.00, 60.00, 1051,
     NOW() - INTERVAL '7 days'),

    (a04, r04, 'gemini-1.5-pro', 'v1.0',
     'Road surface damage in Balaji Colony detected. Affects pedestrian access near park. Moderate severity. No duplicate candidates found in proximity. Medium priority recommended.',
     c_pothole, 'MEDIUM',
     55.00, 83.00, 10.00, 50.00, 982,
     NOW() - INTERVAL '5 days'),

    (a05, r05, 'gemini-1.5-pro', 'v1.0',
     'Large garbage accumulation near Renigunta bus stop confirmed by image and video analysis. Strong odour and fly infestation indicators visible. High upvote count validates community impact. Public health risk flagged.',
     c_garbage, 'HIGH',
     82.00, 94.00, 72.00, 80.00, 1325,
     NOW() - INTERVAL '8 days'),

    (a06, r06, 'gemini-1.5-pro', 'v1.0',
     'Construction waste on Renigunta Road footpath detected. GPS is within 50 metres of Report r05. Same ward and category. Likely same dump site or connected dumping activity. High duplicate probability.',
     c_garbage, 'MEDIUM',
     68.00, 86.00, 80.00, 65.00, 1103,
     NOW() - INTERVAL '7 days'),

    (a07, r07, 'gemini-1.5-pro', 'v1.0',
     'Overflowing garbage bin near Tiruchanoor Road market detected. Separate ward from Renigunta reports. Independent issue confirmed. Medium severity. Routine sanitation escalation recommended.',
     c_garbage, 'MEDIUM',
     60.00, 85.00, 12.00, 55.00, 1022,
     NOW() - INTERVAL '4 days'),

    (a08, r08, 'gemini-1.5-pro', 'v1.0',
     'Major water pipe burst in Bhavani Nagar confirmed by image and video evidence. Continuous water flow visible on road surface. Highest severity score in current batch. Immediate intervention required. CRITICAL priority assigned.',
     c_water, 'CRITICAL',
     96.00, 97.00, 65.00, 95.00, 1453,
     NOW() - INTERVAL '6 days'),

    (a09, r09, 'gemini-1.5-pro', 'v1.0',
     'Underground pipe leak near Bhavani Nagar community park detected. GPS within 80 metres of Report r08. Same ward, same category. Very high probability of same pipeline failure. Recommend merging with r08.',
     c_water, 'HIGH',
     88.00, 91.00, 90.00, 87.00, 1381,
     NOW() - INTERVAL '5 days'),

    (a10, r10, 'gemini-1.5-pro', 'v1.0',
     'Pipeline leak on Korlagunta street detected. Different ward from Bhavani Nagar reports. Independent infrastructure issue confirmed. Medium priority. No duplicate candidates identified.',
     c_water, 'MEDIUM',
     62.00, 84.00, 8.00, 58.00, 1013,
     NOW() - INTERVAL '3 days'),

    (a11, r11, 'gemini-1.5-pro', 'v1.0',
     'Five non-functional streetlights in Srinivasapuram colony identified. Night safety risk confirmed. No nearby duplicate reports found. High priority repair recommended.',
     c_streetlight, 'HIGH',
     75.00, 89.00, 5.00, 72.00, 1092,
     NOW() - INTERVAL '6 days'),

    (a12, r12, 'gemini-1.5-pro', 'v1.0',
     'Broken lamp post on RC Road footpath detected. Physical obstruction on pedestrian walkway. Medium severity. Different location from Srinivasapuram streetlight report. Independent issue.',
     c_streetlight, 'MEDIUM',
     58.00, 82.00, 4.00, 55.00, 963,
     NOW() - INTERVAL '2 days'),

    (a13, r13, 'gemini-1.5-pro', 'v1.0',
     'Major stormwater drain blockage on Tiruchanoor Road detected from image evidence. Flood risk to residential properties confirmed. High community impact. High severity assigned.',
     c_drainage, 'HIGH',
     84.00, 93.00, 18.00, 85.00, 1284,
     NOW() - INTERVAL '7 days'),

    (a14, r14, 'gemini-1.5-pro', 'v1.0',
     'Fallen tree branch blocking road near Korlagunta temple detected. Road obstruction confirmed from image and video. Diseased tree risk noted. Medium-high severity. No duplicate candidates.',
     c_tree, 'HIGH',
     72.00, 88.00, 6.00, 70.00, 1098,
     NOW() - INTERVAL '2 days'),

    (a15, r15, 'gemini-1.5-pro', 'v1.0',
     'Illegal encroachment on RC Road footpath detected. Permanent-looking structure blocking pedestrian access. Low urgency compared to safety issues but regulatory action required. Low severity score.',
     c_encroach, 'LOW',
     38.00, 80.00, 3.00, 32.00, 884,
     NOW() - INTERVAL '1 day');

    -- --------------------------------------------------------
    -- AI PROCESSING LOGS (15 — one per analysis)
    -- --------------------------------------------------------
    INSERT INTO ai_processing_logs (
        id, analysis_id, status,
        started_at, finished_at,
        processing_time_ms, token_usage, error_message
    ) VALUES

    (gen_random_uuid(), a01, 'SUCCESS',
     NOW() - INTERVAL '10 days' - INTERVAL '2 seconds',
     NOW() - INTERVAL '10 days',
     1242, 1840, NULL),

    (gen_random_uuid(), a02, 'SUCCESS',
     NOW() - INTERVAL '9 days' - INTERVAL '2 seconds',
     NOW() - INTERVAL '9 days',
     1184, 1762, NULL),

    (gen_random_uuid(), a03, 'SUCCESS',
     NOW() - INTERVAL '7 days' - INTERVAL '2 seconds',
     NOW() - INTERVAL '7 days',
     1051, 1543, NULL),

    (gen_random_uuid(), a04, 'SUCCESS',
     NOW() - INTERVAL '5 days' - INTERVAL '2 seconds',
     NOW() - INTERVAL '5 days',
     982, 1421, NULL),

    (gen_random_uuid(), a05, 'SUCCESS',
     NOW() - INTERVAL '8 days' - INTERVAL '2 seconds',
     NOW() - INTERVAL '8 days',
     1325, 1923, NULL),

    (gen_random_uuid(), a06, 'SUCCESS',
     NOW() - INTERVAL '7 days' - INTERVAL '2 seconds',
     NOW() - INTERVAL '7 days',
     1103, 1612, NULL),

    (gen_random_uuid(), a07, 'SUCCESS',
     NOW() - INTERVAL '4 days' - INTERVAL '2 seconds',
     NOW() - INTERVAL '4 days',
     1022, 1498, NULL),

    (gen_random_uuid(), a08, 'SUCCESS',
     NOW() - INTERVAL '6 days' - INTERVAL '2 seconds',
     NOW() - INTERVAL '6 days',
     1453, 2104, NULL),

    (gen_random_uuid(), a09, 'SUCCESS',
     NOW() - INTERVAL '5 days' - INTERVAL '2 seconds',
     NOW() - INTERVAL '5 days',
     1381, 1987, NULL),

    (gen_random_uuid(), a10, 'SUCCESS',
     NOW() - INTERVAL '3 days' - INTERVAL '2 seconds',
     NOW() - INTERVAL '3 days',
     1013, 1502, NULL),

    (gen_random_uuid(), a11, 'SUCCESS',
     NOW() - INTERVAL '6 days' - INTERVAL '2 seconds',
     NOW() - INTERVAL '6 days',
     1092, 1634, NULL),

    (gen_random_uuid(), a12, 'SUCCESS',
     NOW() - INTERVAL '2 days' - INTERVAL '2 seconds',
     NOW() - INTERVAL '2 days',
     963, 1387, NULL),

    (gen_random_uuid(), a13, 'SUCCESS',
     NOW() - INTERVAL '7 days' - INTERVAL '2 seconds',
     NOW() - INTERVAL '7 days',
     1284, 1876, NULL),

    (gen_random_uuid(), a14, 'SUCCESS',
     NOW() - INTERVAL '2 days' - INTERVAL '2 seconds',
     NOW() - INTERVAL '2 days',
     1098, 1645, NULL),

    (gen_random_uuid(), a15, 'SUCCESS',
     NOW() - INTERVAL '1 day' - INTERVAL '2 seconds',
     NOW() - INTERVAL '1 day',
     884, 1298, NULL);

    -- --------------------------------------------------------
    -- DUPLICATE CANDIDATES
    -- AI flagged 3 pairs as likely duplicates
    -- --------------------------------------------------------
    INSERT INTO duplicate_candidates (
        id, analysis_id, matched_report_id,
        similarity_score, reason, created_at
    ) VALUES

    -- a02 (Alipiri crater) flagged r01 (Alipiri pothole) as duplicate
    (gen_random_uuid(), a02, r01,
     85.00,
     'GPS coordinates within 95 metres. Same ward, same category, same predicted priority. Reports submitted within 22 hours of each other. Gemini semantic analysis confirms near-identical issue description.',
     NOW() - INTERVAL '9 days'),

    -- a06 (Renigunta footpath waste) flagged r05 (Renigunta garbage pile) as duplicate
    (gen_random_uuid(), a06, r05,
     80.00,
     'GPS coordinates within 48 metres. Same ward, same category. Both describe waste accumulation on or adjacent to Renigunta Road. Likely same dump site reported from two vantage points.',
     NOW() - INTERVAL '7 days'),

    -- a09 (Bhavani park leak) flagged r08 (Bhavani pipe burst) as duplicate
    (gen_random_uuid(), a09, r08,
     90.00,
     'GPS coordinates within 78 metres. Same ward, same category, same CRITICAL-adjacent severity. Both describe water pipeline failure in Bhavani Nagar. Strong indicator of single underlying pipe rupture.',
     NOW() - INTERVAL '5 days');

    -- --------------------------------------------------------
    -- RELATED CANDIDATES
    -- AI flagged reports that are related but not duplicates
    -- --------------------------------------------------------
    INSERT INTO related_candidates (
        id, analysis_id, related_report_id,
        relationship_reason, confidence_score, created_at
    ) VALUES

    -- a03 (RC Road potholes) related to r04 (Balaji Colony road damage)
    -- Both are road surface issues in adjacent wards
    (gen_random_uuid(), a03, r04,
     'Both reports describe road surface deterioration. Different wards but same root infrastructure issue category. May share same contractor or maintenance schedule.',
     62.00,
     NOW() - INTERVAL '7 days'),

    -- a07 (Tiruchanoor garbage bin) related to r05 (Renigunta garbage pile)
    -- Both are garbage issues, different wards, same sanitation department
    (gen_random_uuid(), a07, r05,
     'Both reports describe sanitation failures on major roads. Different wards but same responsible department. Possible systemic collection schedule failure.',
     58.00,
     NOW() - INTERVAL '4 days'),

    -- a10 (Korlagunta pipeline leak) related to r08 (Bhavani pipe burst)
    -- Both are water supply failures, different wards, same department
    (gen_random_uuid(), a10, r08,
     'Both reports describe water supply pipeline failures. Different wards but same Water Supply department. May indicate ageing infrastructure across the zone.',
     55.00,
     NOW() - INTERVAL '3 days'),

    -- a13 (Tiruchanoor drain blockage) related to r07 (Tiruchanoor garbage overflow)
    -- Same ward, drain blockage and garbage overflow often co-occur
    (gen_random_uuid(), a13, r07,
     'Same ward. Blocked drain and overflowing garbage bin are co-located on Tiruchanoor Road. Garbage debris may be contributing to drain blockage. Related remediation recommended.',
     70.00,
     NOW() - INTERVAL '7 days'),

    -- a14 (Korlagunta tree fall) related to r10 (Korlagunta pipeline leak)
    -- Same ward, tree root damage can cause pipe failures
    (gen_random_uuid(), a14, r10,
     'Same ward. Fallen tree near Korlagunta temple may share root cause with pipeline joint failure on same street. Tree root intrusion into ageing pipelines is a known risk factor.',
     48.00,
     NOW() - INTERVAL '2 days');

END $$;