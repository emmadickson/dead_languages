from PIL import Image
import random

color_mappings = {
'white': {'r': 255, 'g': 255, 'b': 255},
'blue': {'r': 0, 'g': 54, 'b': 247},
'green': {'r': 0, 'g': 247, 'b': 63},
'cyan': {'r': 0, 'g': 251, 'b': 253},
'red': {'r': 255, 'g': 51, 'b': 40},
'magenta': {'r': 255, 'g': 70, 'b': 250},
'yellow': {'r': 255, 'g': 251, 'b': 75},
'black': {'r': 0, 'g': 0, 'b': 0}
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
