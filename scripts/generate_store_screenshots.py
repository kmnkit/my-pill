#!/usr/bin/env python3
"""App Store marketing screenshot generator for くすりどき.

Takes raw simulator screenshots and composites them onto a teal gradient
background with a Japanese caption, producing App Store 6.7-inch images.

Input:  assets/marketing/screenshots/ja/*.png  (1290×2796, RGB)
Output: assets/marketing/store/*_store.png      (1290×2796, RGB)

Usage:
    python3 scripts/generate_store_screenshots.py
"""

import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont, ImageFilter, __version__ as PIL_VERSION

# --- Version guard ---
_major, _minor = (int(v) for v in PIL_VERSION.split(".")[:2])
if (_major, _minor) < (10, 1):
    sys.exit(f"ERROR: Pillow 10.1+ required (have {PIL_VERSION})")

# --- Paths ---
ROOT    = Path(__file__).parent.parent
SRC_DIR = ROOT / "assets" / "marketing" / "screenshots" / "ja"
OUT_DIR = ROOT / "assets" / "marketing" / "store"
FONT_PATH = ROOT / "assets" / "fonts" / "NotoSansJP-Regular.ttf"

# --- Canvas (App Store 6.7-inch) ---
W, H = 1290, 2796

# --- Colors ---
GRAD_TOP    = (13, 148, 136)    # #0D9488 teal
GRAD_BOT    = (5,  100,  95)    # darker teal at bottom
CAPTION_CLR = (255, 255, 255)   # white
ACCENT_CLR  = (245, 158,  11)   # amber

# --- Layout ---
CAPTION_ZONE   = 300    # px at top reserved for text
CAPTION_Y      = 90     # distance from top to text baseline start
FONT_SIZE      = 66
MAX_TEXT_W     = 1150   # W - 2*70 padding
SCREEN_PADDING = 40     # horizontal padding each side for the screenshot
BOTTOM_MARGIN  = 80     # gap between screen bottom and canvas bottom
CORNER_RADIUS  = 52     # rounded corners on the screenshot (matches iPhone 15)
SHADOW_BLUR    = 18     # drop shadow blur radius

W_CLR = CAPTION_CLR
A_CLR = ACCENT_CLR

# --- Screenshot definitions ---
SCREENSHOTS = [
    {
        "src": "01_home.png",
        "out": "01_home_store.png",
        "caption_parts": [("今日のお薬、", W_CLR), ("これだけ見ればOK。", A_CLR)],
    },
    {
        "src": "02_medications_list.png",
        "out": "02_medications_store.png",
        "caption_parts": [("お薬をまとめて管理。", W_CLR), ("在庫もひと目で。", A_CLR)],
    },
    {
        "src": "03_weekly_summary.png",
        "out": "03_weekly_store.png",
        "caption_parts": [("週間レポートで", W_CLR), ("服薬率を確認。", A_CLR)],
    },
    {
        "src": "04_caregiver.png",
        "out": "04_family_store.png",
        "caption_parts": [("離れた家族の服薬を", W_CLR), ("見守り。", A_CLR)],
    },
    {
        "src": "05_travel_mode.png",
        "out": "05_travel_store.png",
        "caption_parts": [("海外旅行中も", W_CLR), ("時差に自動対応。", A_CLR)],
    },
]


def make_gradient() -> Image.Image:
    """Vertical teal gradient."""
    strip = Image.new("RGB", (1, H))
    px = strip.load()
    for y in range(H):
        t = y / (H - 1)
        px[0, y] = tuple(round(a + t * (b - a)) for a, b in zip(GRAD_TOP, GRAD_BOT))
    return strip.resize((W, H), Image.NEAREST)


def rounded_mask(w: int, h: int, radius: int) -> Image.Image:
    """RGBA mask with rounded corners (anti-aliased via 4× supersample)."""
    scale = 4
    big = Image.new("L", (w * scale, h * scale), 0)
    draw = ImageDraw.Draw(big)
    draw.rounded_rectangle([0, 0, w * scale - 1, h * scale - 1],
                           radius=radius * scale, fill=255)
    return big.resize((w, h), Image.LANCZOS)


def add_shadow(img: Image.Image, blur: int, offset: tuple[int, int] = (0, 12)) -> Image.Image:
    """Return a new RGBA image with a soft drop shadow beneath img."""
    ox, oy = offset
    pad = blur * 2
    out_w = img.width  + pad * 2
    out_h = img.height + pad * 2
    shadow = Image.new("RGBA", (out_w, out_h), (0, 0, 0, 0))
    # Shadow shape (black, semi-transparent)
    silhouette = Image.new("RGBA", img.size, (0, 0, 0, 160))
    shadow.paste(silhouette, (pad + ox, pad + oy))
    shadow = shadow.filter(ImageFilter.GaussianBlur(blur))
    # Paste actual image on top
    shadow.paste(img, (pad, pad), mask=img if img.mode == "RGBA" else None)
    return shadow


def load_font(size: int) -> ImageFont.FreeTypeFont:
    font = ImageFont.truetype(str(FONT_PATH), size)
    try:
        font.set_variation_by_name("Bold")
    except (OSError, AttributeError):
        pass
    return font


def draw_caption(draw: ImageDraw.ImageDraw, parts: list) -> None:
    """Render two-part colored caption, centered. Auto-shrinks if too wide."""
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
        print(f"  SKIP  {src.name} — not found")
        return False

    raw = Image.open(src).convert("RGB")

    # --- Scale screenshot to fit within canvas minus padding ---
    avail_w = W - SCREEN_PADDING * 2
    avail_h = H - CAPTION_ZONE - BOTTOM_MARGIN
    scale   = min(avail_w / raw.width, avail_h / raw.height)
    sw = round(raw.width  * scale)
    sh = round(raw.height * scale)
    screen = raw.resize((sw, sh), Image.LANCZOS)

    # --- Apply rounded corners ---
    mask = rounded_mask(sw, sh, CORNER_RADIUS)
    screen_rgba = screen.convert("RGBA")
    screen_rgba.putalpha(mask)

    # --- Drop shadow ---
    shadowed = add_shadow(screen_rgba, blur=SHADOW_BLUR)
    shadow_w, shadow_h = shadowed.size
    pad = SHADOW_BLUR * 2

    # --- Gradient background ---
    canvas = make_gradient()

    # --- Center screenshot horizontally, align top of screen to caption zone ---
    sx = (W - sw) // 2 - pad
    sy = CAPTION_ZONE - pad
    canvas.paste(shadowed, (sx, sy), mask=shadowed.split()[3])

    # --- Caption ---
    draw_caption(ImageDraw.Draw(canvas), entry["caption_parts"])

    # --- Save ---
    assert canvas.size == (W, H)
    assert canvas.mode == "RGB"
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    canvas.save(str(out), "PNG")
    print(f"  OK    {out.name}  ({W}×{H})")
    return True


def main() -> None:
    print(f"Pillow {PIL_VERSION} | canvas {W}×{H}")
    print(f"Source: {SRC_DIR}")
    ok = sum(generate(e) for e in SCREENSHOTS)
    print(f"\n{ok}/{len(SCREENSHOTS)} generated → {OUT_DIR}")


if __name__ == "__main__":
    main()
