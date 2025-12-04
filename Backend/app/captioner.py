from PIL import Image, ImageDraw, ImageFont
import os

def add_bottom_caption(img, caption):
    width, height = img.size
    bi = Image.new('RGBA', (width + 10, height + int(height / 5)), 'white')
    bi.paste(img, (5, 5))
    font_path = os.path.join(os.path.dirname(__file__), "..", "asset", "fonts", "arialbd.ttf")
    try:
        font = ImageFont.truetype(font_path, 20)
        print("Using arialbd.ttf font for caption.")
    except:
        print("Arial font not found. Using default font.")
        font = ImageFont.load_default()

    draw = ImageDraw.Draw(bi)

    max_width = width - 20
    words = caption.split()
    lines, current_line = [], []

    for word in words:
        test_line = " ".join(current_line + [word])
        w, h = draw.textbbox((0, 0), test_line, font=font)[2:]
        if w <= max_width:
            current_line.append(word)
        else:
            lines.append(" ".join(current_line))
            current_line = [word]

    if current_line:
        lines.append(" ".join(current_line))

    line_height = draw.textbbox((0, 0), "Test", font=font)[3]
    total_height = (line_height + 10) * len(lines)
    y = height + ((height/5) - total_height) / 2

    for line in lines:
        tw = draw.textbbox((0, 0), line, font=font)[2]
        draw.text(((width - tw)/2, y), line, fill="black", font=font)
        y += line_height + 10

    return bi
