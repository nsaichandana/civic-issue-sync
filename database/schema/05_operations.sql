-- ============================================================
-- CivicTrust
-- 05_operations.sql
-- Operations Module
-- Version : 3.0 (Frozen)
-- ============================================================

-- ============================================================
-- ENUMS
-- ============================================================

CREATE TYPE task_status AS ENUM (
    'PENDING',
    'IN_PROGRESS',
    'COMPLETED',
    'CANCELLED'
);

-- ============================================================
-- ASSIGNMENTS
-- An issue is assigned to a field worker by an officer
-- ============================================================

CREATE TABLE assignments (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    issue_id UUID NOT NULL
        REFERENCES issues(id)
        ON DELETE CASCADE,

    assigned_to UUID NOT NULL
        REFERENCES users(id),

    assigned_by UUID NOT NULL
        REFERENCES users(id),

    status assignment_status
        NOT NULL
        DEFAULT 'ASSIGNED',

    notes TEXT,

    -- When the assignment was officially made (may differ from created_at)
    assigned_at TIMESTAMPTZ
        NOT NULL
        DEFAULT NOW(),

    due_date TIMESTAMPTZ,

    accepted_at TIMESTAMPTZ,

    completed_at TIMESTAMPTZ,

    cancelled_at TIMESTAMPTZ,

    cancellation_reason TEXT,

    created_at TIMESTAMPTZ
        NOT NULL
        DEFAULT NOW(),

    updated_at TIMESTAMPTZ
        NOT NULL
        DEFAULT NOW(),

    -- A field worker cannot assign to themselves
    CHECK (assigned_to <> assigned_by),

    -- Timestamp integrity
    CHECK (
        accepted_at IS NULL
        OR accepted_at >= assigned_at
    ),

    CHECK (
        completed_at IS NULL
        OR (
            accepted_at IS NOT NULL
            AND completed_at >= accepted_at
        )
    ),

    CHECK (
        due_date IS NULL
        OR due_date >= assigned_at
    )

);

CREATE TRIGGER trg_assignments_updated
BEFORE UPDATE ON assignments
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- FIELD TASKS
-- Granular work items under an assignment
-- ============================================================

CREATE TABLE field_tasks (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    assignment_id UUID NOT NULL
        REFERENCES assignments(id)
        ON DELETE CASCADE,

    title VARCHAR(200) NOT NULL,

    description TEXT,

    status task_status
        NOT NULL
        DEFAULT 'PENDING',

    completed_by UUID
        REFERENCES users(id),

    completed_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ
        NOT NULL
        DEFAULT NOW(),

    updated_at TIMESTAMPTZ
        NOT NULL
        DEFAULT NOW(),

    CHECK (
        completed_at IS NULL
        OR completed_at >= created_at
    ),

    -- completed_by must be set if completed_at is set and vice versa
    CHECK (
        (completed_at IS NULL AND completed_by IS NULL)
        OR (completed_at IS NOT NULL AND completed_by IS NOT NULL)
    )

);

CREATE TRIGGER trg_field_tasks_updated
BEFORE UPDATE ON field_tasks
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- RESOLUTION EVIDENCE
-- Before/after proof submitted when resolving an issue
-- media_type  → what kind of file (IMAGE, VIDEO, AUDIO, DOCUMENT)
-- evidence_stage → where in the workflow (BEFORE, IN_PROGRESS, AFTER)
-- ============================================================

CREATE TABLE resolution_evidence (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    assignment_id UUID NOT NULL
        REFERENCES assignments(id)
        ON DELETE CASCADE,

    submitted_by UUID NOT NULL
        REFERENCES users(id),

    -- File type using the media_type enum from 01_foundation.sql
    media_type media_type NOT NULL,

    -- Stage of the work this evidence belongs to
    evidence_stage VARCHAR(30)
        NOT NULL
        CHECK (evidence_stage IN ('BEFORE', 'IN_PROGRESS', 'AFTER')),

    file_url TEXT NOT NULL,

    file_name VARCHAR(255) NOT NULL,

    mime_type VARCHAR(100) NOT NULL,

    file_size BIGINT
        CHECK (file_size > 0),

    caption TEXT,

    -- GPS proof of on-site presence
    latitude DOUBLE PRECISION,

    longitude DOUBLE PRECISION,

    taken_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ
        NOT NULL
        DEFAULT NOW(),

    -- lat and long must both be present or both absent
    CHECK (
        (latitude IS NULL AND longitude IS NULL)
        OR (latitude IS NOT NULL AND longitude IS NOT NULL)
    )

);

-- ============================================================
-- NOTIFICATIONS
-- Alerts sent to users on issue/assignment events
-- ============================================================

CREATE TABLE notifications (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id UUID NOT NULL
        REFERENCES users(id)
        ON DELETE CASCADE,

    issue_id UUID
        REFERENCES issues(id)
        ON DELETE SET NULL,

    title VARCHAR(200) NOT NULL,

    body TEXT NOT NULL,

    type VARCHAR(50)
        NOT NULL
        CHECK (type IN (
            'ISSUE_CREATED',
            'ISSUE_ASSIGNED',
            'ISSUE_UPDATED',
            'ISSUE_RESOLVED',
            'ISSUE_CLOSED',
            'ISSUE_REJECTED',
            'ASSIGNMENT_RECEIVED',
            'ASSIGNMENT_COMPLETED',
            'COMMENT_ADDED',
            'SLA_WARNING',
            'SLA_BREACH',
            'SYSTEM'
        )),

    is_read BOOLEAN
        NOT NULL
        DEFAULT FALSE,

    read_at TIMESTAMPTZ,

    -- Tracks whether the notification was successfully delivered
    is_sent BOOLEAN
        NOT NULL
        DEFAULT FALSE,

    sent_at TIMESTAMPTZ,

    sent_via VARCHAR(50)
        DEFAULT 'IN_APP'
        CHECK (sent_via IN ('IN_APP', 'EMAIL', 'SMS', 'PUSH')),

    created_at TIMESTAMPTZ
        NOT NULL
        DEFAULT NOW(),

    CHECK (
        read_at IS NULL
        OR (is_read = TRUE AND read_at >= created_at)
    ),

    CHECK (
        sent_at IS NULL
        OR (is_sent = TRUE AND sent_at >= created_at)
    )

);

-- ============================================================
-- AUDIT LOGS
-- Immutable record of all significant state changes
-- Write-once: no updated_at, no soft delete, no hard delete
-- ============================================================

CREATE TABLE audit_logs (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    actor_id UUID
        REFERENCES users(id)
        ON DELETE SET NULL,

    entity_type VARCHAR(100)
        NOT NULL
        CHECK (entity_type IN (
            'REPORT',
            'DRAFT_ISSUE',
            'ISSUE',
            'ASSIGNMENT',
            'FIELD_TASK',
            'RESOLUTION_EVIDENCE',
            'USER',
            'DEPARTMENT',
            'CATEGORY',
            'SLA_RULE',
            'SYSTEM_SETTING'
        )),

    entity_id UUID NOT NULL,

    action VARCHAR(100)
        NOT NULL
        CHECK (action IN (
            'CREATED',
            'UPDATED',
            'DELETED',
            'STATUS_CHANGED',
            'APPROVED',
            'REJECTED',
            'MERGED',
            'SPLIT',
            'ASSIGNED',
            'REASSIGNED',
            'COMPLETED',
            'CANCELLED',
            'ESCALATED',
            'LOGIN',
            'LOGOUT'
        )),

    old_value JSONB,

    new_value JSONB,

    description TEXT,

    created_at TIMESTAMPTZ
        NOT NULL
        DEFAULT NOW()

);

-- ============================================================
-- INDEXES
-- ============================================================

-- assignments
CREATE INDEX idx_assignment_issue
ON assignments(issue_id);

CREATE INDEX idx_assignment_assigned_to
ON assignments(assigned_to);

CREATE INDEX idx_assignment_assigned_by
ON assignments(assigned_by);

CREATE INDEX idx_assignment_status
ON assignments(status);

CREATE INDEX idx_assignment_due_date
ON assignments(due_date);

-- field_tasks
CREATE INDEX idx_field_task_assignment
ON field_tasks(assignment_id);

CREATE INDEX idx_field_task_status
ON field_tasks(status);

-- resolution_evidence
CREATE INDEX idx_evidence_assignment
ON resolution_evidence(assignment_id);

CREATE INDEX idx_evidence_submitted_by
ON resolution_evidence(submitted_by);

CREATE INDEX idx_evidence_stage
ON resolution_evidence(evidence_stage);

CREATE INDEX idx_evidence_media_type
ON resolution_evidence(media_type);

-- notifications
CREATE INDEX idx_notification_user
ON notifications(user_id);

CREATE INDEX idx_notification_issue
ON notifications(issue_id);

CREATE INDEX idx_notification_is_read
ON notifications(is_read);

CREATE INDEX idx_notification_is_sent
ON notifications(is_sent);

CREATE INDEX idx_notification_created
ON notifications(created_at);

-- audit_logs
CREATE INDEX idx_audit_actor
ON audit_logs(actor_id);

CREATE INDEX idx_audit_entity
ON audit_logs(entity_type, entity_id);

CREATE INDEX idx_audit_action
ON audit_logs(action);

CREATE INDEX idx_audit_created
ON audit_logs(created_at);

-- ============================================================
-- MODULE COMPLETE
-- STATUS : FROZEN ✅
-- VERSION: 3.0
-- ============================================================