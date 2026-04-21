from PIL import Image
import os

# Load original robot
source_path = '/home/nontanan/MonsterXPilot/docs/presentation/images/monsterx_front.png'
robot = Image.open(source_path)

# Create 16:9 canvas (1920x1080)
canvas = Image.new('RGB', (1920, 1080), (0, 0, 0))

# Resize robot to fit height (1080)
# Original might be square, so let's preserve aspect ratio
w, h = robot.size
ratio = 1080 / h
new_w = int(w * ratio)
robot_resized = robot.resize((new_w, 1080))

# Paste in center
canvas.paste(robot_resized, ( (1920-new_w)//2, 0 ))

# Save as reference for expansion
temp_ref = '/home/nontanan/MonsterXPilot/docs/images/temp_16_9_ref.png'
os.makedirs(os.path.dirname(temp_ref), exist_ok=True)
canvas.save(temp_ref)

print(f"Created 16:9 reference canvas with {new_w}x1080 robot centered.")
