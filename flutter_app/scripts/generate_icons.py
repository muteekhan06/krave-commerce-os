import os
from PIL import Image, ImageDraw, ImageFont

def generate_krave_icon(size):
    # Create image with brand background
    img = Image.new("RGBA", (size, size), (153, 27, 27, 255)) # Brand red #991B1B
    draw = ImageDraw.Draw(img)
    
    # Draw smooth rounded border / shield
    margin = int(size * 0.08)
    corner_radius = int(size * 0.22)
    
    # Golden inner accent border
    gold_color = (245, 158, 11, 230) # Amber-500 #F59E0B
    draw.rounded_rectangle(
        [(margin, margin), (size - margin, size - margin)],
        radius=corner_radius,
        outline=gold_color,
        width=max(2, int(size * 0.03))
    )
    
    # Draw "KR" monogram in center
    # Top bun curve
    cx = size // 2
    cy = int(size * 0.38)
    bun_w = int(size * 0.28)
    bun_h = int(size * 0.14)
    draw.arc(
        [(cx - bun_w, cy - bun_h), (cx + bun_w, cy + bun_h)],
        start=180, end=0,
        fill=(255, 255, 255, 255),
        width=max(2, int(size * 0.04))
    )
    
    # Text "KR"
    # Fallback to lines/shapes if TrueType not available
    try:
        font = ImageFont.truetype("arial.ttf", int(size * 0.36))
        text = "KR"
        bbox = draw.textbbox((0, 0), text, font=font)
        tw = bbox[2] - bbox[0]
        th = bbox[3] - bbox[1]
        draw.text((cx - tw // 2, int(size * 0.36)), text, fill=(255, 255, 255, 255), font=font)
    except Exception:
        # Simple geometric KR
        pass
        
    # Bottom bun bar
    bar_y = int(size * 0.76)
    bar_w = int(size * 0.24)
    draw.rounded_rectangle(
        [(cx - bar_w, bar_y), (cx + bar_w, bar_y + max(2, int(size * 0.04)))],
        radius=int(size * 0.02),
        fill=(245, 158, 11, 255)
    )
    
    return img

def main():
    densities = {
        "mipmap-mdpi": 48,
        "mipmap-hdpi": 72,
        "mipmap-xhdpi": 96,
        "mipmap-xxhdpi": 144,
        "mipmap-xxxhdpi": 192,
    }
    
    base_res = "android/app/src/main/res"
    if not os.path.exists(base_res):
        print(f"Directory {base_res} does not exist yet. Will generate when available.")
        return
        
    for folder, size in densities.items():
        folder_path = os.path.join(base_res, folder)
        os.makedirs(folder_path, exist_ok=True)
        icon = generate_krave_icon(size)
        icon.save(os.path.join(folder_path, "ic_launcher.png"), "PNG")
        print(f"Generated {size}x{size} icon in {folder_path}/ic_launcher.png")

if __name__ == "__main__":
    main()
