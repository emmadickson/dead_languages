from PIL import Image

color_mappings = {
'poppy_field': {'r': 179, 'g': 48, 'b': 34},
'yellow_brick_road': {'r': 229, 'g': 207, 'b': 60},
'mint': {'r': 188, 'g': 217, 'b': 190},
'powder_blue': {'r': 159, 'g': 176, 'b': 199},
'egyptian_blue': {'r': 69, 'g': 94, 'b': 149},
'jade': {'r': 81, 'g': 114, 'b': 91},
'wizard': {'r': 134, 'g': 205, 'b': 106},
'deep_pink': {'r': 204, 'g': 85, 'b': 155},
'white':{'r': 255, 'g': 255, 'b': 255},
'black':{'r': 0, 'g': 0, 'b': 0},
'magenta': {'r': 255, 'g': 0, 'b': 255},
'cyan': {'r': 0, 'g': 255, 'b': 255},
'yellow': {'r': 255, 'g': 255, 'b': 0},
'digital_green': {'r': 164, 'g': 255, 'b': 78}
}

colors = open("data/rgb.txt", "r")
im= Image.new('RGB', (200,200))

pixels = (colors.read().split("\n"))
data = []
for x in range(0, len(pixels)-2):
    if pixels[x] != '':
        rgb = color_mappings[pixels[x]]
        data.append((rgb['r'],rgb['g'],rgb['b']))

im.putdata(data)
im.save('generated_test_images/test58.png')
