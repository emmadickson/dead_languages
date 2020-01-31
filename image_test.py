from PIL import Image
import random

color_mappings = {
'red': {'r': 251, 'g': 13, 'b': 28},
'yellow': {'r': 253, 'g': 250, 'b': 55},
'cyan': {'r': 45, 'g': 255, 'b': 254},
'green': {'r': 42, 'g': 253, 'b': 47},
'pink': {'r': 253, 'g': 41, 'b': 252},
'blue': {'r': 11, 'g': 35, 'b': 243},
'white': {'r': 255, 'g': 255, 'b': 255},
'black': {'r': 0, 'g': 0, 'b': 0},

'magenta': {'r': 255, 'g': 0, 'b': 255}
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
