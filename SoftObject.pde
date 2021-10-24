
PVector gravity;
float deltaTime;
float collisionDampingFactor;
float springDampingFactor;
float springStiffness;
int floorHeight;

int mass;
int size;
int spacing;
int radius;

float springMaxStress;
float maxFrameStress;

float brownianMotionInstability;

ArrayList<Spring> springs;
MassPoint[][] points;


void setup(){
  
  size(2000,2000,P2D);
  frameRate(60);
  
  // Universal Constants
  gravity = new PVector(0,4);
  deltaTime = 0.09;
  
  floorHeight = 1270;
  collisionDampingFactor=0.9;
  
  springDampingFactor = 0.99;
  springStiffness = 170;
  
  brownianMotionInstability = 0;
  
  mass = 10;
  size = 30;
  spacing = 40;
  radius = 10;
  
  springMaxStress = 3000;
  maxFrameStress = 0;
  
  points = new MassPoint[size][size];
  springs = new ArrayList<Spring>();
  
  

  for(int i = 0; i < size; i++){
    for(int j = 0; j < size; j++){
      MassPoint newPoint = new MassPoint(new PVector((width/3)+spacing*i,100+spacing*j),mass,radius);
      points[i][j] = newPoint; 
    } 
  }
  
  for(int i = 0; i < size; i++){
    for(int j = 0; j < size; j++){
      if(i < size-1){
       Spring spring = new Spring(points[i][j], points[i+1][j]);
       springs.add(spring);
      }
      if(j < size-1){
       Spring spring = new Spring(points[i][j], points[i][j+1]);
       springs.add(spring);
      }
      if(j < size-1 && i< size-1){
        Spring spring = new Spring(points[i][j], points[i+1][j+1]);
        springs.add(spring);
      }
      if(j < size-1 && i>0){
        Spring spring = new Spring(points[i][j], points[i-1][j+1]);
        springs.add(spring);
      }
    } 
  }
  
  
  
}

void draw(){
  
  
  background(0);
  
  float maxFrameStress = 0;
  float integrity = 0;
  for(Spring s : springs){
    s.display();
    s.calculateForces();
    
    if(s.active){
      integrity++;
      if(s.stress() > maxFrameStress){
         maxFrameStress = s.stress(); 
      }
    }
  }
  
  integrity = integrity/springs.size() *100;
  
 
     
   for(int i = 0; i < size; i++){
    for(int j = 0; j < size; j++){
      
      
      points[i][j].display();
      points[i][j].updatePosition();
      points[i][j].brownianMotion();
      
      for(int k = 0; k < size; k++){
        for(int l = 0; l < size; l++){

          if(!points[i][j].equals(points[k][l])){
            points[i][j].collisionCheck(points[k][l]);
          }
        }
      }
      
    } 
  }
  



  line(0,floorHeight,width,floorHeight);
  
  fill(255);
  textSize(42);
  text("FPS: "+int(frameRate),10,50);
  text("Max Frame Stress: "+round(maxFrameStress),10,100);
  
  colorMode(HSB,360,100,100,1);
  float hue = map(maxFrameStress,0,springMaxStress*0.7,120,0);
  fill(color(hue,100,100));
  text(round(100*maxFrameStress/springMaxStress)+"%",520,100);
  colorMode(RGB,255,255,255);
  
  fill(255);
  textSize(20);
  text("(Spring Maximum Stress: "+ int(springMaxStress)+")",10,130);
  
  textSize(42);
  text("Structure Integrity: "+round(integrity)+"%",10,180);
  
  textSize(42);
  text("Brownian Motion Instability: "+round(brownianMotionInstability),10,230);

  
  
  
}

void mousePressed(){

    floorHeight = mouseY;
  
}

void mouseWheel(MouseEvent event){
  
  brownianMotionInstability -= event.getCount();
  if(brownianMotionInstability <0) brownianMotionInstability = 0;
}
