"""Render images/logo.svg to images/logo.png.

There is no SVG rasteriser available here, so the SVG is wrapped in a
zero-margin page and screenshotted with headless Chromium at 1024x1024, the
same size csv_plus and excel_plus use.

Usage, from the package root:

    python tool/make_logo.py

Requires a Chromium browser.
"""

from __future__ import annotations

import http.server
import os
import socketserver
import subprocess
import sys
import threading
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
IMAGES = ROOT / "images"
SVG = IMAGES / "logo.svg"
OUT = IMAGES / "logo.png"
SIZE = 1024
PORT = 8141

BROWSERS = [
    r"C:\Program Files\Google\Chrome\Application\chrome.exe",
    r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
    r"C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe",
    "/usr/bin/google-chrome",
    "/usr/bin/chromium",
]

# A standalone SVG document picks up the default body margin, so it is wrapped
# rather than loaded directly.
WRAPPER = """<!doctype html>
<meta charset="utf-8">
<style>
  html, body {{ margin: 0; padding: 0; background: transparent; }}
  img {{ display: block; width: {size}px; height: {size}px; }}
</style>
<img src="logo.svg" alt="">
"""


def find_browser() -> str:
    env = os.environ.get("CHROME_EXECUTABLE")
    if env and Path(env).exists():
        return env
    for candidate in BROWSERS:
        if Path(candidate).exists():
            return candidate
    sys.exit("No Chromium browser found. Set CHROME_EXECUTABLE.")


def main() -> None:
    if not SVG.exists():
        sys.exit(f"missing {SVG.relative_to(ROOT)}")

    wrapper = IMAGES / "_logo_render.html"
    wrapper.write_text(WRAPPER.format(size=SIZE), encoding="utf-8")

    def handler(*a, **kw):
        return http.server.SimpleHTTPRequestHandler(*a, directory=str(IMAGES), **kw)

    socketserver.TCPServer.allow_reuse_address = True
    server = socketserver.TCPServer(("127.0.0.1", PORT), handler)
    threading.Thread(target=server.serve_forever, daemon=True).start()

    try:
        subprocess.run(
            [
                find_browser(),
                "--headless=new",
                "--disable-gpu",
                "--no-sandbox",
                "--hide-scrollbars",
                "--default-background-color=00000000",
                f"--window-size={SIZE},{SIZE}",
                "--virtual-time-budget=15000",
                f"--screenshot={OUT}",
                f"http://127.0.0.1:{PORT}/_logo_render.html",
            ],
            check=True,
            capture_output=True,
            timeout=180,
        )
    finally:
        server.shutdown()
        wrapper.unlink(missing_ok=True)

    if not OUT.exists():
        sys.exit("render failed")
    print(f"wrote {OUT.relative_to(ROOT)}  {SIZE}x{SIZE}  {OUT.stat().st_size / 1024:.0f} KB")


if __name__ == "__main__":
    main()
