import base64
import os

png_b64 = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
png_data = base64.b64decode(png_b64)

files = [
    "sprite_boomerang.png",
    "sprite_scarab.png",
    "sprite_quill.png",
    "sprite_key.png",
    "sprite_gecko.png"
]

dir_path = r"c:\Users\HP\.gemini\antigravity-ide\scratch\find_your_path\assets\images"
os.makedirs(dir_path, exist_ok=True)

for f in files:
    with open(os.path.join(dir_path, f), "wb") as out_file:
        out_file.write(png_data)

print("Generated 5 transparent PNGs.")
