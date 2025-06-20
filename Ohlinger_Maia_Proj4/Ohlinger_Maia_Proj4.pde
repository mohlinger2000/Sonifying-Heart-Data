import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;
import static javax.swing.JOptionPane.*;

ControlP5 p5;

SamplePlayer musicSample;
Gain masterGain;
Glide masterGainGlide;
Glide cutoffGlide;
Glide musicRateGlide;
double musicLength;
Bead musicEndListener;
WavePlayer modulator; 
Glide modulatorFrequency;
WavePlayer carrier;

Envelope gainEnvelope;
Gain synthGain;

Reverb reverb;
BiquadFilter lpFilter;

boolean forward;
boolean onStartup = true;
float speed;
int i = 0;

TextToSpeechMaker ttsMaker; 

boolean meaning = false;

String eventDataJSON = "heart_health.json";

Server server; 

void setup() {
  size(400,400);
  
  server = new Server();
  
  ac = new AudioContext();
  p5 = new ControlP5(this);
  
  ttsMaker = new TextToSpeechMaker();
  
  musicSample = getSamplePlayer("piano_fugue.wav");
  musicSample.pause(true);
  musicLength = musicSample.getSample().getLength();
  musicRateGlide = new Glide(ac, 0 , 500);
  musicSample.setRate(musicRateGlide);
  
  masterGainGlide = new Glide(ac, 1.0, 200);
  masterGain = new Gain(ac, 1, masterGainGlide);
  
  modulatorFrequency = new Glide(ac, 20, 30);
  modulator = new WavePlayer(ac, modulatorFrequency, Buffer.SINE);
  
  Function customFrequencyModulation = new Function(modulator) {
    public float calculate() {
      return (x[0] * 100.0 + 400);
    }
  };
  
  carrier = new WavePlayer(ac, customFrequencyModulation, Buffer.SINE);
  gainEnvelope = new Envelope(ac, 0.0);
  synthGain = new Gain(ac, 1, gainEnvelope);
  synthGain.addInput(carrier);
  
  ac.out.addInput(synthGain);
  
  cutoffGlide = new Glide(ac, 1500.0, 50);
  lpFilter = new BiquadFilter(ac, BiquadFilter.AP, cutoffGlide, 10.0f);
  lpFilter.addInput(musicSample);
  masterGain.addInput(lpFilter);
  
  reverb = new Reverb(ac, 1);
  reverb.addInput(musicSample);
  masterGain.addInput(reverb);
  
  ac.out.addInput(masterGain);
  
  musicEndListener = new Bead()
  {
    public void messageReceived(Bead message)
    {
      SamplePlayer sp = (SamplePlayer) message;
      sp.setEndListener(null);
      setPlaybackRate(0, false);
      sp.setPosition(0);
    }
  };
    
  p5.addButton("NormalMusic")
    .setPosition(120, 20)
    .setSize(width / 2 - 30, 30)
    .setLabel("Play Normal Sample")
    .activateBy((ControlP5.RELEASE));
  
  p5.addButton("TransformMusic")
    .setPosition(120, 60)
    .setSize(width / 2 - 30, 30)
    .setLabel("Play My Daily Sample")
    .activateBy((ControlP5.RELEASE));
    
  p5.addButton("Meaning")
    .setPosition(120, 350)
    .setSize(width / 2 - 30, 30)
    .setLabel("What Does My Sample Mean?")
    .activateBy((ControlP5.RELEASE));
  
  server.loadEventStream(eventDataJSON);
  println("Size: " + server.printSize(eventDataJSON));
  
  ac.start();
}

public void addEndListener() {
  if (musicSample.getEndListener() == null) {
    musicSample.setEndListener(musicEndListener);
  }
}

public void setPlaybackRate(float rate, boolean immediately) {
  if (musicSample.getPosition() >= musicLength) {
    println("End of tape");
    musicSample.setToEnd();
  }

  if (musicSample.getPosition() < 0) {
    println("Beginning of tape");
    musicSample.reset();
  }
  
  if (immediately) {
    musicRateGlide.setValueImmediately(rate);
  }
  else {
    musicRateGlide.setValue(rate);
  }
}

public void Envelope() {
  gainEnvelope.addSegment(0.8, 50);
  gainEnvelope.addSegment(0.0, 300);
}

public void Meaning() {
  if (meaning) {
    meaning = false;
    i = 0;
  } else {  
    meaning = true;
  }
}

public void cases(int i) {
  switch(i) {
    case 1:
      saySpeech1();
      break;
    case 2:
      saySpeech2();
      break;
    case 3:
      saySpeech3();
      break;
    case 4:
      saySpeech4();
      break;
    case 5:
      saySpeech5();
      break;
    case 6:
      saySpeech6();
      break;
    case 7:
      saySpeech7();
      break;
  }
}

public void NormalMusic() {
  speed = 1.0;
  setPlaybackRate(speed, false);
  reverb.setDamping(0.0);
  reverb.setLateReverbLevel(0.0);
  lpFilter.setType(BiquadFilter.AP);
  addEndListener();
  musicSample.start();
}

public void TransformMusic() {
  speed = 1.0;
  Damping(server.user.getNumPalpitationEpisodes());
  LateReverb(server.user.getNumTimesPurged());
  Filter(server.stats.bloodPressure.getCurrBP());
  Backwards(server.stats.getArrhythmia());
  Speed(server.stats.getAvgHR());
  musicSample.start();
}

public void Damping(int value) {
  float dampingLevel = (float)value * 0.1;
  if (dampingLevel >= 1.0) {
    reverb.setDamping(1.0);
  } else if (dampingLevel < 1.0 && dampingLevel > 0.0) {
    reverb.setDamping(dampingLevel);
  } else {
    reverb.setDamping(0.0);
  }
}

public void LateReverb(float value) {
  float reverbLevel = value * 0.2;
  if (reverbLevel >= 1.0) {
    reverb.setLateReverbLevel(1.0);
  } else if (reverbLevel < 1.0 && reverbLevel > 0.0) {
    reverb.setLateReverbLevel(value);
  } else {
    reverb.setLateReverbLevel(0);
  }
}

public void Filter(String bp) {
  int intBP = parseInt(bp.replace("/", ""));
  if (intBP > 12090) {
    lpFilter.setType(BiquadFilter.LP);
  } else if (intBP < 9050) {
    lpFilter.setType(BiquadFilter.HP);
  } else {
    lpFilter.setType(BiquadFilter.AP);
  }
}

public void Speed(int heartrate) {
  if (heartrate <= 60) {
    speed = speed * 0.5;
    setPlaybackRate(speed, false);
    addEndListener();
  } else if (heartrate >= 100) {
    speed = speed * 2.0;
    setPlaybackRate(speed, false);
    addEndListener();
  } else {
    speed = speed * 1.0;
    setPlaybackRate(speed, false);
    addEndListener();
  }
}

public void Backwards(boolean arrhythmia) {
  if (arrhythmia) {
    speed = speed * -1.0;
    musicSample.setToEnd();
    setPlaybackRate(speed, false);
    addEndListener();
  } else {
    speed = speed * 1.0;
    setPlaybackRate(speed, false);
    addEndListener();
  }
}

void drawWaveform() {
  fill (0, 32, 0, 32);
  rect (0, 0, width, height);
  stroke (32);
  for (int i = 0; i < 11 ; i++){
    line (0, i*75, width, i*75);
    line (i*75+25, 0, i*75+25, height);
  }
  stroke (0);
  line (width/2, 0, width/2, height);
  line (0, height/2, width, height/2);
  stroke (128,255,128);
  int crossing=0;

  for(int i = 0; i < ac.getBufferSize() - 1 && i<width+crossing; i++)
  {
    if (crossing==0 && ac.out.getValue(0, i) < 0 && ac.out.getValue(0, i+1) > 0) crossing=i;
    if (crossing!=0) {
      line( i-crossing, height/2 + ac.out.getValue(0, i)*300, i+1-crossing, height/2 + ac.out.getValue(0, i+1)*300 );
    }
  }
}

void drawMeaning() {
  String name = server.user.getName();
  String purge = Integer.toString(server.user.getNumTimesPurged());
  String palpitation = Integer.toString(server.user.getNumPalpitationEpisodes());
  String avgHR = Integer.toString(server.stats.getAvgHR());
  String bloodPressure = server.stats.bloodPressure.getCurrBP();
  String rhythm = server.stats.heartRhythm.getRhythm();
  
  textSize(15);
  text(name + "'s Report:\n", width / 2 - 60, 100, 200, 200); 
  text("Average HR: 60-100 bpm", width / 2 - 180, 125, 100, 200);
  text("Your Average HR: " + avgHR + " bpm", width / 2 + 20, 125, 120, 200);
  text("Average Blood Pressure: 90/60mmHg - 120/80mmHg", width / 2 - 180, 165, 200, 200);
  text("Your Blood Pressure: " + bloodPressure + "mmHg", width / 2 + 20, 165, 150, 200);
  text("Average Heart Rhythm: SINUS", width / 2 - 180, 205, 150, 50);
  text("Your Heart Rhythm: " + rhythm, width / 2 + 20, 205, 150, 50);
  text("Press Any Key to Hear the Report", width / 2 - 90, 330);
  fill(255, 255, 255);
}
 
public void draw() {
  background(0);
  
  if (onStartup == true) {
    onStartup = false;
    Envelope();
    showMessageDialog(null, "Your music sample is ready, " + server.user.getName() + ".", 
      "Alert", ERROR_MESSAGE);
  }

  if (meaning == false) {
    drawWaveform(); 
  } else {
    drawMeaning();
  }
}

void saySpeech0() {
  String speech = "Press any key to hear the report.";
  ttsPlayback(speech);
}

void saySpeech1() {
  String name = server.user.getName();
  String speech = name + "'s Report";
  ttsPlayback(speech);
}

void saySpeech2() {
  String speech = "The average heartrate is between 60 and 100 beats per minute.";
  ttsPlayback(speech);
}

void saySpeech3() {
  String avgHR = Integer.toString(server.stats.getAvgHR());
  String speech = "Your average heartrate was " + avgHR + " beats per minute.";
  ttsPlayback(speech);
}

void saySpeech4() {
  String speech = "The average blood pressure is between 90 over 60 millimeters mercury to 120 over 80 millimeters mercury.";
  ttsPlayback(speech);
}

void saySpeech5() {
  String bloodPressure = server.stats.bloodPressure.getCurrBP();
  String speech = "Your average blood pressure was " + bloodPressure + " millimeters mercury.";
  ttsPlayback(speech);
}

void saySpeech6() {
  String speech = "The average heart rhythm is a sinus rhythm.";
  ttsPlayback(speech);
}

void saySpeech7() {
  String rhythm = server.stats.heartRhythm.getRhythm();
  String speech = "Your heart rhythm was a " + rhythm + " rhythm.";
  ttsPlayback(speech);
}

void ttsPlayback(String inputSpeech) {
  String ttsFilePath = ttsMaker.createTTSWavFile(inputSpeech);
  println("File created at " + ttsFilePath);
  
  SamplePlayer sp = getSamplePlayer(ttsFilePath, true); 
  
  ac.out.addInput(sp);
  sp.setToLoopStart();
  masterGainGlide.setValue(masterGainGlide.getValue() / 5);
  sp.start();
  //println("TTS: " + inputSpeech);
}

void keyPressed() {
  if (meaning) {
    i++;
    cases(i);
  }
}

void mousePressed() {
  if (meaning) {
    saySpeech0();
  }
}
