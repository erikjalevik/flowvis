import websockets.*;

WebsocketClient wsc;
Websocket ws;
JSONObject response;
boolean wsMessage;
int spawnCounter = 0;

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
    user = new UserImage(300, 300, avatar);

    Vec2 offset = new Vec2();
    if (spawnCounter == 0) {
      offset.x = 0;
      offset.y = -(user.h / 2);
    } else if (spawnCounter == 1) {
      offset.x = user.w / 2;
      offset.y = 0;
    } else if (spawnCounter == 2) {
      offset.x = 0;
      offset.y = user.h / 2;
    } else if (spawnCounter == 3) {
      offset.x = -(user.w / 2);
      offset.y = 0;
    }
    spawnCounter = (spawnCounter + 1) % 4;
    //TextBox n = new TextBox(nick, x, y);
    TextBox c = new TextBox(content, user.x + offset.x, user.y + offset.y);

    //boxes.add(n);
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