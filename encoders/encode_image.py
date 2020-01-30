from PIL import Image
import pyaudio
import math
import array
import wave
from math import *


im = Image.open('images/man.jpg')
pixels = list(im.getdata())

raw_data_rgb = open("data/raw_data_rgb.txt", 'w')

for pix in pixels:
    pix = str(pix)

    pix = pix.replace("(", "")
    pix = pix.replace(")", "")
    pix = pix.replace(",", "")

    raw_data_rgb.write(pix)
    raw_data_rgb.write("\n")
