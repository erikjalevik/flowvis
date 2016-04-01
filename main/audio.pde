import ddf.minim.*;
import ddf.minim.ugens.*;

class Audio {
  Minim minim;
  AudioOutput output;
  
  Audio(Object main) {
    minim = new Minim(main);
    output = minim.getLineOut();
  }

  AudioInstrument createInstrument() {
    return new AudioInstrument(output);
  }

  void playInstrument(float freq, float amp, AudioInstrument instr) {
    instr.osc.setFrequency(freq);
    instr.osc.setAmplitude(amp);
    output.pauseNotes();
    output.playNote(0, amp, instr);
    output.resumeNotes();
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

        playInstrument(freq, 0.5, textBox.instr);
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