from PIL import Image
import pyaudio
import math
import array
import wave
from math import *

volume = 100     # range [0.0, 1.0]
fs = 44100       # sampling rate, Hz, must be integer
duration = .013 # in seconds, may be float
data = array.array('h') # signed short integer (-32768 to 32767) data
channels = 1
dataSize = 2
numSamples = duration * fs

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

sound_mappings = {

'white': 200,
'blue': 400,
'green': 600,
'cyan': 800,
'red': 1000,
'magenta': 1200,
'yellow': 1400,
'black': 1600,
}

takeClosest = lambda num,collection:min(collection,key=lambda x:abs(x-num))

def find_css_color(new_color):
    min = 10000
    color_match = 0
    for color in color_mappings:
        d = sqrt(((int(new_color['r'])-int(color_mappings[color]['r']))*0.8)**2 + ((int(new_color['g'])-int(color_mappings[color]['g']))*0.59)**2 + ((int(new_color['b'])-int(color_mappings[color]['b']))*0.11)**2)
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
        generate_tone(int(pix[0])*8)
        tt.write(pix[0])
        tt.write("\n")
        if count == 25:
            generate_tone(7000, fs*.05)
            count = 0
        count = count + 1

f = wave.open('audio/sound.wav', 'w')
f.setparams((int(channels), int(dataSize), int(fs), int(numSamples), "NONE", "Uncompressed"))
f.writeframes(data.tostring())
f.close()
