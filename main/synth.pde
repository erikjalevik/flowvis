import ddf.minim.*;
import ddf.minim.ugens.*;

class Synth {
  Minim minim;
  AudioOutput out;

  class SynthInstrument implements Instrument {
    Oscil osc;
    ADSR adsr;
    Delay delay;

    SynthInstrument(float freq, float amp) {
      osc = new Oscil(freq, amp, Waves.TRIANGLE);
      adsr = new ADSR(amp, 0.001, 0.2, 0.001, 0.001);
      delay = new Delay(0.6, 0.4, true, true);
  
      osc.patch(adsr);
    }

    void noteOn(float duration) {
      adsr.noteOn();
      adsr.patch(delay).patch(out);
    }

    void noteOff() {
      adsr.unpatchAfterRelease(out);
      adsr.noteOff();
    }
  }

  Synth(Object main) {
    minim = new Minim(main);
    out = minim.getLineOut();
  }

  void play(float freq, float amp) {
    out.pauseNotes();
    out.playNote(0, 1.0, new SynthInstrument(freq, amp));
    out.resumeNotes();
  }
}