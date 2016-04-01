import ddf.minim.*;
import ddf.minim.ugens.*;

static Minim minim;
static AudioOutput output;

static void initSynth(Object main) {
  minim = new Minim(main);
  output = minim.getLineOut();
}

class Synth {
  Oscil osc;
  ADSR adsr;
  
  Synth() {
    osc = new Oscil(440, 1.0, Waves.SINE);
    adsr = new ADSR(1.0, 0.01, 0.2);

    osc.patch(adsr).patch(output);
  }
  
  void play(float freq, float amp) {
    osc.setFrequency(freq);
    osc.setAmplitude(amp);
    adsr.noteOn();
  }
}