# PUUL - Development Documentation

## 1. Application Overview

### The Problem (Pain Points)
- **Context Clutter**: Users see irrelevant photos from acquaintances on a single feed
- **Oversharing Anxiety**: Hesitation to post private moments due to broad audience
- **Organization Paralysis**: Manual sorting and sharing of photos is tedious

### The PUUL Solution
PUUL provides **Contextual, Controlled Sharing** through category-based organization and granular permission control.

#### Core Features
| Feature | Description | User Benefit |
|---------|-------------|--------------|
| Category-Based Sharing | Fundamental unit is the Category ("PUUL"), not the public profile | Complete control over audience for every photo set |
| Contextual Feed | Home screen shows recently active Categories, not global feed | Relevance-first: only see content from current shared experiences |
| PUUL Moments | AI-suggested highlight reels from Category clusters | Effortless storytelling with automated curation |
| Promoted PUUL | Separate public category for 3000+ Connect users to monetize | Clean monetization keeping private life ad-free |

### Tech Stack
- **Frontend**: Flutter
- **Backend**: Node.js/Express (or Python/FastAPI)
- **Database**: PostgreSQL
- **Storage**: MinIO (S3-compatible object storage)
- **State Management**: Riverpod
- **Payment**: Stripe Connect

---

## 2. Onboarding Flow

| Step | Screen | Action | Goal |
|------|--------|--------|------|
| 1 | Welcome | Enter phone/email, create password | Establish identity and security |
| 2 | Value Proposition | "Stop Oversharing. Start PUULing." | Communicate core value |
| 3 | First PUUL | Create first Category (Family/Friends) | Teach primary interaction |
| 4 | Find Connects | Request contacts, send 3+ Connection Requests | Build initial network |
| 5 | Home Screen | Display new Category on Contextual Feed | Successful app entry |

---

## 3. UX/UI Flow

### A. Home Screen (Contextual Feed)
- Vertical stack of large Category Tiles
- Each tile shows: name, last active date, member count, thumbnail
- Floating (+) button for: Upload to Category or Create New Category

### B. New Content Flow
1. Source Selection: In-app camera or gallery
2. **Category Assignment** (Required): Select target Category
3. Metadata: Auto-filled time/location (editable)
4. Upload: Content uploaded to MinIO via secure API

### C. Category Management
- Members List: Add/Remove members (instant access control)
- Visibility Toggle: Discoverable or hidden
- PUUL Moment History: View generated highlights

### D. Creator Dashboard (3000+ Connects)
- Current Balance & Earnings
- Performance Analytics (charts)
- Campaign Management & Audit Log
- Payout Settings

---

## 4. User Stories

| Priority | User Type | Goal | Story |
|----------|-----------|------|-------|
| High | Private User | Share sensitive content with control | "As Sarah, I want to upload baby pictures to Family category and be certain only spouse and parents can see them" |
| Medium | Social User | Collect photos from shared event | "As Tom, I want to create an Ephemeral PUUL after my party to collect everyone's photos without permanent connections" |
| Low | Creator | Monetize while keeping private life separate | "As Alex with 5000 Connects, I want to post sponsored content in Promoted PUUL with automatic 50/50 revenue split tracking" |

---

## 5. Color Palette

| Role | Color | Code | Application |
|------|-------|------|-------------|
| Primary Background | Soft Gray | #F5F5F5 | Main screens, text background |
| Primary Accent | Dark Charcoal | #575656 | Navigation, buttons, important text |
| Secondary Accent | Soft Gold | #FFB300 | Notifications, PUUL Moments, CTAs |
| Monetization Accent | Deep Magenta | #9B4171 | Promoted PUUL section only |

---

## 6. Database Schema (PostgreSQL)

### Core Tables

#### users
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    connect_count INTEGER DEFAULT 0,
    public_profile BOOLEAN DEFAULT FALSE,
    is_creator BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

#### categories
```sql
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    category_tag VARCHAR(50) NOT NULL,
    visibility VARCHAR(20) DEFAULT 'private',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

#### category_members (Permission Control)
```sql
CREATE TABLE category_members (
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (category_id, user_id)
);
```

#### content
```sql
CREATE TABLE content (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    file_url VARCHAR(2048) NOT NULL,
    thumbnail_url VARCHAR(2048) NOT NULL,
    file_type VARCHAR(50) NOT NULL,
    caption VARCHAR(500),
    location JSONB,
    uploaded_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### Monetization Tables

#### advertisers
```sql
CREATE TABLE advertisers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(150) NOT NULL,
    contact_email VARCHAR(100) UNIQUE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

#### ad_campaigns
```sql
CREATE TABLE ad_campaigns (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
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
```

#### campaign_views_log (Revenue Split Tracking)
```sql
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
```

#### puul_moments
```sql
CREATE TABLE puul_moments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    moment_url VARCHAR(2048) NOT NULL,
    content_ids UUID[] NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    generated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

---

## 7. PUUL Moments Algorithm

### Trigger Conditions
- **Primary**: 5+ photos uploaded to same category within 6 hours
- **Secondary**: Manual request from Category Management

### Clustering Logic
1. **Temporal Clustering**: Group content within 8-hour window
2. **Spatial Clustering**: Content within 5-10km radius
3. **Content Selection**:
   - Time Diversity: Photos from start, middle, end
   - Owner Diversity: Different uploaders
   - Content Type Mix: Images + videos

### Process
1. API detects cluster
2. Selects best content (10-15 items)
3. Sends to FFmpeg/video service for compilation
4. Stores result in MinIO
5. Notifies all category members

---

## 8. API Architecture

### Key Endpoints

#### Authentication
- `POST /api/v1/auth/register` - User registration
- `POST /api/v1/auth/login` - User login
- `POST /api/v1/auth/verify` - Phone/email verification

#### Categories
- `GET /api/v1/categories` - List user's categories
- `POST /api/v1/categories` - Create new category
- `GET /api/v1/categories/:id` - Get category details
- `PUT /api/v1/categories/:id` - Update category
- `DELETE /api/v1/categories/:id` - Delete category

#### Category Members
- `POST /api/v1/categories/:id/members` - Add member
- `DELETE /api/v1/categories/:id/members/:userId` - Remove member
- `GET /api/v1/categories/:id/members` - List members

#### Content (MinIO Integration)
- `POST /api/v1/content/upload/request` - Get pre-signed upload URL
- `POST /api/v1/content/upload/finalize` - Finalize upload metadata
- `GET /api/v1/content/view/:id` - Get pre-signed view URL
- `GET /api/v1/categories/:id/content` - List category content

#### Connections
- `GET /api/v1/connections` - List user's connections
- `POST /api/v1/connections/request` - Send connection request
- `POST /api/v1/connections/accept/:id` - Accept request
- `DELETE /api/v1/connections/:id` - Remove connection

#### Monetization
- `GET /api/v1/creator/dashboard` - Creator analytics
- `GET /api/v1/creator/campaigns` - List campaigns
- `POST /api/v1/creator/payout` - Request payout

---

## 9. Security Considerations

### Permission Enforcement
Every content request MUST verify:
```sql
SELECT content.*
FROM content
WHERE content.category_id = $1
AND content.category_id IN (
    SELECT category_id 
    FROM category_members 
    WHERE user_id = $2
);
```

### MinIO Pre-Signed URLs
- Upload URLs: 15-minute expiration
- View URLs: 1-hour expiration
- All URLs validated against PostgreSQL permissions

### Password Security
- bcrypt hashing (cost factor: 12)
- Minimum 8 characters, 1 uppercase, 1 number

---

## 10. Growth Features

### PUUL Migration Kit
Import photos from device/cloud and auto-assign to categories

### PUUL Request
Request photos from non-connected users for specific events (creates viral invitation)

### Ephemeral PUULs
Time-limited categories (48 hours) for events, creating FOMO

---

## Next Steps
1. Set up Flutter project structure
2. Initialize PostgreSQL database
3. Set up MinIO instance
4. Implement authentication flow
5. Build category management
6. Integrate camera and content upload
7. Implement PUUL Moments
8. Build creator dashboard
