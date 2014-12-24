import processing.serial.*; 
 
Serial myPort;    // The serial port
PFont myFont;     // The display font
String inString;  // Input string from serial port
int lf = 10;      // ASCII linefeed 
String[] dataStrings; 
String type; 
String dataval; 
float gx=1,gy=1,gz=1,ax=1,ay=1,az=1,dt=1;
float gxf, angle_x = 0,angle_y=0,angle_z=0;
float accel_angle_x = 0,accel_angle_y = 0;

final int lineglade = 15;//khoang trong giua cac duong

void serialEvent(Serial p) { 
  inString = p.readString(); 
  //println(inString);
  dataStrings = split(inString, '#');
 //  println(dataStrings.length);
   for (int i = 1; i < dataStrings.length; i++) {
      println(dataStrings[i]);
      type = dataStrings[i].substring(0,2);
      dataval = dataStrings[i].substring(2);
      if (type.equals("gx")) {
        angle_x = float(dataval);       
      }
      else if (type.equals("gy")) {
        angle_y = float(dataval);
        
      }
      else if (type.equals("gz")) {
        angle_z = float(dataval);
        
      }
      else if (type.equals("ax")) {
        accel_angle_x = float(dataval);
      // gx_file.println(ax);
      }
      else if (type.equals("ay")) {
        accel_angle_y = float(dataval);
     //  gy_file.println(ay);
      }
      else if (type.equals("az")) {
        az = float(dataval);
        // gz_file.println(az);
      }
      else if (type.equals("dt")) {
        dt = float(dataval);
        
      }
   }
    
} 

