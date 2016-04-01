class AudioInstrument implements Instrument {
  Oscil osc;
  ADSR adsr;
  Delay delay;
  Pan pan;

  AudioInstrument(AudioOutput output) {
    int defaultFreq = 440;
    int defaultAmp = 1;

    osc = new Oscil(defaultFreq, defaultAmp, Waves.TRIANGLE);
    adsr = new ADSR(defaultAmp, 0.001, 0.2, 0.001, 0.001);
    delay = new Delay(0.6, 0.1, true, true);
    pan = new Pan(0);
    osc.patch(adsr).patch(delay).patch(pan).patch(output);
  }

  void noteOn(float duration) {
    adsr.noteOn();
  }

  void noteOff() {
    adsr.noteOff();
  }
}