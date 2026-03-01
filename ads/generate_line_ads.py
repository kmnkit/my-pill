"""
LINE Ads Creative Generator for Kusuridoki (くすりどき)
Generates Card (1200x628) and Square (1080x1080) ad images
for the caregiver segment (40-60 age group).
"""

from PIL import Image, ImageDraw, ImageFont, ImageFilter
import os

# Paths
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_DIR = os.path.dirname(BASE_DIR)
SCREENSHOTS_DIR = os.path.join(PROJECT_DIR, "screenshots", "ja")
ICON_PATH = os.path.join(PROJECT_DIR, "assets", "icons", "app_icon.png")
OUTPUT_DIR = os.path.join(BASE_DIR, "line")

# Colors (matching app theme)
TEAL_DARK = (13, 120, 112)       # #0D7870
TEAL_PRIMARY = (13, 148, 136)    # #0D9488
TEAL_LIGHT = (20, 184, 166)      # #14B8A6
WHITE = (255, 255, 255)
WHITE_90 = (255, 255, 255, 230)
BLACK = (0, 0, 0)
DARK_TEXT = (30, 30, 30)
AMBER = (245, 158, 11)           # #F59E0B
LIGHT_GRAY = (200, 200, 200)
DISCLAIMER_GRAY = (180, 180, 180)

# Fonts
FONT_BOLD = "/System/Library/Fonts/ヒラギノ角ゴシック W7.ttc"
FONT_MEDIUM = "/System/Library/Fonts/ヒラギノ角ゴシック W5.ttc"
FONT_REGULAR = "/System/Library/Fonts/ヒラギノ角ゴシック W3.ttc"
FONT_LIGHT = "/System/Library/Fonts/ヒラギノ角ゴシック W2.ttc"


def load_font(path, size):
    try:
        return ImageFont.truetype(path, size)
    except Exception:
        return ImageFont.load_default()


def create_rounded_rectangle(draw, xy, radius, fill):
    """Draw a rounded rectangle."""
    x0, y0, x1, y1 = xy
    draw.rounded_rectangle(xy, radius=radius, fill=fill)


def create_gradient_background(width, height, color_top, color_bottom):
    """Create a vertical gradient background."""
    img = Image.new("RGB", (width, height))
    for y in range(height):
        ratio = y / height
        r = int(color_top[0] + (color_bottom[0] - color_top[0]) * ratio)
        g = int(color_top[1] + (color_bottom[1] - color_top[1]) * ratio)
        b = int(color_top[2] + (color_bottom[2] - color_top[2]) * ratio)
        for x in range(width):
            img.putpixel((x, y), (r, g, b))
    return img


def create_gradient_background_fast(width, height, color_top, color_bottom):
    """Create a vertical gradient using line drawing (much faster)."""
    img = Image.new("RGB", (width, height))
    draw = ImageDraw.Draw(img)
    for y in range(height):
        ratio = y / height
        r = int(color_top[0] + (color_bottom[0] - color_top[0]) * ratio)
        g = int(color_top[1] + (color_bottom[1] - color_top[1]) * ratio)
        b = int(color_top[2] + (color_bottom[2] - color_top[2]) * ratio)
        draw.line([(0, y), (width, y)], fill=(r, g, b))
    return img


def prepare_screenshot(screenshot_path, target_height, crop_top_ratio=0.12, crop_bottom_ratio=0.05):
    """Load and crop a screenshot to show just the app content."""
    img = Image.open(screenshot_path)
    w, h = img.size
    # Crop off the ASO header text and bottom nav
    top = int(h * crop_top_ratio)
    bottom = int(h * (1 - crop_bottom_ratio))
    img = img.crop((0, top, w, bottom))
    # Resize to target height
    ratio = target_height / img.size[1]
    new_w = int(img.size[0] * ratio)
    img = img.resize((new_w, target_height), Image.LANCZOS)
    return img


def add_phone_frame_shadow(img, screenshot, x, y):
    """Place screenshot with a subtle shadow effect."""
    # Create shadow
    shadow_offset = 6
    shadow_color = (0, 0, 0, 40)
    shadow = Image.new("RGBA", (screenshot.width + 20, screenshot.height + 20), (0, 0, 0, 0))
    shadow_draw = ImageDraw.Draw(shadow)
    shadow_draw.rounded_rectangle(
        [shadow_offset, shadow_offset, screenshot.width + shadow_offset + 10, screenshot.height + shadow_offset + 10],
        radius=20, fill=shadow_color
    )
    shadow = shadow.filter(ImageFilter.GaussianBlur(radius=8))

    # Paste shadow then screenshot
    if img.mode != "RGBA":
        img = img.convert("RGBA")
    img.paste(shadow, (x - 10, y - 5), shadow)

    # Round the screenshot corners
    mask = Image.new("L", screenshot.size, 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.rounded_rectangle([0, 0, screenshot.width, screenshot.height], radius=16, fill=255)
    img.paste(screenshot, (x, y), mask)
    return img


def draw_app_icon(img, draw, x, y, size=56):
    """Draw the app icon at position."""
    icon = Image.open(ICON_PATH).convert("RGBA")
    icon = icon.resize((size, size), Image.LANCZOS)
    # Round corners
    mask = Image.new("L", (size, size), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.rounded_rectangle([0, 0, size, size], radius=int(size * 0.22), fill=255)
    if img.mode != "RGBA":
        img = img.convert("RGBA")
    img.paste(icon, (x, y), mask)
    return img


def draw_cta_button(draw, x, y, text, font, bg_color=WHITE, text_color=TEAL_PRIMARY, padding_h=30, padding_v=10):
    """Draw a CTA button."""
    bbox = draw.textbbox((0, 0), text, font=font)
    tw = bbox[2] - bbox[0]
    th = bbox[3] - bbox[1]
    btn_w = tw + padding_h * 2
    btn_h = th + padding_v * 2
    draw.rounded_rectangle(
        [x, y, x + btn_w, y + btn_h],
        radius=btn_h // 2, fill=bg_color
    )
    draw.text((x + padding_h, y + padding_v), text, fill=text_color, font=font)
    return btn_w, btn_h


def draw_free_badge(draw, x, y, font):
    """Draw a 無料 badge."""
    text = "無料"
    bbox = draw.textbbox((0, 0), text, font=font)
    tw = bbox[2] - bbox[0]
    th = bbox[3] - bbox[1]
    pad = 8
    draw.rounded_rectangle(
        [x, y, x + tw + pad * 2, y + th + pad * 2],
        radius=6, fill=AMBER
    )
    draw.text((x + pad, y + pad), text, fill=WHITE, font=font)


# ============================================================
# Creative 1: 見守り訴求 (Caregiver emotional appeal)
# ============================================================

def create_card_mimamori():
    """Card format (1200x628) - 見守り訴求"""
    W, H = 1200, 628
    img = create_gradient_background_fast(W, H, TEAL_DARK, TEAL_PRIMARY)
    img = img.convert("RGBA")
    draw = ImageDraw.Draw(img)

    # Fonts
    font_main = load_font(FONT_BOLD, 52)
    font_sub = load_font(FONT_MEDIUM, 24)
    font_app_name = load_font(FONT_MEDIUM, 22)
    font_disclaimer = load_font(FONT_LIGHT, 14)
    font_badge = load_font(FONT_BOLD, 18)
    font_cta = load_font(FONT_BOLD, 20)

    # Left side: Text content
    # Main copy (2 lines)
    main_y = 100
    draw.text((60, main_y), "離れていても、", fill=WHITE, font=font_main)
    draw.text((60, main_y + 70), "\"飲んだよ\"が届く。", fill=WHITE, font=font_main)

    # Sub copy
    draw.text((60, main_y + 170), "家族の服薬を見守れるアプリ", fill=(200, 235, 232), font=font_sub)

    # App icon + name + badge
    icon_y = main_y + 240
    img = draw_app_icon(img, draw, 60, icon_y, size=48)
    draw = ImageDraw.Draw(img)  # Refresh draw after paste
    draw.text((120, icon_y + 6), "くすりどき", fill=WHITE, font=font_app_name)
    draw_free_badge(draw, 260, icon_y + 4, font_badge)

    # CTA button
    draw_cta_button(draw, 60, icon_y + 70, "無料ダウンロード", font_cta,
                    bg_color=WHITE, text_color=TEAL_PRIMARY)

    # Right side: Screenshot
    screenshot = prepare_screenshot(
        os.path.join(SCREENSHOTS_DIR, "03_caregiver.png"),
        target_height=500, crop_top_ratio=0.14, crop_bottom_ratio=0.08
    )
    sc_x = W - screenshot.width - 40
    sc_y = (H - screenshot.height) // 2 + 20
    img = add_phone_frame_shadow(img, screenshot, sc_x, sc_y)
    draw = ImageDraw.Draw(img)

    # Disclaimer
    draw.text((60, H - 30), "※ 本アプリは医療機器ではありません", fill=DISCLAIMER_GRAY, font=font_disclaimer)

    # Save
    output = img.convert("RGB")
    output.save(os.path.join(OUTPUT_DIR, "01_mimamori_card_1200x628.png"), quality=95)
    print("Created: 01_mimamori_card_1200x628.png")


def create_square_mimamori():
    """Square format (1080x1080) - 見守り訴求"""
    W, H = 1080, 1080
    img = create_gradient_background_fast(W, H, TEAL_DARK, TEAL_PRIMARY)
    img = img.convert("RGBA")
    draw = ImageDraw.Draw(img)

    # Fonts
    font_main = load_font(FONT_BOLD, 56)
    font_sub = load_font(FONT_MEDIUM, 26)
    font_app_name = load_font(FONT_MEDIUM, 24)
    font_disclaimer = load_font(FONT_LIGHT, 15)
    font_badge = load_font(FONT_BOLD, 20)
    font_cta = load_font(FONT_BOLD, 22)

    # Top: Text
    main_y = 60
    draw.text((60, main_y), "離れていても、", fill=WHITE, font=font_main)
    draw.text((60, main_y + 75), "\"飲んだよ\"が届く。", fill=WHITE, font=font_main)
    draw.text((60, main_y + 175), "家族の服薬を見守れるアプリ", fill=(200, 235, 232), font=font_sub)

    # Center: Screenshot
    screenshot = prepare_screenshot(
        os.path.join(SCREENSHOTS_DIR, "03_caregiver.png"),
        target_height=540, crop_top_ratio=0.14, crop_bottom_ratio=0.08
    )
    sc_x = (W - screenshot.width) // 2
    sc_y = 300
    img = add_phone_frame_shadow(img, screenshot, sc_x, sc_y)
    draw = ImageDraw.Draw(img)

    # Bottom: App info + CTA
    bottom_y = H - 140
    img = draw_app_icon(img, draw, 60, bottom_y, size=50)
    draw = ImageDraw.Draw(img)
    draw.text((122, bottom_y + 8), "くすりどき", fill=WHITE, font=font_app_name)
    draw_free_badge(draw, 272, bottom_y + 6, font_badge)

    # CTA
    draw_cta_button(draw, W - 280, bottom_y + 4, "無料ダウンロード", font_cta)

    # Disclaimer
    draw.text((60, H - 35), "※ 本アプリは医療機器ではありません", fill=DISCLAIMER_GRAY, font=font_disclaimer)

    output = img.convert("RGB")
    output.save(os.path.join(OUTPUT_DIR, "01_mimamori_square_1080x1080.png"), quality=95)
    print("Created: 01_mimamori_square_1080x1080.png")


# ============================================================
# Creative 2: 一包化訴求 (Dose pack differentiation)
# ============================================================

def create_card_ippoka():
    """Card format (1200x628) - 一包化訴求"""
    W, H = 1200, 628
    img = create_gradient_background_fast(W, H, (8, 100, 95), TEAL_PRIMARY)
    img = img.convert("RGBA")
    draw = ImageDraw.Draw(img)

    font_main = load_font(FONT_BOLD, 50)
    font_sub = load_font(FONT_MEDIUM, 24)
    font_app_name = load_font(FONT_MEDIUM, 22)
    font_disclaimer = load_font(FONT_LIGHT, 14)
    font_badge = load_font(FONT_BOLD, 18)
    font_cta = load_font(FONT_BOLD, 20)

    # Left: Text
    main_y = 100
    draw.text((60, main_y), "一包化の薬も、", fill=WHITE, font=font_main)
    draw.text((60, main_y + 68), "ひとつのアプリで。", fill=WHITE, font=font_main)

    # Feature tags
    tag_y = main_y + 170
    tag_font = load_font(FONT_MEDIUM, 20)
    tags = ["服薬リマインダー", "在庫管理", "週間レポート"]
    tag_x = 60
    for tag in tags:
        bbox = draw.textbbox((0, 0), tag, font=tag_font)
        tw = bbox[2] - bbox[0]
        th = bbox[3] - bbox[1]
        pad_h, pad_v = 14, 6
        # Semi-transparent white bg
        tag_bg = Image.new("RGBA", (tw + pad_h * 2, th + pad_v * 2), (255, 255, 255, 50))
        img.paste(Image.alpha_composite(
            Image.new("RGBA", tag_bg.size, (0, 0, 0, 0)), tag_bg
        ), (tag_x, tag_y), tag_bg)
        draw = ImageDraw.Draw(img)
        draw.text((tag_x + pad_h, tag_y + pad_v), tag, fill=WHITE, font=tag_font)
        tag_x += tw + pad_h * 2 + 12

    # App icon + name
    icon_y = tag_y + 70
    img = draw_app_icon(img, draw, 60, icon_y, size=48)
    draw = ImageDraw.Draw(img)
    draw.text((120, icon_y + 6), "くすりどき", fill=WHITE, font=font_app_name)
    draw_free_badge(draw, 260, icon_y + 4, font_badge)

    draw_cta_button(draw, 60, icon_y + 68, "無料ダウンロード", font_cta)

    # Right: Screenshot (home screen showing ippoka)
    screenshot = prepare_screenshot(
        os.path.join(SCREENSHOTS_DIR, "01_home.png"),
        target_height=500, crop_top_ratio=0.14, crop_bottom_ratio=0.08
    )
    sc_x = W - screenshot.width - 40
    sc_y = (H - screenshot.height) // 2 + 20
    img = add_phone_frame_shadow(img, screenshot, sc_x, sc_y)
    draw = ImageDraw.Draw(img)

    draw.text((60, H - 30), "※ 本アプリは医療機器ではありません", fill=DISCLAIMER_GRAY, font=font_disclaimer)

    output = img.convert("RGB")
    output.save(os.path.join(OUTPUT_DIR, "02_ippoka_card_1200x628.png"), quality=95)
    print("Created: 02_ippoka_card_1200x628.png")


def create_square_ippoka():
    """Square format (1080x1080) - 一包化訴求"""
    W, H = 1080, 1080
    img = create_gradient_background_fast(W, H, (8, 100, 95), TEAL_PRIMARY)
    img = img.convert("RGBA")
    draw = ImageDraw.Draw(img)

    font_main = load_font(FONT_BOLD, 54)
    font_sub = load_font(FONT_MEDIUM, 24)
    font_app_name = load_font(FONT_MEDIUM, 24)
    font_disclaimer = load_font(FONT_LIGHT, 15)
    font_badge = load_font(FONT_BOLD, 20)
    font_cta = load_font(FONT_BOLD, 22)

    # Top: Text
    main_y = 60
    draw.text((60, main_y), "一包化の薬も、", fill=WHITE, font=font_main)
    draw.text((60, main_y + 72), "ひとつのアプリで。", fill=WHITE, font=font_main)

    # Feature tags
    tag_y = main_y + 170
    tag_font = load_font(FONT_MEDIUM, 20)
    tags = ["服薬リマインダー", "在庫管理", "週間レポート"]
    tag_x = 60
    for tag in tags:
        bbox = draw.textbbox((0, 0), tag, font=tag_font)
        tw = bbox[2] - bbox[0]
        th = bbox[3] - bbox[1]
        pad_h, pad_v = 14, 6
        tag_bg = Image.new("RGBA", (tw + pad_h * 2, th + pad_v * 2), (255, 255, 255, 50))
        img.paste(Image.alpha_composite(
            Image.new("RGBA", tag_bg.size, (0, 0, 0, 0)), tag_bg
        ), (tag_x, tag_y), tag_bg)
        draw = ImageDraw.Draw(img)
        draw.text((tag_x + pad_h, tag_y + pad_v), tag, fill=WHITE, font=tag_font)
        tag_x += tw + pad_h * 2 + 12

    # Center: Screenshot
    screenshot = prepare_screenshot(
        os.path.join(SCREENSHOTS_DIR, "01_home.png"),
        target_height=540, crop_top_ratio=0.14, crop_bottom_ratio=0.08
    )
    sc_x = (W - screenshot.width) // 2
    sc_y = 300
    img = add_phone_frame_shadow(img, screenshot, sc_x, sc_y)
    draw = ImageDraw.Draw(img)

    # Bottom
    bottom_y = H - 140
    img = draw_app_icon(img, draw, 60, bottom_y, size=50)
    draw = ImageDraw.Draw(img)
    draw.text((122, bottom_y + 8), "くすりどき", fill=WHITE, font=font_app_name)
    draw_free_badge(draw, 272, bottom_y + 6, font_badge)
    draw_cta_button(draw, W - 280, bottom_y + 4, "無料ダウンロード", font_cta)

    draw.text((60, H - 35), "※ 本アプリは医療機器ではありません", fill=DISCLAIMER_GRAY, font=font_disclaimer)

    output = img.convert("RGB")
    output.save(os.path.join(OUTPUT_DIR, "02_ippoka_square_1080x1080.png"), quality=95)
    print("Created: 02_ippoka_square_1080x1080.png")


# ============================================================
# Creative 3: 安心訴求 (Anxiety-empathy question)
# ============================================================

def create_card_anshin():
    """Card format (1200x628) - 安心訴求 (question style)"""
    W, H = 1200, 628
    img = create_gradient_background_fast(W, H, TEAL_PRIMARY, TEAL_LIGHT)
    img = img.convert("RGBA")
    draw = ImageDraw.Draw(img)

    font_main = load_font(FONT_BOLD, 46)
    font_highlight = load_font(FONT_BOLD, 48)
    font_sub = load_font(FONT_MEDIUM, 22)
    font_app_name = load_font(FONT_MEDIUM, 22)
    font_disclaimer = load_font(FONT_LIGHT, 14)
    font_badge = load_font(FONT_BOLD, 18)
    font_cta = load_font(FONT_BOLD, 20)

    # Left: Text (question format - empathy)
    main_y = 80
    draw.text((60, main_y), "親の薬、", fill=WHITE, font=font_main)
    draw.text((60, main_y + 65), "ちゃんと飲めてる？", fill=AMBER, font=font_highlight)
    draw.text((60, main_y + 140), "がスマホで分かる。", fill=WHITE, font=font_main)

    # Sub
    draw.text((60, main_y + 220), "服薬状況をリアルタイムで確認", fill=(200, 235, 232), font=font_sub)

    # App icon + name + CTA
    icon_y = main_y + 280
    img = draw_app_icon(img, draw, 60, icon_y, size=48)
    draw = ImageDraw.Draw(img)
    draw.text((120, icon_y + 6), "くすりどき", fill=WHITE, font=font_app_name)
    draw_free_badge(draw, 260, icon_y + 4, font_badge)

    draw_cta_button(draw, 60, icon_y + 68, "服薬管理をはじめよう", font_cta)

    # Right: Two screenshots overlapping (parent + child concept)
    screenshot_home = prepare_screenshot(
        os.path.join(SCREENSHOTS_DIR, "01_home.png"),
        target_height=420, crop_top_ratio=0.14, crop_bottom_ratio=0.10
    )
    screenshot_care = prepare_screenshot(
        os.path.join(SCREENSHOTS_DIR, "03_caregiver.png"),
        target_height=420, crop_top_ratio=0.14, crop_bottom_ratio=0.10
    )

    # Back screenshot (parent's view - home)
    sc_x1 = W - screenshot_home.width - 30
    sc_y1 = (H - screenshot_home.height) // 2 + 10
    img = add_phone_frame_shadow(img, screenshot_home, sc_x1, sc_y1)

    # Front screenshot (child's view - caregiver) slightly offset
    sc_x2 = sc_x1 - screenshot_care.width // 3
    sc_y2 = sc_y1 + 30
    img = add_phone_frame_shadow(img, screenshot_care, sc_x2, sc_y2)
    draw = ImageDraw.Draw(img)

    draw.text((60, H - 30), "※ 本アプリは医療機器ではありません", fill=DISCLAIMER_GRAY, font=font_disclaimer)

    output = img.convert("RGB")
    output.save(os.path.join(OUTPUT_DIR, "03_anshin_card_1200x628.png"), quality=95)
    print("Created: 03_anshin_card_1200x628.png")


def create_square_anshin():
    """Square format (1080x1080) - 安心訴求"""
    W, H = 1080, 1080
    img = create_gradient_background_fast(W, H, TEAL_PRIMARY, TEAL_LIGHT)
    img = img.convert("RGBA")
    draw = ImageDraw.Draw(img)

    font_main = load_font(FONT_BOLD, 52)
    font_highlight = load_font(FONT_BOLD, 54)
    font_sub = load_font(FONT_MEDIUM, 26)
    font_app_name = load_font(FONT_MEDIUM, 24)
    font_disclaimer = load_font(FONT_LIGHT, 15)
    font_badge = load_font(FONT_BOLD, 20)
    font_cta = load_font(FONT_BOLD, 22)

    # Top: Text
    main_y = 55
    draw.text((60, main_y), "親の薬、", fill=WHITE, font=font_main)
    draw.text((60, main_y + 70), "ちゃんと飲めてる？", fill=AMBER, font=font_highlight)
    draw.text((60, main_y + 150), "がスマホで分かる。", fill=WHITE, font=font_main)
    draw.text((60, main_y + 230), "服薬状況をリアルタイムで確認", fill=(200, 235, 232), font=font_sub)

    # Center: Two screenshots side by side
    screenshot_home = prepare_screenshot(
        os.path.join(SCREENSHOTS_DIR, "01_home.png"),
        target_height=480, crop_top_ratio=0.14, crop_bottom_ratio=0.10
    )
    screenshot_care = prepare_screenshot(
        os.path.join(SCREENSHOTS_DIR, "03_caregiver.png"),
        target_height=480, crop_top_ratio=0.14, crop_bottom_ratio=0.10
    )

    total_w = screenshot_home.width + screenshot_care.width + 20
    start_x = (W - total_w) // 2
    sc_y = 350

    img = add_phone_frame_shadow(img, screenshot_home, start_x, sc_y)
    img = add_phone_frame_shadow(img, screenshot_care, start_x + screenshot_home.width + 20, sc_y - 20)
    draw = ImageDraw.Draw(img)

    # Labels under screenshots
    label_font = load_font(FONT_MEDIUM, 18)
    # Parent label
    lx1 = start_x + screenshot_home.width // 2
    draw.text((lx1 - 40, sc_y + 490), "お母さん側", fill=(200, 235, 232), font=label_font, anchor="mt" if hasattr(draw, 'textbbox') else None)
    # Child label
    lx2 = start_x + screenshot_home.width + 20 + screenshot_care.width // 2
    draw.text((lx2 - 30, sc_y + 470), "あなた側", fill=(200, 235, 232), font=label_font)

    # Bottom
    bottom_y = H - 130
    img = draw_app_icon(img, draw, 60, bottom_y, size=50)
    draw = ImageDraw.Draw(img)
    draw.text((122, bottom_y + 8), "くすりどき", fill=WHITE, font=font_app_name)
    draw_free_badge(draw, 272, bottom_y + 6, font_badge)
    draw_cta_button(draw, W - 310, bottom_y + 4, "服薬管理をはじめよう", font_cta)

    draw.text((60, H - 35), "※ 本アプリは医療機器ではありません", fill=DISCLAIMER_GRAY, font=font_disclaimer)

    output = img.convert("RGB")
    output.save(os.path.join(OUTPUT_DIR, "03_anshin_square_1080x1080.png"), quality=95)
    print("Created: 03_anshin_square_1080x1080.png")


# ============================================================
# Main
# ============================================================

if __name__ == "__main__":
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    print("Generating LINE Ads creatives for Kusuridoki...")
    print(f"Output: {OUTPUT_DIR}/")
    print()

    create_card_mimamori()
    create_square_mimamori()
    create_card_ippoka()
    create_square_ippoka()
    create_card_anshin()
    create_square_anshin()

    print()
    print("Done! Generated 6 creatives (3 designs x 2 sizes)")
    print()
    print("Files:")
    for f in sorted(os.listdir(OUTPUT_DIR)):
        if f.endswith(".png"):
            path = os.path.join(OUTPUT_DIR, f)
            size_kb = os.path.getsize(path) / 1024
            print(f"  {f} ({size_kb:.0f} KB)")
