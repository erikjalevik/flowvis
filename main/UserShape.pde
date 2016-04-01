// The graphical representation of a user
class UserShape {

  // We need to keep track of a Body and a width and height
  Body body;
  float w = 24;
  float h = 20;
  float r = w/1.5;
  Vec2 circleOffset;
  Vec2 triangleOffset;
  ArrayList<Vec2> triangleVertices;
  
  // Constructor
  UserShape(float x, float y) {
    // Add the box to the box2d world
    makeBody(new Vec2(x, y));
  }

  void makeBody(Vec2 center) {
    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);

    CircleShape circle = new CircleShape();
    
    circle.m_radius = box2d.scalarPixelsToWorld(r);
    // m_p is the offset from the center pos of the body
    circleOffset = new Vec2(0, -(h/4));    
    circle.m_p.set(box2d.coordPixelsToWorld(circleOffset));

    PolygonShape sd = new PolygonShape();
    
    triangleVertices = new ArrayList<Vec2>();
    triangleVertices.add(new Vec2(w/2, h/8));
    triangleVertices.add(new Vec2(0, h));
    triangleVertices.add(new Vec2(w, h));
    
    sd.set(mapPixelListToWorld(triangleVertices), 3);

    // m_centroid is also an offset
    triangleOffset = new Vec2(0, h/16);    
    sd.m_centroid.set(box2d.coordPixelsToWorld(triangleOffset));

    body.createFixture(sd, 1.0);
    body.createFixture(circle, 1.0);

    // Give it some initial random velocity
    //body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
    //body.setAngularVelocity(random(-5, 5));
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+w*h) {
      killBody();
      return true;
    }
    return false;
  }

  void display() {

    Vec2 pos = box2d.getBodyPixelCoord(body);

    pushMatrix();
    translate(pos.x, pos.y);
    fill(175);
    stroke(0);

    ellipse(w/2 + circleOffset.x, h/2 + circleOffset.y, r, r);
    
    beginShape();
    for (Vec2 p: triangleVertices) {
      vertex(p.x + triangleOffset.x, p.y + triangleOffset.y);
    }
    endShape(CLOSE);

    //triangle(w/2, h/8, 0, h, w, h);
    
    popMatrix();
  }

  Vec2[] mapPixelListToWorld(ArrayList<Vec2> pixelList) {
    Vec2[] worldList = new Vec2[pixelList.size()];
    int i = 0;
    for (Vec2 vec: pixelList) {
      worldList[i] =  box2d.coordPixelsToWorld(vec);
      i++;
    }
    return worldList;
  }

}