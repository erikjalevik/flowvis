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
Island thread;
UserImage user;

String[] words = { "hey", "here's", "some", "words", "to", "test", "with" };
String incomingWord = "";
int counter = 0;

color backgroundColor = #000000;

Audio audio;

void setup() {
  size(800, 600);
  frameRate(60);

  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, 0); //-0.05); // very slight downward gravity

  // Turn on collision listening!
  box2d.listenForCollisions();

  boxes = new ArrayList<TextBox>();
  thread = new Island(width / 2, height / 2, 200);
  user = new UserImage(100, 100, "chilicorn_no_text-256.png");
  
  //String[] fontList = PFont.list();
  //printArray(fontList);

  audio = new Audio(this);

  initWebsocket(this);
}

void draw() {
  background(backgroundColor);

  box2d.step();

  thread.display();
  user.display();

  if (!incomingWord.isEmpty()) {
    TextBox b = new TextBox(incomingWord, mouseX, mouseY);
    boxes.add(b);
    incomingWord = "";
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

void mousePressed() {
  incomingWord = words[counter];
  counter = (counter + 1) % words.length;
}

void beginContact(Contact c) {}

void endContact(Contact c) {}

void postSolve(Contact c, ContactImpulse ci) {
  audio.collision(c, ci);
}

void webSocketEvent(String msg){
  ws.newWebSocketMsg(msg);
}