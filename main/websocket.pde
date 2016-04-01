import websockets.*;

WebsocketClient wsc;
Websocket ws;
JSONObject response;
boolean wsMessage;

// Message properties
String nick;
String avatar;
String content;
String tags;
String thread_id;
String created_at;

void initWebsocket(PApplet parent) {
  wsc = new WebsocketClient(parent, "ws://localhost:8001/");
  ws = new Websocket();
}

class Websocket {

  Websocket() {
    wsMessage = false;
    nick = "";
    content = "";
    tags = "";
    thread_id = "";
  }

  void displayMessage() {
    float x = 400;
    float y = 300;
    TextBox n = new TextBox(nick, x, y);
    TextBox c = new TextBox(content, x, y);
    user = new UserImage(300, 300, avatar);

    boxes.add(n);
    boxes.add(c);
    wsMessage = false;
  }

  void newWebSocketMsg(String msg){
    response = parseJSONObject(msg);
    nick = response.getString("nick");
    avatar = response.getString("avatar");
    content = response.getString("content");
    println(nick + " says " + content);
    wsMessage = true;
  }
}