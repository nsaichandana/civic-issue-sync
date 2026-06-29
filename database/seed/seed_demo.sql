-- ============================================================
-- CivicTrust - Seed Demo Data
-- Complete workflow from citizen reports to resolution
-- ============================================================

-- ============================================================
-- REPORTS (15 reports)
-- ============================================================

INSERT INTO reports (reporter_id, category_id, ward_id, title, description, source, is_anonymous, status, upvote_count, submitted_at, created_at)
SELECT
    u.id,
    c.id,
    w.id,
    r.title,
    r.description,
    r.source::report_source,
    r.is_anonymous,
    r.status::report_status,
    r.upvote_count,
    r.submitted_at,
    r.created_at
FROM (
    VALUES
    ('citizen@civictrust.in', 'Pothole', 'Alipiri', 'Large pothole on Alipiri Main Road', 'There is a very large pothole near Alipiri checkpost causing accidents. Two wheelers have fallen. Needs urgent repair.', 'CITIZEN', FALSE, 'CONVERTED_TO_ISSUE', 12, NOW() - INTERVAL '10 days', NOW() - INTERVAL '10 days'),
    ('citizen@civictrust.in', 'Pothole', 'Alipiri', 'Deep crater near Alipiri junction', 'Deep crater formed after rain near Alipiri bus stop. Road completely broken at one side.', 'CITIZEN', FALSE, 'CONVERTED_TO_ISSUE', 8, NOW() - INTERVAL '9 days', NOW() - INTERVAL '9 days'),
    ('citizen@civictrust.in', 'Pothole', 'RC Road', 'Pothole on RC Road near SBI Bank', 'Multiple potholes on RC Road near SBI bank branch. Traffic is slowing down.', 'CITIZEN', FALSE, 'CONVERTED_TO_ISSUE', 5, NOW() - INTERVAL '7 days', NOW() - INTERVAL '7 days'),
    ('citizen@civictrust.in', 'Pothole', 'Balaji Colony', 'Road damaged in Balaji Colony', 'Road in front of Balaji Colony park is completely broken. Old people are struggling to walk.', 'CITIZEN', FALSE, 'UNDER_REVIEW', 3, NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days'),
    ('citizen@civictrust.in', 'Garbage', 'Renigunta Road', 'Garbage pile near Renigunta Road bus stop', 'Huge garbage pile near Renigunta Road bus stop not cleared for a week. Very bad smell.', 'CITIZEN', FALSE, 'CONVERTED_TO_ISSUE', 15, NOW() - INTERVAL '8 days', NOW() - INTERVAL '8 days'),
    ('citizen@civictrust.in', 'Garbage', 'Renigunta Road', 'Waste dumped on Renigunta Road footpath', 'Construction waste dumped on Renigunta Road footpath blocking pedestrians.', 'CITIZEN', FALSE, 'CONVERTED_TO_ISSUE', 7, NOW() - INTERVAL '7 days', NOW() - INTERVAL '7 days'),
    ('citizen@civictrust.in', 'Garbage', 'Tiruchanoor Road', 'Overflowing garbage bin on Tiruchanoor Road', 'Garbage bin overflowing near Tiruchanoor Road market. Not cleared in 5 days.', 'CITIZEN', FALSE, 'UNDER_REVIEW', 4, NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days'),
    ('citizen@civictrust.in', 'Water Leakage', 'Bhavani Nagar', 'Water pipe burst in Bhavani Nagar', 'Water pipe burst near Bhavani Nagar main entrance. Water flowing on road for 2 days.', 'CITIZEN', FALSE, 'CONVERTED_TO_ISSUE', 20, NOW() - INTERVAL '6 days', NOW() - INTERVAL '6 days'),
    ('citizen@civictrust.in', 'Water Leakage', 'Bhavani Nagar', 'Water leaking near Bhavani Nagar park', 'Underground water pipe leaking near the park in Bhavani Nagar. Road becoming waterlogged.', 'CITIZEN', FALSE, 'CONVERTED_TO_ISSUE', 11, NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days'),
    ('citizen@civictrust.in', 'Water Leakage', 'Korlagunta', 'Leaking pipeline on Korlagunta street', 'Continuous water leakage from main pipeline on Korlagunta main street near temple.', 'CITIZEN', FALSE, 'UNDER_REVIEW', 6, NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days'),
    ('citizen@civictrust.in', 'Streetlight', 'Srinivasapuram', 'Streetlights not working in Srinivasapuram', 'Five consecutive streetlights not working in Srinivasapuram colony. Very dark at night.', 'CITIZEN', FALSE, 'CONVERTED_TO_ISSUE', 9, NOW() - INTERVAL '6 days', NOW() - INTERVAL '6 days'),
    ('citizen@civictrust.in', 'Streetlight', 'RC Road', 'Broken lamp post on RC Road', 'Lamp post broken and lying on footpath on RC Road near college. Safety hazard.', 'CITIZEN', FALSE, 'UNDER_REVIEW', 3, NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),
    ('citizen@civictrust.in', 'Drainage', 'Tiruchanoor Road', 'Blocked drain on Tiruchanoor Road', 'Main drain completely blocked near Tiruchanoor Road. Water overflowing into houses during rain.', 'CITIZEN', FALSE, 'CONVERTED_TO_ISSUE', 18, NOW() - INTERVAL '7 days', NOW() - INTERVAL '7 days'),
    ('citizen@civictrust.in', 'Drainage', 'Balaji Colony', 'Drainage overflow in Balaji Colony', 'Drain overflowing in Balaji Colony main road causing mosquito breeding.', 'CITIZEN', FALSE, 'UNDER_REVIEW', 7, NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),
    ('citizen@civictrust.in', 'Public Property', 'Korlagunta', 'Park benches vandalised in Korlagunta', 'All benches in Korlagunta public park vandalised and broken. Children have no place to sit.', 'CITIZEN', FALSE, 'UNDER_REVIEW', 2, NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day')
) AS r(email, category_name, ward_name, title, description, source, is_anonymous, status, upvote_count, submitted_at, created_at)
JOIN users u ON u.email = r.email
JOIN categories c ON c.category_name = r.category_name
JOIN wards w ON w.ward_name = r.ward_name;

-- ============================================================
-- REPORT LOCATIONS
-- ============================================================

INSERT INTO report_location (report_id, latitude, longitude, address, landmark)
SELECT
    r.id,
    rl.latitude,
    rl.longitude,
    rl.address,
    rl.landmark
FROM (
    VALUES
    ('Large pothole on Alipiri Main Road', 13.6288, 79.4192, 'Alipiri Main Road, Tirupati', 'Near Alipiri Checkpost'),
    ('Deep crater near Alipiri junction', 13.6295, 79.4188, 'Alipiri Road, Tirupati', 'Near Alipiri Bus Stop'),
    ('Pothole on RC Road near SBI Bank', 13.6352, 79.4198, 'RC Road, Tirupati', 'Near SBI Bank Branch'),
    ('Road damaged in Balaji Colony', 13.6401, 79.4221, 'Balaji Colony Main Road, Tirupati', 'Near Balaji Colony Park'),
    ('Garbage pile near Renigunta Road bus stop', 13.6489, 79.4098, 'Renigunta Road, Tirupati', 'Near Renigunta Bus Stop'),
    ('Waste dumped on Renigunta Road footpath', 13.6492, 79.4102, 'Renigunta Road Footpath, Tirupati', 'Opposite to Petrol Bunk'),
    ('Overflowing garbage bin on Tiruchanoor Road', 13.6178, 79.4267, 'Tiruchanoor Road, Tirupati', 'Near Daily Market'),
    ('Water pipe burst in Bhavani Nagar', 13.6421, 79.4231, 'Bhavani Nagar Main Road, Tirupati', 'Near Bhavani Nagar Gate'),
    ('Water leaking near Bhavani Nagar park', 13.6418, 79.4228, 'Bhavani Nagar, Tirupati', 'Near Community Park'),
    ('Leaking pipeline on Korlagunta street', 13.6312, 79.4155, 'Korlagunta Main Street, Tirupati', 'Near Korlagunta Temple'),
    ('Streetlights not working in Srinivasapuram', 13.6198, 79.4312, 'Srinivasapuram Colony, Tirupati', 'Near Colony Entrance'),
    ('Broken lamp post on RC Road', 13.6358, 79.4201, 'RC Road, Tirupati', 'Near Engineering College'),
    ('Blocked drain on Tiruchanoor Road', 13.6182, 79.4271, 'Tiruchanoor Road, Tirupati', 'Near Residential Area'),
    ('Drainage overflow in Balaji Colony', 13.6405, 79.4218, 'Balaji Colony, Tirupati', 'Near Main Road Junction'),
    ('Park benches vandalised in Korlagunta', 13.6315, 79.4158, 'Korlagunta, Tirupati', 'Near Public Park')
) AS rl(title, latitude, longitude, address, landmark)
JOIN reports r ON r.title = rl.title;

-- ============================================================
-- REPORT MEDIA (20 records)
-- ============================================================

INSERT INTO report_media (report_id, media_type, file_url, file_name, mime_type, file_size)
SELECT
    r.id,
    rm.media_type,
    rm.file_url,
    rm.file_name,
    rm.mime_type,
    rm.file_size
FROM (
    VALUES
    ('Large pothole on Alipiri Main Road', 'IMAGE', 'https://storage.civictrust.in/reports/r001_pothole1.jpg', 'pothole_alipiri_1.jpg', 'image/jpeg', 245000),
    ('Large pothole on Alipiri Main Road', 'IMAGE', 'https://storage.civictrust.in/reports/r001_pothole2.jpg', 'pothole_alipiri_2.jpg', 'image/jpeg', 198000),
    ('Deep crater near Alipiri junction', 'IMAGE', 'https://storage.civictrust.in/reports/r002_crater1.jpg', 'crater_alipiri.jpg', 'image/jpeg', 312000),
    ('Deep crater near Alipiri junction', 'IMAGE', 'https://storage.civictrust.in/reports/r002_crater2.jpg', 'crater_alipiri_2.jpg', 'image/jpeg', 289000),
    ('Pothole on RC Road near SBI Bank', 'IMAGE', 'https://storage.civictrust.in/reports/r003_rcroad.jpg', 'pothole_rcroad.jpg', 'image/jpeg', 189000),
    ('Road damaged in Balaji Colony', 'IMAGE', 'https://storage.civictrust.in/reports/r004_balaji.jpg', 'balaji_road_damage.jpg', 'image/jpeg', 234000),
    ('Garbage pile near Renigunta Road bus stop', 'IMAGE', 'https://storage.civictrust.in/reports/r005_garbage1.jpg', 'garbage_renigunta_1.jpg', 'image/jpeg', 278000),
    ('Garbage pile near Renigunta Road bus stop', 'IMAGE', 'https://storage.civictrust.in/reports/r005_garbage2.jpg', 'garbage_renigunta_2.jpg', 'image/jpeg', 301000),
    ('Garbage pile near Renigunta Road bus stop', 'VIDEO', 'https://storage.civictrust.in/reports/r005_garbage.mp4', 'garbage_renigunta.mp4', 'video/mp4', 4500000),
    ('Waste dumped on Renigunta Road footpath', 'IMAGE', 'https://storage.civictrust.in/reports/r006_waste.jpg', 'waste_footpath.jpg', 'image/jpeg', 215000),
    ('Overflowing garbage bin on Tiruchanoor Road', 'IMAGE', 'https://storage.civictrust.in/reports/r007_bin.jpg', 'overflow_bin.jpg', 'image/jpeg', 256000),
    ('Water pipe burst in Bhavani Nagar', 'IMAGE', 'https://storage.civictrust.in/reports/r008_burst1.jpg', 'pipe_burst_bhavani_1.jpg', 'image/jpeg', 334000),
    ('Water pipe burst in Bhavani Nagar', 'IMAGE', 'https://storage.civictrust.in/reports/r008_burst2.jpg', 'pipe_burst_bhavani_2.jpg', 'image/jpeg', 367000),
    ('Water pipe burst in Bhavani Nagar', 'VIDEO', 'https://storage.civictrust.in/reports/r008_burst.mp4', 'pipe_burst_bhavani.mp4', 'video/mp4', 6200000),
    ('Water leaking near Bhavani Nagar park', 'IMAGE', 'https://storage.civictrust.in/reports/r009_leak.jpg', 'pipe_leak_park.jpg', 'image/jpeg', 289000),
    ('Leaking pipeline on Korlagunta street', 'IMAGE', 'https://storage.civictrust.in/reports/r010_korlagunta.jpg', 'korlagunta_leak.jpg', 'image/jpeg', 245000),
    ('Streetlights not working in Srinivasapuram', 'IMAGE', 'https://storage.civictrust.in/reports/r011_light1.jpg', 'dark_street_srini_1.jpg', 'image/jpeg', 156000),
    ('Streetlights not working in Srinivasapuram', 'IMAGE', 'https://storage.civictrust.in/reports/r011_light2.jpg', 'dark_street_srini_2.jpg', 'image/jpeg', 178000),
    ('Blocked drain on Tiruchanoor Road', 'IMAGE', 'https://storage.civictrust.in/reports/r013_drain1.jpg', 'blocked_drain_tiru_1.jpg', 'image/jpeg', 223000),
    ('Blocked drain on Tiruchanoor Road', 'IMAGE', 'https://storage.civictrust.in/reports/r013_drain2.jpg', 'blocked_drain_tiru_2.jpg', 'image/jpeg', 267000)
) AS rm(title, media_type, file_url, file_name, mime_type, file_size)
JOIN reports r ON r.title = rm.title;

-- ============================================================
-- AI ANALYSIS (15 reports)
-- ============================================================

INSERT INTO ai_analysis (report_id, model_name, analysis_version, summary, predicted_category_id, predicted_priority, severity_score, confidence_score, duplicate_score, risk_score, processing_time_ms)
SELECT
    r.id,
    aa.model_name,
    aa.analysis_version,
    aa.summary,
    c.id,
    aa.predicted_priority::priority_type,
    aa.severity_score,
    aa.confidence_score,
    aa.duplicate_score,
    aa.risk_score,
    aa.processing_time_ms
FROM (
    VALUES
    ('Large pothole on Alipiri Main Road', 'gemini-1.5-pro', 'v1.0', 'Large pothole detected near Alipiri checkpost. High accident risk. Multiple upvotes indicate widespread impact.', 'Pothole', 'HIGH', 85.0, 92.0, 78.0, 88.0, 1240),
    ('Deep crater near Alipiri junction', 'gemini-1.5-pro', 'v1.0', 'Road crater in Alipiri area. Location proximity to Report #1 suggests same root cause. Possible duplicate.', 'Pothole', 'HIGH', 80.0, 88.0, 85.0, 82.0, 1180),
    ('Pothole on RC Road near SBI Bank', 'gemini-1.5-pro', 'v1.0', 'Multiple potholes on RC Road. Medium severity, traffic impact noted. Independent location from Alipiri reports.', 'Pothole', 'MEDIUM', 65.0, 87.0, 15.0, 60.0, 1050),
    ('Road damaged in Balaji Colony', 'gemini-1.5-pro', 'v1.0', 'Road damage in Balaji Colony. Low urgency but affects elderly residents. Recommend medium priority.', 'Pothole', 'MEDIUM', 55.0, 83.0, 10.0, 50.0, 980),
    ('Garbage pile near Renigunta Road bus stop', 'gemini-1.5-pro', 'v1.0', 'Large garbage accumulation near Renigunta bus stop. Public health risk. High upvote count confirms severity.', 'Garbage', 'HIGH', 82.0, 94.0, 72.0, 80.0, 1320),
    ('Waste dumped on Renigunta Road footpath', 'gemini-1.5-pro', 'v1.0', 'Construction waste on Renigunta Road footpath. Close proximity to Report #5. Likely same dump site.', 'Garbage', 'MEDIUM', 68.0, 86.0, 80.0, 65.0, 1100),
    ('Overflowing garbage bin on Tiruchanoor Road', 'gemini-1.5-pro', 'v1.0', 'Garbage bin overflow on Tiruchanoor Road. Separate location from Renigunta reports. Independent issue.', 'Garbage', 'MEDIUM', 60.0, 85.0, 12.0, 55.0, 1020),
    ('Water pipe burst in Bhavani Nagar', 'gemini-1.5-pro', 'v1.0', 'Major pipe burst in Bhavani Nagar. Water waste and road damage. Highest severity, immediate action required.', 'Water Leakage', 'CRITICAL', 96.0, 97.0, 65.0, 95.0, 1450),
    ('Water leaking near Bhavani Nagar park', 'gemini-1.5-pro', 'v1.0', 'Underground pipe leak in Bhavani Nagar near park. Very close to Report #8 — likely same pipeline failure.', 'Water Leakage', 'HIGH', 88.0, 91.0, 90.0, 87.0, 1380),
    ('Leaking pipeline on Korlagunta street', 'gemini-1.5-pro', 'v1.0', 'Pipeline leak on Korlagunta street. Different ward from Bhavani Nagar. Separate infrastructure issue.', 'Water Leakage', 'MEDIUM', 62.0, 84.0, 8.0, 58.0, 1010),
    ('Streetlights not working in Srinivasapuram', 'gemini-1.5-pro', 'v1.0', 'Multiple streetlights out in Srinivasapuram. Night safety risk. Recommend prompt repair.', 'Streetlight', 'HIGH', 75.0, 89.0, 5.0, 72.0, 1090),
    ('Broken lamp post on RC Road', 'gemini-1.5-pro', 'v1.0', 'Broken lamp post on RC Road. Physical hazard on footpath. Medium priority.', 'Streetlight', 'MEDIUM', 58.0, 82.0, 4.0, 55.0, 960),
    ('Blocked drain on Tiruchanoor Road', 'gemini-1.5-pro', 'v1.0', 'Major drain blockage on Tiruchanoor Road. Risk of flooding during rain. High community impact.', 'Drainage', 'HIGH', 84.0, 93.0, 18.0, 85.0, 1280),
    ('Drainage overflow in Balaji Colony', 'gemini-1.5-pro', 'v1.0', 'Drain overflow in Balaji Colony. Different location from Tiruchanoor drain. Separate issue.', 'Drainage', 'MEDIUM', 64.0, 86.0, 12.0, 60.0, 1040),
    ('Park benches vandalised in Korlagunta', 'gemini-1.5-pro', 'v1.0', 'Vandalized park benches in Korlagunta. Low urgency but affects public amenity.', 'Public Property', 'LOW', 35.0, 80.0, 2.0, 30.0, 880)
) AS aa(title, model_name, analysis_version, summary, category_name, predicted_priority, severity_score, confidence_score, duplicate_score, risk_score, processing_time_ms)
JOIN reports r ON r.title = aa.title
JOIN categories c ON c.category_name = aa.category_name;

-- ============================================================
-- AI PROCESSING LOGS
-- ============================================================

INSERT INTO ai_processing_logs (analysis_id, status, started_at, finished_at, processing_time_ms, token_usage, error_message)
SELECT
    aa.id,
    pl.status,
    pl.started_at,
    pl.finished_at,
    pl.processing_time_ms,
    pl.token_usage,
    pl.error_message
FROM (
    VALUES
    ('Large pothole on Alipiri Main Road', 'COMPLETED', NOW() - INTERVAL '10 days' + INTERVAL '1 minute', NOW() - INTERVAL '10 days' + INTERVAL '3 minutes', 120000, 1500, NULL),
    ('Deep crater near Alipiri junction', 'COMPLETED', NOW() - INTERVAL '9 days' + INTERVAL '1 minute', NOW() - INTERVAL '9 days' + INTERVAL '3 minutes', 120000, 1400, NULL),
    ('Pothole on RC Road near SBI Bank', 'COMPLETED', NOW() - INTERVAL '7 days' + INTERVAL '1 minute', NOW() - INTERVAL '7 days' + INTERVAL '3 minutes', 120000, 1300, NULL),
    ('Road damaged in Balaji Colony', 'COMPLETED', NOW() - INTERVAL '5 days' + INTERVAL '1 minute', NOW() - INTERVAL '5 days' + INTERVAL '3 minutes', 120000, 1200, NULL),
    ('Garbage pile near Renigunta Road bus stop', 'COMPLETED', NOW() - INTERVAL '8 days' + INTERVAL '1 minute', NOW() - INTERVAL '8 days' + INTERVAL '4 minutes', 180000, 1800, NULL),
    ('Waste dumped on Renigunta Road footpath', 'COMPLETED', NOW() - INTERVAL '7 days' + INTERVAL '1 minute', NOW() - INTERVAL '7 days' + INTERVAL '3 minutes', 120000, 1400, NULL),
    ('Overflowing garbage bin on Tiruchanoor Road', 'COMPLETED', NOW() - INTERVAL '4 days' + INTERVAL '1 minute', NOW() - INTERVAL '4 days' + INTERVAL '3 minutes', 120000, 1300, NULL),
    ('Water pipe burst in Bhavani Nagar', 'COMPLETED', NOW() - INTERVAL '6 days' + INTERVAL '1 minute', NOW() - INTERVAL '6 days' + INTERVAL '5 minutes', 240000, 2500, NULL),
    ('Water leaking near Bhavani Nagar park', 'COMPLETED', NOW() - INTERVAL '5 days' + INTERVAL '1 minute', NOW() - INTERVAL '5 days' + INTERVAL '4 minutes', 180000, 1800, NULL),
    ('Leaking pipeline on Korlagunta street', 'COMPLETED', NOW() - INTERVAL '3 days' + INTERVAL '1 minute', NOW() - INTERVAL '3 days' + INTERVAL '3 minutes', 120000, 1300, NULL),
    ('Streetlights not working in Srinivasapuram', 'COMPLETED', NOW() - INTERVAL '6 days' + INTERVAL '1 minute', NOW() - INTERVAL '6 days' + INTERVAL '3 minutes', 120000, 1400, NULL),
    ('Broken lamp post on RC Road', 'COMPLETED', NOW() - INTERVAL '2 days' + INTERVAL '1 minute', NOW() - INTERVAL '2 days' + INTERVAL '3 minutes', 120000, 1200, NULL),
    ('Blocked drain on Tiruchanoor Road', 'COMPLETED', NOW() - INTERVAL '7 days' + INTERVAL '1 minute', NOW() - INTERVAL '7 days' + INTERVAL '4 minutes', 180000, 1700, NULL),
    ('Drainage overflow in Balaji Colony', 'COMPLETED', NOW() - INTERVAL '2 days' + INTERVAL '1 minute', NOW() - INTERVAL '2 days' + INTERVAL '3 minutes', 120000, 1300, NULL),
    ('Park benches vandalised in Korlagunta', 'COMPLETED', NOW() - INTERVAL '1 day' + INTERVAL '1 minute', NOW() - INTERVAL '1 day' + INTERVAL '3 minutes', 120000, 1100, NULL)
) AS pl(title, status, started_at, finished_at, processing_time_ms, token_usage, error_message)
JOIN ai_analysis aa ON aa.report_id = (SELECT id FROM reports WHERE title = pl.title);

-- ============================================================
-- DUPLICATE CANDIDATES
-- ============================================================

INSERT INTO duplicate_candidates (analysis_id, matched_report_id, similarity_score, reason)
SELECT
    aa.id,
    r.id,
    dc.similarity_score,
    dc.reason
FROM (
    VALUES
    ('Deep crater near Alipiri junction', 'Large pothole on Alipiri Main Road', 85.0, 'Same road area, same category, GPS within 100m, submitted within 1 day'),
    ('Waste dumped on Renigunta Road footpath', 'Garbage pile near Renigunta Road bus stop', 80.0, 'Same road, same category, GPS within 50m, both report waste accumulation'),
    ('Water leaking near Bhavani Nagar park', 'Water pipe burst in Bhavani Nagar', 90.0, 'Same ward, same pipeline, GPS within 80m, both report water leakage')
) AS dc(source_title, matched_title, similarity_score, reason)
JOIN ai_analysis aa ON aa.report_id = (SELECT id FROM reports WHERE title = dc.source_title)
JOIN reports r ON r.title = dc.matched_title;

-- ============================================================
-- RELATED CANDIDATES
-- ============================================================

INSERT INTO related_candidates (analysis_id, related_report_id, relationship_reason, confidence_score)
SELECT
    aa.id,
    r.id,
    rc.relationship_reason,
    rc.confidence_score
FROM (
    VALUES
    ('Pothole on RC Road near SBI Bank', 'Road damaged in Balaji Colony', 'Both pothole reports in adjacent wards. Different streets but similar issue type.', 70.0),
    ('Leaking pipeline on Korlagunta street', 'Park benches vandalised in Korlagunta', 'Both issues reported in Korlagunta ward. Different categories but same location.', 45.0)
) AS rc(source_title, related_title, relationship_reason, confidence_score)
JOIN ai_analysis aa ON aa.report_id = (SELECT id FROM reports WHERE title = rc.source_title)
JOIN reports r ON r.title = rc.related_title;

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
    ('CIV-2026-000001', 'worker@civictrust.in', 'officer@civictrust.in', 'COMPLETED', 'Repair the pothole with bitumen. Barricade first. High priority.', NOW() - INTERVAL '8 days', NOW() - INTERVAL '5 days', NOW() - INTERVAL '7 days', NOW() - INTERVAL '2 days', NULL, NULL, NOW() - INTERVAL '8 days'),
    ('CIV-2026-000002', 'worker@civictrust.in', 'officer@civictrust.in', 'IN_PROGRESS', 'Fill all potholes on RC Road stretch. Multiple locations.', NOW() - INTERVAL '5 days', NOW() - INTERVAL '2 days', NOW() - INTERVAL '4 days', NULL, NULL, NULL, NOW() - INTERVAL '5 days'),
    ('CIV-2026-000004', 'worker@civictrust.in', 'officer@civictrust.in', 'ACCEPTED', 'Clear all waste from Renigunta Road. Use heavy equipment.', NOW() - INTERVAL '5 days', NOW() - INTERVAL '2 days', NOW() - INTERVAL '4 days', NULL, NULL, NULL, NOW() - INTERVAL '5 days'),
    ('CIV-2026-000005', 'worker@civictrust.in', 'officer@civictrust.in', 'ASSIGNED', 'Empty and clean the overflow garbage bin on Tiruchanoor Road.', NOW() - INTERVAL '2 days', NOW() + INTERVAL '1 day', NULL, NULL, NULL, NULL, NOW() - INTERVAL '2 days'),
    ('CIV-2026-000006', 'worker@civictrust.in', 'officer@civictrust.in', 'COMPLETED', 'Repair burst pipeline. Stop water flow first. Critical emergency.', NOW() - INTERVAL '4 days', NOW() - INTERVAL '2 days', NOW() - INTERVAL '3 days', NOW() - INTERVAL '1 day', NULL, NULL, NOW() - INTERVAL '4 days'),
    ('CIV-2026-000007', 'worker@civictrust.in', 'officer@civictrust.in', 'IN_PROGRESS', 'Replace faulty bulbs and check wiring. 5 lights need repair.', NOW() - INTERVAL '4 days', NOW() - INTERVAL '1 day', NOW() - INTERVAL '3 days', NULL, NULL, NULL, NOW() - INTERVAL '4 days'),
    ('CIV-2026-000008', 'worker@civictrust.in', 'officer@civictrust.in', 'ASSIGNED', 'Clear drain blockage. Use high pressure flush. Inspect entire stretch.', NOW() - INTERVAL '5 days', NOW() - INTERVAL '1 day', NULL, NULL, NULL, NULL, NOW() - INTERVAL '5 days'),
    ('CIV-2026-000009', 'worker@civictrust.in', 'officer@civictrust.in', 'ASSIGNED', 'Survey damage and estimate repair cost first. Then repair all benches.', NOW() - INTERVAL '1 day', NOW() + INTERVAL '3 days', NULL, NULL, NULL, NULL, NOW() - INTERVAL '1 day')
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