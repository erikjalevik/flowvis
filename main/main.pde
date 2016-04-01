/**
 * Flowvis main
 * 
 */
 
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import org.jbox2d.callbacks.ContactImpulse;

// A reference to our box2d world
Box2DProcessing box2d;

// A list for all of our rectangles
ArrayList<TextBox> boxes;

String[] words = { "hey", "here's", "some", "words", "to", "test", "with" };  
int[] times = { 1, 2, 4, 8, 9, 12, 15 };
int speed = 100;
int counter = 0;

color backgroundColor = #000000;

Audio audio;

void setup() {
  size(800, 600);
  frameRate(60);

  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -0.05); // very slight downward gravity

  // Turn on collision listening!
  box2d.listenForCollisions();

  boxes = new ArrayList<TextBox>();

  //String[] fontList = PFont.list();
  //printArray(fontList);
  
  audio = new Audio(this);
  
  initWebsocket(this);
}

void draw() {
  background(backgroundColor);
  
  box2d.step();

  if (mousePressed) {
    String w = words[counter];
    counter = (counter + 1) % words.length;
    TextBox b = new TextBox(w, mouseX, mouseY);
    boxes.add(b);
  }
  
  if(wsMessage){
    ws.displayMessage();
  }

  for (TextBox b: boxes) {
    b.display();
  }

  // Boxes that leave the screen, we delete them
  for (int i = boxes.size() - 1; i >= 0; i--) {
    TextBox b = boxes.get(i);
    if (b.done()) {
      boxes.remove(i);
    }
  }
}

void beginContact(Contact c) {}

void endContact(Contact c) {}

void postSolve(Contact c, ContactImpulse ci) {
  audio.collision(c, ci);
}
 
void webSocketEvent(String msg){
  ws.newWebSocketMsg(msg);
} 