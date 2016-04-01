import websockets.*;

WebsocketClient wsc;
Websocket ws;
JSONObject response;
boolean wsMessage;
String name;

void initWebsocket(PApplet parent) {
  //Here I initiate the websocket connection by connecting to "ws://localhost:8025/john", which is the uri of the server.
  //this refers to the Processing sketch it self (you should always write "this").
  wsc = new WebsocketClient(parent, "ws://localhost:8001/");
  ws = new Websocket();
}

class Websocket {
    
  // Constructor
  Websocket() {
    wsMessage = false;
    name = "";
  }
  
  void displayMessage() {
    float x = random(width);
    float y = random(height);
    TextBox b = new TextBox(name, x, y);
    boxes.add(b);
    wsMessage=false;
  }
  
  void newWebSocketMsg(String msg){
    response = parseJSONObject(msg);
    name = response.getString("nick");
    println("Nick: " + name);
    wsMessage=true;
  } 
}