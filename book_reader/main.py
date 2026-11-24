import json
import os
import uuid
import glob
from fastapi import FastAPI, Request, Response, HTTPException, Query
from fastapi.staticfiles import StaticFiles
import re

app = FastAPI()

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
BOOK_DIR = os.path.join(BASE_DIR, "static", "book")
PROGRESS_FILE = os.path.join(BASE_DIR, "progress.json")

if not os.path.exists(PROGRESS_FILE):
    with open(PROGRESS_FILE, "w", encoding="utf-8") as f:
        json.dump({}, f)

def load_book():
    chapters = []
    files = sorted(glob.glob(os.path.join(BOOK_DIR, "*.*")))
    
    for index, filepath in enumerate(files, start=1):
        with open(filepath, "r", encoding="utf-8") as f:
            text = f.read()
        
        filename = os.path.basename(filepath)
        title_match = re.search(r'<H2>(.*?)</H2>', text, re.IGNORECASE)
        title = title_match.group(1) if title_match else f"Файл {filename}"
        
        chapters.append({"id": index, "title": title, "text": text})
    return chapters

CHAPTERS = load_book()

def load_progress():
    with open(PROGRESS_FILE, "r", encoding="utf-8") as f:
        return json.load(f)

def save_progress(data):
    with open(PROGRESS_FILE, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

# --- НОВЫЙ ЭНДПОИНТ: выдает уникальный ID ---
@app.get("/api/init")
async def init_user(uid: str = Query(None)):
    # Если фронтенд прислал uid (при переносе на другое устройство) - берем его.
    # Если нет - генерируем новый.
    return {"uid": uid if uid else str(uuid.uuid4())}

@app.get("/api/chapter")
async def get_chapter(request: Request, chapter_id: int = Query(None)):
    # Берем uid из заголовка, который пришлет фронтенд
    uid = request.headers.get("X-User-Id")
    if not uid:
        raise HTTPException(status_code=401, detail="Нет заголовка X-User-Id")

    progress = load_progress()
    
    if chapter_id is None:
        chapter_id = progress.get(uid, 1) 
    
    chapter = next((c for c in CHAPTERS if c["id"] == chapter_id), None)
    if not chapter:
        raise HTTPException(status_code=404, detail="Глава не найдена")
    
    idx = CHAPTERS.index(chapter)
    prev_id = CHAPTERS[idx - 1]["id"] if idx > 0 else None
    next_id = CHAPTERS[idx + 1]["id"] if idx < len(CHAPTERS) - 1 else None
    
    return {"chapter": chapter, "prev_id": prev_id, "next_id": next_id}

@app.post("/api/progress")
async def save_user_progress(request: Request, data: dict):
    uid = request.headers.get("X-User-Id")
    if not uid:
        raise HTTPException(status_code=401, detail="Нет заголовка X-User-Id")
    
    chapter_id = data.get("chapter_id")
    if not chapter_id:
        raise HTTPException(status_code=400, detail="Не передан chapter_id")
    
    progress = load_progress()
    progress[uid] = chapter_id
    save_progress(progress)
    
    return {"status": "ok", "saved_chapter": chapter_id}

app.mount("/", StaticFiles(directory="static", html=True), name="static")