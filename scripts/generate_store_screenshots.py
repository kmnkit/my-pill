#!/usr/bin/env python3
"""App Store marketing screenshot generator for くすりどき.

Composites pre-framed screenshots (RGBA, with iPhone frame) onto a teal
gradient background and adds a Japanese caption.
Output: 1290×2796 RGB PNG (App Store 6.7-inch).

Usage:
    python3 scripts/generate_store_screenshots.py
"""

import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont, __version__ as PIL_VERSION

# --- Version guard ---
_major, _minor = (int(v) for v in PIL_VERSION.split(".")[:2])
if (_major, _minor) < (10, 1):
    sys.exit(f"ERROR: Pillow 10.1+ required for Variable Font support (have {PIL_VERSION})")

# --- Paths ---
ROOT = Path(__file__).parent.parent
SRC_DIR = ROOT / "assets" / "marketing" / "screenshots" / "frame_added"
OUT_DIR = ROOT / "assets" / "marketing" / "store"
FONT_PATH = ROOT / "assets" / "fonts" / "NotoSansJP-Regular.ttf"

# --- Canvas ---
W, H = 1290, 2796

# --- Colors ---
GRAD_TOP = (13, 148, 136)    # #0D9488 teal
GRAD_BOT = (20, 184, 166)    # #14B8A6 teal lighter
CAPTION_CLR = (255, 255, 255) # #FFFFFF white (primary)
ACCENT_CLR  = (245, 158, 11)  # #F59E0B amber (accent bar)

# --- Layout ---
CAPTION_ZONE = 280   # px reserved at top for caption text
CAPTION_Y = 88       # distance from top canvas edge to text top
FONT_SIZE = 62
MAX_TEXT_W = 1170    # W - 2*60 side padding
BOTTOM_MARGIN = 60   # px below phone frame

# --- Screenshot sequence (6 frames) ---
# caption_parts: list of (text, color) — white primary, amber accent on key phrase
W_CLR = CAPTION_CLR   # alias for readability
A_CLR = ACCENT_CLR

SCREENSHOTS = [
    {
        "src": "01_home-portrait.png",
        "out": "01_home_store.png",
        "caption_parts": [("今日のお薬、", W_CLR), ("これだけ見ればOK。", A_CLR)],
    },
    {
        "src": "07_medications_list-portrait.png",
        "out": "02_medications_store.png",
        "caption_parts": [("お薬をまとめて管理。", W_CLR), ("在庫もひと目で。", A_CLR)],
    },
    {
        "src": "04_family-portrait.png",
        "out": "03_family_store.png",
        "caption_parts": [("離れた家族の服薬を", W_CLR), ("見守り。", A_CLR)],
    },
    {
        "src": "03_weekly_report-portrait.png",
        "out": "04_weekly_report_store.png",
        "caption_parts": [("週間レポートで", W_CLR), ("服薬率を確認。", A_CLR)],
    },
    {
        "src": "06_travel-portrait.png",
        "out": "05_travel_store.png",
        "caption_parts": [("海外旅行中も", W_CLR), ("時差に自動対応。", A_CLR)],
    },
    {
        "src": "08_settings-portrait.png",
        "out": "06_settings_store.png",
        "caption_parts": [("通知もフォントも、", W_CLR), ("あなた好みに。", A_CLR)],
    },
]


def make_gradient() -> Image.Image:
    """Vertical teal gradient: GRAD_TOP → GRAD_BOT."""
    strip = Image.new("RGB", (1, H))
    px = strip.load()
    for y in range(H):
        t = y / (H - 1)
        px[0, y] = tuple(round(a + t * (b - a)) for a, b in zip(GRAD_TOP, GRAD_BOT))
    return strip.resize((W, H), Image.NEAREST)


def load_font(size: int) -> ImageFont.FreeTypeFont:
    """Load NotoSansJP with Bold variation when available."""
    font = ImageFont.truetype(str(FONT_PATH), size)
    try:
        font.set_variation_by_name("Bold")
    except (OSError, AttributeError):
        pass  # not a variable font – use as-is
    return font


def draw_caption(draw: ImageDraw.ImageDraw, parts: list) -> None:
    """Render multi-colored caption centered horizontally.

    parts: list of (text, color) tuples drawn left-to-right on one line.
    Shrinks font size uniformly if total width overflows MAX_TEXT_W.
    """
    full_text = "".join(t for t, _ in parts)

    size = FONT_SIZE
    while size >= 24:
        font = load_font(size)
        bbox = draw.textbbox((0, 0), full_text, font=font)
        if bbox[2] - bbox[0] <= MAX_TEXT_W:
            break
        size -= 2

    bbox = draw.textbbox((0, 0), full_text, font=font)
    x0 = (W - (bbox[2] - bbox[0])) // 2 - bbox[0]
    y  = CAPTION_Y - bbox[1]

    # Draw each part; advance x by measuring prefix width for accuracy
    prefix = ""
    for text, color in parts:
        if prefix:
            pb = draw.textbbox((0, 0), prefix, font=font)
            x = x0 + (pb[2] - pb[0])
        else:
            x = x0
        draw.text((x, y), text, font=font, fill=color)
        prefix += text


def generate(entry: dict) -> bool:
    src = SRC_DIR / entry["src"]
    out = OUT_DIR / entry["out"]

    if not src.exists():
        print(f"  SKIP: {src.name} not found")
        return False

    # 1. Gradient background
    canvas = make_gradient()

    # 2. Scale framed image (RGBA) to fit in available area below caption zone
    framed = Image.open(src).convert("RGBA")
    avail_h = H - CAPTION_ZONE - BOTTOM_MARGIN
    scale = min(W / framed.width, avail_h / framed.height)
    fw = round(framed.width * scale)
    fh = round(framed.height * scale)
    framed = framed.resize((fw, fh), Image.LANCZOS)

    fx = (W - fw) // 2
    fy = CAPTION_ZONE + (avail_h - fh) // 2

    # 3. Composite pre-framed image onto gradient using its alpha channel
    canvas.paste(framed, (fx, fy), mask=framed.split()[3])

    # 4. Caption text (white + amber accent)
    draw_caption(ImageDraw.Draw(canvas), entry["caption_parts"])

    # 5. Save as RGB PNG (App Store requires RGB, not RGBA)
    assert canvas.size == (W, H), f"Size mismatch: {canvas.size}"
    assert canvas.mode == "RGB", f"Mode mismatch: {canvas.mode}"
    canvas.save(str(out), "PNG")
    print(f"  OK  {out.name}  ({W}x{H} {canvas.mode})")
    return True


def main() -> None:
    print(f"Pillow {PIL_VERSION} | canvas {W}x{H}")
    OUT_DIR.mkdir(parents=True, exist_ok=True)

    ok = sum(generate(e) for e in SCREENSHOTS)
    print(f"\n{ok}/{len(SCREENSHOTS)} screenshots generated")
    print(f"Output: {OUT_DIR}")


if __name__ == "__main__":
    main()
