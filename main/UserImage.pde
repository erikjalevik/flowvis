// The graphical representation of a user
class UserImage {

  // We need to keep track of a Body and a width and height
  Body body;
  float w = 32;
  float h = 32;
  float x;
  float y;
  PImage img;

  // Constructor
  UserImage(float _x, float _y, String imageUrl) {
    x = _x;
    y = _y;

    String cacheUrl = cacheUrlForUrl(imageUrl);
    File f = new File(dataPath(cacheUrl));
    if (f.exists()) {
      img = loadImage(cacheUrl, "jpg");
    }
    else {
      img = loadImage(imageUrl, "jpg");
      img.save(dataPath("./cache/" + cacheUrlForUrl(imageUrl)));
    }

    // Add the box to the box2d world
    makeBody(new Vec2(x, y));
  }

  // Stolen from https://forum.processing.org/one/topic/getting-average-pixel-color-value-from-a-pimage-that-is-constantly-changing.html
  color getAverageColor() {
    img.loadPixels();
    int r = 0, g = 0, b = 0;
    for (int i=0; i<img.pixels.length; i++) {
      color c = img.pixels[i];
      r += c>>16&0xFF;
      g += c>>8&0xFF;
      b += c&0xFF;
    }
    r /= img.pixels.length;
    g /= img.pixels.length;
    b /= img.pixels.length;
    return color(r, g, b);
  }

  void makeBody(Vec2 center) {
    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);

    PolygonShape sd = new PolygonShape();
    float box2dHalfWidth = box2d.scalarPixelsToWorld(w/2);
    float box2dHalfHeight = box2d.scalarPixelsToWorld(h/2);
    sd.setAsBox(box2dHalfWidth, box2dHalfHeight);

    body.createFixture(sd, 1.0);

    // Give it some initial random velocity
    //body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
    //body.setAngularVelocity(random(-5, 5));
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+w*h) {
      killBody();
      return true;
    }
    return false;
  }

  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);

    pushMatrix();
    translate(pos.x, pos.y);
    image(img, -w/2, -h/2, w, h);
    popMatrix();
  }

  String cacheUrlForUrl(String imageUrl) {
    String cacheUrl = imageUrl.replace("\\", "_");
    cacheUrl = cacheUrl.replace(":", "_");
    cacheUrl = cacheUrl.replace("/", "_");
    cacheUrl = cacheUrl.replace("?", "_");
    return cacheUrl;
  }

  // Check if two images would overlap
  boolean imageIntersect(float xNew, float yNew) {
    if (dist(x, y, xNew, yNew) < 60) {
      return true;
    } else {
      return false;
    }
  }
}

class ImageUtils {
  color getComplementColor(color c) {
    float red = red(c);
    float green = green(c);
    float blue = blue(c);

    float complementRed = 255 - red;
    float complementGreen = 255 - green;
    float complementBlue = 255 - blue;

    color complement = color(complementRed, complementGreen, complementBlue);
    return complement;
  }
}
