# PUUL Setup Guide

## Prerequisites Installation

### 1. Flutter SDK
```bash
# macOS (using Homebrew)
brew install --cask flutter

# Verify installation
flutter doctor
```

### 2. PostgreSQL
```bash
# macOS
brew install postgresql@14
brew services start postgresql@14

# Create database
createdb puul_db
```

### 3. MinIO
```bash
# Using Docker (Recommended)
docker run -d \
  -p 9000:9000 \
  -p 9001:9001 \
  --name minio \
  -e "MINIO_ROOT_USER=minioadmin" \
  -e "MINIO_ROOT_PASSWORD=minioadmin" \
  minio/minio server /data --console-address ":9001"

# Access MinIO Console: http://localhost:9001
# Login: minioadmin / minioadmin
# Create bucket: puul-content
```

### 4. Node.js
```bash
# macOS
brew install node@18

# Verify
node --version  # Should be 18+
npm --version
```

## Project Setup

### Step 1: Clone and Setup Flutter App

```bash
# Navigate to project root
cd puul

# Install Flutter dependencies
flutter pub get

# Generate model files
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Step 2: Setup Backend

```bash
# Navigate to backend
cd backend

# Install dependencies
npm install

# Create environment file
cp .env.example .env

# Edit .env file with your configuration
nano .env
```

**Required .env Configuration:**
```env
PORT=3000
NODE_ENV=development

DB_HOST=localhost
DB_PORT=5432
DB_NAME=puul_db
DB_USER=postgres
DB_PASSWORD=your_password

JWT_SECRET=your_super_secret_key_change_this_in_production
JWT_EXPIRES_IN=7d

MINIO_ENDPOINT=localhost
MINIO_PORT=9000
MINIO_ACCESS_KEY=minioadmin
MINIO_SECRET_KEY=minioadmin
MINIO_BUCKET=puul-content
MINIO_USE_SSL=false
```

### Step 3: Initialize Database

```bash
# From backend directory
npm run migrate

# Verify tables created
psql -d puul_db -c "\dt"
```

Expected output:
```
                List of relations
 Schema |        Name         | Type  |  Owner   
--------+---------------------+-------+----------
 public | ad_campaigns        | table | postgres
 public | advertisers         | table | postgres
 public | campaign_views_log  | table | postgres
 public | categories          | table | postgres
 public | category_members    | table | postgres
 public | connections         | table | postgres
 public | content             | table | postgres
 public | puul_moments        | table | postgres
 public | users               | table | postgres
```

### Step 4: Start Backend Server

```bash
# From backend directory
npm run dev

# You should see:
# 🚀 PUUL API Server running on port 3000
# 📍 Environment: development
# ✅ Connected to PostgreSQL database
```

### Step 5: Configure Flutter App

Update API endpoint in `lib/core/constants/app_constants.dart`:

```dart
// For iOS Simulator
static const String apiBaseUrl = 'http://localhost:3000/api/v1';

// For Android Emulator
static const String apiBaseUrl = 'http://10.0.2.2:3000/api/v1';

// For Physical Device (use your computer's IP)
static const String apiBaseUrl = 'http://192.168.1.XXX:3000/api/v1';
```

### Step 6: Run Flutter App

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device_id>

# Or just run (will prompt for device)
flutter run
```

## Verification Checklist

- [ ] PostgreSQL running and database created
- [ ] MinIO running and bucket created
- [ ] Backend server running on port 3000
- [ ] Flutter app connects to backend
- [ ] Can access login screen
- [ ] No console errors

## Common Issues

### Issue: Flutter build_runner fails
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Backend can't connect to PostgreSQL
```bash
# Check PostgreSQL is running
brew services list | grep postgresql

# Check connection
psql -d puul_db -c "SELECT 1"
```

### Issue: MinIO bucket not found
1. Access MinIO Console: http://localhost:9001
2. Login with minioadmin/minioadmin
3. Create bucket named "puul-content"
4. Set bucket policy to "public" for development

### Issue: Flutter can't connect to backend
- iOS Simulator: Use `localhost`
- Android Emulator: Use `10.0.2.2`
- Physical Device: Use your computer's local IP
- Check firewall settings

## Development Workflow

### Terminal 1: Backend
```bash
cd backend
npm run dev
```

### Terminal 2: Flutter
```bash
flutter run
```

### Terminal 3: Database (optional)
```bash
psql -d puul_db
```

## Testing the Setup

### 1. Test Backend Health
```bash
curl http://localhost:3000/health
# Expected: {"status":"ok","timestamp":"..."}
```

### 2. Test MinIO
```bash
curl http://localhost:9000/minio/health/live
# Expected: 200 OK
```

### 3. Test Flutter App
1. Launch app
2. Should see login screen
3. UI should match design (gray background, charcoal buttons)

## Next Steps

Once setup is complete:
1. Review [Development Documentation](DEVELOPMENT_DOCUMENTATION.md)
2. Explore [Project Structure](PROJECT_STRUCTURE.md)
3. Start implementing features
4. Run tests: `flutter test`

## Production Deployment

See [DEPLOYMENT.md](DEPLOYMENT.md) for production setup instructions.

## Support

For issues or questions:
1. Check this guide
2. Review error logs
3. Verify all services are running
4. Check environment variables

---

**Setup Time**: ~30 minutes
**Difficulty**: Intermediate
