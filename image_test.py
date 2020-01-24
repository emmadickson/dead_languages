from PIL import Image
import random

color_mappings = {
'dark_red': {'r': 184, 'g': 38, 'b': 22},
'bright_red': {'r': 255, 'g': 0, 'b': 0},
'medium_red': {'r': 161, 'g': 24, 'b': 0},

'dark_orange': {'r': 255, 'g': 77, 'b': 0},
'orange': {'r': 255, 'g': 149, 'b': 0},
'light_orange': {'r': 242, 'g': 141, 'b': 78},

'dark_yellow': {'r': 255, 'g': 191, 'b': 0},
'yellow': {'r': 255, 'g': 247, 'b': 0},
'light_yellow': {'r': 255, 'g': 224, 'b': 131},

'dark_green': {'r': 2, 'g': 184, 'b': 62},
'bright_green': {'r': 77, 'g': 255, 'b': 0},
'pale_green': {'r': 170, 'g': 227, 'b': 176},

'sky': {'r': 150, 'g': 199, 'b': 255},
'light_blue': {'r': 0, 'g': 252, 'b': 252},
'blue': {'r': 0, 'g': 29, 'b': 252},
'folder_blue': {'r': 2, 'g': 110, 'b': 232},

'indigo': {'r': 6, 'g': 11, 'b': 92},

'purple': {'r': 97, 'g': 0, 'b': 252},
'purple_sky': {'r': 153, 'g': 116, 'b': 166},
'dark_purple': {'r': 58, 'g': 15, 'b': 128},
'swimmer_purple': {'r': 166, 'g': 0, 'b': 225},


'deep_pink': {'r': 209, 'g': 2, 'b': 199},
'nipple_pink': {'r': 158, 'g': 96, 'b': 130},
'millenial_pink': {'r': 219, 'g': 136, 'b': 99},
'white_pink': {'r': 250, 'g': 209, 'b': 253},

'white': {'r': 255, 'g': 255, 'b': 255},
'black': {'r': 0, 'g': 0, 'b': 0},
'gray': {'r': 169, 'g': 162, 'b': 179}

}


colors = open("data/raw_data_rgb.txt", "r")
im= Image.new('RGB', (200,200))

pixels = (colors.read().split("\n"))
data = []
for x in range(0, len(pixels)-2):
    if pixels[x] != '':
        pixels[x] = pixels[x].split(" ")
        data.append((0,0,int(pixels[x][2])))

im.putdata(data)
im.save('generated_test_images/test47b.png')
