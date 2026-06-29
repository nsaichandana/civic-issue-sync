-- ============================================================
-- CivicTrust
-- 03_ai.sql
-- AI Analysis Module
-- ============================================================

-- ============================================================
-- AI ANALYSIS
-- ============================================================

CREATE TABLE ai_analysis (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    report_id UUID NOT NULL
        REFERENCES reports(id)
        ON DELETE CASCADE,

    model_name VARCHAR(100) NOT NULL,

    analysis_version VARCHAR(50),

    summary TEXT,

    predicted_category_id UUID
        REFERENCES categories(id),

    predicted_priority priority_type,

    severity_score NUMERIC(5,2)
        CHECK (severity_score BETWEEN 0 AND 100),

    confidence_score NUMERIC(5,2)
        CHECK (confidence_score BETWEEN 0 AND 100),

    duplicate_score NUMERIC(5,2)
        CHECK (duplicate_score BETWEEN 0 AND 100),

    risk_score NUMERIC(5,2)
        CHECK (risk_score BETWEEN 0 AND 100),

    processing_time_ms INTEGER,

    created_at TIMESTAMPTZ DEFAULT NOW()

);

-- ============================================================
-- DUPLICATE CANDIDATES
-- ============================================================

CREATE TABLE duplicate_candidates (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    analysis_id UUID NOT NULL
        REFERENCES ai_analysis(id)
        ON DELETE CASCADE,

    matched_report_id UUID NOT NULL
        REFERENCES reports(id)
        ON DELETE CASCADE,

    similarity_score NUMERIC(5,2)
        CHECK (similarity_score BETWEEN 0 AND 100),

    reason TEXT,

    created_at TIMESTAMPTZ DEFAULT NOW()

);

-- ============================================================
-- RELATED CANDIDATES
-- ============================================================

CREATE TABLE related_candidates (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    analysis_id UUID NOT NULL
        REFERENCES ai_analysis(id)
        ON DELETE CASCADE,

    related_report_id UUID NOT NULL
        REFERENCES reports(id)
        ON DELETE CASCADE,

    relationship_reason TEXT,

    confidence_score NUMERIC(5,2)
        CHECK (confidence_score BETWEEN 0 AND 100),

    created_at TIMESTAMPTZ DEFAULT NOW()

);

-- ============================================================
-- AI PROCESSING LOGS
-- ============================================================

CREATE TABLE ai_processing_logs (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    analysis_id UUID NOT NULL
        REFERENCES ai_analysis(id)
        ON DELETE CASCADE,

    status VARCHAR(50) NOT NULL,

    started_at TIMESTAMPTZ,

    finished_at TIMESTAMPTZ,

    processing_time_ms INTEGER,

    token_usage INTEGER,

    error_message TEXT

);

-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_ai_analysis_report
ON ai_analysis(report_id);

CREATE INDEX idx_ai_analysis_category
ON ai_analysis(predicted_category_id);

CREATE INDEX idx_duplicate_analysis
ON duplicate_candidates(analysis_id);

CREATE INDEX idx_duplicate_report
ON duplicate_candidates(matched_report_id);

CREATE INDEX idx_related_analysis
ON related_candidates(analysis_id);

CREATE INDEX idx_related_report
ON related_candidates(related_report_id);

CREATE INDEX idx_processing_logs_analysis
ON ai_processing_logs(analysis_id);

-- ============================================================
-- MODULE COMPLETE
-- ============================================================