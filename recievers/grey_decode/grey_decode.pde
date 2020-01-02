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

int cellCount = 0;
int t = 200;
Integer[] buckets = new Integer[t];
int total_count = 0;

void setup() {

  size(600, 600);
  fill(126);
  background(105);
  int[] red = {255, 0, 0};
  color_mappings.put("red", red);
  
  int[] orange = {255, 149, 0};
  color_mappings.put("orange", orange);
  
  int[] yellow = {255, 247, 0};
  color_mappings.put("yellow", yellow);
  
  int[] green = {12, 252, 0};
  color_mappings.put("green", green);
  
  int[] light_blue = {0, 252, 252};
  color_mappings.put("light_blue", light_blue);
  
  int[] blue = {0, 29, 252};
  color_mappings.put("blue", blue);
  
  int[] purple = {97, 0, 252};
  color_mappings.put("purple", purple);

  int[] indigo = {6, 11, 92};
  color_mappings.put("indigo", indigo);
  
  int[] deep_pink = {209, 2, 199};
  color_mappings.put("deep_pink", deep_pink);
  
  int[] white = {255, 255, 255};
  color_mappings.put("white", white);
  
  int[] black = {0, 0, 0};
  color_mappings.put("black", black);
  
  int[] brown = {150, 75, 0};
  color_mappings.put("brown", brown);
  
  int[] dark_orange = {255, 77, 0};
  color_mappings.put("dark_orange", dark_orange);
  
  int[] dark_yellow = {255, 191, 0};
  color_mappings.put("dark_yellow", dark_yellow);
  
  int[] dark_green = {2, 184, 62};
  color_mappings.put("dark_green", dark_green);
  
   int[] light_pink = {253, 145, 255};
  color_mappings.put("light_pink", light_pink);
  
  int[] light_yellow = {255, 212, 143};
  color_mappings.put("light_yellow", light_yellow);
  
  sound_mappings.put(300, "red");
  sound_mappings.put(350, "dark_orange");
  sound_mappings.put(400, "orange");
  sound_mappings.put(450, "dark_yellow");
  sound_mappings.put(500, "yellow");
  sound_mappings.put(550, "dark_green");

  sound_mappings.put(600, "green");
  sound_mappings.put(700, "blue");
  sound_mappings.put(650, "light_blue");
  sound_mappings.put(800, "purple");
  sound_mappings.put(900, "indigo");
    sound_mappings.put(1500, "light_pink");

  sound_mappings.put(1000, "deep_pink");
  sound_mappings.put(1200, "white");
  sound_mappings.put(1300, "black");
    sound_mappings.put(1400, "brown");
    sound_mappings.put(1550, "light_yellow");

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
  rect(x,y,3,3);
  x = x + 3;
  total_count = total_count + 1;
  cellCount = cellCount + 1;
  if (cellCount >= 200){

    x = 0;
    y = y + 3;
    cellCount = 0;
  }
  if (total_count >= 40000){
    listening = false;
  }
}
String map_freq(int freq, Map<Integer, String> sound_mappings){
  for (Map.Entry<Integer, String> entry : sound_mappings.entrySet()) {
        Integer key = entry.getKey();
        String value = entry.getValue();
        if (freq >= parseInt(key) - 55 && freq <= parseInt(key) + 55){
          return value;
        }
    }
    return "fail";
}
boolean starter_threshold(String[] values){
  int count = 0;
  for (int i = 0; i < values.length; i++){
    if (parseInt(values[i]) > 9000 && parseInt(values[i]) < 13000){
      count = count + 1;
    }
  }
  if (count >= 1){
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
      if(spectrum[i] > max_2 && i != max_1_index){
       max_2 = spectrum[i];
       max_2_index = i;
      }
  }
  items = items + "," + (max_1_index*43);
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

      for (int i = 0; i < packet.length; i++){
        
        if (parseInt(packet[i]) >= 5000 && parseInt(packet[i]) <= 6000){
          
          String[] row_pixels = split(row, ",");
          List<String> pixelList = Arrays.asList(row_pixels);
          if (row_pixels.length >= 20){
            int diff = row_pixels.length - 52;
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
                  int rand = (int)random(row_pixels.length-1);
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
            /* if (freq == 0){
               color c = color(0, 0, 0);
                makepixel(c);
             }
             else{
               grayscale
                 color c = color(freq/8, freq/8, freq/8);
             */
            
            String value = map_freq(freq, sound_mappings);
              if (value != "fail"){
                println(value);
               int[] new_color = color_mappings.get(value);
               color c = color(new_color[0], new_color[1], new_color[2]);
               makepixel(c);
             }
             else{
               color c = color(50, 50, 50);
               println("fail");
               makepixel(c);
             }

           }
          }
          row = "";
        }
        if  (parseInt(packet[i]) > 150){

          row = row + "," + packet[i];
        }
      }
    }
    String[] leftover_packet = subset(list, 3);
    items = join(leftover_packet, ",");
  }
}
