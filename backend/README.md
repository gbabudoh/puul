# PUUL Backend API

## Tech Stack
- Node.js + Express
- PostgreSQL
- MinIO (S3-compatible storage)
- JWT Authentication
- Stripe Connect (for payments)

## Setup Instructions

### Prerequisites
- Node.js 18+
- PostgreSQL 14+
- MinIO server

### Installation

```bash
cd backend
npm install
```

### Environment Variables

Create a `.env` file:

```env
# Server
PORT=3000
NODE_ENV=development

# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=puul_db
DB_USER=postgres
DB_PASSWORD=your_password

# JWT
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRES_IN=7d

# MinIO
MINIO_ENDPOINT=localhost
MINIO_PORT=9000
MINIO_ACCESS_KEY=minioadmin
MINIO_SECRET_KEY=minioadmin
MINIO_BUCKET=puul-content

# Stripe
STRIPE_SECRET_KEY=your_stripe_secret_key
STRIPE_WEBHOOK_SECRET=your_webhook_secret
```

### Database Setup

```bash
# Create database
createdb puul_db

# Run migrations
npm run migrate
```

### Run Development Server

```bash
npm run dev
```

## API Endpoints

### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login user
- `GET /api/v1/auth/me` - Get current user
- `POST /api/v1/auth/verify` - Verify phone/email

### Categories
- `GET /api/v1/categories` - List user's categories
- `POST /api/v1/categories` - Create category
- `GET /api/v1/categories/:id` - Get category details
- `PUT /api/v1/categories/:id` - Update category
- `DELETE /api/v1/categories/:id` - Delete category

### Category Members
- `POST /api/v1/categories/:id/members` - Add member
- `DELETE /api/v1/categories/:id/members/:userId` - Remove member
- `GET /api/v1/categories/:id/members` - List members

### Content
- `POST /api/v1/content/upload/request` - Request upload URL
- `POST /api/v1/content/upload/finalize` - Finalize upload
- `GET /api/v1/content/view/:id` - Get view URL
- `GET /api/v1/categories/:id/content` - List category content
- `DELETE /api/v1/content/:id` - Delete content

### Connections
- `GET /api/v1/connections` - List connections
- `POST /api/v1/connections/request` - Send request
- `POST /api/v1/connections/accept/:id` - Accept request
- `DELETE /api/v1/connections/:id` - Remove connection

### Creator/Monetization
- `GET /api/v1/creator/dashboard` - Get dashboard data
- `GET /api/v1/creator/campaigns` - List campaigns
- `POST /api/v1/creator/payout` - Request payout

## Project Structure

```
backend/
├── config/
│   ├── database.js
│   ├── minio.js
│   └── stripe.js
├── controllers/
│   ├── auth.controller.js
│   ├── category.controller.js
│   ├── content.controller.js
│   ├── connection.controller.js
│   └── creator.controller.js
├── middleware/
│   ├── auth.middleware.js
│   ├── validation.middleware.js
│   └── error.middleware.js
├── models/
│   ├── user.model.js
│   ├── category.model.js
│   ├── content.model.js
│   └── campaign.model.js
├── routes/
│   ├── auth.routes.js
│   ├── category.routes.js
│   ├── content.routes.js
│   ├── connection.routes.js
│   └── creator.routes.js
├── services/
│   ├── minio.service.js
│   ├── puul-moments.service.js
│   └── payment.service.js
├── migrations/
│   └── 001_initial_schema.sql
├── .env
├── package.json
└── server.js
```
