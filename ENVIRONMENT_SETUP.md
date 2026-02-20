# 🔧 Environment Configuration Guide

<div align="center">

**Panduan Konfigurasi Lengkap untuk Development, Staging & Production**

</div>

---

##  Daftar Isi

- [Development Setup](#development-setup)
- [Staging Setup](#staging-setup)
- [Production Setup](#production-setup)
- [Database Configuration](#database-configuration)
- [API Keys & Credentials](#api-keys--credentials)
- [Security Checklist](#security-checklist)

---

##  Development Setup

### Local Machine Configuration

```env
# Database (Local)
DB_HOST=localhost
DB_PORT=5432
DB_USER=devuser
DB_PASSWORD=dev_password_123
DB_NAME=sobi-db-dev
DB_SSLMODE=disable

# Server
SERVER_HOST=0.0.0.0
SERVER_PORT=8000
SERVER_ENV=development

# JWT (Use any value for dev)
JWT_SECRET=dev-secret-key-not-used-in-production-min-32-chars

# Email (Use test Gmail or Mailtrap)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-test-email@gmail.com
SMTP_PASSWORD=your-app-specific-password

# Payment Gateway (Sandbox)
MIDTRANS_ENVIRONMENT=sandbox
MIDTRANS_SERVER_KEY=YOUR_MIDTRANS_SERVER_KEY
MIDTRANS_CLIENT_KEY=YOUR_MIDTRANS_CLIENT_KEY

# Google OAuth (Development)
OAUTH_CLIENT_ID=YOUR_GOOGLE_CLIENT_ID
OAUTH_CLIENT_SECRET=YOUR_GOOGLE_CLIENT_SECRET
OAUTH_REDIRECT_URI=http://localhost:8000/auth/google/callback

# RAG Service
RAG_SERVICE_URL=http://localhost:8001

# Features
ENABLE_OFFLINE_MODE=true
ENABLE_ANALYTICS=false
DEBUG_MODE=true
LOG_LEVEL=debug

# CORS
ALLOWED_ORIGINS=http://localhost:3001,http://localhost:3002,http://localhost:3003,http://localhost:8081
```

### Docker Compose for Development

```bash
# Start all services
docker-compose up

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Flutter Development

```bash
# Run on emulator
flutter run -d emulator-5554

# Run on physical device
flutter devices
flutter run

# Run with logging
flutter run -v

# Run web version
flutter run -d chrome

# Enable dart devtools
dart devtools
```

---

##  Staging Setup

### Remote Server Configuration

```env
# Database (Staging Server)
DB_HOST=staging-db.company.com
DB_PORT=5432
DB_USER=stg_user
DB_PASSWORD=stg_password_strong_secure
DB_NAME=sobi-db-staging
DB_SSLMODE=require

# Server
SERVER_HOST=0.0.0.0
SERVER_PORT=8000
SERVER_ENV=staging

# JWT (Generate secure key)
JWT_SECRET=generate-strong-32-char-key-for-staging

# Email (Use actual Gmail)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=noreply-staging@company.com
SMTP_PASSWORD=app-specific-password-from-gmail

# Payment Gateway (Sandbox - testing before production)
MIDTRANS_ENVIRONMENT=sandbox
MIDTRANS_SERVER_KEY=YOUR_STAGING_MIDTRANS_SERVER_KEY
MIDTRANS_CLIENT_KEY=YOUR_STAGING_MIDTRANS_CLIENT_KEY

# Google OAuth (Staging)
OAUTH_CLIENT_ID=YOUR_STAGING_GOOGLE_CLIENT_ID
OAUTH_CLIENT_SECRET=YOUR_STAGING_GOOGLE_CLIENT_SECRET
OAUTH_REDIRECT_URI=https://staging-api.sobi.company.com/auth/google/callback

# RAG Service
RAG_SERVICE_URL=http://rag-service-staging:8001

# URLs
APP_URL=https://staging.sobi.company.com
API_URL=https://staging-api.sobi.company.com

# Features
ENABLE_OFFLINE_MODE=true
ENABLE_ANALYTICS=true
DEBUG_MODE=false
LOG_LEVEL=info

# CORS
ALLOWED_ORIGINS=https://staging.sobi.company.com,https://staging-api.sobi.company.com

# Redis Cache
REDIS_ENABLED=true
REDIS_HOST=staging-redis.company.com
REDIS_PORT=6379
REDIS_PASSWORD=redis_password_staging
```

### Staging Deployment

```bash
# Build Docker images
docker build -t sobi-backend:staging ./Sobi-MainBackend
docker build -t sobi-rag:staging ./sobi-AiQuran
docker build -t sobi-frontend:staging ./Sobi-Frontend

# Push to registry (optional)
docker tag sobi-backend:staging registry.company.com/sobi-backend:staging
docker push registry.company.com/sobi-backend:staging

# Deploy using docker-compose
docker-compose -f docker-compose.staging.yml up -d

# Verify deployment
curl https://staging-api.sobi.company.com/health
```

---

##  Production Setup

###  CRITICAL: Production Security Requirements

```env
# Database (Production - RDS/Managed Service)
DB_HOST=prod-db.c.amazonaws.com
DB_PORT=5432
DB_USER=prod_user_minimal_permissions
DB_PASSWORD=VERY_STRONG_PASSWORD_40_CHARS_MINIMUM
DB_NAME=sobi-db-prod
DB_SSLMODE=require
DB_MAX_CONNECTIONS=50
DB_POOL_MAX_SIZE=30

# Server Configuration
SERVER_HOST=0.0.0.0
SERVER_PORT=8000
SERVER_ENV=production
SERVER_READ_TIMEOUT=15
SERVER_WRITE_TIMEOUT=15

# JWT (MUST BE STRONG & RANDOM)
JWT_SECRET=use-secure-key-generator-at-least-64-chars-random

# Email (Production Email Service)
SMTP_HOST=email-smtp.region.amazonaws.com
SMTP_PORT=587
SMTP_USER=noreply@sobi.company.com
SMTP_PASSWORD=strong-password-from-aws-ses
SMTP_FROM=noreply@sobi.company.com

# Payment Gateway (Production - REAL KEYS)
MIDTRANS_ENVIRONMENT=production
MIDTRANS_SERVER_KEY=YOUR_PRODUCTION_MIDTRANS_SERVER_KEY
MIDTRANS_CLIENT_KEY=YOUR_PRODUCTION_MIDTRANS_CLIENT_KEY
MIDTRANS_MERCHANT_ID=YOUR_PRODUCTION_MERCHANT_ID

# Google OAuth (Production)
OAUTH_CLIENT_ID=YOUR_PRODUCTION_GOOGLE_CLIENT_ID
OAUTH_CLIENT_SECRET=YOUR_PRODUCTION_GOOGLE_CLIENT_SECRET
OAUTH_REDIRECT_URI=https://api.sobi.com/auth/google/callback

# API Keys (Gemini, etc)
GEMINI_API_KEY=YOUR_PRODUCTION_GEMINI_API_KEY
GEMINI_TEMPERATURE=0.5

# RAG Service
RAG_SERVICE_URL=https://rag-api.sobi.com
RAG_SERVICE_TIMEOUT=30

# URLs
APP_URL=https://sobi.com
API_URL=https://api.sobi.com
FRONTEND_URL=https://sobi.com

# Features
ENABLE_OFFLINE_MODE=false
ENABLE_ANALYTICS=true
DEBUG_MODE=false
LOG_LEVEL=warn
MAINTENANCE_MODE=false

# CORS (Strict)
ALLOWED_ORIGINS=https://sobi.com,https://api.sobi.com
ALLOWED_METHODS=GET,POST,PUT,DELETE,OPTIONS
MAX_AGE=3600

# Redis Cache (Production)
REDIS_ENABLED=true
REDIS_HOST=prod-redis-cluster.cache.amazonaws.com
REDIS_PORT=6379
REDIS_PASSWORD=VERY_STRONG_REDIS_PASSWORD
REDIS_CACHE_TTL=86400

# Rate Limiting (Strict for production)
RATE_LIMIT_ENABLED=true
RATE_LIMIT_REQUESTS=100
RATE_LIMIT_WINDOW=60

# Security Headers
ENCRYPTION_KEY=STRONG_ENCRYPTION_KEY_MIN_32_CHARS
HASH_ROUNDS=12

# Logging & Monitoring
LOG_LEVEL=warn
SENTRY_DSN=https://your-sentry-dsn@sentry.io
DATADOG_API_KEY=production-datadog-key
```

### Production Deployment Checklist

```bash
#  Pre-Deployment Checklist

# 1. Database
- [ ] PostgreSQL 14+ installed
- [ ] Database created & migration completed
- [ ] Backups configured
- [ ] SSL/TLS enabled
- [ ] Connection pooling configured

# 2. Environment Variables
- [ ] All secrets generated & secured
- [ ] JWT_SECRET is 64+ characters random
- [ ] Database password is strong
- [ ] API keys restricted to domains
- [ ] Environment file encrypted

# 3. Application
- [ ] All dependencies up to date
- [ ] Security patches applied
- [ ] Code tested thoroughly
- [ ] Performance optimized
- [ ] Logs configured properly

# 4. Infrastructure
- [ ] Load balancer configured
- [ ] SSL/TLS certificates installed
- [ ] Firewall rules configured
- [ ] Monitoring & alerting setup
- [ ] Backup systems verified

# 5. Deployment
- [ ] CI/CD pipeline configured
- [ ] Docker images built & tested
- [ ] Kubernetes manifests ready
- [ ] Health checks configured
- [ ] Rollback plan ready

# 6. Security
- [ ] HTTPS enforced
- [ ] CORS properly configured
- [ ] Rate limiting enabled
- [ ] Input validation implemented
- [ ] Security headers added

# 7. Monitoring
- [ ] Error tracking enabled
- [ ] Performance monitoring active
- [ ] Log aggregation setup
- [ ] Alerts configured
- [ ] Dashboard ready
```

### Production Deployment Commands

```bash
# 1. Build production images
docker build --build-arg ENV=production -t sobi-backend:v1.0.0 ./Sobi-MainBackend
docker build -t sobi-rag:v1.0.0 ./sobi-AiQuran

# 2. Tag for registry
docker tag sobi-backend:v1.0.0 prod-registry.com/sobi-backend:v1.0.0
docker tag sobi-rag:v1.0.0 prod-registry.com/sobi-rag:v1.0.0

# 3. Push to registry
docker push prod-registry.com/sobi-backend:v1.0.0
docker push prod-registry.com/sobi-rag:v1.0.0

# 4. Deploy to Kubernetes
kubectl apply -f k8s/namespace.yml
kubectl apply -f k8s/configmap.yml
kubectl apply -f k8s/secret.yml
kubectl apply -f k8s/backend-deployment.yml
kubectl apply -f k8s/rag-deployment.yml
kubectl apply -f k8s/service.yml

# 5. Verify deployment
kubectl get pods -n sobi
kubectl logs -f deployment/sobi-backend -n sobi

# 6. Monitor
kubectl top nodes
kubectl top pods -n sobi
```

---

## 🗄️ Database Configuration

### Development Database

```sql
-- Create dev database
createdb sobi-db-dev

-- Connect to database
psql -h localhost -U devuser -d sobi-db-dev

-- Verify setup
\dt                     -- List tables
SELECT version();       -- Check PostgreSQL version
```

### Staging Database

```bash
# Using AWS RDS
export DB_HOST=sobi-db-staging.xxxxx.rds.amazonaws.com
export DB_USER=stg_user

psql -h $DB_HOST -U $DB_USER -d sobi-db-staging
```

### Production Database

```bash
# Using managed PostgreSQL service (AWS RDS, Google Cloud SQL, etc)
# Enable automated backups
# Enable multi-AZ deployment
# Enable encryption at rest
# Use SSL/TLS connections

# Backup strategy
pg_dump -h prod-db.xxxxx.rds.amazonaws.com -U prod_user \
  -d sobi-db-prod > backup-$(date +%Y%m%d).sql
```

---

##  API Keys & Credentials Management

### Generate Secure Keys

```bash
# Generate JWT Secret (64 characters)
openssl rand -hex 32

# Generate Random Password
openssl rand -base64 32

# Generate Encryption Key
python -c "import secrets; print(secrets.token_hex(16))"
```

### Secure Credential Storage

#### Option 1: Environment Variables (Simple)
```bash
export JWT_SECRET=$(openssl rand -hex 32)
export DB_PASSWORD=$(openssl rand -base64 32)
```

#### Option 2: .env File (Local Development)
```bash
# Create .env file (never commit)
cp .env.example .env
# Edit values
nano .env

# Load environment
source .env
```

#### Option 3: Secrets Manager (Production)
```bash
# AWS Secrets Manager
aws secretsmanager create-secret --name sobi/production/jwt-secret \
  --secret-string $(openssl rand -hex 32)

# Google Secret Manager
gcloud secrets create sobi-jwt-secret --data-file=<(openssl rand -hex 32)

# Vault
vault kv put secret/sobi/production jwt_secret=$(openssl rand -hex 32)
```

#### Option 4: Kubernetes Secrets (Containerized)
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: sobi-secrets
  namespace: sobi
type: Opaque
stringData:
  db-password: $STRONG_PASSWORD
  jwt-secret: $RANDOM_SECRET
  api-key: $API_KEY
```

---

##  Security Checklist

### Environment Variables Security

- [ ] **Never commit .env to repository**
  ```bash
  echo ".env" >> .gitignore
  ```

- [ ] **Use strong, random values for all secrets**
  ```bash
  openssl rand -hex 32  # Generate 64-char hex key
  ```

- [ ] **Rotate secrets regularly**
  - JWT_SECRET every 90 days
  - Database passwords every 60 days
  - API keys quarterly

- [ ] **Use different values per environment**
  - .env.development (weakest security)
  - .env.staging (medium security)
  - .env.production (highest security)

- [ ] **Restrict file permissions**
  ```bash
  chmod 600 .env
  ```

### API Keys Security

- [ ] **Use API key restrictions**
  - Domain/IP whitelist
  - Specific endpoints only
  - Rate limiting

- [ ] **Rotate keys quarterly**
  - Create new key
  - Test with new key
  - Deactivate old key

- [ ] **Monitor key usage**
  - Set up alerts for unusual activity
  - Review logs regularly

### Database Security

- [ ] **Strong password policy**
  - Minimum 16 characters
  - Mix of upper/lower/numbers/symbols
  - Auto-generated, not memorable

- [ ] **Principle of least privilege**
  - Create role per service
  - Grant only needed permissions
  - Read-only where possible

- [ ] **Encryption**
  - Enable SSL/TLS
  - Enable encryption at rest
  - Use encrypted backups

### Application Security

- [ ] **HTTPS everywhere**
  - Use valid SSL certificates
  - Enforce HTTPS redirect

- [ ] **CORS properly configured**
  - Only allow necessary origins
  - Review allowed methods

- [ ] **Rate limiting enabled**
  - Prevent brute force attacks
  - Protect against DDoS

---

##  Environment Variables Priority

When variables are defined in multiple places, the priority is:

1. **Kubernetes Secrets** (highest - production)
2. **System Environment Variables**
3. **.env file**
4. **Default values** (lowest)

---

##  Related Documentation

- [README.md](./README.md) - Complete project documentation
- [QUICK_START.md](./QUICK_START.md) - Quick setup guide
- [.env.example](./.env.example) - Environment variable template
