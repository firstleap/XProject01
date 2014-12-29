int x = 0;
float py = 0;
 PFont font;
int error;
void setup(){
  size(600,200);
  background(0);
  println(Serial.list());
 if(Serial.list().length ==0) error = 1;
  else{
    myPort = new Serial(this, Serial.list()[0], 500000); 
    myPort.clear();
    myPort.bufferUntil(10); 
  } 
}
 
void draw(){
  noStroke();
  fill(0,0,0,15);
  rect(0,0,width,height);
  translate(0,height/2);
  x++;
  x%=width;
  float fx = py + random(-20,20);
  stroke(100,255,100);
  noFill();
  line(x-1,py, x,angle_x);
  py = angle_x;
  if(py>height/2) py=height/2;
  if(py<-height/2) py=-height/2;
}
