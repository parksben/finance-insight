#!/usr/bin/env python3
"""
Magic Link 认证服务
- POST /send-link?email=xxx  发送魔法链接到邮箱
- GET  /verify?token=xxx     验证 token，写 cookie
- GET  /check                Caddy forward_auth 检查点
- GET  /logout               清除 cookie
"""
import os, secrets, time, smtplib, json
from http.server import HTTPServer, BaseHTTPRequestHandler
from email.mime.text import MIMEText
from urllib.parse import urlparse, parse_qs
from http.cookies import SimpleCookie

# ── 配置 ──────────────────────────────────────────────
SMTP_HOST   = os.getenv("SMTP_HOST", "smtp.126.com")
SMTP_PORT   = int(os.getenv("SMTP_PORT", "465"))
SMTP_USER   = os.getenv("SMTP_USER", "npupyz@126.com")
SMTP_PASS   = os.getenv("SMTP_PASS", "TYDHcQrWTtWpYYir")
SMTP_FROM   = os.getenv("SMTP_FROM", SMTP_USER)

ALLOWED_EMAIL = os.getenv("ALLOWED_EMAIL", "npupyz@126.com")
BASE_URL      = os.getenv("BASE_URL", "https://api.parksben.xyz")
COOKIE_SECRET = os.getenv("COOKIE_SECRET", secrets.token_hex(32))
COOKIE_NAME   = "ag_auth"
TOKEN_TTL     = 600   # magic link 有效期 10 分钟
SESSION_TTL   = 86400 * 7  # session 有效期 7 天
PORT          = int(os.getenv("PORT", "8090"))

# ── 内存存储 ──────────────────────────────────────────
pending_tokens = {}   # token -> {email, expires}
sessions       = {}   # session_id -> expires

# ── 工具函数 ──────────────────────────────────────────
def send_magic_link(email: str, token: str):
    link = f"{BASE_URL}/__auth/verify?token={token}"
    body = f"""你好，

点击下方链接登录 Antigravity Proxy Dashboard（10 分钟内有效）：

{link}

如果不是你发起的请求，请忽略此邮件。
"""
    msg = MIMEText(body, "plain", "utf-8")
    msg["Subject"] = "登录 Antigravity Dashboard"
    msg["From"]    = SMTP_FROM
    msg["To"]      = email

    with smtplib.SMTP_SSL(SMTP_HOST, SMTP_PORT) as s:
        s.login(SMTP_USER, SMTP_PASS)
        s.sendmail(SMTP_FROM, [email], msg.as_string())

def make_session():
    sid = secrets.token_urlsafe(32)
    sessions[sid] = time.time() + SESSION_TTL
    return sid

def is_valid_session(sid: str) -> bool:
    exp = sessions.get(sid)
    if not exp:
        return False
    if time.time() > exp:
        sessions.pop(sid, None)
        return False
    return True

def get_session_from_request(handler):
    cookie_header = handler.headers.get("Cookie", "")
    c = SimpleCookie()
    c.load(cookie_header)
    if COOKIE_NAME in c:
        return c[COOKIE_NAME].value
    return None

# ── HTTP 处理 ──────────────────────────────────────────
class AuthHandler(BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        print(f"[auth] {self.address_string()} - {fmt % args}")

    def send_html(self, code: int, body: str):
        b = body.encode()
        self.send_response(code)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(b)))
        self.end_headers()
        self.wfile.write(b)

    def send_redirect(self, location: str, cookie: str = None):
        self.send_response(302)
        self.send_header("Location", location)
        if cookie:
            self.send_header("Set-Cookie", cookie)
        self.end_headers()

    def do_GET(self):
        parsed = urlparse(self.path)
        qs     = parse_qs(parsed.query)
        path   = parsed.path

        # Caddy forward_auth 检查点
        if path == "/__auth/check":
            sid = get_session_from_request(self)
            if sid and is_valid_session(sid):
                self.send_response(200)
                self.end_headers()
            else:
                # 直接 302，让 Caddy 透传重定向给浏览器
                self.send_response(302)
                self.send_header("Location", f"{BASE_URL}/__auth/login")
                self.send_header("Content-Length", "0")
                self.end_headers()
            return

        # 登录页
        if path in ("/__auth/login", "/__auth/"):
            self.send_html(200, LOGIN_PAGE)
            return

        # 验证 magic link
        if path == "/__auth/verify":
            token = qs.get("token", [None])[0]
            info  = pending_tokens.pop(token, None) if token else None
            if not info or time.time() > info["expires"]:
                self.send_html(400, "<h2>链接已失效或无效，请重新发送</h2>"
                                    f'<a href="/__auth/login">返回登录</a>')
                return
            sid    = make_session()
            cookie = (f"{COOKIE_NAME}={sid}; Path=/; HttpOnly; Secure; SameSite=Lax; "
                      f"Max-Age={SESSION_TTL}")
            self.send_redirect("/", cookie)
            return

        # 登出
        if path == "/__auth/logout":
            sid = get_session_from_request(self)
            sessions.pop(sid, None)
            cookie = f"{COOKIE_NAME}=; Path=/; Max-Age=0"
            self.send_redirect("/__auth/login", cookie)
            return

        self.send_html(404, "Not Found")

    def do_POST(self):
        parsed = urlparse(self.path)
        path   = parsed.path

        if path == "/__auth/send-link":
            length = int(self.headers.get("Content-Length", 0))
            body   = self.rfile.read(length).decode()
            qs     = parse_qs(body)
            email  = qs.get("email", [None])[0] or ""
            email  = email.strip().lower()

            if email != ALLOWED_EMAIL.lower():
                self.send_html(403, "<h2>不允许的邮箱地址</h2>"
                                    f'<a href="/__auth/login">返回</a>')
                return

            token = secrets.token_urlsafe(32)
            pending_tokens[token] = {"email": email, "expires": time.time() + TOKEN_TTL}

            try:
                send_magic_link(email, token)
                self.send_html(200, SENT_PAGE.replace("{{EMAIL}}", email))
            except Exception as e:
                print(f"[auth] send email error: {e}")
                self.send_html(500, f"<h2>发送失败：{e}</h2>"
                                    f'<a href="/__auth/login">返回</a>')
            return

        self.send_html(404, "Not Found")


LOGIN_PAGE = """<!DOCTYPE html>
<html lang="zh">
<head>
<meta charset="utf-8">
<title>登录 - Antigravity Proxy</title>
<style>
  body{font-family:system-ui,sans-serif;display:flex;align-items:center;
       justify-content:center;min-height:100vh;margin:0;background:#0f172a;color:#e2e8f0}
  .box{background:#1e293b;padding:2.5rem;border-radius:1rem;width:340px;
       box-shadow:0 4px 32px rgba(0,0,0,.4)}
  h1{margin:0 0 1.5rem;font-size:1.3rem;text-align:center}
  input{width:100%;padding:.75rem 1rem;border-radius:.5rem;border:1px solid #334155;
        background:#0f172a;color:#e2e8f0;font-size:1rem;box-sizing:border-box}
  button{width:100%;padding:.75rem;margin-top:1rem;border:none;border-radius:.5rem;
         background:#6366f1;color:#fff;font-size:1rem;cursor:pointer}
  button:hover{background:#818cf8}
  p{margin:.75rem 0 0;font-size:.85rem;color:#94a3b8;text-align:center}
</style>
</head>
<body>
<div class="box">
  <h1>🔐 Antigravity Proxy</h1>
  <form method="POST" action="/__auth/send-link">
    <input type="email" name="email" placeholder="输入邮箱地址" required autofocus>
    <button type="submit">发送登录链接</button>
  </form>
  <p>Magic Link 将发送到授权邮箱，10 分钟内有效</p>
</div>
</body>
</html>"""

SENT_PAGE = """<!DOCTYPE html>
<html lang="zh">
<head><meta charset="utf-8"><title>已发送</title>
<style>body{font-family:system-ui,sans-serif;display:flex;align-items:center;
justify-content:center;min-height:100vh;margin:0;background:#0f172a;color:#e2e8f0}
.box{background:#1e293b;padding:2.5rem;border-radius:1rem;width:340px;text-align:center}
</style></head>
<body>
<div class="box">
  <div style="font-size:3rem">📬</div>
  <h2>链接已发送</h2>
  <p>登录链接已发送到 <strong>{{EMAIL}}</strong></p>
  <p style="color:#94a3b8;font-size:.85rem">10 分钟内有效，请检查收件箱（含垃圾箱）</p>
</div>
</body>
</html>"""


if __name__ == "__main__":
    print(f"[auth] Magic Link 认证服务启动，监听 :{PORT}")
    print(f"[auth] 允许邮箱: {ALLOWED_EMAIL}")
    HTTPServer(("127.0.0.1", PORT), AuthHandler).serve_forever()
