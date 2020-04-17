  
import processing.sound.*;
import java.util.Map;
import java.util.Hashtable;
import processing.serial.*;

Serial myPort;  // Create object from Serial class
String val;    

FFT fft;
AudioIn in;
int bands = 512;
float[] spectrum = new float[bands];
float max_value;
float max_index;
boolean recording = false;
String row = "";
int cellCount = 0;
int x = 0;
int y = 0;

Map<Integer, String> sound_mappings = new Hashtable();
Map<String, int[]> color_mappings = new Hashtable();
int[] sounds = {215, 301, 387, 559, 645, 731, 903, 989, 1075, 1247, 1333, 1419, 1591, 1677, 1763, 1935, 2021, 2107, 2236, 2322};

void setup() {

  int[] red = {252,13,27};
  color_mappings.put("red", red);
  int[] dark_red = {192,191,39};
  color_mappings.put("dark_red", dark_red);
  

  int[] pink = {253,40,152};
  color_mappings.put("pink", pink);
  int[] dark_pink = {31,192,191};
  color_mappings.put("dark_pink", dark_pink);

  int[] green = {41,253,47};
  color_mappings.put("green", green);
  int[] dark_green = {28,190,32};
  color_mappings.put("dark_green", dark_green);
  
  int[] blue = {11,36,250};
  color_mappings.put("blue", blue);
  int[] dark_blue = {190,28,190};
  color_mappings.put("dark_blue", dark_blue);
  
  int[] cyan = {45,255,254};
  color_mappings.put("cyan", cyan);
  int[] dark_cyan = {190,7,17};
  color_mappings.put("dark_cyan", dark_cyan);
  
  int[] yellow = {255,253,56};
  color_mappings.put("yellow",yellow);
  int[] dark_yellow = {6,24,189};
  color_mappings.put("dark_yellow", dark_yellow);
  
  
  int[] white = {255,255,255};
  color_mappings.put("white", white);
  int[] black = {0,0,0};
  color_mappings.put("black", black);

  sound_mappings.put(301, "red");
  sound_mappings.put(387, "dark_red");

  sound_mappings.put(645, "pink");
  sound_mappings.put(731, "dark_pink");

  sound_mappings.put(989, "green");
  sound_mappings.put(1075, "dark_green");
  
  sound_mappings.put(1333, "blue");
  sound_mappings.put(1419, "dark_blue");
  
  sound_mappings.put(1677, "cyan");
  sound_mappings.put(1763, "dark_cyan");
  
  sound_mappings.put(2021, "yellow");
  sound_mappings.put(2107, "dark_yellow");

  sound_mappings.put(2236, "white");
  sound_mappings.put(2322, "black");
  
  size(200, 200);
  background(255);
    
  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, bands);
  in = new AudioIn(this, 0);
  
  // start the Audio Input
  in.start();
  
  // patch the AudioIn
  fft.input(in);
}      

int [] find(int number){
  int distance = Math.abs(sounds[0] - number);
  int idx = 0;
  for(int c = 1; c < sounds.length; c++){
      int cdistance = Math.abs(sounds[c] - number);
      if(cdistance < distance){
          idx = c;
          distance = cdistance;
      }
  }
  int theNumber = sounds[idx];
  String c = sound_mappings.get(theNumber);
  return color_mappings.get(c);
}

void makepixel(int r, int g, int b){
  color c = color(r,g,b);

  stroke(c);
  fill(c);
  rect(x,y,1,1);

  x = x + 1;

  cellCount = cellCount + 1;
  if (cellCount >= 200){
    x = 0;
    y = y + 1;
    cellCount = 0;
  }
}

void draw() { 
  String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
  if ( myPort.available() > 0) 
  {  // If data is available,
  val = myPort.readStringUntil('\n');         // read it and store it in val
  } 
  max_value = -1000;
  max_index = -1000;
  
  float freq = max_index * 43;
  if (recording == true && freq < 3600 && freq > 350){
     row = row + freq;
     row = row + ",";
  }
  else if (freq >= 11900 && freq <= 12100){
    x = 0;
    y = 0;
    row = "";
    background(255);
  }
  else if (freq >= 5900 && freq <= 6100 && recording == false){
    recording = true;
  }
  else if (freq >= 3900 && freq <= 4100 && recording == true){
     recording = false;
     row = row + "";
     String[] row_pixels = split(row, ",");
     int diff = row_pixels.length - 54;
     row_pixels = subset(row_pixels, 2);
     row_pixels = subset(row_pixels, 0, row_pixels.length-2);
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
           }
         }
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
         println(row_pixels);
         for (int l = 0; l <= row_pixels.length-1; l++){
             int freq_def = parseInt(row_pixels[l]);
             int [] color_array = find(freq_def);
             makepixel(color_array[0], color_array[1], color_array[2]);
         }
         row = "";
  }
       
  
  else if (freq >= 10900 && freq <= 13200) {
     recording = true;
  }
}
