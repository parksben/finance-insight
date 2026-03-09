# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

Add whatever helps you do your job. This is your cheat sheet.

---

## File Upload & Artifact Management

### upload-artifact Command

**When to use:** Whenever you need to generate files (screenshots, documents, images, etc.) that need to be shared with the user via public URLs.

**Command:** `/usr/local/bin/upload-artifact <file-path> [original-name]`

**What it does:**
1. Automatically categorizes files by type (images, documents, videos, audios, archives, others)
2. Renames with SHA256 hash (first 16 chars) to avoid conflicts
3. Uploads to GitHub repo: parksben/openclaw-artifect
4. Deletes local file after successful upload (saves disk space)
5. Returns public URL: `https://assets.parksben.xyz/{category}/{hash}.{ext}`

**Categories:**
- **images**: jpg, jpeg, png, gif, bmp, webp, svg, ico
- **documents**: pdf, doc, docx, xls, xlsx, ppt, pptx, txt, md, csv
- **videos**: mp4, avi, mov, wmv, flv, webm, mkv
- **audios**: mp3, wav, flac, aac, ogg, m4a
- **archives**: zip, tar, gz, rar, 7z, bz2
- **others**: everything else

**Example workflow:**
```bash
# Take a screenshot
screencapture /tmp/screenshot.png

# Upload it
upload-artifact /tmp/screenshot.png "dashboard-view.png"
# Returns: https://assets.parksben.xyz/images/abc123def4567890.png

# Share the URL with user
```

**Important:** 
- Always use this tool for file sharing instead of local paths
- The local file is automatically deleted after upload
- URLs are public and permanent (stored in GitHub)
- All agents have access to this capability


## Screenshot Quality Protocol

**Goal:** Keep screenshots readable on both desktop and mobile chat clients.

**Required workflow before sharing screenshots:**
1. **Minimum viewport width: 1920px** — always set before taking any screenshot.
2. Use the browser tool's `act` with `kind=resize` to set `width=1920, height=1080`.
3. Prefer focused capture (visible area) for readability.
4. Use `fullPage=true` only when user explicitly asks for full-page context.
5. After navigating, use `loadState=networkidle` to ensure content is fully loaded.
6. Upload via `upload-artifact` and return only the public URL.

**Browser tool example:**
```
browser action=act request={"kind":"resize","width":1920,"height":1080}
browser action=navigate url="https://..." loadState="networkidle"
browser action=screenshot type="jpeg"
exec: upload-artifact <path> "name.jpg"
```

**Why 1920px:** Narrower viewports trigger mobile layouts and font fallbacks that break Chinese/CJK rendering.

## System Fonts

CJK (Chinese/Japanese/Korean) fonts installed:
- `google-noto-sans-cjk-ttc-fonts` — Noto Sans CJK SC/TC/JP/KR
- Location: `/usr/share/fonts/google-noto-cjk/`
- Installed: 2026-03-09
