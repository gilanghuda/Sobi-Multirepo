import json

src = "quran_terjemahan_indonesia.json"
dst = "quran_kemenag_id.jsonl"

with open(src, "r", encoding="utf-8") as f:
    data = json.load(f)

with open(dst, "w", encoding="utf-8") as f:
    for x in data:
        if x.get("tipe") == "quran":
            rec = {
                "surah_name": x["surat"],
                "ayah": x["ayat"],
                "indo": x["teks"],
                "arab": None,
            }
            rec["ayah_id"] = f'{rec["surah_name"]}:{rec["ayah"]}'
            rec["text_index"] = rec["indo"]
            f.write(json.dumps(rec, ensure_ascii=False) + "\n")
