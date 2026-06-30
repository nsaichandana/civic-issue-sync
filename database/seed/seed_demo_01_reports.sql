-- ============================================================
-- CivicTrust
-- seed_demo_01_reports.sql
-- Demo Seed: Reports, Report Locations, Report Media
-- City: Tirupati, Andhra Pradesh
-- ============================================================

DO $$
DECLARE
    v_citizen_id  UUID;
    v_officer_id  UUID;
    v_admin_id    UUID;
    v_worker_id   UUID;

    -- category ids
    c_pothole     UUID;
    c_garbage     UUID;
    c_water       UUID;
    c_streetlight UUID;
    c_drainage    UUID;
    c_public      UUID;
    c_tree        UUID;
    c_encroach    UUID;

    -- ward ids
    w_alipiri     UUID;
    w_rc          UUID;
    w_balaji      UUID;
    w_bhavani     UUID;
    w_renigunta   UUID;
    w_tiruchanoor UUID;
    w_korlagunta  UUID;
    w_srini       UUID;

    -- report ids
    r01 UUID; r02 UUID; r03 UUID; r04 UUID; r05 UUID;
    r06 UUID; r07 UUID; r08 UUID; r09 UUID; r10 UUID;
    r11 UUID; r12 UUID; r13 UUID; r14 UUID; r15 UUID;

BEGIN

    -- --------------------------------------------------------
    -- Resolve user IDs
    -- --------------------------------------------------------
    SELECT id INTO v_citizen_id  FROM users WHERE email = 'citizen@civictrust.in';
    SELECT id INTO v_officer_id  FROM users WHERE email = 'officer@civictrust.in';
    SELECT id INTO v_admin_id    FROM users WHERE email = 'admin@civictrust.in';
    SELECT id INTO v_worker_id   FROM users WHERE email = 'worker@civictrust.in';

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
    -- Generate report UUIDs
    -- --------------------------------------------------------
    r01 := gen_random_uuid(); r02 := gen_random_uuid(); r03 := gen_random_uuid();
    r04 := gen_random_uuid(); r05 := gen_random_uuid(); r06 := gen_random_uuid();
    r07 := gen_random_uuid(); r08 := gen_random_uuid(); r09 := gen_random_uuid();
    r10 := gen_random_uuid(); r11 := gen_random_uuid(); r12 := gen_random_uuid();
    r13 := gen_random_uuid(); r14 := gen_random_uuid(); r15 := gen_random_uuid();

    -- --------------------------------------------------------
    -- REPORTS (15)
    -- --------------------------------------------------------
    INSERT INTO reports (id, reporter_id, category_id, ward_id, title, description, source, is_anonymous, status, upvote_count, submitted_at, created_at, updated_at) VALUES

    (r01, v_citizen_id, c_pothole, w_alipiri,
     'Large pothole near Alipiri checkpost causing accidents',
     'There is a very large pothole just before the Alipiri checkpost on the main road leading to Tirumala. It is nearly 2 feet wide and 8 inches deep. Two-wheelers have skidded here twice this week. Urgent repair is needed before someone gets seriously hurt.',
     'CITIZEN', FALSE, 'CONVERTED_TO_ISSUE', 14,
     NOW() - INTERVAL '10 days', NOW() - INTERVAL '10 days', NOW() - INTERVAL '10 days'),

    (r02, v_citizen_id, c_pothole, w_alipiri,
     'Deep road crater formed near Alipiri bus stop after rain',
     'Heavy rain last week caused a deep crater to form near the Alipiri bus stop. The road base has completely collapsed on one side. Buses and autos are swerving dangerously to avoid it.',
     'CITIZEN', FALSE, 'CONVERTED_TO_ISSUE', 9,
     NOW() - INTERVAL '9 days', NOW() - INTERVAL '9 days', NOW() - INTERVAL '9 days'),

    (r03, v_citizen_id, c_pothole, w_rc,
     'Multiple potholes on RC Road near SBI Bank branch',
     'There are at least five potholes in a 50 metre stretch of RC Road in front of the SBI Bank branch. Traffic is slowing down significantly during peak hours. One vehicle suffered a tyre puncture yesterday.',
     'CITIZEN', FALSE, 'CONVERTED_TO_ISSUE', 6,
     NOW() - INTERVAL '7 days', NOW() - INTERVAL '7 days', NOW() - INTERVAL '7 days'),

    (r04, v_citizen_id, c_pothole, w_balaji,
     'Road surface badly damaged in front of Balaji Colony park',
     'The road in front of the Balaji Colony park entrance is completely broken. Large chunks of tar have come loose. Elderly residents and schoolchildren walk here daily and are at risk of injury.',
     'CITIZEN', FALSE, 'UNDER_REVIEW', 3,
     NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days'),

    (r05, v_citizen_id, c_garbage, w_renigunta,
     'Uncollected garbage pile near Renigunta Road bus stop',
     'A massive pile of garbage has been accumulating near the Renigunta Road bus stop for over a week. It has not been cleared by the sanitation team. The smell is unbearable and flies are everywhere. Serious public health risk.',
     'CITIZEN', FALSE, 'CONVERTED_TO_ISSUE', 18,
     NOW() - INTERVAL '8 days', NOW() - INTERVAL '8 days', NOW() - INTERVAL '8 days'),

    (r06, v_citizen_id, c_garbage, w_renigunta,
     'Construction waste illegally dumped on Renigunta Road footpath',
     'Someone has dumped a large amount of construction debris including bricks, cement bags and broken tiles on the footpath of Renigunta Road near the petrol bunk. Pedestrians are being forced to walk on the road.',
     'CITIZEN', FALSE, 'CONVERTED_TO_ISSUE', 7,
     NOW() - INTERVAL '7 days', NOW() - INTERVAL '7 days', NOW() - INTERVAL '7 days'),

    (r07, v_citizen_id, c_garbage, w_tiruchanoor,
     'Garbage bin overflowing near Tiruchanoor Road daily market',
     'The municipality garbage bin near the Tiruchanoor Road daily market has not been emptied in 5 days. It is completely overflowing and the surrounding area is covered in loose waste. Market shoppers and residents are complaining.',
     'CITIZEN', FALSE, 'UNDER_REVIEW', 4,
     NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days'),

    (r08, v_citizen_id, c_water, w_bhavani,
     'Water pipe burst near Bhavani Nagar main entrance',
     'A main water supply pipe has burst near the entrance of Bhavani Nagar. Water has been flowing continuously onto the road for 2 days. The road has turned into a muddy swamp. Vehicles are getting stuck and water is being wasted.',
     'CITIZEN', FALSE, 'CONVERTED_TO_ISSUE', 22,
     NOW() - INTERVAL '6 days', NOW() - INTERVAL '6 days', NOW() - INTERVAL '6 days'),

    (r09, v_citizen_id, c_water, w_bhavani,
     'Underground water pipe leaking near Bhavani Nagar community park',
     'There is a continuous underground water leak near the community park in Bhavani Nagar. The ground is saturated and water is bubbling up through cracks in the road. The footpath is becoming unstable.',
     'CITIZEN', FALSE, 'CONVERTED_TO_ISSUE', 11,
     NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days'),

    (r10, v_citizen_id, c_water, w_korlagunta,
     'Continuous water leakage from main pipeline on Korlagunta street',
     'The main water supply pipeline on Korlagunta main street near the temple is leaking from a joint. Water is running into the storm drain continuously. Supply pressure in nearby houses has dropped significantly.',
     'CITIZEN', FALSE, 'UNDER_REVIEW', 5,
     NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days'),

    (r11, v_citizen_id, c_streetlight, w_srini,
     'Five streetlights not working in Srinivasapuram colony',
     'Five consecutive streetlights in Srinivasapuram colony have not been working for the past 10 days. The entire stretch of road is completely dark at night. Women and children are afraid to walk here after sunset. Please fix urgently.',
     'CITIZEN', FALSE, 'CONVERTED_TO_ISSUE', 9,
     NOW() - INTERVAL '6 days', NOW() - INTERVAL '6 days', NOW() - INTERVAL '6 days'),

    (r12, v_citizen_id, c_streetlight, w_rc,
     'Broken lamp post fallen on footpath near RC Road college',
     'A lamp post has broken at its base and is lying across the footpath on RC Road near the engineering college. It is a serious safety hazard. Students walking to college have to step into the road to pass. Needs immediate removal.',
     'CITIZEN', FALSE, 'UNDER_REVIEW', 3,
     NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),

    (r13, v_citizen_id, c_drainage, w_tiruchanoor,
     'Main drain completely blocked on Tiruchanoor Road causing flooding',
     'The main stormwater drain on Tiruchanoor Road near the residential colony is completely blocked with silt and solid waste. During last nights light rain, water entered three houses. If it rains heavily this will be a disaster.',
     'CITIZEN', FALSE, 'CONVERTED_TO_ISSUE', 20,
     NOW() - INTERVAL '7 days', NOW() - INTERVAL '7 days', NOW() - INTERVAL '7 days'),

    (r14, v_citizen_id, c_tree, w_korlagunta,
     'Large tree branch fallen and blocking road near Korlagunta temple',
     'A large branch from an old tree near the Korlagunta temple has fallen and is blocking half the road. Traffic is moving very slowly. The branch appears to be from a diseased tree and the rest of the tree looks unstable.',
     'CITIZEN', FALSE, 'UNDER_REVIEW', 6,
     NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),

    (r15, v_citizen_id, c_encroach, w_rc,
     'Illegal temporary shop blocking footpath on RC Road',
     'A vendor has illegally set up a permanent-looking temporary shop structure on the RC Road footpath near the bus stand. The structure is built with iron sheets and completely blocks pedestrian access forcing people to walk on the road.',
     'CITIZEN', FALSE, 'SUBMITTED', 2,
     NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day');

    -- --------------------------------------------------------
    -- REPORT LOCATIONS (15)
    -- --------------------------------------------------------
    INSERT INTO report_location (id, report_id, latitude, longitude, accuracy, address, landmark, created_at) VALUES

    (gen_random_uuid(), r01, 13.62881, 79.41923, 8.5,
     'Alipiri Main Road, Tirupati, Andhra Pradesh 517501',
     'Near Alipiri Checkpost, 200m before toll gate', NOW() - INTERVAL '10 days'),

    (gen_random_uuid(), r02, 13.62952, 79.41884, 10.2,
     'Alipiri Road, Tirupati, Andhra Pradesh 517501',
     'Adjacent to Alipiri APSRTC Bus Stop', NOW() - INTERVAL '9 days'),

    (gen_random_uuid(), r03, 13.63524, 79.41981, 6.8,
     'RC Road, Tirupati, Andhra Pradesh 517501',
     'In front of State Bank of India, RC Road Branch', NOW() - INTERVAL '7 days'),

    (gen_random_uuid(), r04, 13.64013, 79.42218, 12.0,
     'Balaji Colony Main Road, Tirupati, Andhra Pradesh 517502',
     'Opposite Balaji Colony Park main entrance gate', NOW() - INTERVAL '5 days'),

    (gen_random_uuid(), r05, 13.64893, 79.40982, 7.3,
     'Renigunta Road, Tirupati, Andhra Pradesh 517520',
     'Next to Renigunta Road APSRTC Bus Stop', NOW() - INTERVAL '8 days'),

    (gen_random_uuid(), r06, 13.64921, 79.41024, 9.1,
     'Renigunta Road Footpath, Tirupati, Andhra Pradesh 517520',
     'Opposite HP Petrol Bunk, Renigunta Road', NOW() - INTERVAL '7 days'),

    (gen_random_uuid(), r07, 13.61782, 79.42674, 11.5,
     'Tiruchanoor Road, Tirupati, Andhra Pradesh 517503',
     'Near Tiruchanoor Road Daily Vegetable Market', NOW() - INTERVAL '4 days'),

    (gen_random_uuid(), r08, 13.64212, 79.42313, 5.9,
     'Bhavani Nagar Main Road, Tirupati, Andhra Pradesh 517502',
     'At Bhavani Nagar colony entrance gate', NOW() - INTERVAL '6 days'),

    (gen_random_uuid(), r09, 13.64184, 79.42281, 8.4,
     'Bhavani Nagar, Tirupati, Andhra Pradesh 517502',
     'Near Bhavani Nagar Community Park, east side', NOW() - INTERVAL '5 days'),

    (gen_random_uuid(), r10, 13.63121, 79.41553, 13.2,
     'Korlagunta Main Street, Tirupati, Andhra Pradesh 517501',
     'In front of Korlagunta Sri Venkateswara Temple', NOW() - INTERVAL '3 days'),

    (gen_random_uuid(), r11, 13.61984, 79.43124, 7.6,
     'Srinivasapuram Colony Road, Tirupati, Andhra Pradesh 517507',
     'Between Srinivasapuram Colony Gate and Water Tank', NOW() - INTERVAL '6 days'),

    (gen_random_uuid(), r12, 13.63581, 79.42012, 10.8,
     'RC Road, Tirupati, Andhra Pradesh 517501',
     'Near Sri Venkateswara Engineering College main gate', NOW() - INTERVAL '2 days'),

    (gen_random_uuid(), r13, 13.61824, 79.42714, 6.2,
     'Tiruchanoor Road Residential Area, Tirupati, Andhra Pradesh 517503',
     'Behind Tiruchanoor Road bus shelter, near Colony Road junction', NOW() - INTERVAL '7 days'),

    (gen_random_uuid(), r14, 13.63154, 79.41582, 14.0,
     'Korlagunta Street, Tirupati, Andhra Pradesh 517501',
     'Beside Korlagunta Sri Anjaneya Swamy Temple compound wall', NOW() - INTERVAL '2 days'),

    (gen_random_uuid(), r15, 13.63498, 79.41944, 9.7,
     'RC Road Footpath, Tirupati, Andhra Pradesh 517501',
     'Near RC Road APSRTC Bus Stand, footpath side', NOW() - INTERVAL '1 day');

    -- --------------------------------------------------------
    -- REPORT MEDIA (20)
    -- --------------------------------------------------------
    INSERT INTO report_media (id, report_id, media_type, file_url, file_name, mime_type, file_size, uploaded_at) VALUES

    -- r01: pothole alipiri — 2 images
    (gen_random_uuid(), r01, 'IMAGE',
     'https://storage.civictrust.in/reports/r01_pothole_alipiri_01.jpg',
     'pothole_alipiri_main_01.jpg', 'image/jpeg', 248320, NOW() - INTERVAL '10 days'),

    (gen_random_uuid(), r01, 'IMAGE',
     'https://storage.civictrust.in/reports/r01_pothole_alipiri_02.jpg',
     'pothole_alipiri_main_02.jpg', 'image/jpeg', 193512, NOW() - INTERVAL '10 days'),

    -- r02: road crater alipiri — 1 image + 1 video
    (gen_random_uuid(), r02, 'IMAGE',
     'https://storage.civictrust.in/reports/r02_crater_alipiri_01.jpg',
     'road_crater_alipiri_01.jpg', 'image/jpeg', 314880, NOW() - INTERVAL '9 days'),

    (gen_random_uuid(), r02, 'VIDEO',
     'https://storage.civictrust.in/reports/r02_crater_alipiri_01.mp4',
     'road_crater_alipiri_01.mp4', 'video/mp4', 4718592, NOW() - INTERVAL '9 days'),

    -- r03: rc road potholes — 1 image
    (gen_random_uuid(), r03, 'IMAGE',
     'https://storage.civictrust.in/reports/r03_potholes_rcroad_01.jpg',
     'potholes_rcroad_sbi_01.jpg', 'image/jpeg', 201728, NOW() - INTERVAL '7 days'),

    -- r04: balaji colony road — 1 image
    (gen_random_uuid(), r04, 'IMAGE',
     'https://storage.civictrust.in/reports/r04_road_balaji_01.jpg',
     'road_damage_balaji_colony_01.jpg', 'image/jpeg', 178688, NOW() - INTERVAL '5 days'),

    -- r05: garbage renigunta — 2 images + 1 video
    (gen_random_uuid(), r05, 'IMAGE',
     'https://storage.civictrust.in/reports/r05_garbage_renigunta_01.jpg',
     'garbage_pile_renigunta_01.jpg', 'image/jpeg', 289792, NOW() - INTERVAL '8 days'),

    (gen_random_uuid(), r05, 'IMAGE',
     'https://storage.civictrust.in/reports/r05_garbage_renigunta_02.jpg',
     'garbage_pile_renigunta_02.jpg', 'image/jpeg', 256000, NOW() - INTERVAL '8 days'),

    (gen_random_uuid(), r05, 'VIDEO',
     'https://storage.civictrust.in/reports/r05_garbage_renigunta_01.mp4',
     'garbage_pile_renigunta_01.mp4', 'video/mp4', 6291456, NOW() - INTERVAL '8 days'),

    -- r06: construction waste — 1 image
    (gen_random_uuid(), r06, 'IMAGE',
     'https://storage.civictrust.in/reports/r06_waste_renigunta_01.jpg',
     'construction_waste_renigunta_footpath_01.jpg', 'image/jpeg', 224256, NOW() - INTERVAL '7 days'),

    -- r07: garbage bin overflow — 1 image
    (gen_random_uuid(), r07, 'IMAGE',
     'https://storage.civictrust.in/reports/r07_bin_tiruchanoor_01.jpg',
     'overflowing_bin_tiruchanoor_market_01.jpg', 'image/jpeg', 198656, NOW() - INTERVAL '4 days'),

    -- r08: pipe burst bhavani — 2 images + 1 video
    (gen_random_uuid(), r08, 'IMAGE',
     'https://storage.civictrust.in/reports/r08_burst_bhavani_01.jpg',
     'pipe_burst_bhavani_nagar_01.jpg', 'image/jpeg', 401408, NOW() - INTERVAL '6 days'),

    (gen_random_uuid(), r08, 'IMAGE',
     'https://storage.civictrust.in/reports/r08_burst_bhavani_02.jpg',
     'pipe_burst_bhavani_nagar_02.jpg', 'image/jpeg', 356352, NOW() - INTERVAL '6 days'),

    (gen_random_uuid(), r08, 'VIDEO',
     'https://storage.civictrust.in/reports/r08_burst_bhavani_01.mp4',
     'pipe_burst_bhavani_nagar_01.mp4', 'video/mp4', 7340032, NOW() - INTERVAL '6 days'),

    -- r09: underground leak bhavani — 1 image
    (gen_random_uuid(), r09, 'IMAGE',
     'https://storage.civictrust.in/reports/r09_leak_bhavani_01.jpg',
     'underground_leak_bhavani_park_01.jpg', 'image/jpeg', 231424, NOW() - INTERVAL '5 days'),

    -- r11: streetlights srinivasapuram — 1 image
    (gen_random_uuid(), r11, 'IMAGE',
     'https://storage.civictrust.in/reports/r11_lights_srini_01.jpg',
     'dark_streetlights_srinivasapuram_01.jpg', 'image/jpeg', 158720, NOW() - INTERVAL '6 days'),

    -- r13: drain blocked tiruchanoor — 2 images
    (gen_random_uuid(), r13, 'IMAGE',
     'https://storage.civictrust.in/reports/r13_drain_tiruchanoor_01.jpg',
     'blocked_drain_tiruchanoor_01.jpg', 'image/jpeg', 267264, NOW() - INTERVAL '7 days'),

    (gen_random_uuid(), r13, 'IMAGE',
     'https://storage.civictrust.in/reports/r13_drain_tiruchanoor_02.jpg',
     'drain_overflow_tiruchanoor_02.jpg', 'image/jpeg', 289280, NOW() - INTERVAL '7 days'),

    -- r14: fallen tree korlagunta — 1 image + 1 video
    (gen_random_uuid(), r14, 'IMAGE',
     'https://storage.civictrust.in/reports/r14_tree_korlagunta_01.jpg',
     'fallen_branch_korlagunta_temple_01.jpg', 'image/jpeg', 312320, NOW() - INTERVAL '2 days'),

    (gen_random_uuid(), r14, 'VIDEO',
     'https://storage.civictrust.in/reports/r14_tree_korlagunta_01.mp4',
     'fallen_branch_korlagunta_temple_01.mp4', 'video/mp4', 5242880, NOW() - INTERVAL '2 days');

END $$;