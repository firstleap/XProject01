float xtheta=0, ytheta=0, ztheta=0;
PFont font;
int error;
int xbox1, ybox1, xbox2,ybox2,xbox3,ybox3;
PImage Top,Bot,Left,Right,Front,Back;
PrintWriter accel_file,compass_file,gyro_file,fil_file,time_file,gx_file,gy_file,gz_file;
//com--------------------------------------
//het com------------------------------------
//int xwindow=600,ywindow=400;
void setup() {
  size(1200, 700, P3D);
  //font = createFont("Adalus", 20, true);//phong chu
  time_file = createWriter("time.txt"); 
   println(Serial.list()); 
  // I know that the first port in the serial list on my mac 
  // is always my  Keyspan adaptor, so I open Serial.list()[0]. 
  // Open whatever port is the one you're using. 
//  compass_file = createWriter("compass.txt"); 
//  accel_file = createWriter("accel_file.txt"); 
//  gyro_file = createWriter("gyro_file.txt"); 
//  gx_file = createWriter("gx_file.txt"); 
//  gy_file = createWriter("gy_file.txt"); 
//  gz_file = createWriter("gz_file.txt"); 
//  fil_file = createWriter("fil_file.txt"); 
  if(Serial.list().length ==0) error = 1;
  else{
    myPort = new Serial(this, Serial.list()[0], 115200); 
    myPort.clear();
    myPort.bufferUntil(10); 
  }

  xbox2 = width/2;
  ybox2 = height/2;

  
  Top = loadImage("3d_image/Top.png");
  Bot = loadImage("3d_image/Bottom.png");
  Front = loadImage("3d_image/Front.png");
  Back = loadImage("3d_image/Back.png");
  Left = loadImage("3d_image/Left.png");
  Right = loadImage("3d_image/Right.png");
  
  frameRate(500);
  smooth();
}
void draw() {
//  xtheta+=0.02;
//  ztheta+=0.02;
//  ytheta+=0.02;
//  textFont(font);                ///tao phong chu
  background(0);
  textSize(12);
  fill(255);
  if(error==1){
    fill(255,0,0);
    rectMode(CORNER);
    rect(200,15,250,45);
    fill(255);
  text("serial error, reconnect the COM",200,30);
  }
  text("IMU6050 with Pic30F5016 4Mhz Crystal Processor Clock 16MHz", 10, 30);
  text("received: " + inString , 10,50); 
  
  text("angle x: "+angle_x,10,70); 
  text("angle y: "+angle_y,10,85); 
  text("angle z: "+angle_z,10,100);
 
  text("accel angle x: "+ accel_angle_x,10,125); 
  text("accel angle y: "+ accel_angle_y,10,150); 
  //text("accel angle z: "+angle_z,10,200); 

  text("dt: "+dt,10,175);
 
  fill(255,255,255);
  textAlign(LEFT);
  textSize(20);
 
  
  pushMatrix();
  translate(xbox2, ybox2, 0);        //cho ve giua man hinh
  rotateX(PI/2); 
  rotateY(radians(angle_y));
  rotateX(radians(-angle_x));
  rotateZ(radians(-angle_z));
  hop(200);
  popMatrix();
  
}

void hop(int t) {
  beginShape();
    stroke(255);
    line(-500, 0, 0, 500, 0, 0);
    line(0, 0, -500, 0, 0, 500);
    line(0, -500, 0, 0, 500, 0);
    noStroke();
    
    //mattop
    beginShape();
      texture(Top);
      vertex(-t/2, -t/2, t/4,0,0); 
      vertex(t/2, -t/2, t/4,Top.width,0);
      vertex(t/2, t/2, t/4,Top.width,Top.height);
      vertex(-t/2, t/2, t/4,0,Top.height); 
    endShape(CLOSE);

    beginShape();
      texture(Bot);
      vertex(-t/2, -t/2, -t/4,0,Bot.height);
      vertex(t/2, -t/2, -t/4,Bot.width,Bot.height); 
      vertex(t/2, t/2, -t/4,Bot.width,0);
      vertex(-t/2, t/2, -t/4,0,0);   
    endShape(CLOSE);
  
    beginShape();
      texture(Front);
      vertex(-t/2, t/2, t/4,0,0);
      vertex(t/2, t/2, t/4,Front.width,0);
      vertex(t/2, t/2, -t/4,Front.width,Front.height);
      vertex(-t/2, t/2, -t/4,0,Front.height); 
    endShape(CLOSE);
 
    beginShape();
      texture(Back);
      vertex(t/2, -t/2, t/4,0,0);
      vertex(-t/2, -t/2, t/4,Back.width,0);
      vertex(-t/2, -t/2, -t/4,Back.width,Back.height);
      vertex(t/2, -t/2, -t/4,0,Back.height);     
    endShape(CLOSE);
   
    //  //mat left
    beginShape();
      texture(Left);
      vertex(-t/2, -t/2, t/4, 0, 0); 
      vertex(-t/2, t/2, t/4, Left.width, 0);
      vertex(-t/2, t/2, -t/4, Left.width, Left.height);
      vertex(-t/2, -t/2, -t/4, 0, Left.height);  
    endShape(CLOSE);
      
    //  //mat right  
    beginShape();
      texture(Right);
      vertex(t/2, t/2, t/4, 0, 0);
      vertex(t/2, -t/2, t/4, Right.width, 0);
      vertex(t/2, -t/2, -t/4, Right.width, Right.height);
      vertex(t/2, t/2, -t/4, 0, Right.height);
    endShape(CLOSE);
  endShape(CLOSE);
}
