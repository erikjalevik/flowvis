import websockets.*;

WebsocketClient wsc;
int now;
boolean newEllipse;
String name;
JSONObject response;

void settings() {
   size(640, 760);
}

void setup(){
  newEllipse=true;
  name="";

  //Here I initiate the websocket connection by connecting to "ws://localhost:8025/john", which is the uri of the server.
  //this refers to the Processing sketch it self (you should always write "this").
  wsc= new WebsocketClient(this, "ws://localhost:8025/john");
  now=millis();
}

void draw(){
    //Here I draw a new ellipse if newEllipse is true
  if(newEllipse){
    //ellipse(random(width),random(height),10,10);
    newMessage(name);
    newEllipse=false;
  }

    //Every 5 seconds I send a message to the server through the sendMessage method
  if(millis()>now+5000){
    wsc.sendMessage("Client message");
    now=millis();
  }
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