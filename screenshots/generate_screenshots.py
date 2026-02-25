#!/usr/bin/env python3
"""Generate App Store screenshots with Japanese captions.

Design direction based on AD_CREATIVE_STRATEGY.md:
- Background: Teal gradient (app brand color)
- Accent: Amber for keyword emphasis
- Captions: ASO keyword-optimized, value-proposition style
- Sequence: prioritized by conversion impact (first 3 are critical)
"""

from PIL import Image, ImageDraw, ImageFont
import os

# --- Config ---
CANVAS_W, CANVAS_H = 1260, 2736

# Teal gradient (app brand color)
BG_COLOR_TOP = (13, 148, 136)       # #0D9488
BG_COLOR_BOT = (8, 100, 92)         # darker teal for depth

ACCENT_AMBER = (245, 158, 11)       # #F59E0B
TEXT_WHITE = (255, 255, 255)
TEXT_LIGHT = (204, 235, 232)         # light teal-tinted gray for subtitles

CORNER_RADIUS = 40
SCREENSHOT_SCALE = 0.82
STATUS_BAR_H = 135  # pixels to cover in base screenshot (pre-scale)

HEADLINE_PADDING = 60       # px each side → 120px total
SUBTITLE_PADDING = 40       # px each side → 80px total
MIN_HEADLINE_SIZE = 60
MIN_SUBTITLE_SIZE = 32

FONT_BOLD = "/System/Library/Fonts/ヒラギノ角ゴシック W6.ttc"
FONT_REGULAR = "/System/Library/Fonts/ヒラギノ角ゴシック W3.ttc"

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
INPUT_DIR = os.path.join(BASE_DIR, "base")
OUTPUT_DIR = os.path.join(BASE_DIR, "ja")

# Screenshot sequence optimized per AD_CREATIVE_STRATEGY.md section 2-A
# First 3 screenshots are critical (90% of users don't scroll past #3)
SCREENSHOTS = [
    {
        "file": "IMG_0075.PNG",
        "headline": "一包化も個別薬も、まとめて管理",
        "subtitle": "服薬リマインダー・在庫管理・週間レポート",
        "accent_word": "まとめて管理",
        "output": "01_home.png",
    },
    {
        "file": "IMG_0076.PNG",
        "headline": "分包薬もワンタップで服薬記録",
        "subtitle": "一包化にも個別薬にも対応",
        "accent_word": "ワンタップ",
        "output": "02_medication.png",
    },
    {
        "file": "IMG_0078.PNG",
        "headline": "離れた家族の服薬を見守り",
        "subtitle": "飲み忘れ・在庫不足をリアルタイム通知",
        "accent_word": "見守り",
        "output": "03_caregiver.png",
    },
    {
        "file": "IMG_0077.PNG",
        "headline": "週間レポートで服薬率を確認",
        "subtitle": "お薬ごとの服薬状況をグラフで可視化",
        "accent_word": "服薬率",
        "output": "04_weekly_report.png",
    },
    {
        "file": "IMG_0079.PNG",
        "headline": "海外旅行中も時差に自動対応",
        "subtitle": "タイムゾーン自動調整トラベルモード",
        "accent_word": "自動対応",
        "output": "05_travel.png",
    },
    {
        "file": "about_app.png",
        "headline": "あなたの健康データを安全に保護",
        "subtitle": "プライバシーを守る安心設計",
        "accent_word": "安全に保護",
        "output": "06_privacy.png",
    },
]


def create_gradient_bg(w, h, color_top, color_bot):
    """Create a vertical gradient background."""
    img = Image.new("RGB", (w, h), color_top)
    pixels = img.load()
    for y in range(h):
        ratio = y / h
        r = int(color_top[0] + (color_bot[0] - color_top[0]) * ratio)
        g = int(color_top[1] + (color_bot[1] - color_top[1]) * ratio)
        b = int(color_top[2] + (color_bot[2] - color_top[2]) * ratio)
        for x in range(w):
            pixels[x, y] = (r, g, b)
    return img


def round_corners(img, radius):
    """Apply rounded corners to an image."""
    mask = Image.new("L", img.size, 0)
    draw = ImageDraw.Draw(mask)
    draw.rounded_rectangle([(0, 0), img.size], radius=radius, fill=255)
    result = img.copy()
    result.putalpha(mask)
    return result


def draw_text_with_accent(draw, text, accent_word, y, font, accent_color, base_color, canvas_w):
    """Draw centered text with an accented word."""
    if accent_word and accent_word in text:
        parts = text.split(accent_word)
        before = parts[0]
        after = accent_word.join(parts[1:])

        before_bbox = font.getbbox(before) if before else (0, 0, 0, 0)
        accent_bbox = font.getbbox(accent_word)
        after_bbox = font.getbbox(after) if after else (0, 0, 0, 0)

        before_w = before_bbox[2] - before_bbox[0] if before else 0
        accent_w = accent_bbox[2] - accent_bbox[0]
        after_w = after_bbox[2] - after_bbox[0] if after else 0
        total_w = before_w + accent_w + after_w

        x_start = (canvas_w - total_w) // 2

        if before:
            draw.text((x_start, y), before, fill=base_color, font=font)
            x_start += before_w
        draw.text((x_start, y), accent_word, fill=accent_color, font=font)
        x_start += accent_w
        if after:
            draw.text((x_start, y), after, fill=base_color, font=font)
    else:
        bbox = font.getbbox(text)
        text_w = bbox[2] - bbox[0]
        x = (canvas_w - text_w) // 2
        draw.text((x, y), text, fill=base_color, font=font)


def fit_font(font_path, text, max_size, min_size, available_w):
    """Shrink font until text fits within available_w. Returns (font, size)."""
    size = max_size
    while size > min_size:
        font = ImageFont.truetype(font_path, size)
        bbox = font.getbbox(text)
        text_w = bbox[2] - bbox[0]
        if text_w <= available_w:
            return font, size
        size -= 2
    return ImageFont.truetype(font_path, min_size), min_size


def generate_screenshot(config):
    """Generate a single App Store screenshot."""
    headline_available_w = CANVAS_W - HEADLINE_PADDING * 2
    subtitle_available_w = CANVAS_W - SUBTITLE_PADDING * 2

    headline_font, _ = fit_font(
        FONT_BOLD, config["headline"], 88, MIN_HEADLINE_SIZE, headline_available_w
    )
    subtitle_font, _ = fit_font(
        FONT_REGULAR, config["subtitle"], 48, MIN_SUBTITLE_SIZE, subtitle_available_w
    )

    canvas = create_gradient_bg(CANVAS_W, CANVAS_H, BG_COLOR_TOP, BG_COLOR_BOT)
    draw = ImageDraw.Draw(canvas)

    # Headline
    headline_y = 180
    draw_text_with_accent(
        draw, config["headline"], config["accent_word"],
        headline_y, headline_font, ACCENT_AMBER, TEXT_WHITE, CANVAS_W
    )

    # Subtitle
    subtitle_y = headline_y + 120
    subtitle_bbox = subtitle_font.getbbox(config["subtitle"])
    subtitle_w = subtitle_bbox[2] - subtitle_bbox[0]
    subtitle_x = (CANVAS_W - subtitle_w) // 2
    draw.text((subtitle_x, subtitle_y), config["subtitle"], fill=TEXT_LIGHT, font=subtitle_font)

    # Screenshot
    screenshot_path = os.path.join(INPUT_DIR, config["file"])
    screenshot = Image.open(screenshot_path).convert("RGBA")

    target_w = int(CANVAS_W * SCREENSHOT_SCALE)
    scale = target_w / screenshot.width
    target_h = int(screenshot.height * scale)
    screenshot = screenshot.resize((target_w, target_h), Image.LANCZOS)

    # Cover status bar to hide "Trip Wallet" and other system UI text
    ss_draw = ImageDraw.Draw(screenshot)
    cover_h = int(STATUS_BAR_H * scale)
    ss_draw.rectangle([(0, 0), (target_w, cover_h)], fill=(255, 255, 255, 255))

    screenshot = round_corners(screenshot, CORNER_RADIUS)

    ss_x = (CANVAS_W - target_w) // 2
    ss_y = subtitle_y + 120

    if ss_y + target_h > CANVAS_H:
        crop_h = CANVAS_H - ss_y
        screenshot = screenshot.crop((0, 0, target_w, crop_h))

    canvas.paste(screenshot, (ss_x, ss_y), screenshot)

    # Bottom fade
    fade_height = 80
    fade_start_y = CANVAS_H - fade_height
    overlay = Image.new("RGBA", (CANVAS_W, fade_height), (0, 0, 0, 0))
    overlay_pixels = overlay.load()
    for y in range(fade_height):
        alpha = int(255 * (y / fade_height))
        for x in range(CANVAS_W):
            overlay_pixels[x, y] = (BG_COLOR_BOT[0], BG_COLOR_BOT[1], BG_COLOR_BOT[2], alpha)

    canvas = canvas.convert("RGBA")
    canvas.paste(overlay, (0, fade_start_y), overlay)

    output_path = os.path.join(OUTPUT_DIR, config["output"])
    canvas.convert("RGB").save(output_path, "PNG", quality=95)
    print(f"Generated: {output_path}")
    return output_path


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    print(f"Canvas: {CANVAS_W}x{CANVAS_H}")
    print(f"Input:  {INPUT_DIR}")
    print(f"Output: {OUTPUT_DIR}")
    print()

    for config in SCREENSHOTS:
        generate_screenshot(config)

    print(f"\nDone! {len(SCREENSHOTS)} screenshots generated in {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
