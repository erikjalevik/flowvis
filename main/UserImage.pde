// The graphical representation of a user
class UserImage {

  // We need to keep track of a Body and a width and height
  Body body;
  float w = 32;
  float h = 32;
  PImage img;
  
  // Constructor
  UserImage(float x, float y, String imageUrl) {
    img = loadImage(imageUrl);
    
    // Add the box to the box2d world
    makeBody(new Vec2(x, y));
  }

  void makeBody(Vec2 center) {
    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);

    PolygonShape sd = new PolygonShape();
    float box2dHalfWidth = box2d.scalarPixelsToWorld(w/2);
    float box2dHalfHeight = box2d.scalarPixelsToWorld(h/2);
    sd.setAsBox(box2dHalfWidth, box2dHalfHeight);

    body.createFixture(sd, 1.0);

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
    image(img, -w/2, -h/2, w, h);      
    popMatrix();
  }

}