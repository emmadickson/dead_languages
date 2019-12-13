import image_slicer
from PIL import Image
import pyaudio
import math
import array
import wave
from math import *

volume = 100     # range [0.0, 1.0]
fs = 44100       # sampling rate, Hz, must be integer
duration = .02 # in seconds, may be float
data = array.array('h') # signed short integer (-32768 to 32767) data
channels = 1
dataSize = 2
numSamples = duration * fs

color_mappings = {
'red': {'r': 255, 'g': 0, 'b': 0}, 
'orange': {'r': 255, 'g': 165, 'b': 0}, 
'yellow': {'r': 255, 'g': 255, 'b': 0}, 
'green': {'r': 0, 'g': 128, 'b': 0},
'blue': {'r': 0, 'g': 0, 'b': 255},
'purple': {'r': 128, 'g': 0, 'b': 128}, 
'indigo': {'r': 75, 'g': 0, 'b': 130},
'deep_pink': {'r': 255, 'g': 20, 'b': 147},
'brown': {'r': 165, 'g': 42, 'b': 42}, 
'white': {'r': 255, 'g': 255, 'b': 255},
'black': {'r': 0, 'g': 0, 'b': 0}
}

sound_mappings = {
'red': 300, 
'orange': 400, 
'yellow': 500, 
'green': 600, 
'blue': 700,
'purple': 800, 
'indigo': 900,
'deep_pink': 1000,
'brown': 1100, 
'white': 1200,
'black': 1300
}

takeClosest = lambda num,collection:min(collection,key=lambda x:abs(x-num))

def find_css_color(new_color):
    min = 10000
    color_match = 0
    for color in color_mappings:
        d = sqrt(((int(new_color['r'])-int(color_mappings[color]['r']))*0.3)**2 + ((int(new_color['g'])-int(color_mappings[color]['g']))*0.59)**2 + ((int(new_color['b'])-int(color_mappings[color]['b']))*0.11)**2)
        if int(d) < int(min):
            min = d
            color_match = color
    return color_match

def myround(x, base=42):
    return (base * (round(x/base)))
    
def multiple(m, n): 
    # inserts all elements from n to  
    # (m * n)+1 incremented by n. 
    a = []
    for x in range(n):    
        a.append(x*n)
    return a
    
def generate_tone(f, numSamples=duration * fs):
    if f == 0:
        f = 250
    for i in range(int(numSamples)):
        numSamplesPerCyc = int(fs / f)
        sample = 32767 * float(volume) / 100
        sample *= math.sin(math.pi * 2 * (i % numSamplesPerCyc) / numSamplesPerCyc)
        data.append(int(sample))
        
t = open("raw_data_rgb.txt", "r")
pixels = (t.read().split("\n"))
generate_tone(10000, fs*.5)
count = 0
buckets = multiple(500, 42)

for pix in pixels:
    if pix != "":
        pix = pix.split(" ")
        p = pyaudio.PyAudio()

        color = {'r': pix[0], 'g': pix[1], 'b': pix[2]}
        color = find_css_color(color)
        generate_tone(sound_mappings[color])
    
        if count == 50:
            generate_tone(5000, fs*.3)
            count = 0
        
f = wave.open('color.wav', 'w')
f.setparams((int(channels), int(dataSize), int(fs), int(numSamples), "NONE", "Uncompressed"))
f.writeframes(data.tostring())
f.close()