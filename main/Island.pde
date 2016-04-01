// Series of Particles connected in a circular shape with distance joints

class Island {

  float radius;
  int numPoints;
  float particleRadius = 8;

  // Our chain is a list of particles
  ArrayList<Particle> particles;
  Particle centerParticle;

  color islandColor = color(20, 28, 38, 200);

  // Chain constructor
  Island(int xPos, int yPos, float _radius) {

    radius = _radius;
    numPoints = (int)(radius / 2.5); // this could be smarter

    // Fixed invisible particle in the middle
    centerParticle = new Particle(xPos, yPos, particleRadius, true);
    
    particles = new ArrayList();

    // Add circle chain
    for (int i = 0; i < numPoints; i++) {
      // Make a new particle
      Particle p = null;
      
      float angle = map(i, 0, numPoints, 0, TWO_PI);
      float x = xPos + radius * sin(angle);
      float y = yPos + radius * cos(angle);
      
      // First particle is fixed
      p = new Particle(x, y, particleRadius, false);
      particles.add(p);

      // Connect the particles with a distance joint
      if (i > 0) {
         Particle previous = particles.get(i - 1);
         // Connection between previous particle and this one
         join(previous, p, 2 *particleRadius);
      }
    }
    
    // Connect last to first to complete circle
    join(particles.get(0), particles.get(numPoints - 1), 2 * particleRadius);

    // Add some struts to center
    join(centerParticle, particles.get(0), radius);
    join(centerParticle, particles.get(numPoints / 2), radius);
    join(centerParticle, particles.get(numPoints / 4), radius);
    join(centerParticle, particles.get(3 * (numPoints / 4)), radius);

    // Add some struts across
    join(particles.get(0), particles.get(numPoints / 2), 2 * radius);
    join(particles.get(numPoints / 4), particles.get(3 * (numPoints / 4)), 2 * radius);
    join(particles.get(numPoints / 8), particles.get(5 * numPoints / 8), 2 * radius);
    join(particles.get(3 * (numPoints / 8)), particles.get(7 * (numPoints / 8)), 2 * radius);
}

  void join(Particle a, Particle b, float length) {
     DistanceJointDef djd = new DistanceJointDef();

     // Connection between previous particle and this one
     djd.bodyA = a.body;
     djd.bodyB = b.body;

     // Equilibrium length
     djd.length = box2d.scalarPixelsToWorld(length);
     
     // These properties affect how springy the joint is 
     djd.frequencyHz = 2; // the higher, the springier
     djd.dampingRatio = 0;
     
     // Make the joint. Note we aren't storing a reference to the joint ourselves anywhere!
     // We might need to someday, but for now it's ok
     DistanceJoint dj = (DistanceJoint)box2d.world.createJoint(djd);
  }

  // Draw the island
  void display() {
    beginShape();
    fill(islandColor);
    noStroke();
    for (Particle p: particles) {
      Vec2 pos = box2d.getBodyPixelCoord(p.body);
      vertex(pos.x, pos.y);
    }
    endShape(CLOSE);
  }

}