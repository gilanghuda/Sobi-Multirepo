import json
import os
import re
from typing import List, Dict, Tuple
from pathlib import Path

import numpy as np
from rank_bm25 import BM25Okapi
from sentence_transformers import SentenceTransformer
import faiss
from rapidfuzz import fuzz, process
import requests

# ---------- Config ----------
DATA_PATH = "quran_terjemahan_indonesia.json"
EMB_MODEL_NAME = "sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2"
FAISS_INDEX_PATH = "faiss_quran.index"
EMB_NPY_PATH = "emb_quran.npy"
META_JSON_PATH = "meta_quran.json"
TOP_K = 10

# ---------- Utils ----------
def normalize_text(s: str) -> str:
    # Lowercase + hapus tanda baca ringan
    s = s.lower()
    s = re.sub(r"[^\w\s]", " ", s, flags=re.UNICODE)
    s = re.sub(r"\s+", " ", s).strip()
    return s

def load_corpus(path: str) -> List[Dict]:
    # File kamu berupa JSON array
    with open(path, "r", encoding="utf-8") as f:
        data = json.load(f)

    # mapping of surah names to their numbers (1-based)
    SURAH_NAMES = [
        "Al-Fatihah", "Al-Baqarah", "Ali Imran", "An-Nisa", "Al-Ma'idah",
        "Al-An'am", "Al-A'raf", "Al-Anfal", "At-Taubah", "Yunus",
        "Hud", "Yusuf", "Ar-Ra'd", "Ibrahim", "Al-Hijr",
        "An-Nahl", "Al-Isra", "Al-Kahf", "Maryam", "Ta-Ha",
        "Al-Anbiya", "Al-Hajj", "Al-Mu'minun", "An-Nur", "Al-Furqan",
        "Ash-Shu'ara", "An-Naml", "Al-Qasas", "Al-Ankabut", "Ar-Rum",
        "Luqman", "As-Sajda", "Al-Ahzab", "Saba", "Fatir",
        "Yasin", "As-Saffat", "Sad", "Az-Zumar", "Ghafir",
        "Fussilat", "Ash-Shura", "Az-Zukhruf", "Ad-Dukhan", "Al-Jathiya",
        "Al-Ahqaf", "Muhammad", "Al-Fath", "Al-Hujurat", "Qaf",
        "Adh-Dhariyat", "At-Tur", "An-Najm", "Al-Qamar", "Ar-Rahman",
        "Al-Waqi'a", "Al-Hadid", "Al-Mujadila", "Al-Hashr", "Al-Mumtahina",
        "As-Saff", "Al-Jumu'a", "Al-Munafiqun", "At-Taghabun", "At-Talaq",
        "At-Tahrim", "Al-Mulk", "Al-Qalam", "Al-Haqqah", "Al-Ma'arij",
        "Nuh", "Al-Jinn", "Al-Muzzammil", "Al-Muddathir", "Al-Qiyamah",
        "Al-Insan", "Al-Mursalat", "An-Naba", "An-Nazi'at", "Abasa",
        "At-Takwir", "Al-Infitar", "Al-Mutaffifin", "Al-Inshiqaq", "Al-Buruj",
        "At-Tariq", "Al-A'la", "Al-Ghashiyah", "Al-Fajr", "Al-Balad",
        "Ash-Shams", "Al-Lail", "Ad-Duha", "Ash-Sharh", "At-Tin",
        "Al-‘Alaq", "Al-Qadr", "Al-Bayyina", "Az-Zalzalah", "Al-‘Adiyat",
        "Al-Qari‘ah", "At-Takathur", "Al-‘Asr", "Al-Humazah", "Al-Fil",
        "Quraisy", "Al-Ma’un", "Al-Kawthar", "Al-Kafirun", "An-Nasr",
        "Al-Lahab", "Al-Ikhlas", "Al-Falaq", "An-Nas"
    ]

    docs = []
    for obj in data:
        # filter kalau ada tipe lain
        if obj.get("tipe") != "quran":
            continue
        surah_name = obj.get("surat", "").strip()
        ayah = int(obj.get("ayat", 0))
        indo = obj.get("teks", "").strip()

        if not surah_name or not ayah or not indo:
            continue

        # determine numeric surah if possible
        surah_num = None
        try:
            surah_num = SURAH_NAMES.index(surah_name) + 1
        except ValueError:
            # try to extract leading number from the original object if present
            try:
                if "surah_no" in obj:
                    surah_num = int(obj.get("surah_no"))
                else:
                    m = re.search(r"(\d+)", obj.get("surat", ""))
                    if m:
                        surah_num = int(m.group(1))
            except Exception:
                surah_num = None

        # kita nggak butuh nomor surah untuk indexing awal
        # pakai ID berbasis nama surah:ayat biar simpel
        ayah_id = f"{surah_name}:{ayah}"

        docs.append({
            "surah_name": surah_name,    
            "surah": surah_num,         
            "ayah": ayah,                 
            "ayah_id": ayah_id,        
            "indo": indo,               
            "arab": None,                
            "sumber": obj.get("sumber"),  
            "text_index": indo           
        })

    surah_nums = sorted({d["surah"] for d in docs if d.get("surah")})
    arab_cache = {}
    for sn in surah_nums:
        try:
            resp = requests.get(f"https://equran.id/api/v2/surat/{sn}", timeout=10)
            if resp.status_code == 200:
                payload = resp.json()
                ayat_list = payload.get("data", {}).get("ayat", [])
                m = {int(a.get("nomorAyat")): a.get("teksArab") for a in ayat_list if a.get("nomorAyat")}
                arab_cache[sn] = m
            else:
                arab_cache[sn] = {}
        except Exception:
            arab_cache[sn] = {}

    for d in docs:
        sn = d.get("surah")
        if sn and sn in arab_cache:
            try:
                d["arab"] = arab_cache[sn].get(int(d.get("ayah")))
            except Exception:
                d["arab"] = None

    return docs

def build_bm25_corpus(docs: List[Dict]) -> Tuple[BM25Okapi, List[List[str]]]:
    tokenized = [normalize_text(d["text_index"]).split() for d in docs]
    bm25 = BM25Okapi(tokenized)
    return bm25, tokenized

def build_or_load_embeddings(docs: List[Dict], model_name: str):
    model = SentenceTransformer(model_name)
    texts = [d["text_index"] for d in docs]
    if os.path.exists(EMB_NPY_PATH) and os.path.exists(FAISS_INDEX_PATH) and os.path.exists(META_JSON_PATH):
        emb = np.load(EMB_NPY_PATH)
        index = faiss.read_index(FAISS_INDEX_PATH)
        with open(META_JSON_PATH, "r", encoding="utf-8") as f:
            meta = json.load(f)
        assert len(meta) == len(docs), "Meta length mismatch; re-index needed."
        return model, emb, index
    # Build embeddings
    emb = model.encode(texts, batch_size=64, show_progress_bar=True, convert_to_numpy=True, normalize_embeddings=True)
    dim = emb.shape[1]
    index = faiss.IndexFlatIP(dim)  # cosine sim with normalized vectors
    index.add(emb.astype(np.float32))
    # Save
    np.save(EMB_NPY_PATH, emb)
    faiss.write_index(index, FAISS_INDEX_PATH)
    with open(META_JSON_PATH, "w", encoding="utf-8") as f:
        json.dump([{"ayah_id": d["ayah_id"], "surah": d["surah"], "ayah": d["ayah"]} for d in docs], f, ensure_ascii=False)
    return model, emb, index

def rrf_fuse(bm25_scores: Dict[int, float], dense_scores: Dict[int, float], k: float = 60.0) -> List[Tuple[int, float]]:
    # Convert to ranks
    def to_rank(scores: Dict[int, float]) -> Dict[int, int]:
        # higher score -> better rank
        sorted_ids = sorted(scores.items(), key=lambda x: x[1], reverse=True)
        return {doc_id: rank+1 for rank, (doc_id, _) in enumerate(sorted_ids)}
    r_bm25 = to_rank(bm25_scores) if bm25_scores else {}
    r_dense = to_rank(dense_scores) if dense_scores else {}

    all_ids = set(r_bm25.keys()) | set(r_dense.keys())
    fused = []
    for i in all_ids:
        s = (1.0 / (k + r_bm25.get(i, 10**6))) + (1.0 / (k + r_dense.get(i, 10**6)))
        fused.append((i, s))
    fused.sort(key=lambda x: x[1], reverse=True)
    return fused

def bm25_search(query: str, bm25: BM25Okapi, tokenized_docs: List[List[str]], top_k: int = TOP_K) -> Dict[int, float]:
    q = normalize_text(query).split()
    scores = bm25.get_scores(q)
    top_idx = np.argsort(scores)[::-1][:top_k]
    return {int(i): float(scores[i]) for i in top_idx}

def dense_search(query: str, model: SentenceTransformer, index: faiss.Index, docs_len: int, top_k: int = TOP_K) -> Dict[int, float]:
    qv = model.encode([query], normalize_embeddings=True, convert_to_numpy=True)
    D, I = index.search(qv.astype(np.float32), top_k)
    return {int(idx): float(sim) for idx, sim in zip(I[0], D[0]) if 0 <= idx < docs_len}

def highlight(text: str, query: str, max_hits: int = 5) -> str:
    # Highlight kata-kata paling mirip (kasar tapi cepat)
    toks = list(set(normalize_text(query).split()))
    toks = sorted(toks, key=len, reverse=True)[:8]
    out = text
    hits = 0
    for t in toks:
        if not t or len(t) < 3:
            continue
        # gunakan boundary longgar
        out_new = re.sub(rf"(?i)\b({re.escape(t)})\b", r"**\1**", out)
        if out_new != out:
            hits += 1
            out = out_new
        if hits >= max_hits:
            break
    return out

class QuranRAG:
    def __init__(self, data_path: str = DATA_PATH):
        self.docs = load_corpus(data_path)
        if not self.docs:
            raise RuntimeError("Data kosong. Pastikan quran_kemenag_id.jsonl tersedia.")
        self.bm25, self.tokenized = build_bm25_corpus(self.docs)
        self.model, self.emb, self.index = build_or_load_embeddings(self.docs, EMB_MODEL_NAME)

    def retrieve(self, query: str, top_k: int = TOP_K) -> List[Dict]:
        b = bm25_search(query, self.bm25, self.tokenized, top_k=top_k*2)
        d = dense_search(query, self.model, self.index, len(self.docs), top_k=top_k*2)
        fused = rrf_fuse(b, d)
        hits = []
        for i, _score in fused[:top_k]:
            doc = self.docs[i].copy()
            doc["score_bm25"] = float(b.get(i, 0.0))
            doc["score_dense"] = float(d.get(i, 0.0))
            hits.append(doc)
        return hits

    def answer_lookup(self, query: str, top_k: int = 5) -> Dict:
        hits = self.retrieve(query, top_k=top_k)
        for h in hits:
            h["indo_highlight"] = highlight(h["indo"], query)
        return {
            "query": query,
            "results": [
                {
                    "ayah_id": h["ayah_id"],
                    "surah_name": h["surah_name"],
                    "surah": h.get("surah", None),
                    "indo": h["indo_highlight"],
                    "arab": h.get("arab", None),
                }
                for h in hits
            ],
        }

    def answer_qa(self, question: str, top_k: int = 5) -> Dict:
        hits = self.retrieve(question, top_k=top_k)
        # Ringkas sangat sederhana: gabung 2–3 ayat teratas (tanpa menafsir)
        snippet = " ".join([h["indo"] for h in hits[:3]])
        return {
            "question": question,
            "summary": snippet,  # ringkasan kutipan sederhana
            "citations": [f'QS. {h["surah_name"]} {h["ayah"]}' for h in hits[:3]],
            "results": [
                {
                    "ayah_id": h["ayah_id"],
                    "surah_name": h["surah_name"],
                    "surah": h.get("surah", None),
                    "indo": h["indo"],
                    "arab": h.get("arab", None),
                } for h in hits
            ]
        }

    def detail_ayat(self, surah: int, ayah: int) -> Dict:
        """Return arab, indo and tafsir for given surah and ayah.
        Fetch arab and tafsir from equran.id and look up local translation in self.docs.
        Special case: if ayah == 1, return ayat 1..5 (or until end) and combine tafsir into one string.
        """
        arab_text = None
        tafsir_text = None
        indo_text = None
        surah_name = None

        # fetch surat payload once
        payload = None
        try:
            resp = requests.get(f"https://equran.id/api/v2/surat/{surah}", timeout=10)
            if resp.status_code == 200:
                payload = resp.json().get("data", {})
        except Exception:
            payload = None

        # If requesting ayah 1, collect ayat 1..5
        if ayah == 1 and payload is not None:
            ayat_list = payload.get("ayat", []) or []
            jumlah = int(payload.get("jumlahAyat") or len(ayat_list) or 0)
            end = min(ayah + 4, jumlah)
            arab_parts = {}
            indo_parts = {}

            for a in ayat_list:
                try:
                    num = int(a.get("nomorAyat"))
                except Exception:
                    continue
                if ayah <= num <= end:
                    arab_parts[num] = a.get("teksArab") or ""
                    indo_parts[num] = a.get("teksIndonesia") or ""

            # fetch tafsir for multiple ayat
            tafsir_parts = {}
            try:
                resp2 = requests.get(f"https://equran.id/api/v2/tafsir/{surah}", timeout=10)
                if resp2.status_code == 200:
                    payload2 = resp2.json().get("data", {})
                    for t in payload2.get("tafsir", []) or []:
                        try:
                            tnum = int(t.get("ayat"))
                        except Exception:
                            continue
                        if ayah <= tnum <= end:
                            tafsir_parts[tnum] = t.get("teks") or ""
            except Exception:
                pass

            items = []
            for n in range(ayah, end + 1):
                # arab: prefer arab_parts, fallback to None
                a_text = arab_parts.get(n)
                # indo: prefer local docs
                local_indo = None
                for d in self.docs:
                    if d.get("surah") == surah and d.get("ayah") == n:
                        local_indo = d.get("indo")
                        break
                i_text = local_indo or indo_parts.get(n)

                items.append({
                    "ayah": n,
                    "arab": [a_text] if a_text else None,
                    "indo": [i_text] if i_text else None,
                })

            # combine tafsir into one string (ordered)
            tafsir_text = "\n\n".join([tafsir_parts.get(n) for n in range(ayah, end + 1) if tafsir_parts.get(n)]) or None

            # set surah_name from payload or local docs
            surah_name = payload.get("namaLatin") or payload.get("nama")

            return {
                "surah": surah,
                "surah_name": surah_name,
                "items": items,
                "tafsir": tafsir_text,
            }

        if payload is not None:
            ayat_list = payload.get("ayat", []) or []
            jumlah = int(payload.get("jumlahAyat") or len(ayat_list) or 0)
            if ayah < 1 or ayah > jumlah:
                pass
            else:
                end = min(ayah + 4, jumlah)
                arab_parts = {}
                indo_parts = {}

                for a in ayat_list:
                    try:
                        num = int(a.get("nomorAyat"))
                    except Exception:
                        continue
                    if ayah <= num <= end:
                        arab_parts[num] = a.get("teksArab") or ""
                        indo_parts[num] = a.get("teksIndonesia") or ""

       
                tafsir_parts = {}
                try:
                    resp2 = requests.get(f"https://equran.id/api/v2/tafsir/{surah}", timeout=10)
                    if resp2.status_code == 200:
                        payload2 = resp2.json().get("data", {})
                        for t in payload2.get("tafsir", []) or []:
                            try:
                                tnum = int(t.get("ayat"))
                            except Exception:
                                continue
                            if ayah <= tnum <= end:
                                tafsir_parts[tnum] = t.get("teks") or ""
                except Exception:
                    pass

                items = []
                for n in range(ayah, end + 1):
                    a_text = arab_parts.get(n)
                    # prefer local translation
                    local_indo = None
                    for d in self.docs:
                        if d.get("surah") == surah and d.get("ayah") == n:
                            local_indo = d.get("indo")
                            break
                    i_text = local_indo or indo_parts.get(n)

                    items.append({
                        "ayah": n,
                        "arab": [a_text] if a_text else None,
                        "indo": [i_text] if i_text else None,
                    })

                tafsir_text = "\n\n".join([tafsir_parts.get(n) for n in range(ayah, end + 1) if tafsir_parts.get(n)]) or None
                surah_name = payload.get("namaLatin") or payload.get("nama")

                return {
                    "surah": surah,
                    "surah_name": surah_name,
                    "items": items,
                    "tafsir": tafsir_text,
                }

        # fallback: single ayah behavior
        # fetch arab for single ayah
        try:
            if payload is None:
                resp = requests.get(f"https://equran.id/api/v2/surat/{surah}", timeout=10)
                if resp.status_code == 200:
                    payload = resp.json().get("data", {})
            if payload is not None:
                for a in payload.get("ayat", []) or []:
                    try:
                        if int(a.get("nomorAyat")) == int(ayah):
                            arab_text = a.get("teksArab")
                            # try to get teksIndonesia from API if available
                            if not indo_text:
                                indo_text = a.get("teksIndonesia")
                            break
                    except Exception:
                        continue
        except Exception:
            arab_text = None

        # fetch tafsir for single ayah
        try:
            resp2 = requests.get(f"https://equran.id/api/v2/tafsir/{surah}", timeout=10)
            if resp2.status_code == 200:
                payload2 = resp2.json().get("data", {})
                for t in payload2.get("tafsir", []) or []:
                    try:
                        if int(t.get("ayat")) == int(ayah):
                            tafsir_text = t.get("teks")
                            break
                    except Exception:
                        continue
        except Exception:
            tafsir_text = None

        # find local translation and surah name
        if indo_text is None:
            for d in self.docs:
                if d.get("surah") == surah and d.get("ayah") == ayah:
                    indo_text = d.get("indo")
                    surah_name = d.get("surah_name")
                    break
        else:
            # if we got indo_text from API but not surah_name, try to find name
            if not surah_name:
                for d in self.docs:
                    if d.get("surah") == surah:
                        surah_name = d.get("surah_name")
                        break

        single_item = {
            "ayah": ayah,
            "arab": [arab_text] if arab_text is not None else None,
            "indo": [indo_text] if indo_text is not None else None,
        }

        return {
            "surah": surah,
            "surah_name": surah_name,
            "items": [single_item],
            "tafsir": tafsir_text,
        }
# ---------- CLI Demo ----------
if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--mode", choices=["lookup", "qa"], default="lookup")
    parser.add_argument("--q", required=True, help="Kata kunci atau pertanyaan")
    parser.add_argument("--k", type=int, default=5)
    args = parser.parse_args()

    rag = QuranRAG(DATA_PATH)
    if args.mode == "lookup":
        out = rag.answer_lookup(args.q, top_k=args.k)
    else:
        out = rag.answer_qa(args.q, top_k=args.k)
    print(json.dumps(out, ensure_ascii=False, indent=2))
