class Spring {
  
  MassPoint pointA;
  MassPoint pointB;
  float stiffness;
  float restLength;
  float dampingFactor;
  float maxStress;
  boolean active;
  
  Spring(MassPoint pointA, MassPoint pointB){
    this.pointA = pointA;
    this.pointB = pointB;
    this.restLength = PVector.dist(pointA.position,pointB.position);
    if(springStiffnessAddFluctuations){
      this.stiffness = springStiffness * random(springStiffnessMinFluct,springStiffnessMaxFluct); 
    } else {
      this.stiffness = springStiffness; 
    }   
    this.dampingFactor = springDampingFactor;
    this.maxStress = springMaxStress;
    this.active = true;
  }
  
  
  void calculateForces(){
    
    if(active){
    float springForce = stiffness * deltaLength();
    
    PVector normalizedDistance = PVector.sub(pointB.position,pointA.position).normalize();
    PVector velocityDifference = PVector.sub(pointB.velocity,pointA.velocity);
    
    float dampingForce = PVector.dot(normalizedDistance,velocityDifference) * dampingFactor;
    
    float totalSpringForce = springForce + dampingForce;
    
    PVector forceA = PVector.sub(pointB.position,pointA.position).normalize().mult(totalSpringForce);
    PVector forceB = PVector.sub(pointA.position,pointB.position).normalize().mult(totalSpringForce);
    
    pointA.force.add(forceA);
    pointB.force.add(forceB);
    
    
    float stress = abs(deltaLength()) * stiffness;
    
    if(stress > maxStress && allowMaxStress){
      deactivate();
    }
    
    }
    
  }
  
  void deactivate(){
    active = false;
    
  }
  
  float deltaLength(){
    return PVector.dist(pointA.position,pointB.position)- restLength;
  }
  
  float stress(){
    return abs(deltaLength())*stiffness;
  }
  
  
  
  void display(){
    
    colorMode(HSB,360,100,100,1);
    float hue = map(stress(),0,springMaxStress*0.7,120,0);
    if(active){
    stroke(color(hue,100,100));
    } else{
    stroke(color(270,100,100,0.2));  
    }
    line(pointA.position.x,pointA.position.y,pointB.position.x,pointB.position.y);
    colorMode(RGB,255,255,255);

    
  }
  
  
  
}
