#  SoBi Documentation Index

<div align="center">

**Dokumentasi Lengkap Setup & Konfigurasi Lingkungan Pengembangan SoBi**

Panduan komprehensif untuk setup integrated development environment pada proyek multirepo

</div>

---

##  Quick Navigation

Pilih dokumen sesuai kebutuhan Anda:

### 🚀 Untuk Memulai (Pertama Kali)
1. **[QUICK_START.md](./QUICK_START.md)** ⭐ **START HERE**
   - Setup 5 menit
   - Verifikasi checklist
   - Common issues solutions

###  Dokumentasi Lengkap
2. **[README.md](./README.md)** - Main Documentation
   - Project overview & architecture
   - Complete installation guide
   - Running services
   - Docker deployment
   - Troubleshooting guide

###  Setup Tools & IDE
3. **[DEVELOPMENT_SETUP.md](./DEVELOPMENT_SETUP.md)** - IDE & Tools
   - VS Code configuration
   - Go setup & tools
   - Flutter development
   - Python virtual environment
   - Database tools
   - Git workflow
   - Docker setup

###  Environment Configuration
4. **[ENVIRONMENT_SETUP.md](./ENVIRONMENT_SETUP.md)** - Configurations
   - Development setup
   - Staging setup
   - Production setup
   - API keys management
   - Security checklist

###  Environment Variables
5. **[.env.example](./.env.example)** - Configuration Template
   - All available variables
   - Descriptions & defaults
   - Backend, Frontend, AI service vars

---

##  Documentation Structure

```
sobi-app/
├── README.md                    # Main documentation
├── QUICK_START.md              # 5-minute quick setup
├── DEVELOPMENT_SETUP.md        # IDE & tools setup
├── ENVIRONMENT_SETUP.md        # Environment configuration
├── .env.example                # Environment variables template
└── [Project Folders]
    ├── Sobi-MainBackend/       # Go + Fiber backend
    ├── Sobi-Frontend/          # Flutter frontend
    └── sobi-AiQuran/           # Python RAG service
```

---

##  Learning Path

### Beginner Setup (
```
1. Read: QUICK_START.md (5 min)
   ↓
2. Clone & Setup: Follow Quick Start commands (15 min)
   ↓
3. Verify: Run checklist items (10 min)
   ↓
 Development environment ready!
```

### Intermediate Setup (1-2 hours)
```
1. Read: README.md - Arsitektur Sistem (10 min)
   ↓
2. Read: DEVELOPMENT_SETUP.md - IDE Setup (20 min)
   ↓
3. Install: All required tools (30 min)
   ↓
4. Read: ENVIRONMENT_SETUP.md - Dev Configuration (20 min)
   ↓
5. Setup: Copy & configure .env.example (10 min)
   ↓
 Complete development environment!
```

### Advanced Setup (2-4 hours)
```
1. Read: All documentation files (40 min)
   ↓
2. Setup: Docker environment (30 min)
   ↓
3. Configure: Multiple environments (.env.dev, .env.staging, .env.prod) (30 min)
   ↓
4. Setup: CI/CD pipeline (1 hour)
   ↓
5. Security: Implement security measures (1 hour)
   ↓
 Production-ready development environment!
```

---

##  Project Overview

### SoBi Application Stack

| Layer | Technology | Port | Docs |
|-------|-----------|------|------|
| **Frontend** | Flutter | 3001-8081 | QUICK_START.md L16 |
| **Backend API** | Go + Fiber | 8000 | README.md L145 |
| **AI/RAG Service** | Python + FastAPI | 8001 | README.md L230 |
| **Database** | PostgreSQL | 5432 | README.md L186 |
| **Cache** | Redis (optional) | 6379 | ENVIRONMENT_SETUP.md |

### Services Architecture

```
┌─────────────┐
│   Flutter   │ (Mobile, Web, Desktop)
│  (Ports     │
│  3001-8081) │
└──────┬──────┘
       │
       ├─────────────────────────┐
       │                         │
    REST API               WebSocket
       │                         │
       ↓                         ↓
  ┌─────────────┐         ┌──────────┐
  │ Go Backend  │────────→│  Cache   │
  │ (Port 8000) │         │ (Redis)  │
  └──────┬──────┘         └──────────┘
         │
    ┌────┴──────────────────┐
    │                       │
    ↓                       ↓
┌──────────────┐     ┌────────────────┐
│ PostgreSQL   │     │ Python RAG API │
│ (Port 5432)  │     │ (Port 8001)    │
└──────────────┘     └────────────────┘
```

---

##  Use Case Documentation

### "I just cloned the repo, what do I do?" 
→ **[QUICK_START.md](./QUICK_START.md)** (5 minutes)

### "I want to set up my IDE"
→ **[DEVELOPMENT_SETUP.md](./DEVELOPMENT_SETUP.md)** (30 minutes)

### "I need to configure environment variables"
→ **[ENVIRONMENT_SETUP.md](./ENVIRONMENT_SETUP.md)** (20 minutes)

### "I want to understand the full architecture"
→ **[README.md](./README.md)** (1 hour)

### "I need to deploy to staging/production"
→ **[ENVIRONMENT_SETUP.md](./ENVIRONMENT_SETUP.md)** - Staging/Production sections

### "I'm stuck with an error"
→ **[README.md](./README.md)** - Troubleshooting section

### "I need API key configuration"
→ **[ENVIRONMENT_SETUP.md](./ENVIRONMENT_SETUP.md)** - API Keys section

### "I want to understand database setup"
→ **[README.md](./README.md)** - Database Migration section

---

##  Key Configuration Files

### Essential Files to Understand

```
Project Root:
├── .env.example          ← Copy to .env for local development
├── README.md             ← Main reference
└── QUICK_START.md        ← Start here

Backend (Go):
├── Sobi-MainBackend/
│   ├── main.go           ← Entry point
│   ├── go.mod            ← Dependencies
│   ├── Dockerfile        ← Container config
│   └── migrations/       ← Database schemas
└── docker-compose.yml    ← Service orchestration

Frontend (Flutter):
├── Sobi-Frontend/
│   ├── pubspec.yaml      ← Dependencies
│   ├── lib/main.dart     ← Entry point
│   └── lib/features/     ← Feature modules
└── .env (in Flutter)     ← Flutter-specific config

AI Service (Python):
├── sobi-AiQuran/
│   ├── main.py           ← Entry point
│   ├── requirements.txt   ← Dependencies
│   ├── Dockerfile        ← Container config
│   └── data/             ← Quran embeddings & index
└── .env                  ← RAG service config
```

---

##  Command Cheat Sheet

### Quick Commands

```bash
# Clone & Setup (5 min)
git clone https://github.com/gilanghuda/sobi-app.git && cd sobi-app
cp .env.example .env

# Start all services (in separate terminals)
# Terminal 1:
docker run --name sobi-postgres -e POSTGRES_DB=sobi-db -e POSTGRES_USER=etmin -e POSTGRES_PASSWORD=etmin -p 5432:5432 -d postgres:14

# Terminal 2:
cd Sobi-MainBackend && go run main.go

# Terminal 3:
cd sobi-AiQuran && source venv/bin/activate && python main.py

# Terminal 4:
cd Sobi-Frontend && flutter run

# Verify all running
curl http://localhost:8000/
curl http://localhost:8001/docs
```

### Development Commands

```bash
# Format code
go fmt ./Sobi-MainBackend/...
dart format Sobi-Frontend/lib/
black sobi-AiQuran/

# Run tests
go test ./Sobi-MainBackend/...
flutter test Sobi-Frontend/
python -m pytest sobi-AiQuran/

# Database migrations
cd Sobi-MainBackend
migrate -path ./migrations -database "postgresql://etmin:etmin@localhost:5432/sobi-db" up

# Docker
docker-compose up -d
docker-compose logs -f
docker-compose down
```

---

##  Environment Variables Summary

### Backend (.env at root)
```env
DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME
JWT_SECRET, ACCESS_TOKEN_MINUTES, REFRESH_TOKEN_HOURS
SMTP_HOST, SMTP_PORT, SMTP_USER, SMTP_PASSWORD
MIDTRANS_SERVER_KEY, MIDTRANS_CLIENT_KEY
GEMINI_API_KEY, OAUTH_CLIENT_ID, OAUTH_CLIENT_SECRET
RAG_SERVICE_URL, ALLOWED_ORIGINS
```

### Frontend (.env in Sobi-Frontend)
```env
API_BASE_URL
GOOGLE_CLIENT_ID
APP_ENV, DEBUG_MODE
```

### RAG Service (.env in sobi-AiQuran)
```env
RAG_SERVER_HOST, RAG_SERVER_PORT
QURAN_DATA_PATH, EMBEDDINGS_PATH, FAISS_INDEX_PATH
GEMINI_API_KEY
```

→ See **[.env.example](./.env.example)** for complete list

---

##  Pre-Development Checklist

Before starting development, ensure:

- [ ] **Git**: `git --version` works
- [ ] **Go**: `go version` shows 1.24.0+
- [ ] **Flutter**: `flutter --version` shows 3.7.0+
- [ ] **Python**: `python --version` shows 3.8+
- [ ] **PostgreSQL**: `psql --version` works
- [ ] **Docker**: `docker --version` works
- [ ] **.env copied**: `cp .env.example .env`
- [ ] **Variables updated**: Edit `.env` with your values
- [ ] **Database running**: PostgreSQL accessible
- [ ] **All services starting**: No port conflicts

---

##  Development Workflow

### Daily Development Routine

```bash
# 1. Start services (each in separate terminal)
# Terminal 1: Database
docker-compose up postgres

# Terminal 2: Backend
cd Sobi-MainBackend && go run main.go

# Terminal 3: RAG Service  
cd sobi-AiQuran && source venv/bin/activate && python main.py

# Terminal 4: Frontend
cd Sobi-Frontend && flutter run

# 2. Make changes
# Edit files in your IDE

# 3. Test changes
# Auto-reload in Flutter/Go/Python
# or manually restart service

# 4. Commit changes
git add .
git commit -m "feat: description"
git push origin branch-name
```

---

##  Support & Resources

### Documentation
-  [README.md](./README.md) - Complete guide
-  [QUICK_START.md](./QUICK_START.md) - 5-minute setup
-  [DEVELOPMENT_SETUP.md](./DEVELOPMENT_SETUP.md) - Tools & IDE
-  [ENVIRONMENT_SETUP.md](./ENVIRONMENT_SETUP.md) - Configuration

### External Resources
- [Go Documentation](https://golang.org/doc)
- [Flutter Documentation](https://flutter.dev/docs)
- [FastAPI Documentation](https://fastapi.tiangolo.com)
- [PostgreSQL Documentation](https://www.postgresql.org/docs)
- [Docker Documentation](https://docs.docker.com)


---

##  Documentation Maintenance

Last Updated: **February 2026**

Documentation version: **1.0.0**

### How to Update Documentation

```bash
# Edit documentation files
nano README.md
nano QUICK_START.md

# Test all instructions
# Verify all links work
# Update version number

# Commit changes
git add *.md .env.example
git commit -m "docs: update documentation"
git push origin main
```

---

##  Learning Resources

### Getting Started Series
1. **5-Minute Quick Start** → [QUICK_START.md](./QUICK_START.md)
2. **IDE Setup** → [DEVELOPMENT_SETUP.md](./DEVELOPMENT_SETUP.md)
3. **Full Documentation** → [README.md](./README.md)
4. **Environment Config** → [ENVIRONMENT_SETUP.md](./ENVIRONMENT_SETUP.md)
5. **Environment Variables** → [.env.example](./.env.example)

### By Role

**Frontend Developer**
- Read: QUICK_START.md → DEVELOPMENT_SETUP.md (Flutter section)
- Read: ENVIRONMENT_SETUP.md (Development)
- Configure: .env.example for Flutter

**Backend Developer**
- Read: QUICK_START.md → README.md (Backend section)
- Read: DEVELOPMENT_SETUP.md (Go section)
- Read: ENVIRONMENT_SETUP.md (Development)
- Configure: .env.example

**DevOps/Infrastructure**
- Read: README.md (Docker Deployment section)
- Read: ENVIRONMENT_SETUP.md (all sections)
- Read: DEVELOPMENT_SETUP.md (Docker section)
- Configure: docker-compose.yml, Kubernetes manifests

**Full Stack Developer**
- Read all documentation in order
- Setup complete development environment
- Practice all development workflows

---

##  Next Steps

1. **Read QUICK_START.md** (5 minutes)
2. **Follow setup instructions** (15-30 minutes)
3. **Verify everything runs** (5 minutes)
4. **Start development** (Happy coding! )

---

<div align="center">

**Selamat datang di tim pengembang SoBi!** 🎓

Jika ada pertanyaan, baca dokumentasi yang relevan atau hubungi tim development.

---

**Last Updated**: February 20, 2026  
**Documentation Version**: 1.0.0  
**Project**: SoBi - Islamic Learning Platform  
**Status**:  Complete & Ready for Use

</div>
