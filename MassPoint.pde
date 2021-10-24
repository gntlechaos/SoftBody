class MassPoint{
  
  PVector position;
  PVector velocity;
  PVector force;
  float mass;
  float radius;
  
  MassPoint(PVector position, float mass, float radius){
    this.position = position;
    this.mass = mass;
    this.radius = radius;
    
    this.velocity = new PVector(0,0);
    this.force = new PVector(0,0);
    
  }
  
  void updatePosition(){

    force.add(gravity.copy().mult(mass));

    velocity.add(force.copy().mult(deltaTime).div(mass));
   // velocity.limit(100);
    
    position.add(velocity.copy().mult(deltaTime));
    
    if(position.y > floorHeight-radius){
      
     position.y = floorHeight-radius;
     velocity.y = velocity.y*-1*collisionDampingFactor;
      
    }
    
    force = new PVector(0,0);
    
  }
  
   void collisionCheck(MassPoint other){
    
    if(frameCount % 1 == 0){ 
      float distance = PVector.dist(this.position,other.position) - other.radius;
      
      if(distance < this.radius && distance != 0){
        PVector pushVector = PVector.sub(other.position,this.position).normalize().mult(this.radius-distance);
        other.position.add(pushVector);
        
        PVector reflectionNormal = pushVector.copy().normalize();
        PVector reflectedVelocity = PVector.mult(reflectionNormal.copy().mult(PVector.dot(other.velocity,reflectionNormal)).add(other.velocity),-2);
        PVector newVelocity = PVector.mult(reflectedVelocity,0.1);
        other.velocity = newVelocity;
        
      }
    }
    
  }
  
  void brownianMotion(){

      this.velocity.add(PVector.random2D().mult(brownianMotionInstability));

    
    
  }
  
  void display(){
    
   pushMatrix();
   translate(position.x,position.y);
   ellipseMode(CENTER);
   stroke(255);
   ellipse(0,0,radius*2,radius*2);
   popMatrix();
    
  }
  
  
  
}
