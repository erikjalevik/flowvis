class TextBox  {

  // We need to keep track of a Body and a width and height
  Body body;

  String text;
  float w;
  float h;
  float margin = 6;
  
  PFont font;

  color boxColor = #800000;
  color wordColor = #E00000;

  SynthInstrument instr;

  // Constructor
  TextBox(String _text, float x, float y) {
    text = _text;
  
    font = createFont("SharpSansNo1-Bold", 20, true);
    textFont(font);

    w = textWidth(text) + (4 * margin);
    h = textAscent() + textDescent() + (2 * margin);

    // Add the box to the box2d world
    Body body = makeBody(new Vec2(x, y), w, h);

    // Create an instrument for box
    instr = new SynthInstrument(audio.getSynth());

    body.setUserData(this);
  }

  // This function adds the rectangle to the box2d world
  Body makeBody(Vec2 center, float w_, float h_) {

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.createFixture(fd);
    //body.setMassFromShapes();

    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(random(-6, 6), random(-5, 5)));
    body.setAngularVelocity(random(-9, 9));

    return body;
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the box ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height + w*h) {
      killBody();
      return true;
    }
    return false;
  }

  // Drawing the box
  void display() {
    // We look at the body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    rectMode(CENTER);
    pushMatrix();
    
    translate(pos.x,pos.y);
    rotate(-a);
    
    fill(boxColor);
    stroke(#400000);
    rect(0, 0, w, h);

    textAlign(CENTER);
    fill(wordColor);
    noStroke();
    text(text, 0, 5);
    
    popMatrix();
  }

}