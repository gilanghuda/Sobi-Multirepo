# api.py
from typing import List, Optional
from fastapi import FastAPI, Query
from pydantic import BaseModel
from rag_quran import QuranRAG
import requests

app = FastAPI(
    title="RAG Al-Qur'an (Kemenag, ID)",
    version="0.1.0",
    description="Endpoint sederhana untuk lookup & QA berbasis RAG Al-Qur'an (terjemahan Indonesia Kemenag)",
)

from fastapi.middleware.cors import CORSMiddleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # batasi di produksi
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# --- Inisialisasi (load index & BM25 sekali) ---
rag = QuranRAG()  # pastikan DATA_PATH di rag_quran.py sudah benar

# --- Skema respons ---
class LookupHit(BaseModel):
    ayah_id: str
    surah_name: str
    surah: Optional[int] = None
    indo: str
    arab: Optional[str] = None

class LookupResponse(BaseModel):
    query: str
    results: List[LookupHit]

class QAResponse(BaseModel):
    question: str
    summary: str
    citations: List[str]
    results: List[LookupHit]

# new: detail ayat request/response
class DetailAyatRequest(BaseModel):
    surah: int
    ayah: int

class AyahDetail(BaseModel):
    ayah: int
    arab: Optional[List[str]] = None
    indo: Optional[List[str]] = None

class DetailAyatResponse(BaseModel):
    surah: int
    surah_name: Optional[str] = None
    items: List[AyahDetail]
    tafsir: Optional[str] = None

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/lookup", response_model=LookupResponse)
def lookup(
    q: str = Query(..., description="Kata kunci / frasa dalam Bahasa Indonesia"),
    k: int = Query(5, ge=1, le=20, description="Jumlah hasil")
):
    return rag.answer_lookup(q, top_k=k)

@app.get("/qa", response_model=QAResponse)
def qa(
    q: str = Query(..., description="Pertanyaan bebas dalam Bahasa Indonesia"),
    k: int = Query(5, ge=1, le=20, description="Jumlah konteks")
):
    return rag.answer_qa(q, top_k=k)

@app.post("/detail_ayat", response_model=DetailAyatResponse)
def detail_ayat(payload: DetailAyatRequest):
    return rag.detail_ayat(payload.surah, payload.ayah)


@app.get("/detail", response_model=DetailAyatResponse)
def detail_get(surah: int = Query(..., ge=1), ayah: int = Query(..., ge=1)):
    return rag.detail_ayat(surah, ayah)
