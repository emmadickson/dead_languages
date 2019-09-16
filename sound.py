import image_slicer
from PIL import Image
import pyaudio
import math
import array
import wave
from math import *

"""
im = Image.open('images/girl.JPG')
pixels = list(im.getdata())

raw_data_rgb = open("raw_data_rgb.txt", 'w')

for pix in pixels:
    pix = str(pix)
    
    pix = pix.replace("(", "")
    pix = pix.replace(")", "")
    pix = pix.replace(",", "")

    raw_data_rgb.write(pix)
    raw_data_rgb.write("\n")
"""

volume = 100     # range [0.0, 1.0]
fs = 44100       # sampling rate, Hz, must be integer
duration = .018 # in seconds, may be float
data = array.array('h') # signed short integer (-32768 to 32767) data
channels = 1
dataSize = 2
numSamples = duration * fs

color_mappings = {
'red': {'r': 255, 'g': 0, 'b': 0}, 
'dark_red': {'r': 139, 'g': 0, 'b': 0},
'orange': {'r': 255, 'g': 165, 'b': 0}, 
'coral': {'r': 255, 'g': 127, 'b': 80},
'dark_orange': {'r':255, 'g': 140, 'b': 0},
'yellow': {'r': 255, 'g': 255, 'b': 0}, 
'golden_rod': {'r':218, 'g': 165, 'b': 32},
'antique_white': {'r':250, 'g':235, 'b':215},
'corn_silk': {'r':255, 'g': 248, 'b': 220},
'burly_wood': {'r':222, 'g':184, 'b':135},
'green': {'r': 0, 'g': 128, 'b': 0}, 
'light_sea_green': {'r': 32, 'g': 178, 'b': 170},
'cornflower_blue': {'r': 100, 'g': 149, 'b': 237},
'blue': {'r': 0, 'g': 0, 'b': 255}, 
'aqua': {'r':0, 'g':255, 'b':255},
'midnight_blue': {'r': 25, 'g': 25, 'b': 112},
'purple': {'r': 128, 'g': 0, 'b': 128}, 
'medium_purple': {'r': 147, 'g': 112, 'b': 219},
'indigo': {'r': 75, 'g': 0, 'b': 130},
'blue_violet': {'r':138, 'g':43, 'b':226},
'dark_magenta': {'r':139, 'g':0, 'b':139},
'deep_pink': {'r': 255, 'g': 20, 'b': 147},
'brown': {'r': 165, 'g': 42, 'b': 42}, 
'saddle_brown': {'r': 139, 'g': 69, 'b': 19},
'white': {'r': 255, 'g': 255, 'b': 255},
'black': {'r': 0, 'g': 0, 'b': 0}
}

sound_mappings = {
'red': 300, 
'dark_red': 400,
'orange': 500, 
'coral': 600,
'dark_orange': 700, 
'yellow': 800, 
'golden_rod': 900, 
'antique_white': 1000,
'corn_silk': 1100,
'burly_wood': 1200,
'green': 1300, 
'light_sea_green': 1400, 
'cornflower_blue': 1500,
'blue': 1600,
'aqua': 1650,
'midnight_blue': 650, 
'purple': 750, 
'medium_purple': 850,
'indigo':950,
'blue_violet': 1050,
'dark_magenta': 1150,
'deep_pink': 1250,
'brown': 1350, 
'saddle_brown': 1450, 
'white': 1550,
'black': 1650
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

f = open("raw_data_rgb.txt", "r")
g = open("raw_color_check.txt", "w")

pixels = (f.read().split("\n"))
generate_tone(1700, fs*.3)
count = 0
buckets = multiple(500, 42)

for pix in pixels:
    if pix != "":
        pix = pix.split(" ")
        p = pyaudio.PyAudio()

        color = {'r': pix[0], 'g': pix[1], 'b': pix[2]}
        color = find_css_color(color)
        generate_tone(sound_mappings[color])
        
        #complex encoding
        
        #round_number_0 = int(myround(int(pix[0])))
        #r_value = buckets.index(round_number_0)
        
        #round_number_1 = int(myround(int(pix[1])))
        #g_value = buckets.index(round_number_1)
        
        #round_number_2 = int(myround(int(pix[2])))
        #b_value = buckets.index(round_number_2)
        
        #color_x = str(r_value) + str(g_value) + str(b_value)
        #generate_tone(int(color_x))
        
        #black and white
        #generate_tone(int(pix[0])*10)
        
        if count == 200:
            generate_tone(1800, fs*.3)
            count = 0
        g.write("'"+str(color)+"'")
        g.write(",")
        g.write("\n")
        count = count + 1
generate_tone(1900, fs*.3)
f = wave.open('sound.wav', 'w')
f.setparams((int(channels), int(dataSize), int(fs), int(numSamples), "NONE", "Uncompressed"))
f.writeframes(data.tostring())
f.close()