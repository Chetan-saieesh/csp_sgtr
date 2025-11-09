-- SMART GROCERY TRACKING & REPORTING FOR SCHOOLS - PostgreSQL Database Schema for Supabase
-- Run this SQL in your Supabase SQL Editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- USERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('teacher', 'authority')),
    authority_id UUID REFERENCES users(id) ON DELETE SET NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index on username for faster lookups
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_authority_id ON users(authority_id);

-- ============================================
-- GROCERY USAGE TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS grocery_usage (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    teacher_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    grocery_name VARCHAR(255) NOT NULL,
    quantity DECIMAL(10, 2) NOT NULL CHECK (quantity > 0),
    unit VARCHAR(50) DEFAULT 'kg',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_grocery_usage_teacher_id ON grocery_usage(teacher_id);
CREATE INDEX IF NOT EXISTS idx_grocery_usage_date ON grocery_usage(date);
CREATE INDEX IF NOT EXISTS idx_grocery_usage_teacher_date ON grocery_usage(teacher_id, date);

-- ============================================
-- REPORTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    teacher_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    teacher_name VARCHAR(255) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'submitted' CHECK (status IN ('submitted', 'viewed')),
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT valid_date_range CHECK (to_date >= from_date)
);

-- Create indexes for reports
CREATE INDEX IF NOT EXISTS idx_reports_teacher_id ON reports(teacher_id);
CREATE INDEX IF NOT EXISTS idx_reports_status ON reports(status);
CREATE INDEX IF NOT EXISTS idx_reports_submitted_at ON reports(submitted_at);
CREATE INDEX IF NOT EXISTS idx_reports_date_range ON reports(from_date, to_date);

-- ============================================
-- REPORT ITEMS TABLE (for grocery items in reports)
-- ============================================
CREATE TABLE IF NOT EXISTS report_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    report_id UUID NOT NULL REFERENCES reports(id) ON DELETE CASCADE,
    grocery_name VARCHAR(255) NOT NULL,
    total_quantity DECIMAL(10, 2) NOT NULL CHECK (total_quantity > 0),
    unit VARCHAR(50) DEFAULT 'kg',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index on report_id for faster lookups
CREATE INDEX IF NOT EXISTS idx_report_items_report_id ON report_items(report_id);

-- ============================================
-- FUNCTIONS AND TRIGGERS
-- ============================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to auto-update updated_at on users table
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Trigger to auto-update updated_at on grocery_usage table
CREATE TRIGGER update_grocery_usage_updated_at BEFORE UPDATE ON grocery_usage
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Trigger to auto-update updated_at on reports table
CREATE TRIGGER update_reports_updated_at BEFORE UPDATE ON reports
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE grocery_usage ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE report_items ENABLE ROW LEVEL SECURITY;

-- Users can read their own data
CREATE POLICY "Users can view own profile" ON users
    FOR SELECT USING (auth.uid()::text = id::text);

-- Teachers can view their own grocery usage
CREATE POLICY "Teachers can view own grocery usage" ON grocery_usage
    FOR SELECT USING (
        teacher_id IN (
            SELECT id FROM users WHERE id::text = auth.uid()::text
        )
    );

-- Teachers can insert their own grocery usage
CREATE POLICY "Teachers can insert own grocery usage" ON grocery_usage
    FOR INSERT WITH CHECK (
        teacher_id IN (
            SELECT id FROM users WHERE id::text = auth.uid()::text
        )
    );

-- Authorities can view teachers under their supervision
CREATE POLICY "Authorities can view their teachers" ON users
    FOR SELECT USING (
        authority_id IN (
            SELECT id FROM users WHERE id::text = auth.uid()::text AND role = 'authority'
        )
        OR id::text = auth.uid()::text
    );

-- Authorities can view reports from their teachers
CREATE POLICY "Authorities can view teacher reports" ON reports
    FOR SELECT USING (
        teacher_id IN (
            SELECT id FROM users 
            WHERE authority_id IN (
                SELECT id FROM users WHERE id::text = auth.uid()::text AND role = 'authority'
            )
        )
    );

-- Teachers can view their own reports
CREATE POLICY "Teachers can view own reports" ON reports
    FOR SELECT USING (
        teacher_id IN (
            SELECT id FROM users WHERE id::text = auth.uid()::text
        )
    );

-- Teachers can insert their own reports
CREATE POLICY "Teachers can insert own reports" ON reports
    FOR INSERT WITH CHECK (
        teacher_id IN (
            SELECT id FROM users WHERE id::text = auth.uid()::text
        )
    );

-- Authorities can update report status
CREATE POLICY "Authorities can update report status" ON reports
    FOR UPDATE USING (
        teacher_id IN (
            SELECT id FROM users 
            WHERE authority_id IN (
                SELECT id FROM users WHERE id::text = auth.uid()::text AND role = 'authority'
            )
        )
    );

-- View report items for reports user has access to
CREATE POLICY "Users can view report items for accessible reports" ON report_items
    FOR SELECT USING (
        report_id IN (
            SELECT id FROM reports WHERE 
                teacher_id IN (
                    SELECT id FROM users WHERE id::text = auth.uid()::text
                )
                OR teacher_id IN (
                    SELECT id FROM users 
                    WHERE authority_id IN (
                        SELECT id FROM users WHERE id::text = auth.uid()::text AND role = 'authority'
                    )
                )
        )
    );

-- Teachers can insert report items for their reports
CREATE POLICY "Teachers can insert report items" ON report_items
    FOR INSERT WITH CHECK (
        report_id IN (
            SELECT id FROM reports 
            WHERE teacher_id IN (
                SELECT id FROM users WHERE id::text = auth.uid()::text
            )
        )
    );

-- ============================================
-- SAMPLE DATA (Optional - for testing)
-- ============================================

-- Insert sample authority user
-- Password: password123 (should be hashed in production)
INSERT INTO users (id, username, password, role, name, email) 
VALUES (
    '00000000-0000-0000-0000-000000000001',
    'authority1',
    'password123',
    'authority',
    'Authority User',
    'authority@example.com'
) ON CONFLICT (username) DO NOTHING;

-- Insert sample teacher user
-- Password: password123 (should be hashed in production)
INSERT INTO users (id, username, password, role, authority_id, name, email) 
VALUES (
    '00000000-0000-0000-0000-000000000002',
    'teacher1',
    'password123',
    'teacher',
    '00000000-0000-0000-0000-000000000001',
    'Teacher User',
    'teacher@example.com'
) ON CONFLICT (username) DO NOTHING;

-- ============================================
-- VIEWS (Optional - for easier querying)
-- ============================================

-- View for teacher reports with item counts
CREATE OR REPLACE VIEW teacher_reports_view AS
SELECT 
    r.id,
    r.teacher_id,
    r.teacher_name,
    r.from_date,
    r.to_date,
    r.status,
    r.submitted_at,
    COUNT(ri.id) as item_count,
    SUM(ri.total_quantity) as total_grocery_quantity
FROM reports r
LEFT JOIN report_items ri ON r.id = ri.report_id
GROUP BY r.id, r.teacher_id, r.teacher_name, r.from_date, r.to_date, r.status, r.submitted_at;

-- View for authority dashboard
CREATE OR REPLACE VIEW authority_dashboard_view AS
SELECT 
    u.id as authority_id,
    u.name as authority_name,
    COUNT(DISTINCT t.id) as teacher_count,
    COUNT(DISTINCT r.id) as report_count,
    COUNT(DISTINCT CASE WHEN r.status = 'submitted' THEN r.id END) as pending_reports
FROM users u
LEFT JOIN users t ON t.authority_id = u.id AND t.role = 'teacher'
LEFT JOIN reports r ON r.teacher_id = t.id
WHERE u.role = 'authority'
GROUP BY u.id, u.name;

-- ============================================
-- NOTES
-- ============================================
-- 1. In production, passwords should be hashed using bcrypt or similar
-- 2. Consider using Supabase Auth for authentication instead of custom auth
-- 3. RLS policies may need adjustment based on your authentication setup
-- 4. For production, consider adding more indexes based on query patterns
-- 5. Add foreign key constraints as needed
-- 6. Consider adding soft deletes (deleted_at column) instead of hard deletes

