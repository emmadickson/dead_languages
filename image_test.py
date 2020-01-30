from PIL import Image
import random

color_mappings = {
'poppy_field': {'r': 181, 'g': 34, 'b': 37},
'yellow_brick_road': {'r': 229, 'g': 232, 'b': 68},
'mint': {'r': 130, 'g': 224, 'b': 60},
'powder_blue': {'r': 133, 'g': 229, 'b': 219},
'egyptian_blue': {'r': 25, 'g': 45, 'b': 79},
'jade': {'r': 31, 'g': 32, 'b': 203},
'wizard': {'r': 49, 'g': 0, 'b': 109},
'deep_pink': {'r': 185, 'g': 37, 'b': 219},
'white': {'r': 255, 'g': 255, 'b': 255},
'black': {'r': 0, 'g': 0, 'b': 0},
'magenta': {'r': 191, 'g':188, 'b': 187}
}

colors = open("data/rgb.txt", "r")
im= Image.new('RGB', (150,150))

pixels = (colors.read().split("\n"))
data = []
for x in range(0, len(pixels)-2):
    if pixels[x] != '':
        rgb = color_mappings[pixels[x]]
        data.append((rgb['r'],rgb['g'],rgb['b']))

im.putdata(data)
im.save('generated_test_images/test48.png')
