# PUUL - Contextual Photo Sharing App

**Stop Oversharing. Start PUULing.**

PUUL is a revolutionary photo-sharing app that provides contextual, controlled sharing through category-based organization. Share your party photos only with party friends, family photos only with family—you're in complete control.

## 🌟 Key Features

- **Category-Based Sharing**: Organize photos into contextual categories (Family, Work, Holiday, etc.)
- **Contextual Feed**: See only relevant content from your active categories
- **PUUL Moments**: AI-generated highlight reels from your shared experiences
- **Granular Permissions**: Control exactly who sees what
- **Creator Monetization**: Users with 3000+ connections can monetize through Promoted PUULs
- **Clean Separation**: Private life stays ad-free

## 🛠 Tech Stack

### Frontend
- Flutter 3.10+
- Riverpod (State Management)
- Dio (HTTP Client)
- Camera & Image Picker
- Geolocator

### Backend
- Node.js + Express
- PostgreSQL 14+
- MinIO (S3-compatible storage)
- JWT Authentication
- Stripe Connect

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.10+
- Node.js 18+
- PostgreSQL 14+
- MinIO server

### Flutter Setup

```bash
# Install dependencies
flutter pub get

# Generate code
flutter pub run build_runner build

# Run app
flutter run
```

### Backend Setup

```bash
# Navigate to backend
cd backend

# Install dependencies
npm install

# Setup environment
cp .env.example .env
# Edit .env with your configuration

# Create database
createdb puul_db

# Run migrations
npm run migrate

# Start server
npm run dev
```

### MinIO Setup

```bash
# Using Docker
docker run -p 9000:9000 -p 9001:9001 \
  -e "MINIO_ROOT_USER=minioadmin" \
  -e "MINIO_ROOT_PASSWORD=minioadmin" \
  minio/minio server /data --console-address ":9001"

# Create bucket
# Access MinIO console at http://localhost:9001
# Create bucket named "puul-content"
```

## 📱 App Flow

### Onboarding
1. Enter phone/email and create password
2. Learn about PUUL's unique value proposition
3. Create your first category
4. Connect with initial contacts

### Daily Use
1. View your contextual feed of active categories
2. Tap a category to see its content
3. Upload photos/videos to specific categories
4. Manage category members and permissions
5. Receive PUUL Moments notifications

### Creator Features (3000+ Connects)
1. Access Promoted PUUL section
2. View earnings dashboard
3. Manage brand campaigns
4. Request payouts

## 📚 Documentation

- [Development Documentation](docs/DEVELOPMENT_DOCUMENTATION.md) - Complete technical specs
- [Project Structure](docs/PROJECT_STRUCTURE.md) - Folder organization
- [Backend README](backend/README.md) - API documentation

## 🎨 Design System

### Color Palette
- **Primary Background**: #F5F5F5 (Soft Gray)
- **Primary Accent**: #575656 (Dark Charcoal)
- **Secondary Accent**: #FFB300 (Soft Gold)
- **Monetization Accent**: #9B4171 (Deep Magenta)

### Category Tags
- Family
- Work
- Holiday
- Adventure
- Business
- Events
- Party

## 🔐 Security

- bcrypt password hashing
- JWT token authentication
- Pre-signed URLs for content access
- PostgreSQL permission enforcement
- Secure storage for sensitive data

## 📊 Database Schema

Key tables:
- `users` - User accounts and creator status
- `categories` - Photo categories/PUULs
- `category_members` - Permission control
- `content` - Photo/video metadata
- `connections` - User connections
- `ad_campaigns` - Monetization campaigns
- `campaign_views_log` - Revenue tracking

## 🚧 Development Status

- [x] Project structure
- [x] Database schema
- [x] Core models
- [x] Authentication screens
- [x] Home screen layout
- [ ] Category management
- [ ] Camera integration
- [ ] Content upload
- [ ] PUUL Moments
- [ ] Creator dashboard
- [ ] Payment integration

## 🤝 Contributing

This is a private project. For questions or collaboration inquiries, please contact the project owner.

## 📄 License

Proprietary - All rights reserved

## 🎯 Vision

PUUL aims to solve the fundamental problems of modern photo sharing:
- **Context Clutter**: No more irrelevant photos in your feed
- **Oversharing Anxiety**: Share with confidence knowing your audience
- **Organization Paralysis**: Automatic categorization and AI curation

By focusing on contextual, controlled sharing, PUUL provides a simple yet powerful alternative to traditional social media platforms.

---

**Built with ❤️ for better photo sharing**
