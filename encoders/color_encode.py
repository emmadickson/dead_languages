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
        generate_tone(1500-int(red))
    generate_tone(5500, fs*.1)
    for green in chunks_row_green[x]:
        generate_tone(1500-int(green))
    generate_tone(5500, fs*.1)
    for blue in chunks_row_blue[x]:
        generate_tone(1500-int(blue))
    generate_tone(5500, fs*.1)

f = wave.open('audio/color.wav', 'w')
f.setparams((int(channels), int(dataSize), int(fs), int(numSamples), "NONE", "Uncompressed"))
f.writeframes(data.tostring())
f.close()
