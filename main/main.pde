/**
 * Flowvis main
 * 
 */
 
void setup() {
  initSynth(this);
}

void draw() {
  background(255);
}

void mousePressed() {
  out.playNote(0, 1.0, new Synth(880, 1.0));
}