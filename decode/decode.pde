import processing.sound.*;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Hashtable;
import java.util.Arrays;
import java.util.List;
import java.util.ArrayList;

FFT fft;
AudioIn in;
int bands = 1024;
float[] spectrum = new float[bands];
int index = 0;
int x = 0;
int y = 0;
String items = "";
int count = 0;
boolean listening = false;
String row = "";
boolean pixel_flag = false;
Map<Integer, String> sound_mappings = new Hashtable();
Map<String, int[]> color_mappings = new Hashtable();

// Bayer matrix
int[][] matrix = {
  {
    1, 9, 3, 11
  }
  ,
  {
    13, 5, 15, 7
  }
  ,
  {
    4, 12, 2, 10
  }
  ,
  {
    16, 8, 14, 6
  }
};



float mratio = 1.0 / 17;
float mfactor = 255.0 / 5;
int cellCount = 0;

void setup() {
  int[] white = {255,255,255};
  color_mappings.put("white", white);

  int[] blue = {0,54,247};
  color_mappings.put("blue", blue);

  int[] green = {0,247,63};
  color_mappings.put("green", green);

  int[] cyan = {0,251,253};
  color_mappings.put("cyan", cyan);

  int[] red = {255,51,40};
  color_mappings.put("red", red);

  int[] magenta = {255,70,250};
  color_mappings.put("magenta", magenta);

  int[] yellow = {255,251,75};
  color_mappings.put("yellow", yellow);

  int[] black = {0,0,0};
  color_mappings.put("black", black);

  sound_mappings.put(200, "white");
  sound_mappings.put(400, "blue");
  sound_mappings.put(600, "green");
  sound_mappings.put(800, "cyan");
  sound_mappings.put(1000, "red");
  sound_mappings.put(1200, "magenta");
  sound_mappings.put(1400, "yellow");
  sound_mappings.put(1600, "black");

  size(300, 300);
  fill(126);
  background(255);
  frameRate(100);
  fft = new FFT(this, bands);
  in = new AudioIn(this, 0);

  // start the Audio Input
  in.start();

  // patch the AudioIn
  fft.input(in);

}

String map_freq(int freq, Map<Integer, String> sound_mappings){
  for (Map.Entry<Integer, String> entry : sound_mappings.entrySet()) {
        Integer key = entry.getKey();
        String value = entry.getValue();
        if (freq >= parseInt(key) - 50 && freq <= parseInt(key) + 50){
          return value;
        }
    }
    return "fail";
}

void makepixel(int r, int g, int b){
  color oldpixel = color(r,g,b);
  color c = color( (oldpixel >> 16 & 0xFF) + (mratio*matrix[x%4][y%4] * mfactor), (oldpixel >> 8 & 0xFF) + (mratio*matrix[x%4][y%4] * mfactor), (oldpixel & 0xFF) + + (mratio*matrix[x%4][y%4] * mfactor) );

  stroke(c);
  fill(c);
  rect(x,y,3,3);

  x = x + 3;

  cellCount = cellCount + 1;
  if (cellCount >= 100){
    x = 0;
    y = y + 3;
    cellCount = 0;
  }
}

boolean starter_threshold(String[] values){
  int count = 0;
  for (int i = 0; i < values.length; i++){
    if (parseInt(values[i]) > 9000 && parseInt(values[i]) < 11000){
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

boolean end_threshold(String[] values){
  int count = 0;
  for (int i = 0; i < values.length; i++){
    if (parseInt(values[i]) > 1850 && parseInt(values[i]) < 1950){
      count = count + 1;
    }
  }
  if (count >= 7){
    return true;
  }
  else {
    return false;
  }
}

void draw() {
fft.analyze(spectrum);
float max_1 = -1;
int max_1_index = -1;
float max_2 = -1;
int max_2_index = -1;
for(int i = 0; i < bands; i++){
  if(spectrum[i] > max_1){
     max_1 = spectrum[i];
     max_1_index = i;
    }
  if(spectrum[i] > max_2 && spectrum[i] != max_1){
     max_2 = spectrum[i];
     max_2_index = i;
    }
}

int average = ((max_1_index*21)+(max_2_index*21))/2;
  items = items + "," + average;
  String[] list = split(items, ",");

  if (list.length >= 6){
    String[] packet = subset(list, 0, 3);
    if (listening == false){
      listening = starter_threshold(packet);
      if (listening == true){
        println("listening");
      }
    }

    if (listening != false) {
      boolean end = end_threshold(packet);
      if (end == true){
        listening = false;
        println("done");
      }
      for (int i = 0; i < packet.length; i++){
        if (parseInt(packet[i]) >= 4000 && parseInt(packet[i]) <= 8000){

          String[] row_pixels = split(row, ",");
          List<String> pixelList = Arrays.asList(row_pixels);
          if (row_pixels.length > 10){
            int diff = row_pixels.length - 27;
                         row_pixels = subset(row_pixels, 2);

            println(diff);
             if (diff > 0){
             for (int k = 0; k < diff; k++){

              int rand = (int)random(row_pixels.length);
              if (rand == 0){
                row_pixels = subset(row_pixels, 1, row_pixels.length-1);
              }
                if (rand != 0){
                      String[] replacement = new String[row_pixels.length -1];
                      int place = 0;
                      for (int j = 0; j < row_pixels.length; j ++){
                        if (j != rand){
                          replacement[place] = row_pixels[j];
                          place = place + 1;
                        }
                      }
                  row_pixels = replacement;
                }}
               }
               if (diff < 0){
                 for (int l = 0; l < diff*-1; l++){
                 String[] replacement = new String[row_pixels.length +1];
                  int rand = (int)random(row_pixels.length-4);
                  if (rand == 0){
                    rand = 1;
                  }
                  int place = 0;
                  for (int j = 0; j < row_pixels.length+1; j ++){
                      if (j != rand){
                        replacement[j] = row_pixels[place];
                        place = place + 1;
                      }
                      else{
                        replacement[j] = row_pixels[rand];
                      }
                    }
                    row_pixels = replacement;
               }

             }
           println("fixed");
           println(row_pixels.length);
           for (int l = 0; l <= row_pixels.length-1; l++){

             int freq = parseInt(row_pixels[l]);


               int reduced_freq = freq/8;
               makepixel(reduced_freq,reduced_freq,reduced_freq);
              /* String value = map_freq(freq, sound_mappings);
              println(value);
              if (value != "fail"){
               int[] new_color = color_mappings.get(value);
               makepixel(new_color[0], new_color[1], new_color[2]);
             }
             else{
               color c = color(50, 50, 50);
               println("fail");
               makepixel(50, 50, 50);
             }
            */

           }
          }
          row = "";
        }
        if  (parseInt(packet[i]) >= 200 && parseInt(packet[i]) <= 10000){

          row = row + "," + packet[i];
        }
      }
    }
    String[] leftover_packet = subset(list, 3);
    items = join(leftover_packet, ",");
  }
}
