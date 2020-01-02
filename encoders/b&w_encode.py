from PIL import Image
import pyaudio
import math
import array
import wave
from math import *


volume = 100     # range [0.0, 1.0]
fs = 44100       # sampling rate, Hz, must be integer
duration = .0182 # in seconds, may be float
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
tt = open("data/raw_data_bw.txt", "w")

pixels = (t.read().split("\n"))
generate_tone(10000, fs*.1)
count = 0
quarter = 0
for pix in pixels:
    if pix != "":
        pix = pix.split(" ")
        p = pyaudio.PyAudio()

        #black and white
        generate_tone(int(pix[0])*8)
        tt.write(str(int(pix[0])*8))
        tt.write("\n")
        if count == 40:
            generate_tone(5500, fs*.1)
            count = 0

        count = count + 1

f = wave.open('audio/b&w.wav', 'w')
f.setparams((int(channels), int(dataSize), int(fs), int(numSamples), "NONE", "Uncompressed"))
f.writeframes(data.tostring())
f.close()
