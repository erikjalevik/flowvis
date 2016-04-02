class TextBox  {

  // We need to keep track of a Body and a width and height
  Body body;

  String text;
  float w;
  float h;
  float margin = 6;
  int colorIndex = 0;
  
  PFont font;

  color[] boxColors = {#991F1F, #99701F, #70991F, #1F991F, #1F9970, #1F7099, #1F1F99, #701F99, #991F70};
  color[] wordColors = {#E61717, #E6A117, #A1E617, #17E617, #17E6A1, #17A1E6, #1717E6, #A117E6, #E617A1};
  
  float fadeMultiplier = 0.995;
  float alpha = 255;

  Vec2 force = new Vec2(0, 0);
  
  AudioInstrument instr;

  // Constructor
  TextBox(String _text, float x, float y, int _colorIndex) { // colorIndex 0..8
    text = _text;
    colorIndex = _colorIndex;
  
    font = createFont("SharpSansNo1-Bold", 20, true);
    textFont(font);

    w = textWidth(text) + (4 * margin);
    h = textAscent() + textDescent() + (2 * margin);

    // Add the box to the box2d world
    Body body = makeBody(new Vec2(x, y), w, h);

    // Create an instrument for box
    instr = audio.createInstrument();

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
    fd.density = 0.6;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.createFixture(fd);

    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(random(-7, 7), random(-7, 7)));
    body.setAngularVelocity(random(-11, 11));

    return body;
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the box ready for deletion?
  boolean done() {
    if (alpha < 25) {
      audio.destroyInstrument(instr);
    }

    if (alpha < 1) {
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
    
    fill(boxColors[colorIndex], alpha);
    stroke(#000000, alpha);
    rect(0, 0, w, h);

    textAlign(CENTER);
    fill(wordColors[colorIndex], alpha);
    noStroke();
    text(text, 0, 5);
    
    alpha = alpha * fadeMultiplier;

    popMatrix();
    
    body.applyForceToCenter(force);
  }

}