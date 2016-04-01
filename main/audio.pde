class Audio {
  Synth synth;
  
  Audio(Object main) {
    synth = new Synth(main);
  }

  Synth getSynth() {
    return synth;
  }

  void collision(Contact c, ContactImpulse ci) {
    if (isBoxCollision(c)) {
      TextBox textBox = (TextBox)c.getFixtureA().getBody().getUserData();

      float impulse = constrain(ci.normalImpulses[0], 0, 50);
      float freq = impulse * 10;

      if (freq > 40 && freq < 1600) {
        Body body = c.getFixtureA().getBody();
        float rotation = abs(body.getAngularVelocity());
        float amp = constrain(rotation, 0, 0.5);

        synth.play(freq, 0.5, textBox.instr);
      }
    }
  }

  boolean isBoxCollision(Contact c) {
    Object userDataA = c.getFixtureA().getBody().getUserData();
    Object userDataB = c.getFixtureB().getBody().getUserData();
    if (userDataA != null && userDataB != null &&
      userDataA.getClass() == TextBox.class && userDataB.getClass() == TextBox.class) {
      return true;
    } else {
      return false;
    }
  }
}