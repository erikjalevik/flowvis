import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

class Audio {
  final int COLLISION_SOUND_DELAY = 50;
  final int MAXIMUM_INSTRUMENT_COUNT = 50;

  Minim minim;
  AudioOutput output;
  String notes[] = {
    "A1", "E2", "A2", "E3", "A3", "C4", "D4", "E4", "G4", "A4"
  };
  String specialNotes[] = {
    "F3", "F4", "C#3", "C#4"
  };
  int lastCollision = millis();
  int instrumentCount = 0;

  Audio(Object main) {
    minim = new Minim(main);
    output = minim.getLineOut();

    // Create background noise
    Noise noise = new Noise(0.1, Noise.Tint.RED);
    IIRFilter filter = new LowPassSP(1000, output.sampleRate());
    Oscil lfo = new Oscil(0.25, 50, Waves.SINE);
    lfo.offset.setLastValue(100);
    lfo.patch(filter.cutoff);
    noise.patch(filter).patch(output);
  }

  AudioInstrument createInstrument() {
    if (instrumentCount <= MAXIMUM_INSTRUMENT_COUNT) {
      instrumentCount++;
      return new AudioInstrument(output, true);
    } else {
      return new AudioInstrument(output, false);
    }
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

  void collision(Contact c, ContactImpulse ci) {
    TextBox textBoxA = (TextBox)c.getFixtureA().getBody().getUserData();
    TextBox textBoxB = (TextBox)c.getFixtureB().getBody().getUserData();

    if (millis() - lastCollision < COLLISION_SOUND_DELAY) {
      return;
    }

    if (!isBoxCollision(c)) {
      return;
    }

    if (textBoxA.instr == null) {
      return;
    }

    float impulse = ci.normalImpulses[0];
    if (impulse > 10) {
      float rotation = c.getFixtureA().getBody().getAngularVelocity();
      float pan = constrain(rotation, -1, 1);
      float alpha = (textBoxA.alpha + textBoxB.alpha) / 2;
      float amp = alpha / 255 * 0.7;

      playInstrument(amp, pan, textBoxA.instr);

      lastCollision = millis();
    }
  }

  void playInstrument(float amp, float pan, AudioInstrument instr) {
    if (instr.isDestroyed() || instr.osc == null) {
      return;
    }
    
    instr.osc.setFrequency(Frequency.ofPitch(randomizeNote()).asHz());
    instr.osc.setAmplitude(amp);
    instr.pan.setPan(pan);
    output.playNote(0, 0.5, instr);
  }

  void destroyInstrument(AudioInstrument instr) {
    if (!instr.isDestroyed()) {
      instr.destroy();
  
      if (instr.osc != null) {
        instrumentCount--;
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