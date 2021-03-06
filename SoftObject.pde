
PVector gravity;
float deltaTime;
float collisionDampingFactor;
float springDampingFactor;
float springStiffness;
boolean springStiffnessAddFluctuations;
float springStiffnessMaxFluct;
float springStiffnessMinFluct;
int floorHeight;

int mass;
int size;
int spacing;
int radius;

float springMaxStress;
float maxFrameStress;
boolean allowMaxStress;

float brownianMotionInstability;

ArrayList<Spring> springs;
MassPoint[][] points;


void setup(){
  
  size(2000,2000,P2D);
  frameRate(60);
  
  // Simulation Settings //
  
  gravity = new PVector(0,4);
  deltaTime = 0.11; // Do not f
  
  floorHeight = 1270;
  collisionDampingFactor=0.9;
  
  springDampingFactor = 0.99;
  springStiffness = 170;
  springStiffnessAddFluctuations = true;
  springStiffnessMaxFluct = 1.25;
  springStiffnessMinFluct = 0.75;
  
  brownianMotionInstability = 0;
  
  mass = 10;
  size = 30;
  spacing = 40;
  radius = 10;
  
  springMaxStress = 3000;
  maxFrameStress = 0; // Not really a config. Leave it like that.
  allowMaxStress = false; // Disable carefully - It is used as to not allow infinite forces in case something goes wrong
  
  points = new MassPoint[size][size];
  springs = new ArrayList<Spring>();
  
  // Simulation Settings - END //
  
  // Calculating Simulation Stability Factor //
  
  
  float stabilityFactor = pow((1/deltaTime),2) * pow(1/(gravity.y*mass/40),1/2);
  
  if(springStiffnessAddFluctuations){
    println(springStiffnessMaxFluct*springStiffnessMinFluct);
    stabilityFactor = stabilityFactor * 1/(springStiffnessMaxFluct*springStiffnessMinFluct);
  }
  
  if(allowMaxStress){
    stabilityFactor = 100; // If MaxStress is enabled, the simulation is considered stable.
  }
  println("Simulation Stability Factor: "+stabilityFactor);
  if(stabilityFactor < 50){
   println("Careful! Simulation is instable and likely to fail!");
  } 
  
  // Calculating Simulation Stability Factor - END //
  

  // Populating Simulation with points and springs //
  
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
  
  // Populating Simulation with points and springs - END //
  
}

void draw(){
  
  
  background(0);
  
 
  float maxFrameStress = 0;
  float integrity = 0;
  
  // Displaying and Calculating Spring and Mass Forces // 
  for(Spring s : springs){
    s.display();
    s.calculateForces();
    
     // Calculating Frame Statistics// 
    if(s.active){
      integrity++;
      if(s.stress() > maxFrameStress){
         maxFrameStress = s.stress(); 
      }
    }
  }  
  integrity = integrity/springs.size() *100;
  // Calculating Frame Statistics - END// 
  
 
     
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
  
 // Displaying and Calculating Spring and Mass Forces - END// 


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

  if(mouseButton == LEFT){
    floorHeight = mouseY;
  }
  else if(mouseButton == RIGHT){
    saveFrame("######.png");
  }
  
}

void mouseWheel(MouseEvent event){
  
  brownianMotionInstability -= event.getCount();
  if(brownianMotionInstability <0) brownianMotionInstability = 0;
}
