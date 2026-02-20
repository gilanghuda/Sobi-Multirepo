# Quick Start 

> setup cepat 

## ⚡ Prerequisites

```bash
# Verify tools installed
go version          # Go 1.24.0+
flutter --version   # Flutter 3.7.0+
python --version    # Python 3.8+
psql --version      # PostgreSQL 14+
```

## Setup Repository

```bash
# Clone repository
cd ~/coding
git clone https://github.com/gilanghuda/sobi-app.git
cd sobi-app

# Copy environment file
cp .env.example .env

# Edit .env dengan credentials Anda
nano .env  # atau vim/code .env
```

## Database Setup 

```bash
# Start PostgreSQL dengan Docker (jika belum)
docker run --name sobi-postgres \
  -e POSTGRES_DB=sobi-db \
  -e POSTGRES_USER=etmin \
  -e POSTGRES_PASSWORD=etmin \
  -p 5432:5432 \
  -d postgres:14

# Test koneksi
psql -h localhost -U etmin -d sobi-db -c "SELECT 1;"
```

##  Run Backend 

```bash
cd Sobi-MainBackend

# Download dependencies
go mod download && go mod tidy

# Run migrations (jika ada)
go run main.go migrate

# Start server
go run main.go

# Expected output: 
# ✓ Server running at http://localhost:8000
# ✓ API Docs at http://localhost:8000/swagger
```

##  Run RAG Service 

```bash
cd sobi-AiQuran

# Create virtual environment
python -m venv venv
source venv/bin/activate  # atau: venv\Scripts\activate (Windows)

# Install dependencies
pip install -r requirements.txt

# Run service
python main.py

# Expected output:
# ✓ Uvicorn running at http://localhost:8001
# ✓ API Docs at http://localhost:8001/docs
```

## Run Frontend 

```bash
cd Sobi-Frontend

# Get dependencies
flutter pub get

# Run app
flutter run

# Pilih device/platform:
# - Tekan 'd' untuk physical device
# - Tekan 'c' untuk Chrome (web)
# - Tekan 'w' untuk Windows desktop
```

## Verification

Semua services sudah berjalan? Check ini:

```bash
# Backend API
curl http://localhost:8000/

# RAG Service
curl http://localhost:8001/docs

# Frontend
# Open your browser & navigate ke http://localhost:8081
```

## Done!

### Backend Setup

```bash
# 1. Navigate to backend
cd Sobi-MainBackend

# 2. Download dependencies
go mod download
go mod tidy

# 3. Run migrations (jika database sudah ready)
go run main.go

# 4. Verify (di terminal lain)
curl http://localhost:8000/
```

### Frontend Setup

```bash
# 1. Navigate to frontend
cd Sobi-Frontend

# 2. Get Flutter dependencies
flutter pub get

# 3. Run on device/emulator
flutter run
# Pilih device saat diminta
```

### RAG Service Setup

```bash
# 1. Navigate to AI service
cd sobi-AiQuran

# 2. Create virtual environment
python -m venv venv
source venv/bin/activate

# 3. Install Python dependencies
pip install -r requirements.txt

# 4. Run service
python main.py

# 5. Verify (di browser)
# Akses: http://localhost:8001/docs
```

### Database Setup

```bash
# 1. Ensure PostgreSQL running
docker run --name sobi-postgres \
  -e POSTGRES_DB=sobi-db \
  -e POSTGRES_USER=etmin \
  -e POSTGRES_PASSWORD=etmin \
  -p 5432:5432 \
  -d postgres:14

# 2. Verify connection
psql -h localhost -U etmin -d sobi-db -c "SELECT 1;"
```

---

##  Verification Checklist

Pastikan semua services berjalan:

```bash
# Backend
curl http://localhost:8000/           Should return "Hello, World!"

# RAG Service
curl http://localhost:8001/docs       Should show Swagger UI

# Database
psql -h localhost -U etmin -d sobi-db -c "SELECT 1;"  Should return 1

# Flutter
flutter devices                       Should show available devices
```

---

##  Environment Variables Essentials

Nilai minimal yang HARUS diubah di `.env`:

```env
# Database
DB_HOST=your_db_host
DB_USER=your_db_user
DB_PASSWORD=your_db_password

# JWT
JWT_SECRET=your-very-secret-key-min-32-chars

# Gmail SMTP
SMTP_USER=your_gmail@gmail.com
SMTP_PASSWORD=your_gmail_app_password

# Midtrans (Payment)
MIDTRANS_SERVER_KEY=your_server_key
MIDTRANS_CLIENT_KEY=your_client_key

# Google OAuth
OAUTH_CLIENT_ID=your_google_client_id
OAUTH_CLIENT_SECRET=your_google_secret
```

---

##  Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| **Port 8000 already in use** | `lsof -i :8000 \| kill -9 <PID>` |
| **Flutter doctor error** | `flutter doctor --android-licenses` |
| **Python module not found** | `pip install -r requirements.txt` |
| **Database connection failed** | Check PostgreSQL service status |
| **FAISS index not found** | Ensure data files dalam `sobi-AiQuran/data/` |

---

##  Next Steps

1.  Baca [README.md](./README.md) untuk dokumentasi lengkap
2.  Explore `docker-compose.yml` untuk automated setup
3.  Setup IDE dan extensions (VS Code, Android Studio, Xcode)
4.  Configure Git hooks untuk code quality

---

##  Development Commands Cheat Sheet

```bash
# Format code
go fmt ./...
dart format lib/
black sobi-AiQuran/

# Run tests
go test ./...
flutter test
python -m pytest

# Database migrations
migrate -path ./Sobi-MainBackend/migrations -database $DATABASE_URL up

# View logs
docker-compose logs -f backend
docker-compose logs -f rag_service
```

