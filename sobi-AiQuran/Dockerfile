FROM python:3.11-slim

# Set workdir
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Expose port
EXPOSE 8001

# Jalankan FastAPI pakai uvicorn
CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8001"]
