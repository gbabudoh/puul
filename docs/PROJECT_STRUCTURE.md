# PUUL Project Structure

## Complete Folder Structure

```
puul/
├── lib/                                    # Flutter Frontend
│   ├── main.dart                          # App entry point
│   │
│   ├── core/                              # Core utilities and config
│   │   ├── constants/
│   │   │   ├── app_constants.dart         # App-wide constants
│   │   │   └── app_colors.dart            # Color palette
│   │   ├── config/
│   │   │   └── app_config.dart            # Environment config
│   │   ├── utils/
│   │   │   ├── validators.dart            # Form validators
│   │   │   ├── date_formatter.dart        # Date utilities
│   │   │   └── permission_handler.dart    # Permission utilities
│   │   └── state/
│   │       └── providers.dart             # Global Riverpod providers
│   │
│   ├── data/                              # Data layer
│   │   ├── models/                        # Data models
│   │   │   ├── user_model.dart
│   │   │   ├── user_model.g.dart          # Generated
│   │   │   ├── category_model.dart
│   │   │   ├── category_model.g.dart
│   │   │   ├── content_model.dart
│   │   │   ├── content_model.g.dart
│   │   │   ├── connection_model.dart
│   │   │   └── campaign_model.dart
│   │   │
│   │   ├── services/                      # API services
│   │   │   ├── api_client.dart            # HTTP client
│   │   │   ├── auth_service.dart
│   │   │   ├── category_service.dart
│   │   │   ├── content_service.dart
│   │   │   └── minio_service.dart
│   │   │
│   │   └── repositories/                  # Data repositories
│   │       ├── auth_repository.dart
│   │       ├── category_repository.dart
│   │       ├── content_repository.dart
│   │       ├── connection_repository.dart
│   │       └── creator_repository.dart
│   │
│   ├── features/                          # Feature modules
│   │   ├── auth/                          # Authentication
│   │   │   ├── screens/
│   │   │   │   ├── login_screen.dart
│   │   │   │   ├── register_screen.dart
│   │   │   │   └── onboarding_screen.dart
│   │   │   ├── view_models/
│   │   │   │   └── auth_view_model.dart
│   │   │   └── widgets/
│   │   │       └── auth_form_field.dart
│   │   │
│   │   ├── categories/                    # Category management
│   │   │   ├── screens/
│   │   │   │   ├── home_screen.dart
│   │   │   │   ├── category_detail_screen.dart
│   │   │   │   ├── create_category_screen.dart
│   │   │   │   └── category_settings_screen.dart
│   │   │   ├── view_models/
│   │   │   │   ├── category_list_notifier.dart
│   │   │   │   └── category_detail_notifier.dart
│   │   │   └── widgets/
│   │   │       ├── category_tile.dart
│   │   │       ├── category_tag_selector.dart
│   │   │       └── member_list_item.dart
│   │   │
│   │   ├── camera/                        # Camera & upload
│   │   │   ├── screens/
│   │   │   │   ├── camera_screen.dart
│   │   │   │   └── upload_screen.dart
│   │   │   ├── view_models/
│   │   │   │   └── upload_notifier.dart
│   │   │   └── widgets/
│   │   │       └── camera_controls.dart
│   │   │
│   │   ├── content/                       # Content viewing
│   │   │   ├── screens/
│   │   │   │   ├── content_feed_screen.dart
│   │   │   │   └── content_detail_screen.dart
│   │   │   ├── view_models/
│   │   │   │   └── content_notifier.dart
│   │   │   └── widgets/
│   │   │       ├── content_grid.dart
│   │   │       └── content_card.dart
│   │   │
│   │   ├── profile/                       # User profile
│   │   │   ├── screens/
│   │   │   │   ├── profile_screen.dart
│   │   │   │   ├── connections_screen.dart
│   │   │   │   └── settings_screen.dart
│   │   │   ├── view_models/
│   │   │   │   └── profile_notifier.dart
│   │   │   └── widgets/
│   │   │       └── connection_tile.dart
│   │   │
│   │   ├── moments/                       # PUUL Moments
│   │   │   ├── screens/
│   │   │   │   └── moments_screen.dart
│   │   │   ├── view_models/
│   │   │   │   └── moments_notifier.dart
│   │   │   └── widgets/
│   │   │       └── moment_player.dart
│   │   │
│   │   └── creator/                       # Creator dashboard
│   │       ├── screens/
│   │       │   ├── creator_dashboard_screen.dart
│   │       │   ├── campaigns_screen.dart
│   │       │   └── payout_screen.dart
│   │       ├── view_models/
│   │       │   └── creator_notifier.dart
│   │       └── widgets/
│   │           ├── earnings_card.dart
│   │           ├── analytics_chart.dart
│   │           └── campaign_tile.dart
│   │
│   └── widgets/                           # Shared widgets
│       ├── custom_button.dart
│       ├── loading_indicator.dart
│       ├── error_widget.dart
│       └── empty_state.dart
│
├── backend/                               # Node.js Backend
│   ├── config/
│   │   ├── database.js                    # PostgreSQL config
│   │   ├── minio.js                       # MinIO config
│   │   └── stripe.js                      # Stripe config
│   │
│   ├── controllers/
│   │   ├── auth.controller.js
│   │   ├── category.controller.js
│   │   ├── content.controller.js
│   │   ├── connection.controller.js
│   │   └── creator.controller.js
│   │
│   ├── middleware/
│   │   ├── auth.middleware.js             # JWT verification
│   │   ├── validation.middleware.js       # Request validation
│   │   ├── permission.middleware.js       # Category permissions
│   │   └── error.middleware.js            # Error handling
│   │
│   ├── models/
│   │   ├── user.model.js
│   │   ├── category.model.js
│   │   ├── content.model.js
│   │   ├── connection.model.js
│   │   └── campaign.model.js
│   │
│   ├── routes/
│   │   ├── auth.routes.js
│   │   ├── category.routes.js
│   │   ├── content.routes.js
│   │   ├── connection.routes.js
│   │   └── creator.routes.js
│   │
│   ├── services/
│   │   ├── minio.service.js               # File storage
│   │   ├── puul-moments.service.js        # AI clustering
│   │   ├── payment.service.js             # Stripe integration
│   │   └── notification.service.js        # Push notifications
│   │
│   ├── migrations/
│   │   └── 001_initial_schema.sql
│   │
│   ├── .env.example
│   ├── package.json
│   └── server.js
│
├── docs/                                  # Documentation
│   ├── DEVELOPMENT_DOCUMENTATION.md       # Complete dev docs
│   ├── PROJECT_STRUCTURE.md               # This file
│   ├── API_DOCUMENTATION.md               # API reference
│   └── DEPLOYMENT.md                      # Deployment guide
│
├── test/                                  # Flutter tests
│   ├── unit/
│   ├── widget/
│   └── integration/
│
├── pubspec.yaml                           # Flutter dependencies
├── README.md                              # Project overview
└── .gitignore
```

## Key Architecture Decisions

### Frontend (Flutter)
- **State Management**: Riverpod for compile-safe, scalable state
- **Architecture**: MVVM + Repository Pattern
- **API Communication**: Dio for HTTP requests
- **Local Storage**: Hive for caching, Secure Storage for tokens
- **Code Generation**: json_serializable for type-safe models

### Backend (Node.js)
- **Framework**: Express.js for simplicity and performance
- **Database**: PostgreSQL for relational integrity
- **Storage**: MinIO for S3-compatible object storage
- **Authentication**: JWT tokens with secure storage
- **Payments**: Stripe Connect for 50/50 revenue split

### Database Design
- **Permission Model**: category_members join table enforces access
- **Monetization**: campaign_views_log tracks every view and split
- **Scalability**: Proper indexing on frequently queried columns
- **Data Integrity**: Foreign keys and constraints ensure consistency

## Development Workflow

### 1. Setup Phase
```bash
# Flutter
flutter pub get
flutter pub run build_runner build

# Backend
cd backend
npm install
npm run migrate
npm run dev
```

### 2. Development Phase
- Frontend: Hot reload for instant UI updates
- Backend: Nodemon for auto-restart on changes
- Database: PostgreSQL with pgAdmin for management

### 3. Testing Phase
```bash
# Flutter
flutter test

# Backend
npm test
```

### 4. Build Phase
```bash
# Flutter
flutter build apk --release
flutter build ios --release

# Backend
npm run build
```

## Next Steps

1. ✅ Project structure created
2. ✅ Database schema defined
3. ✅ Core models implemented
4. ⏳ Implement authentication flow
5. ⏳ Build category management
6. ⏳ Integrate camera and upload
7. ⏳ Implement PUUL Moments
8. ⏳ Build creator dashboard
9. ⏳ Deploy to production

## Required Services

### Development
- PostgreSQL 14+
- MinIO server
- Node.js 18+
- Flutter SDK 3.10+

### Production
- Managed PostgreSQL (AWS RDS, DigitalOcean, etc.)
- MinIO or AWS S3
- Node.js hosting (Heroku, DigitalOcean, AWS)
- Flutter app stores (Google Play, App Store)
