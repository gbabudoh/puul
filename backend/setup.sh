#!/bin/bash

echo "🚀 PUUL Backend Setup Script"
echo "=============================="

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 18+ first."
    exit 1
fi

echo "✅ Node.js $(node --version) detected"

# Check npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed."
    exit 1
fi

echo "✅ npm $(npm --version) detected"

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
npm install

# Create .env if it doesn't exist
if [ ! -f .env ]; then
    echo ""
    echo "📝 Creating .env file from .env.example..."
    cp .env.example .env
    echo "✅ .env file created. Please update it with your configuration."
else
    echo "✅ .env file already exists"
fi

# Check PostgreSQL
echo ""
if command -v psql &> /dev/null; then
    echo "✅ PostgreSQL detected"
    echo ""
    echo "To set up the database, run:"
    echo "  createdb puul_db"
    echo "  npm run migrate"
else
    echo "⚠️  PostgreSQL not found. You'll need to:"
    echo "  1. Install PostgreSQL 14+"
    echo "  2. Create database: createdb puul_db"
    echo "  3. Run migrations: npm run migrate"
fi

echo ""
echo "=============================="
echo "✅ Backend setup complete!"
echo ""
echo "Next steps:"
echo "  1. Update backend/.env with your configuration"
echo "  2. Set up PostgreSQL database (if not done)"
echo "  3. Run: npm run dev"
echo ""
