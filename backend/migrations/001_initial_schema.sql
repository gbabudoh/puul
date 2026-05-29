-- PUUL Database Schema

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users Table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    phone_number VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    connect_count INTEGER DEFAULT 0,
    public_profile BOOLEAN DEFAULT FALSE,
    is_creator BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT phone_or_email_required CHECK (
        phone_number IS NOT NULL OR email IS NOT NULL
    )
);

-- Categories Table
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    category_tag VARCHAR(50) NOT NULL,
    visibility VARCHAR(20) DEFAULT 'private',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Category Members Table (Permission Control)
CREATE TABLE category_members (
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (category_id, user_id)
);

-- Content Table
CREATE TABLE content (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    file_url VARCHAR(2048) NOT NULL,
    thumbnail_url VARCHAR(2048) NOT NULL,
    file_type VARCHAR(50) NOT NULL,
    caption VARCHAR(500),
    location JSONB,
    uploaded_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Connections Table
CREATE TABLE connections (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    requester_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    receiver_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    accepted_at TIMESTAMPTZ,
    UNIQUE(requester_id, receiver_id)
);

-- Advertisers Table
CREATE TABLE advertisers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(150) NOT NULL,
    contact_email VARCHAR(100) UNIQUE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Ad Campaigns Table
CREATE TABLE ad_campaigns (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    advertiser_id UUID NOT NULL REFERENCES advertisers(id),
    creator_id UUID NOT NULL REFERENCES users(id),
    campaign_name VARCHAR(200) NOT NULL,
    content_url VARCHAR(2048) NOT NULL,
    cost_per_view NUMERIC(10, 4) NOT NULL,
    total_budget NUMERIC(12, 2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    start_date TIMESTAMPTZ NOT NULL,
    end_date TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Campaign Views Log (Revenue Split Tracking)
CREATE TABLE campaign_views_log (
    id BIGSERIAL PRIMARY KEY,
    campaign_id UUID NOT NULL REFERENCES ad_campaigns(id),
    creator_id UUID NOT NULL REFERENCES users(id),
    viewer_id UUID NOT NULL REFERENCES users(id),
    view_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    revenue_amount NUMERIC(10, 4) NOT NULL,
    creator_share NUMERIC(10, 4) NOT NULL,
    puul_share NUMERIC(10, 4) NOT NULL
);

-- PUUL Moments Table
CREATE TABLE puul_moments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    moment_url VARCHAR(2048) NOT NULL,
    content_ids UUID[] NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    generated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes for Performance
CREATE INDEX idx_categories_owner ON categories(owner_id);
CREATE INDEX idx_category_members_user ON category_members(user_id);
CREATE INDEX idx_category_members_category ON category_members(category_id);
CREATE INDEX idx_content_category ON content(category_id);
CREATE INDEX idx_content_owner ON content(owner_id);
CREATE INDEX idx_content_uploaded ON content(uploaded_at DESC);
CREATE INDEX idx_connections_requester ON connections(requester_id);
CREATE INDEX idx_connections_receiver ON connections(receiver_id);
CREATE INDEX idx_connections_status ON connections(status);
CREATE INDEX idx_campaign_views_creator ON campaign_views_log(creator_id);
CREATE INDEX idx_campaign_views_campaign ON campaign_views_log(campaign_id);

-- Triggers for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON categories
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
