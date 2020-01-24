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
String items = "";

int count = 0;
boolean listening = false;
String row = "";
int rgb = 0;

Map<Integer, String[]> color_mappings = new Hashtable();

int cellCount = 0;
int total_count = 0;

void setup() {

  size(600, 600);
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
  rect(x,y,4,4);
  x = x + 4;
  total_count = total_count + 1;
  cellCount = cellCount + 1;
  if (cellCount >= 150){

    x = 0;
    y = y + 4;
    cellCount = 0;
  }
  if (total_count >= 40000){
    listening = false;
  }
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

  for(int i = 0; i < bands; i++){
    if(spectrum[i] > max_1){
       max_1 = spectrum[i];
       max_1_index = i;
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
            int diff = row_pixels.length - 77;
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
           color_mappings.put(rgb, row_pixels);
           if (rgb == 2){
             rgb = -1;
             String[] red_row = color_mappings.get(0);
             String[] green_row = color_mappings.get(1);
             String[] blue_row = color_mappings.get(2);
             for (int l = 0; l <= row_pixels.length-1; l++){     
                 makepixel(1500-parseInt(red_row[l]), 1500-parseInt(green_row[l]), 1500-parseInt(blue_row[l]));
              }  
           }
           rgb = rgb + 1;
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
