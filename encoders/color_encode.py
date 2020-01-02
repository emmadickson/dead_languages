from PIL import Image
import pyaudio
import math
import array
import wave
from math import *

volume = 100     # range [0.0, 1.0]
fs = 44100       # sampling rate, Hz, must be integer
duration = .018 # in seconds, may be float
data = array.array('h') # signed short integer (-32768 to 32767) data
channels = 1
dataSize = 2
numSamples = duration * fs

color_mappings = {
'dark_red': {'r': 115, 'g': 1, 'b': 1},
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

'deep_pink': {'r': 209, 'g': 2, 'b': 199},
'nipple_pink': {'r': 158, 'g': 96, 'b': 130},
'millenial_pink': {'r': 245, 'g': 176, 'b': 176},

'brown': {'r': 150, 'g': 75, 'b': 0},
'rust': {'r': 122, 'g': 51, 'b': 7},
'hollywood_brown': {'r': 176, 'g': 123, 'b': 79},

'white': {'r': 255, 'g': 255, 'b': 255},
'black': {'r': 0, 'g': 0, 'b': 0},
'gray': {'r': 169, 'g': 162, 'b': 179}

}

sound_mappings = {
'dark_red': 200,
'bright_red': 250,
'medium_red': 300,

'dark_orange': 350,
'orange': 400,
'light_orange': 450,

'dark_yellow': 500,
'yellow': 550,
'light_yellow': 600,

'dark_green': 650,
'bright_green': 700,
'pale_green': 750,

'sky': 800,
'light_blue': 850,
'blue': 900,
'folder_blue': 950,

'indigo': 1000,

'purple': 1050,
'purple_sky': 1100,
'dark_purple': 1150,

'deep_pink': 1200,
'nipple_pink': 1250,
'millenial_pink': 1300,

'brown': 1350,
'rust': 1400,
'hollywood_brown': 1450,

'white': 1500,
'black': 1550,
'gray': 1600
}

takeClosest = lambda num,collection:min(collection,key=lambda x:abs(x-num))

def find_css_color(new_color):
    min = 10000
    color_match = 0
    for color in color_mappings:
        d = sqrt(((int(new_color['r'])-int(color_mappings[color]['r']))*0.6)**2 + ((int(new_color['g'])-int(color_mappings[color]['g']))*0.59)**2 + ((int(new_color['b'])-int(color_mappings[color]['b']))*0.11)**2)
        if int(d) < int(min):
            min = d
            color_match = color
    return color_match


def generate_tone(f, numSamples=duration * fs):
    if f == 0:
        f = 250
    for i in range(int(numSamples)):
        numSamplesPerCyc = int(fs / f)
        sample = 32767 * float(volume) / 100
        sample *= math.sin(math.pi * 2 * (i % numSamplesPerCyc) / numSamplesPerCyc)
        data.append(int(sample))

t = open("data/raw_data_rgb.txt", "r")
tt = open("data/rgb.txt", "w")

pixels = (t.read().split("\n"))
generate_tone(10000, fs*.5)
count = 0

for pix in pixels:
    if pix != "":
        pix = pix.split(" ")
        p = pyaudio.PyAudio()

        color = {'r': pix[0], 'g': pix[1], 'b': pix[2]}
        color = find_css_color(color)
        generate_tone(sound_mappings[color])
        tt.write(str(color))
        tt.write("\n")
        if count == 50:
            generate_tone(5500, fs*.1)
            count = 0

    count = count + 1

f = wave.open('audio/color.wav', 'w')
f.setparams((int(channels), int(dataSize), int(fs), int(numSamples), "NONE", "Uncompressed"))
f.writeframes(data.tostring())
f.close()
