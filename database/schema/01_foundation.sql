-- ============================================================
-- CivicTrust
-- 01_foundation.sql
-- Foundation Database Schema
-- ============================================================

-- ============================================================
-- EXTENSIONS
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================
-- ENUM TYPES
-- ============================================================

CREATE TYPE role_type AS ENUM (
    'CITIZEN',
    'OFFICER',
    'FIELD_WORKER',
    'DEPARTMENT_HEAD',
    'ADMIN'
);

CREATE TYPE priority_type AS ENUM (
    'LOW',
    'MEDIUM',
    'HIGH',
    'CRITICAL'
);

CREATE TYPE issue_status AS ENUM (
    'DRAFT',
    'OPEN',
    'ASSIGNED',
    'IN_PROGRESS',
    'RESOLVED',
    'CLOSED',
    'REJECTED'
);

CREATE TYPE review_status AS ENUM (
    'PENDING',
    'APPROVED',
    'REJECTED',
    'MERGED',
    'NEEDS_REVIEW'
);

CREATE TYPE assignment_status AS ENUM (
    'ASSIGNED',
    'ACCEPTED',
    'IN_PROGRESS',
    'COMPLETED',
    'CANCELLED'
);

CREATE TYPE report_status AS ENUM (
    'SUBMITTED',
    'UNDER_AI_ANALYSIS',
    'UNDER_REVIEW',
    'CONVERTED_TO_ISSUE',
    'REJECTED'
);

CREATE TYPE report_source AS ENUM (
    'CITIZEN',
    'OFFICER',
    'MUNICIPALITY',
    'NEWS'
);

-- ============================================================
-- ROLES
-- ============================================================

CREATE TABLE roles (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    role_name role_type UNIQUE NOT NULL,

    description TEXT,

    deleted_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ DEFAULT NOW()

);

-- ============================================================
-- DEPARTMENTS
-- ============================================================

CREATE TABLE departments (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    department_name VARCHAR(100) UNIQUE NOT NULL,

    description TEXT,

    is_active BOOLEAN DEFAULT TRUE,

    created_at TIMESTAMPTZ DEFAULT NOW(),

    deleted_at TIMESTAMPTZ,

    updated_at TIMESTAMPTZ DEFAULT NOW()

);

-- ============================================================
-- WARDS
-- ============================================================

CREATE TABLE wards (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    ward_number INTEGER UNIQUE NOT NULL,

    ward_name VARCHAR(100),

    municipality_name VARCHAR(150),

    district VARCHAR(100),

    state VARCHAR(100),

    pincode VARCHAR(10),

    deleted_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ DEFAULT NOW()

);

-- ============================================================
-- CATEGORIES
-- ============================================================

CREATE TABLE categories (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    category_name VARCHAR(100) UNIQUE NOT NULL,

    description TEXT,

    description TEXT,

    icon VARCHAR(100),

    color VARCHAR(30),

    ai_keywords TEXT,

    display_order INTEGER DEFAULT 0,

    department_id UUID REFERENCES departments(id),

    is_active BOOLEAN DEFAULT TRUE,

    deleted_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ DEFAULT NOW()

);

-- ============================================================
-- SLA RULES
-- ============================================================

CREATE TABLE sla_rules (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    category_id UUID REFERENCES categories(id),

    priority priority_type NOT NULL,

    resolution_hours INTEGER NOT NULL,

    warning_hours INTEGER,

    escalation_hours INTEGER,

    auto_escalate BOOLEAN DEFAULT TRUE,

    is_active BOOLEAN DEFAULT TRUE,

    created_at TIMESTAMPTZ DEFAULT NOW()

);

-- ============================================================
-- USERS
-- ============================================================

CREATE TABLE users (

    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,,

    full_name VARCHAR(150) NOT NULL,

    email VARCHAR(255) UNIQUE NOT NULL,

    phone VARCHAR(20),

    designation VARCHAR(120),

    device_token TEXT,

    email_verified BOOLEAN DEFAULT FALSE,

    phone_verified BOOLEAN DEFAULT FALSE,

    last_login TIMESTAMPTZ,

    role_id UUID NOT NULL REFERENCES roles(id),

    department_id UUID REFERENCES departments(id),

    ward_id UUID REFERENCES wards(id),

    profile_image TEXT,

    is_active BOOLEAN DEFAULT TRUE,

    created_at TIMESTAMPTZ DEFAULT NOW(),

    deleted_at TIMESTAMPTZ,

    updated_at TIMESTAMPTZ DEFAULT NOW()

);

-- ============================================================
-- SYSTEM SETTINGS
-- ============================================================

CREATE TABLE system_settings (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    category VARCHAR(100),

    setting_key VARCHAR(100) UNIQUE NOT NULL,

    setting_value TEXT,

    data_type VARCHAR(50),

    editable BOOLEAN DEFAULT TRUE,

    description TEXT,

    updated_by UUID REFERENCES users(id),

    description TEXT,

    updated_at TIMESTAMPTZ DEFAULT NOW()

);

-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_users_role
ON users(role_id);

CREATE INDEX idx_users_department
ON users(department_id);

CREATE INDEX idx_users_ward
ON users(ward_id);

CREATE INDEX idx_categories_department
ON categories(department_id);

CREATE INDEX idx_sla_category
ON sla_rules(category_id);

CREATE INDEX idx_sla_priority
ON sla_rules(priority);

-- ============================================================
-- FOUNDATION COMPLETE
-- ============================================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_users_updated
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_departments_updated
BEFORE UPDATE ON departments
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_categories_updated
BEFORE UPDATE ON categories
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();