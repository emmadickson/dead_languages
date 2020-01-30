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

Map<Integer, String[]> og_color_mappings = new Hashtable();
Map<String, int[]> color_mappings = new Hashtable();

int cellCount = 0;
int total_count = 0;

void setup() {
 int[] poppy_field = {179, 48, 34};
  color_mappings.put("poppy_field", poppy_field);
  int[] yellow_brick_road = {229, 207, 60};
  color_mappings.put("yellow_brick_road", yellow_brick_road);
  int[] mint = {188, 217, 190};
  color_mappings.put("mint", mint);
  int[] powder_blue = {159, 176, 199};
  color_mappings.put("powder_blue", powder_blue);
  int[] egyptian_blue = {69, 94, 149};
  color_mappings.put("egyptian_blue", egyptian_blue);
  int[] jade = {81, 114, 91};
  color_mappings.put("jade", jade);
  int[] wizard = {134, 205, 106};
  color_mappings.put("wizard", wizard);
  int[] deep_pink = {204, 85, 155};
  color_mappings.put("deep_pink", deep_pink);
  int[] white = {255, 255, 255};
  color_mappings.put("white", white);
  int[] black = {0, 0, 0};
  color_mappings.put("black", black);
  int[] magenta = {255, 0,255};
  color_mappings.put("magenta", magenta);
  int[] cyan = {0, 255,255};
  color_mappings.put("cyan", cyan);
  int[] yellow = {255, 255, 0};
  color_mappings.put("yellow", yellow);
  int[] digital_green = {164, 255, 78};
  color_mappings.put("digital_green", digital_green);
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
  rect(x,y,6,6);
  x = x + 6;
  total_count = total_count + 1;
  cellCount = cellCount + 1;
  if (cellCount >= 100){

    x = 0;
    y = y + 4;
    cellCount = 0;
  }
  if (total_count >= 40000){
    listening = false;
  }
}
int[] map_freq(int[] new_color, Map<String, int[]> color_mappings){
  int min = 1000;
  int[] color_match = {0, 0, 0};
  for (Map.Entry<String, int[]> entry : color_mappings.entrySet()) {
        int[] value = entry.getValue();
    
        float d = sqrt(pow(((int(new_color[0]) - int(value[0]))*0.6),2) + pow(((int(new_color[1]) - int(value[1]))*0.59),2) + pow(((int(new_color[2]) - int(value[2]))*0.11),2));
        if (int(d) < int(min)){
          min = int(d);
          color_match = value;
         }
    }
    return color_match;
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
          row = "";
        }
        if  (parseInt(packet[i]) > 150 && parseInt(packet[i]) <= 1500){

          row = row + "," + packet[i];
        }
      }
    }
    String[] leftover_packet = subset(list, 3);
    items = join(leftover_packet, ",");
  }
}
