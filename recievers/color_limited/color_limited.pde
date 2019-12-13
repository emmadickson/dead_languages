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
  
  
  int[] orange = {255, 165, 0};
  color_mappings.put("orange", orange);
  
  int[] yellow = {255, 255, 0};
  color_mappings.put("yellow", yellow);
  
  int[] green = {0, 128, 0};
  color_mappings.put("green", green);
  
  int[] blue = {0, 0, 255};
  color_mappings.put("blue", blue);
  
  int[] purple = {128, 0, 128};
  color_mappings.put("purple", purple);

  int[] indigo = {75, 0, 130};
  color_mappings.put("indigo", indigo);
  
  int[] deep_pink = {255, 20, 147};
  color_mappings.put("deep_pink", deep_pink);
  
  int[] brown = {165, 42, 42};
  color_mappings.put("brown", brown);
  
  int[] white = {255, 255, 255};
  color_mappings.put("white", white);
  
  int[] black = {0, 0, 0};
  color_mappings.put("black", black);
  
  sound_mappings.put(300, "red");
  sound_mappings.put(400, "orange");
  sound_mappings.put(500, "yellow");
  sound_mappings.put(600, "green");
  sound_mappings.put(700, "blue");
  sound_mappings.put(800, "purple");
  sound_mappings.put(900, "indigo");
  sound_mappings.put(1000, "deep_pink");
  sound_mappings.put(1100, "brown");
  sound_mappings.put(1200, "white");
  sound_mappings.put(1300, "black");



  size(300, 300);
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



void makepixel(color c){
  stroke(c);
  fill(c);          // Setting the interior of a shape (fill) to grey 
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
    if (parseInt(values[i]) > 9000 && parseInt(values[i]) < 11500){
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

boolean end_threshold(String[] values){
  int count = 0;
  for (int i = 0; i < values.length; i++){
    if (parseInt(values[i]) > 1850 && parseInt(values[i]) < 1950){
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
  float max_2 = -1;
  int max_2_index = -1;
  float max_3 = -1;
  int max_3_index = -1;
  
  for(int i = 0; i < bands; i++){
    if(spectrum[i] > max_1){
       max_1 = spectrum[i];
       max_1_index = i;
      }
      if(spectrum[i] > max_2 && i != max_1_index){
       max_2 = spectrum[i];
       max_2_index = i;
      }
      if(spectrum[i] > max_3 && i != max_1_index && i != max_2_index){
       max_3 = spectrum[i];
       max_3_index = i;
      }
  } 
  int average = (max_1_index*42);  
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
        if (parseInt(packet[i]) >= 3000 && parseInt(packet[i]) <= 5500){  
   
          String[] row_pixels = split(row, ",");
          List<String> pixelList = Arrays.asList(row_pixels);  
          if (row_pixels.length > 50){
            int diff = row_pixels.length -50;
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
           
             if (freq == 0){
               color c = color(0, 0, 0);
                makepixel(c);
             }
             else{
               String value = map_freq(freq, sound_mappings);
              println(value);
              if (value != "fail"){
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
          }
          row = "";
        }
        if  (parseInt(packet[i]) > 50){
          
          row = row + "," + packet[i];
        }
      }
    }
    String[] leftover_packet = subset(list, 3);
    items = join(leftover_packet, ",");
  }
}
