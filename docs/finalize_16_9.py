from PIL import Image, ImageDraw, ImageFilter
import os

# Path to the last generated image (the 1024x1024 one)
gen_path = '/home/nontanan/.gemini/antigravity/brain/9ce4dcf6-7455-478f-af41-8a802ed17e74/monsterx_final_16_9_dark_1776578820539.png'
img = Image.open(gen_path)

# Target 16:9 size (1920x1080)
# To fit height 1080, 1024x1024 becomes 1080x1080
img_resized = img.resize((1080, 1080))

# Create 1920x1080 canvas
canvas = Image.new('RGB', (1920, 1080), (10, 15, 10)) # Very dark green/black base

# Paste robot in center
canvas.paste(img_resized, ((1920-1080)//2, 0))

# Smooth the edges with gradients to make it feel 'expanded'
# We'll take the leftmost and rightmost column of the image and stretch them or use gradients
left_edge = img_resized.crop((0, 0, 1, 1080)).resize((420, 1080))
right_edge = img_resized.crop((1079, 0, 1080, 1080)).resize((420, 1080))

# Apply heavy blur to edges to make it feel natural
left_edge = left_edge.filter(ImageFilter.GaussianBlur(radius=50))
right_edge = right_edge.filter(ImageFilter.GaussianBlur(radius=50))

canvas.paste(left_edge, (0, 0))
canvas.paste(right_edge, (1920-420, 0))

# Optional: Add a subtle vignette to blend everything
# But for now, let's just save this 1920x1080 file
out_path = '/home/nontanan/MonsterXPilot/docs/presentation/images/monsterx_cover_16_9_final.png'
os.makedirs(os.path.dirname(out_path), exist_ok=True)
canvas.save(out_path)

print(f"Exported true 16:9 (1920x1080) cover to {out_path}")
