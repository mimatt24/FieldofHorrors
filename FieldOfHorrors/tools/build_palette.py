import json, os
from PIL import Image, ImageDraw

with open("design/palette.json","r") as f:
    cfg = json.load(f)
colors = cfg["colors"]
os.makedirs("art/autogen", exist_ok=True)

# palette.png (swatch sheet)
sw = 160; sh = 160
cols = len(colors)
img = Image.new("RGB", (sw*cols, sh), (20,20,20))
draw = ImageDraw.Draw(img)
for i, hexc in enumerate(colors):
    draw.rectangle([i*sw, 0, (i+1)*sw-1, sh-1], fill=hexc)
    draw.text((i*sw+8, sh-24), hexc, fill=(255,255,255))
img.save("art/autogen/palette.png")

# palette.gpl (GIMP palette; convertible to Procreate swatches via 3rd‑party)
with open("art/autogen/palette.gpl","w") as g:
    g.write("GIMP Palette\n")
    g.write(f"Name: {cfg.get('name','Field of Horrors')}\nColumns: {len(colors)}\n#\n")
    for hexc in colors:
        hexc = hexc.lstrip("#")
        r = int(hexc[0:2], 16); gg = int(hexc[2:4], 16); b = int(hexc[4:6], 16)
        g.write(f"{r} {gg} {b}\t#{hexc}\n")
print("Wrote art/autogen/palette.png and art/autogen/palette.gpl")
