class Audio {
  Synth synth;
  
  Audio(Object main) {
    synth = new Synth(main);
  }

  void collision(Contact c, ContactImpulse ci) {
    float impulse = constrain(ci.normalImpulses[0], 0, 50);
    float freq = impulse * 10;
    if (freq > 40 && freq < 1600) {
      Body body = c.getFixtureA().getBody();
      float rotation = abs(body.getAngularVelocity());
      float amp = constrain(rotation, 0, 0.5);
      synth.play(freq, amp);
    }
  }
}