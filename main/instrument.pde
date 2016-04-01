class AudioInstrument implements Instrument {
  Oscil osc;
  ADSR adsr;
  Delay delay;

  AudioInstrument(AudioOutput output) {
    int defaultFreq = 440;
    int defaultAmp = 1;

    osc = new Oscil(defaultFreq, defaultAmp, Waves.TRIANGLE);
    adsr = new ADSR(defaultAmp, 0.001, 0.2, 0.001, 0.001);
    delay = new Delay(0.6, 0.4, true, true);
    osc.patch(adsr);
    adsr.patch(delay).patch(output);
  }

  void noteOn(float duration) {
    adsr.noteOn();
  }

  void noteOff() {
    adsr.noteOff();
  }
}