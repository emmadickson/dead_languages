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
Map<Integer, String[]> og_color_mappings = new Hashtable();

int cellCount = 0;
int t = 200;
Integer[] buckets = new Integer[t];


void setup() {
  for (int i = 0; i < 200; i++){
  buckets[i] = i*40;
}
  int[] red = {251,13,28};
  color_mappings.put("red", red);
  
  int[] yellow = {253,250,55};
  color_mappings.put("yellow", yellow);
  
  int[] cyan  = {45,255,254};
  color_mappings.put("cyan", cyan);
  
  int[] green = {42,253,47};
  color_mappings.put("green", green);
  
  int[] pink = {253,41,252};
  color_mappings.put("pink", pink);
  
  int[] blue = {11,35,243};
  color_mappings.put("blue", blue);

  int[] white = {255,255,255};
  color_mappings.put("white", white);
  
  int[] black = {0,0,0};
  color_mappings.put("black", black);

  int[] gray1 = {51,51,51};
  color_mappings.put("gray1", gray1);
  
  int[] gray2 = {102,102,102};
  color_mappings.put("gray2", gray2);
  
  int[] gray3 = {152,152,152};
  color_mappings.put("gray3", gray3);
  
  int[] gray4 = {203,203,203};
  color_mappings.put("gray4", gray4);
  
  int[] magenta = {255, 0, 255};
  color_mappings.put("magenta", magenta);
  
  sound_mappings.put(300, "red");
  sound_mappings.put(400, "yellow");
  sound_mappings.put(500, "cyan");
  sound_mappings.put(600, "green");
  sound_mappings.put(700, "pink");
  sound_mappings.put(800, "blue");
  sound_mappings.put(900, "white");
  sound_mappings.put(1000, "black");
  sound_mappings.put(1100, "gray1");
  sound_mappings.put(1200, "gray2");
  sound_mappings.put(1300, "gray3");
  sound_mappings.put(1400, "gray4");
  sound_mappings.put(1500, "magenta");


  size(750, 750);
  fill(126);
  background(255);

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
        if (freq >= parseInt(key) - 43 && freq <= parseInt(key) + 43){
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

void makepixel(int r, int g, int b){
  color c = color(r,g,b);
  color star = color(r+1,g+1,b+1);
  color aux = color(r+2,g+2,b+2);

  stroke(aux);
  fill(aux);          
  rect(x,y,2,2);
  
  x = x + 2;
  stroke(star);
  fill(star);          
  rect(x,y,2,2);
  
  x = x + 2;
  stroke(aux);
  fill(aux);          
  rect(x,y,2,2);
  
  y = y + 2;
  x = x - 4;
  
  stroke(star);
  fill(star);          
  rect(x,y,2,2);
  
  x = x + 2;
  stroke(c);
  fill(c);          
  rect(x,y,2,2);
 
  x = x + 2;
  stroke(star);
  fill(star);          
  rect(x,y,2,2);
  
  y = y + 2;
  x = x - 4;
  
  stroke(aux);
  fill(aux);          
  rect(x,y,2,2);
  
  x = x + 2;
  stroke(star);
  fill(star);          
  rect(x,y,2,2);
 
  x = x + 2;
  stroke(aux);
  fill(aux);          
  rect(x,y,2,2);
  
  x = x + 2;
  y = y - 4;
  cellCount = cellCount + 1;
  if (cellCount >= 125){
    x = 0;
    y = y + 7;
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
        if (parseInt(packet[i]) >= 4000 && parseInt(packet[i]) <= 8500){  
   
          String[] row_pixels = split(row, ",");
          List<String> pixelList = Arrays.asList(row_pixels);  
          if (row_pixels.length > 10){
            int diff = row_pixels.length -27;
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
           
             if (freq == 0){
               color c = color(0, 0, 0);
                makepixel(0, 0, 0);
             }
             else{
               String value = map_freq(freq, sound_mappings);
              println(value);
              if (value != "fail"){
               int[] new_color = color_mappings.get(value);
               color c = color(new_color[0], new_color[1], new_color[2]);
               makepixel(new_color[0], new_color[1], new_color[2]);
             }
             else{
               color c = color(50, 50, 50);
               println("fail");
               makepixel(50, 50, 50);
             }
             
               
             }

           }
          }
          /*
          og_color_mappings.put(rgb, row_pixels);
           if (rgb == 2){
             rgb = -1;
             String[] red_row = og_color_mappings.get(0);
             String[] green_row = og_color_mappings.get(1);
             String[] blue_row = og_color_mappings.get(2);
             for (int l = 0; l <= row_pixels.length-1; l++){     
                 int[] parse_color = {700-parseInt(red_row[l]), 700-parseInt(green_row[l]), 700-parseInt(blue_row[l])};
                 int[] color_mapped = map_freq(parse_color, color_mappings);
                 color c = color(color_mapped[0], color_mapped[1], color_mapped[2]);
                 makepixel(c);
                 
              }  
           }
           rgb = rgb + 1;
          }
          */
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
