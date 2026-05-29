# PUUL Backend - Quick Start Guide

## ✅ Setup Complete!

Your backend is now set up with:
- ✅ Dependencies installed
- ✅ Environment file created (.env)
- ✅ Basic routes configured
- ✅ Authentication middleware ready

## 🚀 Running the Server

### Development Mode (with auto-reload)
```bash
npm run dev
```

### Production Mode
```bash
npm start
```

The server will run on `http://localhost:3000`

## 📊 Database Setup (Required)

You need PostgreSQL to run the full application. Here's how to set it up:

### Install PostgreSQL (macOS)
```bash
brew install postgresql@14
brew services start postgresql@14
```

### Create Database
```bash
createdb puul_db
```

### Run Migrations
```bash
npm run migrate
```

## 🔧 Configuration

Edit `backend/.env` to configure:
- Database credentials
- JWT secret (change this!)
- MinIO settings (for file storage)
- Stripe keys (for payments)

## 🧪 Testing the API

### Health Check
```bash
curl http://localhost:3000/health
```

### Register a User
```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

### Login
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

## 📁 Project Structure

```
backend/
├── config/          # Database and service configs
├── routes/          # API route handlers
├── middleware/      # Auth and validation
├── controllers/     # Business logic (to be added)
├── services/        # External services (to be added)
├── models/          # Data models (to be added)
├── migrations/      # Database migrations
└── server.js        # Main entry point
```

## 🔐 Authentication

All protected routes require a JWT token in the Authorization header:
```
Authorization: Bearer <your-token>
```

## 📝 Next Steps

1. Set up PostgreSQL and run migrations
2. Configure MinIO for file storage (optional for now)
3. Add Stripe keys for payment features (optional for now)
4. Start building your Flutter app!

## 🐛 Troubleshooting

### Port already in use
Change the PORT in `.env` file

### Database connection errors
- Check PostgreSQL is running: `brew services list`
- Verify credentials in `.env`
- Ensure database exists: `psql -l`

### Module not found errors
Run `npm install` again
