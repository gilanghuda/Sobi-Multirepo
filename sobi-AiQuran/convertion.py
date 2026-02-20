import json

# Daftar nama surat
surah_names = [
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


data_quran = []

# Buka file hasil unduhan dari Tanzil.net
with open("./assets/id.indonesian.txt", encoding="utf-8") as f:
    for line in f:
        parts = line.strip().split("|")
        if len(parts) != 3:
            continue
        surah_no = int(parts[0])
        ayah_no = int(parts[1])
        text = parts[2]

        data_quran.append({
            "tipe": "quran",
            "surat": surah_names[surah_no - 1],
            "ayat": ayah_no,
            "sumber": f"QS. {surah_names[surah_no - 1]}: {ayah_no}",
            "teks": text
        })

# Simpan ke file JSON
with open("quran_terjemahan_indonesia.json", "w", encoding="utf-8") as f:
    json.dump(data_quran, f, ensure_ascii=False, indent=2)
