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
'poppy_field': {'r': 179, 'g': 48, 'b': 34},
'yellow_brick_road': {'r': 229, 'g': 207, 'b': 60},
'mint': {'r': 188, 'g': 217, 'b': 190},
'powder_blue': {'r': 159, 'g': 176, 'b': 199},
'egyptian_blue': {'r': 69, 'g': 94, 'b': 149},
'jade': {'r': 81, 'g': 114, 'b': 91},
'wizard': {'r': 134, 'g': 205, 'b': 106},
'deep_pink': {'r': 204, 'g': 85, 'b': 55},
'white': {'r': 255, 'g': 255, 'b': 255},
'black': {'r': 0, 'g': 0, 'b': 0},
'magenta': {'r': 255, 'g': 0, 'b': 255},
'cyan': {'r': 0, 'g': 255, 'b': 255},
'yellow': {'r': 255, 'g': 255, 'b': 0},
'digital_green': {'r': 164, 'g': 255, 'b': 78}
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
row_red = []
row_green = []
row_blue = []
for pix in pixels:
    if pix != "":
        pix = pix.split(" ")
        color = {'r': pix[0], 'g': pix[1], 'b': pix[2]}
        color = find_css_color(color)
        tt.write(str(color))
        tt.write("\n")
        row_red.append(pix[0])
        row_green.append(pix[1])
        row_blue.append(pix[2])

rgb = 0
chunks_row_red = [row_red[x:x+50] for x in range(0, len(row_red), 50)]
chunks_row_green = [row_green[x:x+50] for x in range(0, len(row_green), 50)]
chunks_row_blue = [row_blue[x:x+50] for x in range(0, len(row_blue), 50)]


for x in range(0, 200):
    p = pyaudio.PyAudio()
    for red in chunks_row_red[x]:
        generate_tone(700-int(red))
    generate_tone(5500, fs*.1)
    for green in chunks_row_green[x]:
        generate_tone(700-int(green))
    generate_tone(5500, fs*.1)
    for blue in chunks_row_blue[x]:
        generate_tone(700-int(blue))
    generate_tone(5500, fs*.1)

f = wave.open('audio/grill.wav', 'w')
f.setparams((int(channels), int(dataSize), int(fs), int(numSamples), "NONE", "Uncompressed"))
f.writeframes(data.tostring())
f.close()
