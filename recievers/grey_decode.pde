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
  rect(x,y,2,2);
  x = x + 2;
  total_count = total_count + 1;
  cellCount = cellCount + 1;
  if (cellCount >= 200){
    x = 0;
    y = y + 2;
    cellCount = 0;
  }
  if (total_count >= 40000){
    listening = false;
  }
}

boolean starter_threshold(String[] values){
  int count = 0;
  for (int i = 0; i < values.length; i++){
    if (parseInt(values[i]) > 2950 && parseInt(values[i]) < 5400){
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
  int average = ((max_1_index*41)+(max_2_index*41))/2; 
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
      
      for (int i = 0; i < packet.length; i++){
        if (parseInt(packet[i]) >= 2000 && parseInt(packet[i]) <= 6500){  
     
          String[] row_pixels = split(row, ",");
          List<String> pixelList = Arrays.asList(row_pixels);  
          if (row_pixels.length >= 20){
            int diff = row_pixels.length - 50;
            println("section detected");
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
             if (freq == 0){
               color c = color(0, 0, 0);
                makepixel(c);
             }
             else{
              //grayscale
              
               color c = color(freq/10, freq/10, freq/10);
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