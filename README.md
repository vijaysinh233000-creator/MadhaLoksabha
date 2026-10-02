# MadhaLoksabha

VoteYadi is a Marathi/English electoral-roll search application built with
Flutter Web and a FastAPI backend. Administrators organize voter-roll PDFs by
village, run OCR/indexing, and make the resulting records searchable from a
mobile-friendly, installable web app.

## Application routes

- `/` — public voter search
- `/super-admin` — village, PDF, OCR and index management
- `/api/docs` — FastAPI API documentation

## Requirements

- Flutter with web support
- Python 3.12+
- Tesseract OCR 5 with Marathi and English language data

The repository includes `mar`, `eng` and `osd` trained-data files under
`backend/tessdata/`. Uploaded PDFs and generated indexes are runtime data and
are intentionally excluded from Git.

## Local setup (Windows PowerShell)

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r backend\requirements.txt
flutter pub get
flutter build web --release
python backend\run.py
```

Open `http://localhost:8000/` for search or
`http://localhost:8000/super-admin` for administration.

The local FastAPI admin API is intended for development and is not protected by
the Cloudflare Worker authentication gate. Do not expose it publicly.

## Cloudflare web build

Build the Flutter app with the API Worker URL and Supabase Auth client settings:

```powershell
$env:API_BASE_URL = 'https://independent-voter-api.<your-subdomain>.workers.dev'
$env:SUPABASE_URL = 'https://<your-project-ref>.supabase.co'
$env:SUPABASE_PUBLISHABLE_KEY = '<your-publishable-key>'
flutter build web --release `
	--dart-define="API_BASE_URL=$env:API_BASE_URL" `
	--dart-define="SUPABASE_URL=$env:SUPABASE_URL" `
	--dart-define="SUPABASE_PUBLISHABLE_KEY=$env:SUPABASE_PUBLISHABLE_KEY"
```

Deploy `build/web` to Cloudflare Pages. Use only the publishable key in this
build; never put the Supabase service-role/secret key in Flutter or Pages
assets. The Worker checks signed-in users against the `admin_users` table.

## OCR and indexing

Upload PDFs through Super Admin or place them in village folders under
`pdfs/`, then perform a full rebuild:

```powershell
python backend\tools\index_now.py --full --workers 2
```

Inspect a representative OCR page before a full rebuild:

```powershell
python backend\tools\ocr_pdf.py "pdfs\Village\roll.pdf" --pages 3 --records
```

The search index supports Devanagari normalization, Marathi/Latin phonetic
matching, partial names, OCR-tolerant spelling and village filtering.

## Tests

```powershell
$env:PYTHONUTF8='1'
python backend\tests\test_marathi.py
flutter test
```

## Production notes

The generated Flutter web app is an installable PWA. The Cloudflare Worker
admin API requires Supabase Auth and an `admin_users` allowlist entry. The
separate FastAPI admin routes do not enforce authentication and must not be
exposed publicly. A FastAPI deployment also requires persistent storage for
`pdfs/` and `index/`.
