from PIL import Image, ImageFilter
import os

# Path to the generated tech detail image
gen_path = '/home/nontanan/.gemini/antigravity/brain/9ce4dcf6-7455-478f-af41-8a802ed17e74/tech_detail_cover_clean_1776579572526.png'
img = Image.open(gen_path)

# Target 16:9 size (1920x1080)
# To fit height 1080, 1024x1024 becomes 1080x1080
img_resized = img.resize((1080, 1080))

# Create 1920x1080 canvas
# We'll use a neutral gray/green from the image for padding
canvas = Image.new('RGB', (1920, 1080), (45, 55, 45)) 

# Paste robot in center
canvas.paste(img_resized, ((1920-1080)//2, 0))

# Extend sides with blurred orchard
left_edge = img_resized.crop((0, 0, 10, 1080)).resize((420, 1080))
right_edge = img_resized.crop((1070, 0, 1080, 1080)).resize((420, 1080))

left_edge = left_edge.filter(ImageFilter.GaussianBlur(radius=80))
right_edge = right_edge.filter(ImageFilter.GaussianBlur(radius=80))

canvas.paste(left_edge, (0, 0))
canvas.paste(right_edge, (1920-420, 0))

# Save final 16:9 file
out_path = '/home/nontanan/MonsterXPilot/docs/presentation/images/tech_detail_16_9_cover.png'
os.makedirs(os.path.dirname(out_path), exist_ok=True)
canvas.save(out_path)

print(f"Exported true 16:9 (1920x1080) technical cover to {out_path}")
