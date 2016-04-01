import ddf.minim.*;
import ddf.minim.ugens.*;

static Minim minim;
static AudioOutput out;

static void initSynth(Object main) {
  minim = new Minim(main);
  out = minim.getLineOut();
}

class Synth implements Instrument {
  Oscil osc;
  ADSR adsr;
  
  Synth(float freq, float amp) {
    osc = new Oscil(freq, amp, Waves.TRIANGLE);
    adsr = new ADSR(amp, 0.001, 0.2, 0.001, 0.001);

    osc.patch(adsr);
  }
  
  void noteOn(float duration) {
    adsr.noteOn();
    adsr.patch(out);
  }

  void noteOff() {
    adsr.unpatchAfterRelease(out);
    adsr.noteOff();
  }
}