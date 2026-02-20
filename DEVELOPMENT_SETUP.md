# 🛠️ Development Setup Guide - SoBi

**Panduan lengkap setup development environment untuk SoBi multi-platform**

---

## 📋 Daftar Isi

- [Prerequisites](#prerequisites)
- [Backend Setup](#backend-setup-go--fiber)
- [Frontend Setup](#frontend-setup-flutter)
- [RAG Service Setup](#rag-service-setup-python)
- [Database Setup](#database-setup)
- [Running All Services](#running-all-services)
- [IDE Configuration](#ide-configuration)
- [Common Issues](#common-issues)
- [Development Workflow](#development-workflow)

---

## ✅ Prerequisites

### System Requirements

```
OS: macOS, Linux, atau Windows (dengan WSL2)
RAM: 8GB minimum (16GB recommended)
Storage: 20GB SSD available
Internet: Stabil untuk download packages
```

### Required Tools

| Tool | Version | Installation |
|------|---------|--------------|
| **Go** | 1.24.0+ | https://golang.org/dl |
| **Flutter** | 3.7.0+ | https://flutter.dev/docs/get-started/install |
| **Python** | 3.8+ | https://www.python.org/downloads |
| **PostgreSQL** | 14+ | https://www.postgresql.org/download |
| **Git** | 2.30+ | https://git-scm.com/downloads |
| **Docker** | 20.10+ | https://www.docker.com/products/docker-desktop |
| **Node.js** | 16+ | https://nodejs.org/en/download |

### Verify Installation

```bash
# Go
go version
# Output: go version go1.24.7

# Flutter
flutter --version
# Output: Flutter 3.7.0

# Python
python --version
# Output: Python 3.8.0 or higher

# PostgreSQL
psql --version
# Output: psql (PostgreSQL) 14.x

# Docker
docker --version
# Output: Docker version 20.10.x

# Git
git --version
# Output: git version 2.30.x or higher
```

---

## 🔧 Backend Setup (Go + Fiber)

### 1. Navigate to Backend Directory

```bash
cd ~/coding/sobi-app/Sobi-MainBackend
```

### 2. Initialize Go Module (if not exists)

```bash
# Check if go.mod exists
ls go.mod

# If not, initialize
go mod init github.com/gilanghuda/sobi-backend
```

### 3. Download Dependencies

```bash
# Download all dependencies
go mod download

# Clean and verify
go mod tidy

# Check for outdated packages
go list -u -m all
```

### 4. Project Structure

```
Sobi-MainBackend/
├── main.go                    # Entry point
├── go.mod                     # Module definition
├── go.sum                     # Dependency checksums
├── Dockerfile                 # Container config
├── docker-compose.yml         # Service orchestration
├── .gitignore                 # Git ignore rules
├── app/
│   ├── controllers/          # HTTP handlers
│   │   ├── auth.go
│   │   ├── user.go
│   │   ├── goal.go
│   │   └── ...
│   ├── models/               # Data structures
│   │   ├── user.go
│   │   ├── goal.go
│   │   └── ...
│   └── queries/              # Database queries
│       ├── user_query.go
│       ├── goal_query.go
│       └── ...
├── pkg/                      # Shared packages
│   ├── config/              # Configuration
│   ├── middleware/          # HTTP middlewares
│   ├── utils/              # Utility functions
│   └── database/           # Database utilities
└── migrations/             # Database migrations
    ├── 001_create_users.up.sql
    └── 001_create_users.down.sql
```

### 5. Setup Environment

```bash
# Copy environment template
cp ../.env.example ../.env

# Edit .env with your credentials
nano ../.env
```

### 6. Key Environment Variables for Backend

```env
DB_HOST=localhost
DB_PORT=5432
DB_USER=etmin
DB_PASSWORD=etmin
DB_NAME=sobi-db

SERVER_HOST=0.0.0.0
SERVER_PORT=8000
SERVER_ENV=development

JWT_SECRET=your-super-secret-key-min-32-chars
```

### 7. Run Backend

```bash
# Option 1: Run directly
go run main.go

# Option 2: Build and run
go build -o sobi-backend main.go
./sobi-backend

# Output should show:
# ✓ Database connected
# ✓ Server running on :8000
# ✓ All routes initialized
```

### 8. Test Backend

```bash
# Health check
curl http://localhost:8000/

# API Documentation (Swagger)
# Open: http://localhost:8000/swagger
```

---

## 📱 Frontend Setup (Flutter)

### 1. Install Flutter SDK

```bash
# Download Flutter
cd ~
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.7.0-stable.tar.xz
tar xf flutter_linux_3.7.0-stable.tar.xz
export PATH="$PATH:$HOME/flutter/bin"

# Or use official installer
# macOS: brew install flutter
# Windows: choco install flutter
```

### 2. Verify Flutter Installation

```bash
flutter doctor

# Should show green checkmarks for:
# ✓ Flutter
# ✓ Android toolchain
# ✓ Chrome
# ✓ Android Studio
# ✓ VS Code
```

### 3. Navigate to Frontend Directory

```bash
cd ~/coding/sobi-app/Sobi-Frontend
```

### 4. Get Dependencies

```bash
# Get all pub packages
flutter pub get

# Upgrade packages to latest
flutter pub upgrade

# Check for issues
flutter pub outdated
```

### 5. Generate Build Files

```bash
# Run build_runner untuk generate files
flutter pub run build_runner build --delete-conflicting-outputs

# Generate icons
flutter pub run flutter_launcher_icons

# Generate splash screen
flutter pub run flutter_native_splash:create
```

### 6. Project Structure

```
Sobi-Frontend/
├── lib/
│   ├── main.dart              # App entry point
│   ├── splash_screen.dart     # Splash screen
│   ├── core/
│   │   ├── api/              # API clients
│   │   ├── models/           # Data models
│   │   ├── services/         # Business logic
│   │   ├── constants/        # Constants
│   │   └── utils/            # Helper functions
│   ├── di/                   # Dependency Injection (GetIt)
│   ├── features/
│   │   ├── auth/            # Authentication
│   │   ├── home/            # Home page
│   │   ├── goals/           # Goals management
│   │   ├── tracker/         # Ibadah tracker
│   │   ├── journal/         # Journal features
│   │   ├── chat/            # Chat features
│   │   ├── education/       # Education content
│   │   └── profil/          # User profile
│   └── widgets/             # Reusable widgets
├── pubspec.yaml             # Dependencies
├── pubspec.lock             # Locked versions
├── android/                 # Android native code
├── ios/                     # iOS native code
├── web/                     # Web build
├── windows/                 # Windows native code
├── macos/                   # macOS native code
└── linux/                   # Linux native code
```

### 7. Setup Environment

```bash
# Create .env file untuk Flutter
cat > lib/.env << EOF
API_BASE_URL=http://localhost:8000
API_TIMEOUT=30
GOOGLE_CLIENT_ID=397171539019-uf6svnf3ahvc3krmbg053q2bkt7ihn1k.apps.googleusercontent.com
EOF
```

### 8. Run Flutter

```bash
# List available devices
flutter devices

# Run on connected device
flutter run

# Run specific platform
flutter run -d chrome              # Web
flutter run -d "emulator-5554"    # Android
flutter run -d "iPhone 14 Pro"    # iOS

# Run dengan hot reload
flutter run -v
```

### 9. Build Flutter

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

---

## 🤖 RAG Service Setup (Python)

### 1. Navigate to RAG Service Directory

```bash
cd ~/coding/sobi-app/sobi-AiQuran
```

### 2. Create Virtual Environment

```bash
# Linux/macOS
python3 -m venv venv
source venv/bin/activate

# Windows
python -m venv venv
venv\Scripts\activate
```

### 3. Upgrade pip

```bash
pip install --upgrade pip setuptools wheel
```

### 4. Install Dependencies

```bash
# Install from requirements.txt
pip install -r requirements.txt

# Atau install manually
pip install fastapi==0.104.0
pip install uvicorn[standard]==0.24.0
pip install pydantic==2.5.0
pip install numpy==1.24.3
pip install pandas==2.1.4
pip install scikit-learn==1.3.2
pip install rank-bm25==0.2.2
pip install sentence-transformers==2.2.2
pip install faiss-cpu==1.7.4
pip install google-generativeai==0.3.0
pip install rapidfuzz==3.5.2
pip install python-dotenv==1.0.0
```

### 5. Verify Installation

```bash
# Check installed packages
pip list

# Test FastAPI
python -c "import fastapi; print(fastapi.__version__)"

# Test FAISS
python -c "import faiss; print(faiss.__version__)"
```

### 6. Project Structure

```
sobi-AiQuran/
├── main.py                    # Entry point
├── api.py                     # FastAPI app & routes
├── rag_quran.py              # RAG logic
├── convertion.py             # Data conversion
├── jsonl.py                  # JSONL processing
├── requirements.txt          # Dependencies
├── Dockerfile               # Container config
├── docker-compose.yml       # Service orchestration
├── data/
│   ├── quran_kemenag_id.jsonl           # Quran with Indonesian translation
│   ├── quran_terjemahan_indonesia.json  # Alternative translation
│   ├── emb_quran.npy                   # FAISS embeddings
│   ├── faiss_quran.index               # FAISS index
│   ├── meta_quran.json                 # Metadata
│   └── id.indonesian.txt               # Stopwords
├── logs/                    # Log files
└── __pycache__/            # Python cache
```

### 7. Prepare Data Files

```bash
# Ensure data files exist
ls -la data/

# Required files:
# - quran_kemenag_id.jsonl (main Quran data)
# - emb_quran.npy (embeddings matrix)
# - faiss_quran.index (FAISS index)
# - meta_quran.json (metadata)
# - id.indonesian.txt (stopwords)

# If missing, you need to generate them
# See README.md for data generation instructions
```

### 8. Run RAG Service

```bash
# Option 1: Using python main.py
python main.py

# Option 2: Using uvicorn directly
uvicorn api:app --reload --host 0.0.0.0 --port 8001

# Option 3: With workers
uvicorn api:app --workers 4 --host 0.0.0.0 --port 8001
```

### 9. Test RAG Service

```bash
# Health check
curl http://localhost:8001/health

# API Documentation
# Swagger: http://localhost:8001/docs
# ReDoc: http://localhost:8001/redoc

# Test search endpoint
curl -X POST http://localhost:8001/search \
  -H "Content-Type: application/json" \
  -d '{"query":"kesabaran", "top_k":5}'
```

---

## 🗄️ Database Setup

### 1. Install PostgreSQL

```bash
# macOS
brew install postgresql@14
brew services start postgresql@14

# Linux (Ubuntu/Debian)
sudo apt-get install postgresql-14
sudo systemctl start postgresql

# Windows
# Download installer dari: https://www.postgresql.org/download/windows

# Or use Docker
docker run --name sobi-postgres \
  -e POSTGRES_DB=sobi-db \
  -e POSTGRES_USER=etmin \
  -e POSTGRES_PASSWORD=etmin \
  -p 5432:5432 \
  -d postgres:14
```

### 2. Create Database

```bash
# Connect to PostgreSQL
psql -h localhost -U postgres

# Create database
CREATE DATABASE "sobi-db" OWNER etmin;

# Verify
\l
\q
```

### 3. Setup User Permissions

```bash
psql -h localhost -U postgres

-- Create user (if not exists)
CREATE USER etmin WITH PASSWORD 'etmin';

-- Grant permissions
GRANT ALL PRIVILEGES ON DATABASE "sobi-db" TO etmin;
ALTER DATABASE "sobi-db" OWNER TO etmin;

-- Verify
\q
```

### 4. Run Migrations

```bash
cd Sobi-MainBackend

# Method 1: Using Go (if main.go handles migrations)
go run main.go migrate

# Method 2: Using migrate-cli
# Install: brew install migrate (or download from GitHub)
migrate -path ./migrations \
  -database "postgresql://etmin:etmin@localhost:5432/sobi-db?sslmode=disable" \
  up

# Verify migrations
migrate -path ./migrations \
  -database "postgresql://etmin:etmin@localhost:5432/sobi-db?sslmode=disable" \
  version
```

### 5. Verify Database

```bash
psql -h localhost -U etmin -d sobi-db

# List tables
\dt

# Check migrations table
SELECT * FROM schema_migrations;

# Exit
\q
```

---

## 🚀 Running All Services

### Terminal Setup (3 terminals needed)

```bash
# Terminal 1: Backend
cd ~/coding/sobi-app/Sobi-MainBackend
go run main.go
# Expected: ✓ Server running on :8000

# Terminal 2: RAG Service
cd ~/coding/sobi-app/sobi-AiQuran
source venv/bin/activate
python main.py
# Expected: ✓ Uvicorn running on :8001

# Terminal 3: Frontend
cd ~/coding/sobi-app/Sobi-Frontend
flutter run
# Choose device and run
```

### Docker Compose Setup

```bash
# From root directory
cd ~/coding/sobi-app

# Build images
docker-compose build

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Check services
docker-compose ps

# Stop services
docker-compose down
```

### Health Checks

```bash
# Check Backend
curl -s http://localhost:8000/ | jq .

# Check RAG Service
curl -s http://localhost:8001/health | jq .

# Check Database
psql -h localhost -U etmin -d sobi-db -c "SELECT 1;"

# Check Frontend (open in browser)
# http://localhost:8081 (for Chrome)
# or http://localhost:3001 (if running web)
```

---

## 💻 IDE Configuration

### VS Code Setup

```bash
# Install Extensions
code --install-extension golang.go
code --install-extension Dart-Code.dart-code
code --install-extension ms-python.python
code --install-extension ms-python.vscode-pylance
code --install-extension eamodio.gitlens
code --install-extension sqltools.sqltools
code --install-extension ms-vscode-remote.remote-wsl
```

### Go Setup (.vscode/settings.json)

```json
{
  "go.lintOnSave": "package",
  "go.formatOnSave": true,
  "go.useLanguageServer": true,
  "[go]": {
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.fixAll": true
    }
  }
}
```

### Python Setup

```bash
# Install formatter & linter
pip install black flake8 pylint autopep8

# Create .flake8 config
cat > sobi-AiQuran/.flake8 << EOF
[flake8]
max-line-length = 100
ignore = E203, W503, E501
EOF
```

### Flutter Setup

```bash
# Format code
flutter format lib/

# Analyze code
flutter analyze

# Run tests
flutter test
```

---

## 🐛 Common Issues

### Issue: Port Already in Use

```bash
# Find process using port
lsof -i :8000
lsof -i :8001
lsof -i :5432

# Kill process
kill -9 <PID>

# Or change port in .env
SERVER_PORT=8001
RAG_SERVER_PORT=8002
```

### Issue: Database Connection Refused

```bash
# Check PostgreSQL is running
pg_isready -h localhost -p 5432

# Check credentials in .env
cat .env | grep DB_

# Test connection
psql -h localhost -U etmin -d sobi-db -c "SELECT 1;"
```

### Issue: Python Virtual Environment

```bash
# Recreate venv
cd sobi-AiQuran
rm -rf venv
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Issue: Flutter Packages

```bash
# Clean and reinstall
flutter clean
flutter pub cache clean
flutter pub get

# Check for conflicts
flutter pub outdated
```

### Issue: Go Modules

```bash
# Clean module cache
go clean -modcache

# Reinstall dependencies
go mod tidy
go mod download
```

---

## 📝 Development Workflow

### Git Workflow

```bash
# Create feature branch
git checkout -b feature/your-feature

# Make changes and commit
git add .
git commit -m "feat: description of changes"

# Push to remote
git push origin feature/your-feature

# Create Pull Request on GitHub
```

### Code Standards

```bash
# Go
go fmt ./...      # Format code
go vet ./...      # Check for errors
golangci-lint run # Lint code

# Flutter
dart format lib/  # Format code
dart analyze      # Check code
flutter test      # Run tests

# Python
black .                      # Format code
flake8 .                    # Lint code
pylint sobi-AiQuran/       # Deep analysis
```

### Testing

```bash
# Backend tests
cd Sobi-MainBackend
go test ./...

# Frontend tests
cd Sobi-Frontend
flutter test

# RAG Service tests
cd sobi-AiQuran
python -m pytest tests/
```

---

## 📚 Next Steps

1. **Read Full Documentation** → See [README.md](./README.md)
2. **Explore API** → Visit http://localhost:8000/swagger
3. **Check RAG Docs** → Visit http://localhost:8001/docs
4. **Run Tests** → `go test ./...`, `flutter test`
5. **Create First Feature** → Follow git workflow above

---

## 🆘 Need Help?

- **Issues?** → Check [ENVIRONMENT_SETUP.md](./ENVIRONMENT_SETUP.md)
- **Quick answers?** → See [QUICK_START.md](./QUICK_START.md)
- **Configuration?** → Check [.env.example](./.env.example)
- **Email** → gilanghuda99@gmail.com

---

**Happy Development! 🚀**

#### Installation

```bash
# Ubuntu/Debian
sudo apt-get install code

# macOS
brew install --cask visual-studio-code

# Windows
# Download from: https://code.visualstudio.com
```

#### Essential Extensions

```bash
# Go Development
code --install-extension golang.go

# Flutter & Dart
code --install-extension Dart-Code.flutter
code --install-extension Dart-Code.dart-code

# Python
code --install-extension ms-python.python
code --install-extension ms-python.vscode-pylance

# Database Tools
code --install-extension ms-vscode.live-server
code --install-extension ckolkman.vscode-postgres

# Docker
code --install-extension ms-azuretools.vscode-docker

# Git & Version Control
code --install-extension eamodio.gitlens
code --install-extension GitHub.github-vscode-theme

# Formatting & Linting
code --install-extension esbenp.prettier-vscode
code --install-extension charliermarsh.ruff

# Database
code --install-extension quickly.quick-data-explorer
```

#### VS Code Configuration

Create `.vscode/settings.json`:

```json
{
  "[go]": {
    "editor.defaultFormatter": "golang.go",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.organizeImports": "explicit"
    }
  },
  "[dart]": {
    "editor.defaultFormatter": "Dart-Code.flutter",
    "editor.formatOnSave": true
  },
  "[python]": {
    "editor.defaultFormatter": "ms-python.python",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.organizeImports": "explicit"
    }
  },
  "editor.insertSpaces": true,
  "editor.tabSize": 2,
  "editor.rulers": [80, 120],
  "files.exclude": {
    "**/.git": true,
    "**/node_modules": true,
    "**/__pycache__": true,
    "**/.flutter-plugins": true
  }
}
```

### Option 2: JetBrains IDEs

```bash
# GoLand (Go IDE)
brew install --cask goland

# Android Studio (Flutter)
brew install --cask android-studio

# PyCharm (Python)
brew install --cask pycharm-community
```

---

## 🐹 Go Development Setup

### Installation

```bash
# Download Go
# Visit: https://golang.org/dl

# Ubuntu/Debian
wget https://go.dev/dl/go1.24.7.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.24.7.linux-amd64.tar.gz

# macOS
brew install go

# Verify installation
go version
```

### Setup GOPATH & GOROOT

```bash
# Add to ~/.bashrc or ~/.zshrc
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# Reload shell
source ~/.bashrc  # or ~/.zshrc
```

### Go Tools & Dependencies

```bash
# Install essential Go tools
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/golang/mock/mockgen@latest
go install github.com/cosmtrek/air@latest  # Hot reload
go install github.com/golang-migrate/migrate/v4/cmd/migrate@latest

# Verify installations
golangci-lint --version
mockgen -version
air --version
migrate -version
```

### Project Setup

```bash
cd sobi-app/Sobi-MainBackend

# Initialize Go modules (if needed)
go mod init github.com/gilanghuda/sobi-backend

# Download dependencies
go mod download
go mod tidy

# Verify
go mod graph
```

### Development with Hot Reload

Create `.air.toml`:

```toml
root = "."
testdata_dir = "testdata"
tmp_dir = "tmp"

[build]
  args_bin = []
  bin = "./tmp/main"
  cmd = "go build -o ./tmp/main ."
  delay = 1000
  exclude_dir = ["assets", "tmp", "vendor", "testdata"]
  exclude_extension = ["so", "o", "gcimpl"]
  exclude_regex = ["_test.go"]
  exclude_unchanged = false
  poll = false
  poll_interval = 0
  rerun = false
  rerun_delay = 500
  send_interrupt = false
  stop_on_error = false

[color]
  app = ""
  build = "yellow"
  main = "magenta"
  runner = "green"
  watcher = "cyan"

[log]
  main_only = false
  time = false

[misc]
  clean_on_exit = false
```

Run with hot reload:

```bash
air
```

---

## 📱 Flutter Development Setup

### Installation

```bash
# Download Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# or using Homebrew (macOS)
brew install flutter

# Run Flutter Doctor
flutter doctor
```

### Resolve Dependencies

```bash
# Android Development
# Run: flutter doctor
# Follow instructions for Android Studio setup

# iOS Development (macOS only)
# Run: flutter doctor
# May need: sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# Web Development
flutter config --enable-web

# Desktop Development (Windows/macOS/Linux)
flutter config --enable-windows
flutter config --enable-macos
flutter config --enable-linux
```

### Project Setup

```bash
cd sobi-app/Sobi-Frontend

# Get dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Generate build files
flutter pub run build_runner build

# Generate app icons
flutter pub run flutter_launcher_icons

# Generate splash screens
flutter pub run flutter_native_splash:create
```

### Platform-Specific Setup

#### Android Setup

```bash
# Install Android Studio
# Set Android SDK location in ~/.bashrc or ~/.zshrc
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Create emulator
flutter emulators --create --name "android-emulator"
flutter emulators --launch android-emulator

# Run app
flutter run
```

#### iOS Setup (macOS)

```bash
# Install Xcode
xcode-select --install

# Install CocoaPods
sudo gem install cocoapods

# Setup iOS development
cd ios
pod install
cd ..

# Run app
flutter run -d iphone
```

#### Web Setup

```bash
# Enable web support
flutter config --enable-web

# Run web app
flutter run -d chrome

# Build web app
flutter build web
```

---

## 🐍 Python Development Setup

### Python Installation

```bash
# Ubuntu/Debian
sudo apt-get install python3 python3-pip python3-venv

# macOS
brew install python3

# Windows
# Download from: https://www.python.org/downloads

# Verify installation
python --version
pip --version
```

### Virtual Environment Setup

```bash
cd sobi-app/sobi-AiQuran

# Create virtual environment
python -m venv venv

# Activate virtual environment
# Linux/macOS
source venv/bin/activate

# Windows
venv\Scripts\activate

# Upgrade pip
pip install --upgrade pip setuptools wheel
```

### Dependencies Installation

```bash
# Install from requirements.txt
pip install -r requirements.txt

# or individual packages
pip install fastapi uvicorn pydantic numpy pandas scikit-learn
pip install sentence-transformers faiss-cpu rank-bm25 rapidfuzz
```

### Development Tools

```bash
# Testing
pip install pytest pytest-cov

# Code Quality
pip install black flake8 pylint mypy

# Documentation
pip install sphinx

# Jupyter Notebook (optional)
pip install jupyter notebook

# Install all dev tools
pip install pytest black flake8 pylint mypy sphinx
```

### PyProject Configuration

Create `pyproject.toml`:

```toml
[build-system]
requires = ["setuptools>=61.0"]
build-backend = "setuptools.build_meta"

[project]
name = "sobi-rag"
version = "0.1.0"
description = "RAG Service for SoBi Application"
readme = "README.md"
requires-python = ">=3.8"

[tool.black]
line-length = 88
target-version = ["py38"]

[tool.pylint.messages_control]
disable = ["C0103", "R0913"]

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = "test_*.py"
```

---

## 🗄️ Database Tools

### PostgreSQL Client Tools

```bash
# Ubuntu/Debian
sudo apt-get install postgresql-client

# macOS
brew install libpq

# Windows
# Download from: https://www.postgresql.org/download

# Verify
psql --version
```

### pgAdmin (Web Interface)

```bash
# Using Docker
docker run --name pgadmin \
  -e PGADMIN_DEFAULT_EMAIL=admin@example.com \
  -e PGADMIN_DEFAULT_PASSWORD=admin \
  -p 5050:80 \
  -d dpage/pgadmin4

# Access: http://localhost:5050
```

### DBeaver (Desktop Client)

```bash
# macOS
brew install --cask dbeaver-community

# Windows
# Download from: https://dbeaver.io

# Ubuntu/Debian
# Download .deb from: https://dbeaver.io/download
```

### Database Commands Reference

```bash
# Connect to database
psql -h localhost -U etmin -d sobi-db

# Inside psql:
\l                    # List databases
\dt                   # List tables
\d table_name         # Describe table
\i script.sql         # Execute SQL script
SELECT version();     # Check version

# Backup database
pg_dump -U etmin sobi-db > backup.sql

# Restore database
psql -U etmin sobi-db < backup.sql
```

---

## 🔄 Version Control & Git

### Git Installation

```bash
# Ubuntu/Debian
sudo apt-get install git

# macOS
brew install git

# Windows
# Download from: https://git-scm.com

# Verify
git --version
```

### Git Configuration

```bash
# Set global user
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Setup SSH key
ssh-keygen -t rsa -b 4096 -C "your.email@example.com"
cat ~/.ssh/id_rsa.pub  # Copy to GitHub

# Test SSH
ssh -T git@github.com
```

### Git Workflow

```bash
# Clone repository
git clone https://github.com/gilanghuda/sobi-app.git
cd sobi-app

# Create feature branch
git checkout -b feature/new-feature

# Make changes and commit
git add .
git commit -m "feat: description of changes"

# Push to remote
git push origin feature/new-feature

# Create Pull Request on GitHub

# After review, merge to main
git checkout main
git pull origin main
git merge feature/new-feature
git push origin main
```

### Git Hooks (Pre-commit)

Install pre-commit:

```bash
pip install pre-commit

# Create .pre-commit-config.yaml
cat > .pre-commit-config.yaml << 'EOF'
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files

  - repo: https://github.com/psf/black
    rev: 23.1.0
    hooks:
      - id: black

  - repo: https://github.com/PyCQA/flake8
    rev: 6.0.0
    hooks:
      - id: flake8

  - repo: https://github.com/golangci/golangci-lint
    rev: v1.52.0
    hooks:
      - id: golangci-lint
EOF

# Install pre-commit hooks
pre-commit install

# Run pre-commit on all files
pre-commit run --all-files
```

---

## 🐳 Docker Setup

### Docker Installation

```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# macOS
brew install --cask docker

# Windows
# Download from: https://www.docker.com/products/docker-desktop

# Verify
docker --version
docker run hello-world
```

### Docker Compose

```bash
# Ubuntu/Debian
sudo curl -L "https://github.com/docker/compose/releases/download/v2.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# macOS
brew install docker-compose

# Verify
docker-compose --version
```

### Project Setup with Docker

```bash
cd sobi-app

# Build all services
docker-compose build

# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Clean up
docker-compose down -v  # Remove volumes too
```

---

## 🧪 API Testing Tools

### Postman

```bash
# macOS
brew install --cask postman

# Windows
# Download from: https://www.postman.com/downloads

# Linux (Snap)
sudo snap install postman
```

### Insomnia

```bash
# macOS
brew install --cask insomnia

# Ubuntu/Debian
sudo snap install insomnia

# Windows
# Download from: https://insomnia.rest/download
```

### cURL (Built-in)

```bash
# Test GET request
curl http://localhost:8000/

# Test POST request
curl -X POST http://localhost:8000/api/endpoint \
  -H "Content-Type: application/json" \
  -d '{"key":"value"}'

# Test with headers and auth
curl -X GET http://localhost:8000/api/endpoint \
  -H "Authorization: Bearer token" \
  -H "Content-Type: application/json"
```

### API Documentation Viewers

```bash
# Swagger UI (available at /docs)
curl http://localhost:8000/docs

# ReDoc (available at /redoc)
curl http://localhost:8000/redoc

# View with browser
open http://localhost:8000/docs
```

---

## 📦 Useful Extensions

### Browser Extensions

```
- Thunder Client (VS Code)
- REST Client (VS Code)
- Postman (Chrome)
- React DevTools (Chrome/Firefox)
```

### VS Code Extensions Summary

```bash
# Install all recommended extensions at once
code --install-extension golang.go \
  --install-extension Dart-Code.flutter \
  --install-extension ms-python.python \
  --install-extension ms-azuretools.vscode-docker \
  --install-extension eamodio.gitlens
```

---

## 🔧 Troubleshooting

### Go Issues

```bash
# Clear Go cache
go clean -cache
go clean -modcache

# Force re-download dependencies
rm go.sum
go mod tidy

# Check Go environment
go env
```

### Flutter Issues

```bash
# Run doctor
flutter doctor -v

# Clean build
flutter clean
flutter pub get

# Upgrade Flutter
flutter upgrade

# Clear pub cache
rm -rf ~/.pub-cache
```

### Python Issues

```bash
# Clear pip cache
pip cache purge

# Reinstall dependencies
pip install -r requirements.txt --force-reinstall

# Check virtual environment
python -m venv --upgrade-deps venv
```

### Database Issues

```bash
# Check PostgreSQL status
sudo systemctl status postgresql

# Restart PostgreSQL
sudo systemctl restart postgresql

# Check database connection
psql -h localhost -U etmin -d sobi-db -c "SELECT 1;"
```

---

## 📖 Related Documentation

- [README.md](./README.md) - Main documentation
- [QUICK_START.md](./QUICK_START.md) - Quick setup
- [ENVIRONMENT_SETUP.md](./ENVIRONMENT_SETUP.md) - Environment configuration
