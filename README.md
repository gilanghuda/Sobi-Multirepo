# SoBi - Teman Hijrah untuk Remaja

<div align="center">

![SoBi App](./architecture.jpeg)

Teman hijrah yang mendampingi remaja kembali kepada nilai-nilai Al-Qur'an dan Hadits.

Platform pembelajaran Islam yang dirancang khusus sebagai penguat karakter remaja Qurani.

[![Go](https://img.shields.io/badge/Go-1.24.0-00ADD8?style=flat&logo=go)](https://golang.org)
[![Flutter](https://img.shields.io/badge/Flutter-3.7.0-02569B?style=flat&logo=flutter)](https://flutter.dev)
[![Python](https://img.shields.io/badge/Python-3.8+-3776ab?style=flat&logo=python)](https://python.org)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.104+-009688?style=flat&logo=fastapi)](https://fastapi.tiangolo.com)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14+-336791?style=flat&logo=postgresql)](https://www.postgresql.org)
[![Docker](https://img.shields.io/badge/Docker-Supported-2496ED?style=flat&logo=docker)](https://www.docker.com)

</div>

---

## Tentang SoBi

**SoBi** (Sobat Bimbing) hadir sebagai **inovasi atas isu pergaulan bebas** dengan pendekatan Islami berlandaskan Al-Qur'an dan Hadits. Platform ini dirancang khusus sebagai **penguat karakter remaja Qurani**.

### Fitur Unggulan

| Fitur | Deskripsi |
|-------|-----------|
| **Tracker Ibadah** | Visualisasi tracking ibadah harian dengan analitik mendalam |
| **Jurnal Refleksi** | Dokumentasi perjalanan spiritual dan personal growth |
| **AI Counselor** | Teman yang peduli, aktif mengajukan pertanyaan untuk menggali perasaan |
| **Analisis Emosi** | Pengenalan emosi dan hubungan tidak sehat dengan perspektif syariat |
| **Konten Islami** | Podcast, artikel, kisah hijrah, dan ayat Al-Qur'an |
| **Multi-Platform** | iOS, Android, Web, Desktop (Windows/macOS/Linux) |
| **Aman & Terpercaya** | End-to-end encryption, data privacy compliant |


---

## Tim Pengembang

| Nama | Role | Kontribusi |
|------|------|-----------|
| **Aaliyah Shirein** | Product Manager & UX Research | Strategi produk & riset pengguna |
| **Rifa Qonitah** | UX Designer & App Developer | Desain UX & development aplikasi |
| **Chesya Annisa** | UI Designer | Desain interface & visual design |
| **Rafi Ananta Nugraha** | Frontend Developer | Development Flutter frontend |
| **Gilang Fachrul Huda** | Backend Developer | Development Go backend & RAG service |

---

## Daftar Isi

- [Tentang SoBi](#tentang-sobi)
- [Tim Pengembang](#tim-pengembang)
- [Ringkasan Teknis](#ringkasan-teknis)
- [Arsitektur Sistem](#arsitektur-sistem)
- [Struktur Proyek](#struktur-proyek)
- [Persyaratan Sistem](#persyaratan-sistem)
- [Panduan Setup Cepat](#panduan-setup-cepat)
- [Panduan Instalasi Lengkap](#panduan-instalasi-lengkap)
- [Konfigurasi Lingkungan](#konfigurasi-lingkungan)
- [Menjalankan Proyek](#menjalankan-proyek)
- [Database Migration](#database-migration)
- [Development Tools](#development-tools)
- [Docker Deployment](#docker-deployment)
- [Security Best Practices](#security-best-practices)
- [Troubleshooting](#troubleshooting)
- [Resources & Support](#resources--support)

---

## Ringkasan Teknis

**SoBi** adalah aplikasi pembelajaran Islam multi-platform yang mengintegrasikan teknologi terkini:

| Komponen | Teknologi | Deskripsi |
|----------|-----------|----------|
| **Backend** | Go + Fiber | REST API dengan WebSocket support |
| **Frontend** | Flutter | iOS, Android, Web, Windows, macOS, Linux |
| **AI/RAG** | Python + FastAPI | Retrieval Augmented Generation untuk Q&A Al-Qur'an |
| **Database** | PostgreSQL | Data persistence dan management |
| **Payment** | Midtrans | Gateway pembayaran terintegrasi |
| **Email** | SMTP Gmail | Notifikasi dan verifikasi email |
| **Authentication** | OAuth 2.0 & JWT | Google Sign-In & token-based authentication |
| **Real-time** | WebSocket | Live chat dan notifications |
| **Caching** | Redis (Optional) | Performance optimization |
| **Containerization** | Docker & Docker Compose | Deployment dan orchestration |

---

## Arsitektur Sistem

```
┌────────────────────────────────────────────────────────────────┐
│                       Multi-Platform Client                    │
├────────────────┬─────────────────────┬──────────────────────────┤
│  Flutter iOS   │   Flutter Android   │  Flutter Web/Desktop     │
└────────┬───────┴───────────┬─────────┴──────────┬───────────────┘
         │                   │                    │
         └───────────────────┼────────────────────┘
                             │ HTTPS/WebSocket
                    ┌────────▼──────────┐
                    │   Backend API     │
                    │   (Go + Fiber)    │
                    │   Port 8000       │
                    └────────┬──────────┘
                             │
         ┌───────────────────┼───────────────────┐
         │                   │                   │
    ┌────▼────────┐  ┌──────▼──────┐  ┌────────▼────────┐
    │ PostgreSQL  │  │   AI/RAG    │  │ External APIs   │
    │   Database  │  │   (Python)  │  │ (Gemini, OAuth) │
    │  Port 5432  │  │  Port 8001  │  │                 │
    └────┬─────────┘  └──────┬──────┘  └────────┬────────┘
         │                   │                   │
    ┌────▼──────────────────┴───────────────────▼──────┐
    │  SMTP  │  Midtrans  │  JWT Auth  │  Cache       │
    └───────────────────────────────────────────────────┘
```

---

## Struktur Proyek

```
sobi-app/
├── Sobi-MainBackend/        # Go Backend Service
│   ├── main.go             # Entry point
│   ├── go.mod              # Module definition
│   ├── Dockerfile          # Container config
│   ├── docker-compose.yml  # Service orchestration
│   ├── app/
│   │   ├── controllers/    # Request handlers
│   │   ├── models/         # Data structures
│   │   └── queries/        # Database queries
│   ├── pkg/                # Shared packages
│   └── migrations/         # Database migrations
│
├── Sobi-Frontend/          # Flutter Mobile & Web
│   ├── pubspec.yaml        # Dependencies
│   ├── lib/
│   │   ├── main.dart       # App entry
│   │   ├── splash_screen.dart
│   │   ├── core/           # Core utilities
│   │   ├── di/             # Dependency injection
│   │   └── features/       # Feature modules
│   ├── android/            # Android native code
│   ├── ios/                # iOS native code
│   └── web/                # Web build
│
├── sobi-AiQuran/           # Python RAG Service
│   ├── main.py             # FastAPI app
│   ├── api.py              # API endpoints
│   ├── rag_quran.py        # RAG logic
│   ├── requirements.txt     # Dependencies
│   ├── Dockerfile          # Container config
│   └── data/               # Quran data & embeddings
│
├── .env.example            # Environment template
├── QUICK_START.md          # Setup cepat 5 menit
├── DEVELOPMENT_SETUP.md    # Setup lengkap untuk development
├── ENVIRONMENT_SETUP.md    # Konfigurasi environment
├── DOCUMENTATION_INDEX.md  # Index dokumentasi
└── README.md              # File ini
```

---

## Persyaratan Sistem

### Minimal Requirements

| Tool | Versi | Kebutuhan |
|------|-------|----------|
| **Go** | 1.24.0+ | Backend |
| **Flutter** | 3.7.0+ | Frontend |
| **Python** | 3.8+ | AI/RAG Service |
| **PostgreSQL** | 14+ | Database |
| **Node.js** | 16+ | Build tools (optional) |
| **Docker** | 20.10+ | Container deployment |
| **Git** | 2.30+ | Version control |

### Hardware Requirements

```
Development Machine:
- CPU: Multi-core processor (4+ cores recommended)
- RAM: 8GB minimum (16GB recommended)
- Storage: 20GB+ SSD
- Internet: Stabil untuk API calls & package downloads
```

### Tools Recommended

```
IDE/Editors:
- VS Code (Backend, Frontend setup)
- Android Studio (Android development)
- Xcode (iOS development - macOS only)
- PyCharm Community (Python development)

CLI Tools:
- curl/Postman (API testing)
- psql (Database management)
- Docker Desktop (Container management)
```

---

## Setup Sobi-App

### Instalasi Go & Dependencies

```bash
# Navigate to backend directory
cd sobi-app/Sobi-MainBackend

# Initialize Go modules (jika belum ada go.mod)
go mod init github.com/gilanghuda/sobi-backend

# Download dependencies
go mod download

# Install/update dependencies
go get -u ./...

# Verify installation
go mod tidy

# Build binary
go build -o sobi-backend main.go

# Test run
./sobi-backend
```

### Setup Database

```bash
# 1. Create PostgreSQL database
createdb sobi-db -U etmin -h localhost

# 2. Verify database created
psql -h localhost -U etmin -d sobi-db -c "SELECT 1;"

# 3. Run migrations
go run main.go migrate

# atau dengan migrate CLI:
migrate -path ./migrations -database "postgresql://etmin:etmin@localhost:5432/sobi-db?sslmode=disable" up
```

### Struktur Database

Migrations otomatis akan membuat:
- `users` - User accounts & profiles
- `refresh_tokens` - JWT refresh tokens
- `sobi_goals` - Learning goals
- `rooms` - Chat rooms
- `educations` - Course materials
- `history_educations` - User progress
- `transactions` - Payment records
- `ahli` (experts) - Expert profiles

---

## Frontend (Flutter)

### Instalasi Flutter SDK

```bash
# Check Flutter installation
flutter doctor -v

# Update Flutter to latest
flutter upgrade

# Verify all setup requirements
flutter doctor
# Should show no errors (all green checkmarks)

# Verify device/emulator
flutter devices
```

### Setup Flutter Project

```bash
# Navigate to frontend directory
cd sobi-app/Sobi-Frontend

# Get dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Analyze code
flutter analyze

# Generate build files
flutter pub run build_runner build --delete-conflicting-outputs

# Generate app icons
flutter pub run flutter_launcher_icons

# Generate splash screens
flutter pub run flutter_native_splash:create
```

### Struktur Flutter

```
lib/
├── main.dart                 # App entry point
├── splash_screen.dart        # Splash screen
├── core/
│   ├── api/                  # API clients
│   ├── models/               # Data models
│   ├── services/             # Business logic
│   ├── constants/            # Constants
│   └── utils/                # Helper functions
├── di/                       # Dependency injection (GetIt)
├── features/
│   ├── auth/                 # Authentication feature
│   │   ├── presentation/
│   │   ├── domain/
│   │   └── data/
│   ├── home/                 # Home feature
│   ├── goals/                # Goals management
│   ├── tracker/              # Ibadah tracker
│   ├── journal/              # Jurnal refleksi
│   ├── chat/                 # Chat feature
│   ├── education/            # Education content
│   ├── profil/               # User profile
│   └── ...
└── widgets/                  # Reusable widgets
```

### Build untuk berbagai Platform

```bash
# iOS Build
cd ios && pod install && cd ..
flutter build ios

# Android Build
flutter build apk --release
flutter build appbundle --release

# Web Build
flutter build web --release

# Desktop (Windows/macOS/Linux)
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

---

## 🤖 AI/RAG Service (Python)

### Setup Python Environment

```bash
# Navigate to AI service directory
cd sobi-app/sobi-AiQuran

# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Linux/macOS:
source venv/bin/activate
# On Windows:
venv\Scripts\activate

# Upgrade pip
pip install --upgrade pip setuptools wheel

# Install dependencies
pip install -r requirements.txt

# Verify installation
pip list
```

### Dataset & Embeddings

```bash
# Data files yang diperlukan di ./data/:
- quran_kemenag_id.jsonl        # Quran dengan terjemahan Kemenag
- quran_terjemahan_indonesia.json  # Alternative Quran translation
- id.indonesian.txt             # Indonesian stopwords

# Pre-computed embeddings:
- emb_quran.npy                # FAISS embeddings matrix
- faiss_quran.index            # FAISS index untuk search
- meta_quran.json              # Metadata untuk retrieval
```

### Run RAG Service

```bash
# Navigate to service directory
cd sobi-AiQuran

# Start FastAPI server
python main.py

# atau dengan uvicorn (lebih recommended):
uvicorn api:app --reload --host 0.0.0.0 --port 8001

# Akses API documentation
# Swagger: http://localhost:8001/docs
# ReDoc: http://localhost:8001/redoc

# Test health endpoint
curl http://localhost:8001/health
```

### API Endpoints

```bash
# Search Quran dengan hybrid search
POST /search
Content-Type: application/json

{
  "query": "tentang kesabaran",
  "top_k": 5,
  "threshold": 0.3
}

# Q&A dengan Gemini
POST /qa
Content-Type: application/json

{
  "question": "Apa yang dikatakan Al-Qur'an tentang kesabaran?",
  "context_count": 5
}

# Get Surah Info
GET /surah/{surah_id}

# Get Ayah Detail
GET /ayah/{surah_id}/{ayah_number}

# Health Check
GET /health
```

---

## 🔑 Konfigurasi Lingkungan

### Setup .env File

Copy `.env.example` ke `.env` dan sesuaikan:

```bash
# Root directory
cp .env.example .env
```

### Backend Environment Variables

```env
# ═══════════════════════════════════════════════════════════
# DATABASE CONFIGURATION
# ═══════════════════════════════════════════════════════════
DB_HOST=148.230.101.108
DB_PORT=5432
DB_USER=etmin
DB_PASSWORD=etmin
DB_NAME=sobi-db
DB_SSLMODE=disable
DB_MAX_CONNECTIONS=25

# ═══════════════════════════════════════════════════════════
# SERVER CONFIGURATION
# ═══════════════════════════════════════════════════════════
SERVER_HOST=0.0.0.0
SERVER_PORT=8000
SERVER_ENV=development

# ═══════════════════════════════════════════════════════════
# JWT CONFIGURATION
# ═══════════════════════════════════════════════════════════
JWT_SECRET=your-super-secret-jwt-key-min-32-chars
JWT_ALGORITHM=HS256
ACCESS_TOKEN_MINUTES=1440
REFRESH_TOKEN_HOURS=720

# ═══════════════════════════════════════════════════════════
# SMTP/EMAIL CONFIGURATION
# ═══════════════════════════════════════════════════════════
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=YOUR_EMAIL@gmail.com
SMTP_PASSWORD=YOUR_GMAIL_APP_PASSWORD
SMTP_FROM=YOUR_EMAIL@gmail.com
SMTP_TIMEOUT=10

# ═══════════════════════════════════════════════════════════
# PAYMENT GATEWAY (Midtrans)
# ═══════════════════════════════════════════════════════════
MIDTRANS_ENVIRONMENT=sandbox
MIDTRANS_SERVER_KEY=YOUR_MIDTRANS_SERVER_KEY
MIDTRANS_CLIENT_KEY=YOUR_MIDTRANS_CLIENT_KEY

# ═══════════════════════════════════════════════════════════
# EXTERNAL APIs
# ═══════════════════════════════════════════════════════════
# Google Gemini API
GEMINI_API_KEY=YOUR_GEMINI_API_KEY
GEMINI_API_URL=https://generativelanguage.googleapis.com/v1beta/models

# Google OAuth2
OAUTH_CLIENT_ID=YOUR_GOOGLE_CLIENT_ID
OAUTH_CLIENT_SECRET=YOUR_GOOGLE_CLIENT_SECRET
OAUTH_REDIRECT_URI=http://localhost:3001/auth/google/callback

# RAG Service
RAG_SERVICE_URL=http://localhost:8001
RAG_SERVICE_TIMEOUT=30

# ═══════════════════════════════════════════════════════════
# CORS CONFIGURATION
# ═══════════════════════════════════════════════════════════
ALLOWED_ORIGINS=http://localhost:3001,http://localhost:3002,http://localhost:3003,https://sobi.gilanghuda.my.id

# ═══════════════════════════════════════════════════════════
# LOGGING
# ═══════════════════════════════════════════════════════════
LOG_LEVEL=info
LOG_FORMAT=json

# ═══════════════════════════════════════════════════════════
# CACHE/REDIS (Optional)
# ═══════════════════════════════════════════════════════════
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=
REDIS_DB=0
REDIS_CACHE_TTL=3600

# ═══════════════════════════════════════════════════════════
# FILE UPLOAD
# ═══════════════════════════════════════════════════════════
MAX_UPLOAD_SIZE=50MB
UPLOAD_DIR=./uploads
ALLOWED_EXTENSIONS=pdf,doc,docx,jpg,jpeg,png

# ═══════════════════════════════════════════════════════════
# WEBHOOK
# ═══════════════════════════════════════════════════════════
WEBHOOK_SECRET=your-webhook-secret-key
MIDTRANS_WEBHOOK_URL=https://sobi.gilanghuda.my.id/webhook/midtrans
```

### Frontend Environment Variables (.env dalam Flutter)

```env
# ═══════════════════════════════════════════════════════════
# API CONFIGURATION
# ═══════════════════════════════════════════════════════════
API_BASE_URL=http://localhost:8000
API_TIMEOUT=30

# ═══════════════════════════════════════════════════════════
# AUTH CONFIGURATION
# ═══════════════════════════════════════════════════════════
GOOGLE_CLIENT_ID=YOUR_GOOGLE_CLIENT_ID

# ═══════════════════════════════════════════════════════════
# APP CONFIGURATION
# ═══════════════════════════════════════════════════════════
APP_NAME=SoBi
APP_VERSION=1.0.0
APP_ENV=development

# ═══════════════════════════════════════════════════════════
# FEATURE FLAGS
# ═══════════════════════════════════════════════════════════
ENABLE_OFFLINE_MODE=true
ENABLE_ANALYTICS=false
ENABLE_CRASH_REPORTING=false

# ═══════════════════════════════════════════════════════════
# DEEPLINK/NOTIFICATION
# ═══════════════════════════════════════════════════════════
DEEP_LINK_SCHEMA=sobi://
FCM_PROJECT_ID=your-firebase-project-id
```

### Python RAG Service Environment Variables

```env
# ═══════════════════════════════════════════════════════════
# SERVER CONFIGURATION
# ═══════════════════════════════════════════════════════════
FASTAPI_ENV=development
SERVER_HOST=0.0.0.0
SERVER_PORT=8001
DEBUG=true

# ═══════════════════════════════════════════════════════════
# RAG MODEL CONFIGURATION
# ═══════════════════════════════════════════════════════════
EMBEDDINGS_MODEL=all-MiniLM-L6-v2
BM25_WEIGHT=0.5
SEMANTIC_WEIGHT=0.5
TOP_K_RESULTS=5

# ═══════════════════════════════════════════════════════════
# DATA PATHS
# ═══════════════════════════════════════════════════════════
QURAN_DATA_PATH=./data/quran_kemenag_id.jsonl
EMBEDDINGS_PATH=./data/emb_quran.npy
FAISS_INDEX_PATH=./data/faiss_quran.index
META_DATA_PATH=./data/meta_quran.json

# ═══════════════════════════════════════════════════════════
# GEMINI API (untuk augmented generation)
# ═══════════════════════════════════════════════════════════
GEMINI_API_KEY=YOUR_GEMINI_API_KEY
GEMINI_MODEL=gemini-2.0-flash

# ═══════════════════════════════════════════════════════════
# CORS CONFIGURATION
# ═══════════════════════════════════════════════════════════
CORS_ORIGINS=http://localhost:8000,http://localhost:3001,http://localhost:8081

# ═══════════════════════════════════════════════════════════
# LOGGING
# ═══════════════════════════════════════════════════════════
LOG_LEVEL=INFO
LOG_FILE=./logs/rag_service.log
```

---

## Menjalankan Proyek

### Setup All Services (Development Mode)

```bash
# Terminal 1 - Start PostgreSQL
docker run --name sobi-postgres \
  -e POSTGRES_DB=sobi-db \
  -e POSTGRES_USER=etmin \
  -e POSTGRES_PASSWORD=etmin \
  -p 5432:5432 \
  -d postgres:14

# Terminal 2 - Start Backend (Go)
cd sobi-app/Sobi-MainBackend
go run main.go
# Backend running at: http://localhost:8000

# Terminal 3 - Start RAG Service (Python)
cd sobi-app/sobi-AiQuran
source venv/bin/activate
python main.py
# RAG Service at: http://localhost:8001

# Terminal 4 - Start Frontend (Flutter)
cd sobi-app/Sobi-Frontend
flutter run
# Choose device/platform:
# - 'd' for device
# - 'c' for chrome web
# - 'w' for windows
```

### Using Docker Compose

```bash
# Navigate to root
cd sobi-app

# Build all services
docker-compose build

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Verify services
curl http://localhost:8000/          # Backend
curl http://localhost:8001/docs      # RAG Service
# Frontend: http://localhost:3001
```

### Individual Service Testing

```bash
# Test Backend API
curl -X GET http://localhost:8000/

# Test RAG Service
curl -X POST http://localhost:8001/search \
  -H "Content-Type: application/json" \
  -d '{"query":"kesabaran"}'

# Test Database Connection
psql -h localhost -U etmin -d sobi-db -c "SELECT 1;"
```

---

## Database Migration

### Using Go Migrate CLI

```bash
# Install migrate tool
go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest

# Create new migration
migrate create -ext sql -dir migrations -seq create_users_table

# Run migrations up
migrate -path migrations -database "postgresql://etmin:etmin@localhost:5432/sobi-db?sslmode=disable" up

# Run migrations down
migrate -path migrations -database "postgresql://etmin:etmin@localhost:5432/sobi-db?sslmode=disable" down

# Check migration status
migrate -path migrations -database "postgresql://etmin:etmin@localhost:5432/sobi-db?sslmode=disable" version
```

### Manual Migration (SQL)

```bash
# Connect to database
psql -h localhost -U etmin -d sobi-db

# Inside psql:
\dt                        # List tables
\d table_name              # Describe table
SELECT version();          # Check PostgreSQL version
```

---

## Development Tools

### API Testing

```bash
# Using cURL
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password"}'

# Using Postman/Insomnia
# Import dari: [backend-url]/docs (Swagger)

# WebSocket Testing
wscat -c ws://localhost:8000/ws/chat/room-123
```

### Code Formatting & Linting

```bash
# Go
go fmt ./...
go vet ./...
golangci-lint run

# Flutter
dart format lib/
dart fix --apply

# Python
black sobi-AiQuran/
flake8 sobi-AiQuran/
pylint sobi-AiQuran/
```

### Database Tools

```bash
# Using pgAdmin (Web UI)
docker run -p 5050:80 \
  -e PGADMIN_DEFAULT_EMAIL=admin@example.com \
  -e PGADMIN_DEFAULT_PASSWORD=admin \
  -d dpage/pgadmin4

# Akses: http://localhost:5050

# Using DBeaver (Desktop)
# Download dari: https://dbeaver.io
```

---

## 🐳 Docker Deployment

### Build Docker Images

```bash
# Backend
cd Sobi-MainBackend
docker build -t sobi-backend:latest .

# RAG Service
cd sobi-AiQuran
docker build -t sobi-rag:latest .

# Frontend (Web)
cd Sobi-Frontend
docker build -t sobi-frontend:latest .
```

### Docker Compose Setup

```yaml
# docker-compose.yml (di root)
version: '3.8'

services:
  postgres:
    image: postgres:14
    environment:
      POSTGRES_DB: sobi-db
      POSTGRES_USER: etmin
      POSTGRES_PASSWORD: etmin
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  backend:
    build: ./Sobi-MainBackend
    ports:
      - "8000:8000"
    depends_on:
      - postgres
    environment:
      DB_HOST: postgres
      DB_PORT: 5432

  rag_service:
    build: ./sobi-AiQuran
    ports:
      - "8001:8001"
    depends_on:
      - backend

  frontend:
    build: ./Sobi-Frontend
    ports:
      - "3001:3001"
    depends_on:
      - backend

volumes:
  postgres_data:
```

```bash
# Deploy
docker-compose -f docker-compose.yml up -d
```

---

## Security Best Practices

### Environment Variables
- ✅ Gunakan `.env.example` untuk template
- ✅ JANGAN commit `.env` ke repository
- ✅ Jaga JWT_SECRET tetap rahasia
- ✅ Rotate API keys secara berkala

### Database Security
- ✅ Gunakan strong passwords
- ✅ SSL/TLS untuk koneksi database
- ✅ Limited user permissions
- ✅ Regular backups

### API Security
- ✅ CORS properly configured
- ✅ Input validation
- ✅ SQL injection prevention
- ✅ Rate limiting

### Flutter Security
- ✅ Store sensitive data in secure storage
- ✅ Certificate pinning for HTTPS
- ✅ Obfuscate code untuk release build

---

## Useful Commands Reference

### Go Commands
```bash
go mod tidy              # Clean up dependencies
go test ./...            # Run tests
go build -o sobi-backend  # Build binary
```

### Flutter Commands
```bash
flutter doctor           # Check environment
flutter clean            # Clean build
flutter build apk        # Build Android APK
flutter build ios        # Build iOS
```

### Python Commands
```bash
pip freeze > requirements.txt  # Generate requirements
python -m pytest               # Run tests
black . --check                # Check formatting
```

### PostgreSQL Commands
```bash
psql -h localhost -U etmin -d sobi-db
CREATE DATABASE sobi-db;
DROP DATABASE sobi-db;
\dt                      # List tables
```

---

## 🐛 Troubleshooting

### Backend Issues

```bash
# Connection refused (Database)
# Solution: Ensure PostgreSQL is running
docker-compose up postgres

# Port 8000 already in use
# Solution: Kill process on port
lsof -i :8000 && kill -9 <PID>

# Go modules error
# Solution: Clear cache
go clean -modcache
```

### Frontend Issues

```bash
# Build errors
flutter clean
flutter pub get

# Device not found
flutter devices

# Hot reload not working
# Solution: Stop and restart flutter run
```

### RAG Service Issues

```bash
# FAISS index not found
# Solution: Ensure data files exist in ./data/

# Memory error
# Solution: Increase Python process memory limit
```

---

## Additional Resources

- [Go Documentation](https://golang.org/doc)
- [Flutter Documentation](https://flutter.dev/docs)
- [FastAPI Documentation](https://fastapi.tiangolo.com)
- [PostgreSQL Documentation](https://www.postgresql.org/docs)
- [Fiber Framework](https://docs.gofiber.io)

---

<div align="center">

**Dibuat untuk pembelajaran Islam yang lebih baik**

Last Updated: February 2026

</div>
