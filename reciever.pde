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


void setup() {
  for (int i = 0; i < 200; i++){
  buckets[i] = i*40;
}
  int[] red = {255, 0, 0};
  color_mappings.put("red", red);
  int[] dark_red = {139, 0, 0};
  color_mappings.put("dark_red", dark_red);
  int[] orange = {255, 165, 0};
  color_mappings.put("orange", orange);
  int[] dark_orange = {255, 140, 0};
  color_mappings.put("dark_orange", dark_orange);
  int[] yellow = {255, 255, 0};
  color_mappings.put("yellow", yellow);
int[] golden_rod = {218, 165, 0};
  color_mappings.put("golden_rod", golden_rod);
  int[] green = {0, 128, 0};
  color_mappings.put("green", green);
  int[] light_sea_green = {32, 178, 170};
  color_mappings.put("light_sea_green", light_sea_green);
  int[] blue = {0, 0, 255};
  color_mappings.put("blue", blue);
  int[] midnight_blue = {25, 25, 112};
  color_mappings.put("midnight_blue", midnight_blue);
  int[] purple = {128, 0, 128};
  color_mappings.put("purple", purple);
  int[] medium_purple = {147, 112, 219};
  color_mappings.put("medium_purple", medium_purple);

  int[] brown = {165, 42, 42};
  color_mappings.put("brown", brown);
  int[] saddle_brown = {139, 69, 19};
  color_mappings.put("saddle_brown", saddle_brown);
  int[] white = {255, 255, 255};
  color_mappings.put("white", white);
  int[] black = {0, 0, 0};
  color_mappings.put("black", black);
  int[] antique_white = {250, 235, 215};
  color_mappings.put("antique_white", antique_white);
  int[] aqua = {0, 255, 255};
  color_mappings.put("aqua", aqua);
  int[] blue_violet = {138, 43, 226};
  color_mappings.put("blue_violet", blue_violet);
  int[] dark_magenta = {139, 0, 139};
  color_mappings.put("dark_magenta", dark_magenta);
  
  sound_mappings.put(350, "red");
  sound_mappings.put(400, "dark_red");
  sound_mappings.put(450, "orange");
  sound_mappings.put(500, "dark_orange");
  sound_mappings.put(550, "yellow");
  sound_mappings.put(600, "golden_rod");
  sound_mappings.put(650, "green");
  sound_mappings.put(700, "light_sea_green");
  sound_mappings.put(750, "blue");
  sound_mappings.put(800, "midnight_blue");
  sound_mappings.put(850, "purple");
  sound_mappings.put(900, "medium_purple");
  sound_mappings.put(950, "brown");
  sound_mappings.put(1000, "saddle_brown");
  sound_mappings.put(1050, "white");
  sound_mappings.put(1100, "black");
  sound_mappings.put(1150, "antique_white");
  sound_mappings.put(1200, "aqua");
  sound_mappings.put(1250, "blue_violet");
  sound_mappings.put(1300, "dark_magenta");


  size(200, 200);
  fill(126);
  background(105);

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
        if (freq >= parseInt(key) - 30 && freq <= parseInt(key) + 30){
          return value;
        }
    }
    return "fail";
}
public static int find(int[] a, int target)
{
  for (int i = 0; i < a.length; i++)
    if (a[i] == target)
      return i;

  return -1;
}

Integer[] test_map(int freq){
  println("test_map");
  println(freq);
  int r_value;
  int g_value;
  int b_value;
  int r;
  int g;
  int b;
  String string_freq = Integer.toString(freq);
 
  if (string_freq.length() == 2){
     r = 9;
     g = Character.getNumericValue(string_freq.charAt(0));
     b = Character.getNumericValue(string_freq.charAt(1));
     r_value = 9;
  }
  
   else{
     r = Character.getNumericValue(string_freq.charAt(0));
     g = Character.getNumericValue(string_freq.charAt(1));
     b = Character.getNumericValue(string_freq.charAt(2));
     r_value = (r)*40;
   }
    g_value = (g)*40;
    b_value = (b)*40;
 
  Integer[] color_x = new Integer[3];
  color_x[0] = r_value;
  color_x[1] = g_value;
  color_x[2] = b_value;
  return color_x;
}

void makepixel(color c){
  stroke(c);
  fill(c);          // Setting the interior of a shape (fill) to grey 
  rect(x,y,1,1);
  x = x + 1;
  cellCount = cellCount + 1;
  if (cellCount >= 200){
    x = 0;
    y = y + 1;
    cellCount = 0;
  }
}

boolean starter_threshold(String[] values){
  int count = 0;
  for (int i = 0; i < values.length; i++){
    if (parseInt(values[i]) > 1500 && parseInt(values[i]) < 1660){
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
    if (parseInt(values[i]) > 2900 && parseInt(values[i]) < 3050){
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

void draw() { 
  fft.analyze(spectrum);
  float max_1 = -1;
  int max_1_index = -1;
  
  for(int i = 0; i < bands; i++){
    if(spectrum[i] > max_1){
       max_1 = spectrum[i];
       max_1_index = i;
      }
  } 
  int average = max_1_index*42;  
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
        if (parseInt(packet[i]) >= 3400 && parseInt(packet[i]) <= 3650){   
          String[] row_pixels = split(row, ",");
          List<String> pixelList = Arrays.asList(row_pixels);  

          if (row_pixels.length > 50){
            int diff = row_pixels.length - 200;
            //println(diff);
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
           //println("fixed");
           //println(row_pixels);
           for (int l = 0; l <= row_pixels.length-1; l++){
             
             int freq = parseInt(row_pixels[l]);
           
             if (freq == 0){
               color c = color(0, 0, 0);
                makepixel(c);
             }
             else{
               //complex color encoding
              //Integer[] color_x = test_map(freq);
              //grayscale
              // color c = color(freq/10, freq/10, freq/10);
              
              /*color c = color(color_x[0], color_x[1], color_x[2]);
              makepixel(c);*/
              // original hard code map
              String value = map_freq(freq, sound_mappings);
              println(value);
              if (value != "fail"){
               int[] new_color = color_mappings.get(value);
               //println(new_color);
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
          }
          row = "";
        }
        if  (parseInt(packet[i]) < 1500){
          row = row + "," + packet[i];
        }
      }
    }
    String[] leftover_packet = subset(list, 3);
    items = join(leftover_packet, ",");
  }
}