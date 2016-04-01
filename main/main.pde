/**
 * Flowvis main
 * 
 */
 
Synth synth;

void setup() {
  initSynth(this);
  synth = new Synth();
}

void draw() {
  background(255);
}

void mousePressed() {
  synth.play(880, 1.0);
}