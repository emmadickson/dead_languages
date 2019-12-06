import processing.sound.*;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Hashtable;
import java.util.Arrays;
import java.util.List;
import java.util.ArrayList;

FFT fft;
AudioIn in;
int bands = 512;
float[] spectrum = new float[bands];

int x = 0;
int y = 0;
int cellCount = 0;
int line_length = 100;
int width = 4;
int height = 4;
int_total_count = 0;

boolean listening_start = false;
boolean pixel_detected = false;

String[] red_array = '';
String[] green_array = '';
String[] blue_array = '';
String[] max_array = '';

void setup() {

  size(400, 400);
  fill(126);
  background(105);

  fft = new FFT(this, bands);
  in = new AudioIn(this, 0);

  // start the Audio Input
  in.start();

  // patch the AudioIn
  fft.input(in);

}

void makepixel(color c){
  stroke(c);
  fill(c);          // Setting the interior of a shape (fill) to grey
  rect(x,y,width,height);
  x = x + width;
  cellCount = cellCount + 1;
  if (cellCount >= line_length){
    x = 0;
    y = y + height;
    cellCount = 0;
  }
}

boolean starter_threshold(String[] values){
  int count = 0;
  for (int i = 0; i < values.length; i++){
    if (parseInt(values[i]) > 1600 && parseInt(values[i]) < 1790){
      count = count + 1;
    }
  }
  if (count >= 3){
    return true;
  }
  else {
    return false;
  }
}

int max_fft_value(float[] spectrum){
    float max_1 = -1;
    int max_1_index = -1;

    for(int i = 0; i < bands; i++){
      if(spectrum[i] > max_1){
         max_1 = spectrum[i];
         max_1_index = i;
        }
    }
    int average = max_1_index*36;
    return average;
}
int average_value(String[] spectrum){
    int average = 0;

    for(int i = 0; i < spectrum.length-1; i++){
      average = average + int(spectrum[i])
    }
    average = average/spectrum.length;
    return average;
}

void draw() {
  fft.analyze(spectrum);
  int max_fft = max_fft_value(spectrum);

  if (listening_start == false){
      max_array = max_array + "," + max_fft;

      if (max_array.length >= 6){
        listening = starter_threshold(max_array);
        if (listening_start == true){
            println("listening");
        }
      }
  }

  if (listening_start == true){
    if (max_fft_value < 4000){
        int r = max_fft_value(subset(spectrum, 4, 8));
        red_array = red_array + ',' + r

        int g = max_fft_value(subset(spectrum, 12, 8));
        green_array = green_array + ',' + g

        int b = max_fft_value(subset(spectrum, 20, 8));
        blue_array = blue_array + ',' + b
    }
    else{
        if (max_fft_value >= 4000 && max_fft_value < 5500){
            if (red_array.length >= 6){
                int r = average_value(red_array);
                int g = average_value(green_array);
                int b = average_value(blue_array);
                color c = color(r, g, b);
                makepixel(c);
                int_total_count = int_total_count + 1;
                if(int_total_count>= 100000){
                    listening_start = false;
                }
            }
        }
    }
  }



}
