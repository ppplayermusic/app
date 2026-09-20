import os
from PIL import Image, ImageDraw

os.makedirs('assets/icons', exist_ok=True)

size = (32, 32)

def create_icon(name, draw_func):
    img = Image.new('RGBA', size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    draw_func(draw)
    img.save(f"assets/icons/{name}.ico", format='ICO', sizes=[size])
    print(f"Generated {name}.ico")

# Play (Triangle pointing right)
def draw_play(draw):
    draw.polygon([(8, 6), (8, 26), (24, 16)], fill=(255, 255, 255, 255))
create_icon('play', draw_play)

# Pause (Two vertical bars)
def draw_pause(draw):
    draw.rectangle([(8, 6), (12, 26)], fill=(255, 255, 255, 255))
    draw.rectangle([(20, 6), (24, 26)], fill=(255, 255, 255, 255))
create_icon('pause', draw_pause)

# Previous (Bar + Triangle pointing left)
def draw_previous(draw):
    draw.rectangle([(6, 8), (10, 24)], fill=(255, 255, 255, 255))
    draw.polygon([(26, 8), (26, 24), (10, 16)], fill=(255, 255, 255, 255))
create_icon('previous', draw_previous)

# Next (Triangle pointing right + Bar)
def draw_next(draw):
    draw.polygon([(6, 8), (6, 24), (22, 16)], fill=(255, 255, 255, 255))
    draw.rectangle([(22, 8), (26, 24)], fill=(255, 255, 255, 255))
create_icon('next', draw_next)

# Add (Plus sign)
def draw_add(draw):
    draw.rectangle([(14, 6), (18, 26)], fill=(255, 255, 255, 255))
    draw.rectangle([(6, 14), (26, 18)], fill=(255, 255, 255, 255))
create_icon('add', draw_add)

# Remove (Checkmark)
def draw_remove(draw):
    draw.polygon([(6, 16), (12, 22), (26, 8), (28, 10), (12, 26), (4, 18)], fill=(255, 255, 255, 255))
create_icon('remove', draw_remove)

print("Done")
