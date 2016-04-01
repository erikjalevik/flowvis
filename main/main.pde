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

import websockets.*;

// A reference to our box2d world
Box2DProcessing box2d;

// A list for all of our rectangles
ArrayList<TextBox> boxes;

String[] words = { "hey", "here's", "some", "words", "to", "test", "with" };  
int[] times = { 1, 2, 4, 8, 9, 12, 15 };
int speed = 100;
int counter = 0;

color backgroundColor = #000000;

WebsocketClient wsc;
int now;
boolean newEllipse;
String name;
JSONObject response;


void setup() {
  size(800, 600);
  frameRate(60);

  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -0.05); // very slight downward gravity

  boxes = new ArrayList<TextBox>();

  //String[] fontList = PFont.list();
  //printArray(fontList);
  
  initSynth(this);
  
  newEllipse = true;
  name = "";

  //Here I initiate the websocket connection by connecting to "ws://localhost:8025/john", which is the uri of the server.
  //this refers to the Processing sketch it self (you should always write "this").
  //wsc = new WebsocketClient(this, "ws://localhost:8025/john");
  now = millis();
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
  
  
  // Here I draw a new ellipse if newEllipse is true
  if(newEllipse){
    //ellipse(random(width),random(height),10,10);
    newMessage(name);
    newEllipse=false;
  }

  // Every 5 seconds I send a message to the server through the sendMessage method
  if(millis()>now+5000){
    wsc.sendMessage("Client message");
    now=millis();
  }
  
}

void mousePressed() {
  out.playNote(0, 1.0, new Synth(880, 1.0));
}

void newMessage(String name) {
  float x = random(width);
  float y = random(height);
  ellipse(x,y,10,10);
  text(name, x, y-10);
}

//This is an event like onMouseClicked. If you chose to use it, it will be executed whenever the server sends a message 
void webSocketEvent(String msg){
 response = parseJSONObject(msg);
 name = response.getString("nick");
 println("Nick: " + name);
 newEllipse=true;
} 