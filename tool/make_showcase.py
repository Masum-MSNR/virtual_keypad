"""Capture each keyboard on its own, then stitch them into sheets.

Every scene renders a single keyboard at an exact size and is captured at a
viewport to match, so a shot contains the keyboard and nothing else. Shots are
composited at native scale and bottom aligned within their row, which keeps the
real size relationship between a 760px desktop keyboard and a 320px PIN pad.

Both sheets are emitted at the same canvas size so they sit together in a
package gallery.

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
from dataclasses import dataclass, field
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parent.parent
WEB = ROOT / "example" / "build" / "web"
PREVIEWS = ROOT / "previews"
PORT = 8139
DPR = 2

# Both sheets land on exactly this canvas.
CANVAS = (2600, 1500)

BG_TOP = (243, 243, 250)
BG_BOTTOM = (231, 231, 244)
INK = (27, 27, 37)
MUTED = (120, 120, 138)

BROWSERS = [
    r"C:\Program Files\Google\Chrome\Application\chrome.exe",
    r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
    r"C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe",
    "/usr/bin/google-chrome",
    "/usr/bin/chromium",
]


@dataclass(frozen=True)
class Scene:
    key: str
    label: str
    note: str
    width: int
    height: int


@dataclass
class Sheet:
    out: str
    rows: list[list[Scene]] = field(default_factory=list)


LAYOUTS = Sheet(
    "showcase-devices.png",
    [
        [
            Scene("desktop", "Desktop", "Email layout, wide", 760, 330),
            Scene("emoji", "Emoji", "Colour emoji page", 460, 330),
            Scene("pin", "PIN pad", "Custom layout, dark", 320, 330),
        ],
        [
            Scene("phone", "Phone", "QWERTY", 390, 330),
            Scene("arabic", "Arabic", "Right to left", 390, 330),
            Scene("kiosk", "Kiosk", "Numeric, themed", 460, 330),
        ],
    ],
)


def _lang(code: str, label: str, note: str) -> Scene:
    return Scene(f"lang-{code}", label, note, 430, 290)


LANGUAGES = Sheet(
    "showcase-languages.png",
    [
        [
            # Latin layout names, not native script: the caption font has no
            # Bengali, Devanagari, or Hangul glyphs and would render tofu.
            _lang("bn", "Bengali", "Bengali script"),
            _lang("hi", "Hindi", "Devanagari"),
            _lang("ru", "Russian", "JCUKEN, Cyrillic"),
        ],
        [
            _lang("ko", "Korean", "Dubeolsik, Hangul"),
            _lang("th", "Thai", "Kedmanee"),
            _lang("fr", "French", "AZERTY"),
        ],
    ],
)

SHEETS = [LAYOUTS, LANGUAGES]


def find_browser() -> str:
    env = os.environ.get("CHROME_EXECUTABLE")
    if env and Path(env).exists():
        return env
    for candidate in BROWSERS:
        if Path(candidate).exists():
            return candidate
    sys.exit("No Chromium browser found. Set CHROME_EXECUTABLE.")


def serve(directory: Path) -> socketserver.TCPServer:
    def handler(*a, **kw):
        return http.server.SimpleHTTPRequestHandler(*a, directory=str(directory), **kw)

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
        [pad, pad, pad + size[0], pad + size[1]], radius=radius, fill=(0, 0, 0, 72)
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


def gradient(size: tuple[int, int]) -> Image.Image:
    column = Image.new("RGB", (1, size[1]))
    for y in range(size[1]):
        t = y / max(1, size[1] - 1)
        column.putpixel(
            (0, y), tuple(round(a + (b - a) * t) for a, b in zip(BG_TOP, BG_BOTTOM))
        )
    return column.resize(size)


def compose(sheet: Sheet, shots: dict[str, Image.Image]) -> Image.Image:
    """Lay the rows out at native scale, then fit the block to the canvas."""
    gap_x, gap_y, label_block = 60, 96, 104

    rows = [[(s, shots[s.key]) for s in row] for row in sheet.rows]
    for row in rows:
        heights = {i.size[1] for _, i in row}
        assert len(heights) == 1, f"row heights differ: {heights}"
    row_w = [sum(i.size[0] for _, i in r) + gap_x * (len(r) - 1) for r in rows]
    row_h = [max(i.size[1] for _, i in r) for r in rows]

    block_w = max(row_w)
    block_h = sum(h + label_block for h in row_h) + gap_y * (len(rows) - 1)

    block = Image.new("RGBA", (block_w, block_h), (0, 0, 0, 0))
    draw = ImageDraw.Draw(block)

    y_cursor = 0
    for row, width, height in zip(rows, row_w, row_h):
        x = (block_w - width) // 2
        baseline = y_cursor + height
        for scene, img in row:
            w, h = img.size
            y = baseline - h  # bottom aligned within the row
            sh = shadow((w, h), 22, 20)
            block.alpha_composite(sh, (max(0, x - 60), max(0, y - 48)))
            block.alpha_composite(rounded(img, 22), (x, y))

            label_y = baseline + 22
            bold = font(30, True)
            draw.text((x, label_y), scene.label.upper(), font=bold, fill=INK)
            draw.text(
                (x + draw.textlength(scene.label.upper(), font=bold) + 14, label_y + 3),
                f"{scene.width} x {scene.height}",
                font=font(25),
                fill=MUTED,
            )
            draw.text((x, label_y + 42), scene.note, font=font(27), fill=MUTED)
            x += w + gap_x
        y_cursor = baseline + label_block + gap_y

    # Fill as much of the canvas as the margin allows, rather than leaving the
    # block at whatever size the keyboards happened to add up to.
    margin = 70
    fit = min(
        (CANVAS[0] - margin * 2) / block_w,
        (CANVAS[1] - margin * 2) / block_h,
    )
    block = block.resize(
        (round(block_w * fit), round(block_h * fit)), Image.LANCZOS
    )

    canvas = gradient(CANVAS).convert("RGBA")
    canvas.alpha_composite(
        block,
        ((CANVAS[0] - block.size[0]) // 2, (CANVAS[1] - block.size[1]) // 2),
    )
    return canvas.convert("RGB")


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
        shots: dict[str, Image.Image] = {}
        for sheet in SHEETS:
            for row in sheet.rows:
                for scene in row:
                    img = capture(browser, scene, tmp / f"{scene.key}.png")
                    shots[scene.key] = img
                    print(f"  captured {scene.key:12} {img.size[0]}x{img.size[1]}")
    finally:
        server.shutdown()

    PREVIEWS.mkdir(parents=True, exist_ok=True)
    for sheet in SHEETS:
        out = PREVIEWS / sheet.out
        image = compose(sheet, shots)
        image.save(out, optimize=True)
        print(
            f"wrote {out.relative_to(ROOT)}  "
            f"{image.size[0]}x{image.size[1]}  {out.stat().st_size / 1024:.0f} KB"
        )

    shutil.rmtree(tmp, ignore_errors=True)


if __name__ == "__main__":
    main()
