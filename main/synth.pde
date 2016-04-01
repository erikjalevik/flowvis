import ddf.minim.*;
import ddf.minim.ugens.*;

class Synth {
  Minim minim;
  AudioOutput output;

  Synth(Object main) {
    minim = new Minim(main);
    output = minim.getLineOut();
  }

  AudioOutput getOutput() {
    return output;
  }

  void play(float freq, float amp, SynthInstrument instr) {
    instr.osc.setFrequency(freq);
    instr.osc.setAmplitude(amp);
    output.pauseNotes();
    output.playNote(0, amp, instr);
    output.resumeNotes();
  }
}

class SynthInstrument implements Instrument {
  Oscil osc;
  ADSR adsr;
  Delay delay;
  Synth synth;

  SynthInstrument(Synth syn) {
    int defaultFreq = 440;
    int defaultAmp = 1;

    osc = new Oscil(defaultFreq, defaultAmp, Waves.TRIANGLE);
    adsr = new ADSR(defaultAmp, 0.001, 0.2, 0.001, 0.001);
    delay = new Delay(0.6, 0.4, true, true);
    synth = syn;
    osc.patch(adsr);
    adsr.patch(delay).patch(synth.getOutput());
  }

  void noteOn(float duration) {
    adsr.noteOn();
  }

  void noteOff() {
    adsr.noteOff();
  }
}