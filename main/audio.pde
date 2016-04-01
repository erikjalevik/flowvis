import ddf.minim.*;
import ddf.minim.ugens.*;

class Audio {
  Minim minim;
  AudioOutput output;
  String notes[] = {
    "A1", "E2", "A2", "E3", "A3", "C4", "D4", "E4", "G4", "A4"
  };
  String specialNotes[] = {
    "F3", "F4", "C#3", "C#4"
  };
  
  Audio(Object main) {
    minim = new Minim(main);
    output = minim.getLineOut();
  }

  AudioInstrument createInstrument() {
    return new AudioInstrument(output);
  }

  String randomizeNote() {
    // Randomize special notes every now and then
    if (random(0, 1) > 0.9) {
      int index = (int)random(0, specialNotes.length);
      return specialNotes[index];
    } else {
      int index = (int)random(0, notes.length);
      return notes[index];
    }
  }

  void playInstrument(float impulse, float rotation, AudioInstrument instr) {
    instr.osc.setFrequency(Frequency.ofPitch(randomizeNote()).asHz());
    instr.osc.setAmplitude(impulse);
    instr.pan.setPan(rotation);
    output.pauseNotes();
    output.playNote(0, 0.5, instr);
    output.resumeNotes();
  }

  void collision(Contact c, ContactImpulse ci) {
    if (isBoxCollision(c)) {
      TextBox textBox = (TextBox)c.getFixtureA().getBody().getUserData();

      float impulse = ci.normalImpulses[0];

      if (impulse > 10) {
        Body body = c.getFixtureA().getBody();
        float rotation = body.getAngularVelocity();
        float pan = constrain(rotation, -1, 1);

        playInstrument(0.5, pan, textBox.instr);
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