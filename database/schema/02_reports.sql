-- ============================================================
-- CivicTrust
-- 02_reports.sql
-- Citizen Reporting Module
-- ============================================================

-- ============================================================
-- REPORTS
-- ============================================================

CREATE TABLE reports (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    reporter_id UUID NOT NULL
        REFERENCES users(id)
        ON DELETE CASCADE,

    category_id UUID NOT NULL
        REFERENCES categories(id),

    ward_id UUID NOT NULL
        REFERENCES wards(id),

    title VARCHAR(150) NOT NULL,

    description TEXT NOT NULL,

    source report_source
        DEFAULT 'CITIZEN',

    is_anonymous BOOLEAN DEFAULT FALSE,

    status report_status
        DEFAULT 'SUBMITTED',

    submitted_at TIMESTAMPTZ DEFAULT NOW(),

    created_at TIMESTAMPTZ DEFAULT NOW(),

    updated_at TIMESTAMPTZ DEFAULT NOW(),

    deleted_at TIMESTAMPTZ

);

-- ============================================================
-- REPORT MEDIA
-- ============================================================

CREATE TABLE report_media (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    report_id UUID NOT NULL
        REFERENCES reports(id)
        ON DELETE CASCADE,

    media_type media_type NOT NULL,

    file_url TEXT NOT NULL,

    file_name VARCHAR(255) NOT NULL,

    mime_type VARCHAR(100) NOT NULL,

    file_size BIGINT,

    uploaded_at TIMESTAMPTZ DEFAULT NOW()

);

-- ============================================================
-- REPORT LOCATION
-- ============================================================

CREATE TABLE report_location (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    report_id UUID UNIQUE NOT NULL
        REFERENCES reports(id)
        ON DELETE CASCADE,

    latitude DOUBLE PRECISION NOT NULL,

    longitude DOUBLE PRECISION NOT NULL,

    accuracy DOUBLE PRECISION,

    address TEXT,

    landmark TEXT,

    created_at TIMESTAMPTZ DEFAULT NOW()

);

-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_reports_reporter
ON reports(reporter_id);

CREATE INDEX idx_reports_category
ON reports(category_id);

CREATE INDEX idx_reports_ward
ON reports(ward_id);

CREATE INDEX idx_reports_status
ON reports(status);

CREATE INDEX idx_reports_created
ON reports(created_at);

CREATE INDEX idx_report_media_report
ON report_media(report_id);

CREATE INDEX idx_report_location_report
ON report_location(report_id);

-- ============================================================
-- TRIGGER
-- ============================================================

CREATE TRIGGER trg_reports_updated
BEFORE UPDATE ON reports
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- MODULE COMPLETE
-- ============================================================