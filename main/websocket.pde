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
    UserImage user;
    if(users.containsKey(avatar)) {
     user = users.get(avatar);
    } else {
      user = createNewUserImage();
      users.put(avatar, user);
    }
    
    color avgColor = user.getAverageColor();
    
    ImageUtils iu = new ImageUtils();
    
    color cmplColor = iu.getComplementColor(avgColor);

    String[] words = content.split(" ");
    TextBox w;
    for(int i=0; i < words.length; i++) {
      if (i > 8) {
        break;
      }
      if (words[i].length() > 15) {
        break;
      }

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

      w = new TextBox(words[i], user.x + offset.x, user.y + offset.y, avgColor, cmplColor);
      boxes.add(w);

      spawnCounter = (spawnCounter + 1) % 4;
    }

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

  UserImage createNewUserImage() {
    boolean intersect = true;
    boolean changed = false;
    float x = random(150,650);
    float y = random(150,450);
    while(intersect) {
      for(UserImage img : users.values()) {
        if (img.imageIntersect(x,y)) {
          x = random(150,650);
          y = random(150,450);
          changed = true;
          break;
        }
      }
      if (!changed) {intersect = false;}
      changed = false;
    }
    return new UserImage(x, y, avatar);
  }
}
