"""Capture each keyboard on its own, then stitch them into one image.

Every scene renders a single keyboard at an exact size and is captured at a
viewport to match, so a shot contains the keyboard and nothing else. They are
composited at native scale and bottom aligned, which keeps the real size
relationship between a 760px desktop keyboard and a 320px PIN pad.

Usage, from the package root:

    cd example && flutter build web --release -t lib/screenshot_scenes_main.dart
    python tool/make_showcase.py

Requires Pillow and a Chromium browser.
"""

from __future__ import annotations

import http.server
import os
import shutil
import socketserver
import subprocess
import sys
import tempfile
import threading
from dataclasses import dataclass
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parent.parent
WEB = ROOT / "example" / "build" / "web"
OUT = ROOT / "previews" / "showcase-devices.png"
PORT = 8139
DPR = 2

BG_TOP = (243, 243, 250)
BG_BOTTOM = (232, 232, 244)
INK = (27, 27, 37)
MUTED = (122, 122, 140)

BROWSERS = [
    r"C:\Program Files\Google\Chrome\Application\chrome.exe",
    r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
    r"C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe",
    "/usr/bin/google-chrome",
    "/usr/bin/chromium",
]


@dataclass
class Scene:
    key: str
    label: str
    note: str
    width: int
    height: int


SCENES = [
    Scene("desktop", "Desktop", "Email layout, wide", 760, 300),
    Scene("emoji", "Emoji", "Colour emoji page", 460, 380),
    Scene("pin", "PIN pad", "Custom layout, dark", 320, 320),
    Scene("phone", "Phone", "QWERTY, 12 languages", 390, 280),
    Scene("arabic", "Arabic", "Right to left", 390, 280),
    Scene("kiosk", "Kiosk", "Numeric, themed", 460, 300),
]

# Two rows rather than one long strip: a 5:1 banner renders unreadably small
# in a package gallery.
ROWS = [["desktop", "emoji", "pin"], ["phone", "arabic", "kiosk"]]


def find_browser() -> str:
    env = os.environ.get("CHROME_EXECUTABLE")
    if env and Path(env).exists():
        return env
    for candidate in BROWSERS:
        if Path(candidate).exists():
            return candidate
    sys.exit("No Chromium browser found. Set CHROME_EXECUTABLE.")


def serve(directory: Path) -> socketserver.TCPServer:
    handler = lambda *a, **kw: http.server.SimpleHTTPRequestHandler(  # noqa: E731
        *a, directory=str(directory), **kw
    )
    socketserver.TCPServer.allow_reuse_address = True
    server = socketserver.TCPServer(("127.0.0.1", PORT), handler)
    threading.Thread(target=server.serve_forever, daemon=True).start()
    return server


def capture(browser: str, scene: Scene, out: Path) -> Image.Image:
    subprocess.run(
        [
            browser,
            "--headless=new",
            "--disable-gpu",
            "--no-sandbox",
            "--hide-scrollbars",
            f"--force-device-scale-factor={DPR}",
            f"--window-size={scene.width},{scene.height}",
            "--virtual-time-budget=25000",
            f"--screenshot={out}",
            f"http://127.0.0.1:{PORT}/?scene={scene.key}",
        ],
        check=True,
        capture_output=True,
        timeout=240,
    )
    if not out.exists():
        sys.exit(f"capture failed for scene {scene.key}")
    return Image.open(out).convert("RGB")


def rounded(img: Image.Image, radius: int) -> Image.Image:
    mask = Image.new("L", img.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        [0, 0, img.size[0] - 1, img.size[1] - 1], radius=radius, fill=255
    )
    out = Image.new("RGBA", img.size)
    out.paste(img, (0, 0), mask)
    return out


def shadow(size: tuple[int, int], radius: int, blur: int) -> Image.Image:
    pad = blur * 3
    layer = Image.new("RGBA", (size[0] + pad * 2, size[1] + pad * 2), (0, 0, 0, 0))
    ImageDraw.Draw(layer).rounded_rectangle(
        [pad, pad, pad + size[0], pad + size[1]], radius=radius, fill=(0, 0, 0, 70)
    )
    return layer.filter(ImageFilter.GaussianBlur(blur))


def font(size: int, bold: bool = False) -> ImageFont.FreeTypeFont:
    names = (
        ["segoeuib.ttf", "arialbd.ttf", "DejaVuSans-Bold.ttf"]
        if bold
        else ["segoeui.ttf", "arial.ttf", "DejaVuSans.ttf"]
    )
    for name in names:
        for base in [r"C:\Windows\Fonts", "/usr/share/fonts/truetype/dejavu"]:
            path = Path(base) / name
            if path.exists():
                return ImageFont.truetype(str(path), size)
    return ImageFont.load_default(size)


def main() -> None:
    if not (WEB / "index.html").exists():
        sys.exit(
            "Build the scenes first:\n"
            "  cd example && flutter build web --release "
            "-t lib/screenshot_scenes_main.dart"
        )

    browser = find_browser()
    print(f"browser: {browser}")
    server = serve(WEB)
    tmp = Path(tempfile.mkdtemp())
    try:
        shots = []
        for scene in SCENES:
            img = capture(browser, scene, tmp / f"{scene.key}.png")
            print(f"  captured {scene.key:8} {img.size[0]}x{img.size[1]}")
            shots.append((scene, img))
    finally:
        server.shutdown()

    by_key = {scene.key: (scene, img) for scene, img in shots}
    rows = [[by_key[k] for k in row] for row in ROWS]

    gap_x, gap_y = 56, 130
    pad_x, pad_top, pad_bottom = 80, 200, 90
    label_block = 110

    row_w = [
        sum(i.size[0] for _, i in r) + gap_x * (len(r) - 1) for r in rows
    ]
    row_h = [max(i.size[1] for _, i in r) for r in rows]

    canvas_w = max(row_w) + pad_x * 2
    canvas_h = (
        pad_top
        + sum(h + label_block for h in row_h)
        + gap_y * (len(rows) - 1)
        + pad_bottom
    )

    canvas = Image.new("RGB", (canvas_w, canvas_h), BG_TOP)
    column = Image.new("RGB", (1, canvas_h))
    for y in range(canvas_h):
        t = y / canvas_h
        column.putpixel(
            (0, y),
            tuple(round(a + (b - a) * t) for a, b in zip(BG_TOP, BG_BOTTOM)),
        )
    canvas = column.resize((canvas_w, canvas_h))

    draw = ImageDraw.Draw(canvas)
    draw.text((pad_x, 74), "virtual_keypad", font=font(64, True), fill=INK)
    draw.text(
        (pad_x, 152),
        "Layouts, languages, and themes. One on-screen keyboard for Flutter",
        font=font(30),
        fill=MUTED,
    )

    y_cursor = pad_top
    for row, width, height in zip(rows, row_w, row_h):
        x = (canvas_w - width) // 2
        baseline = y_cursor + height
        for scene, img in row:
            w, h = img.size
            y = baseline - h  # bottom aligned within the row
            sh = shadow((w, h), 22, 22)
            canvas.paste(sh, (x - 66, y - 52), sh)
            canvas.paste(rounded(img, 22), (x, y), rounded(img, 22))

            label_y = baseline + 26
            bold = font(28, True)
            draw.text((x, label_y), scene.label.upper(), font=bold, fill=INK)
            draw.text(
                (x + draw.textlength(scene.label.upper(), font=bold) + 14,
                 label_y + 2),
                f"{scene.width} x {scene.height}",
                font=font(24),
                fill=MUTED,
            )
            draw.text((x, label_y + 40), scene.note, font=font(26), fill=MUTED)
            x += w + gap_x
        y_cursor = baseline + label_block + gap_y

    # Keep the final image wide but not absurd.
    max_w = 2600
    if canvas.size[0] > max_w:
        h = round(canvas.size[1] * max_w / canvas.size[0])
        canvas = canvas.resize((max_w, h), Image.LANCZOS)

    OUT.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(OUT, optimize=True)
    shutil.rmtree(tmp, ignore_errors=True)
    kb = OUT.stat().st_size / 1024
    print(f"wrote {OUT.relative_to(ROOT)}  {canvas.size[0]}x{canvas.size[1]}  {kb:.0f} KB")


if __name__ == "__main__":
    main()
