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
float fil_angle_x=0,fil_angle_y=0,fil_angle_z=0;
final float gyroResolution = 65530;//6550 cho thang +-500, con 3280 cho thang +-1000
final int lineglade = 15;//khoang trong giua cac duong
final String correctdata = "imu";
final float delta = 0.96;
float angle(float a,float w){
  a+= dt*w/gyroResolution/2;
  return a;//lamtron2(a);
}
float lamtron2(float a){
   return ((a*1000-(a*1000)%1)/1000);
}
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
        gx = float(dataval);       
      }
      else if (type.equals("gy")) {
        gy = float(dataval);
        
      }
      else if (type.equals("gz")) {
        gz = float(dataval);
        
      }
      else if (type.equals("ax")) {
        ax = float(dataval);
      // gx_file.println(ax);
      }
      else if (type.equals("ay")) {
        ay = float(dataval);
     //  gy_file.println(ay);
      }
      else if (type.equals("az")) {
        az = float(dataval);
        // gz_file.println(az);
      }
      else if (type.equals("gf")) {
        gxf = float(dataval);
       //print("gxf:");
       // println(gxf);
      }
      else if (type.equals("dt")) {
        dt = float(dataval);
        
      }
   }
    angle_x = angle(angle_x,gx);
    angle_y = angle(angle_y,gy);
    angle_z = angle(angle_z,gz);
    accel_angle_y = atan(-ax/sqrt(pow(ay,2) + pow(az,2)));
    if(ax>=0&&az<0){accel_angle_y = -PI-accel_angle_y;  }
    if(ax<=0&&az<0){accel_angle_y = PI-accel_angle_y;  }
    accel_angle_x = atan(ay/sqrt(pow(ax,2) + pow(az,2)));
    if(ay>=0&&az<0){accel_angle_x = -PI-accel_angle_x;  }
    if(ay<=0&&az<0){accel_angle_x = PI-accel_angle_x;  }
    fil_angle_x  = angle(fil_angle_x,gx)*delta + (1-delta)*degrees(accel_angle_x);
    fil_angle_y  = angle(fil_angle_y,gy)*delta + (1-delta)*degrees(accel_angle_y);
    //print("accel angle y: "+degrees(accel_angle_y));
} 

