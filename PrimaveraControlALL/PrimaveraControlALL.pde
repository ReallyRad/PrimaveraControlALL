import themidibus.*; //Import the library
import javax.sound.midi.MidiMessage; //Import the MidiMessage classes http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/MidiMessage.html
import javax.sound.midi.SysexMessage;
import javax.sound.midi.ShortMessage;
import netP5.*;
import oscP5.*;

//OSC
OscP5 oscP5;
NetAddress myRemoteLocation;
OscMessage myMessage;
float bpm;
int nextNumBeats;


//APCMINI
int slider1=48;
int slider2=49;
int slider3=50;
int slider4=51;
int slider5=52;
int slider6=53;
int slider7=54;
int slider8=55;
int slider9=56;

int anim1=56;
int anim2=57;
int anim3=58;
int anim4=59;
int anim5=60;
int anim6=61;
int anim7=62;
int anim8=63;
int anim9=54;
int anim10=55;

int animLengthMas=64;
int animLengthMenos=65;
int animLengthRapido=0;
int animLengthLento=1;

int dmx1=10;
int dmx2=11;
int dmx3=12;

int mask1=2;
int mask2=3;
int mask3=4;

int eff1=5;
int eff2=6;
int eff3=7;

int onset1=69;
int onset2=70;
int onset3=71;

int nextAnim=82;
int nextMask=83;
int block=84;
boolean isNextAnim=false;
boolean isNextMask=false;
boolean isBlock=false;

int resync=98;


int nextNumBeatsMas=32;
int nextNumBeatsMenos=33;

int channel=9;

// MIDI
MidiBus myBus; // The MidiBus
MidiBus myBus2; 

//General
int numeroAnimaciones=10;   //CAMBIAR ESTO CADA VEZ QUE SE PONGA UN NUEVO ALGORITMO
boolean[] ControlAnimaciones= new boolean[numeroAnimaciones];
int[] BotonesAnimaciones= {anim1,anim2,anim3,anim4,anim5,anim6,anim7,anim8,anim9,anim10};

int[] BotonesAnimLength={animLengthRapido,animLengthLento};

boolean[] ControlDMX= new boolean[3];
int[] BotonesDMX = {dmx1,dmx2,dmx3};

boolean[] ControlMASK= new boolean[3];
int[] BotonesMASK = {mask1,mask2,mask3};

boolean[] ControlEffects= new boolean[3];
int[] BotonesEffects = {eff1,eff2,eff3};

boolean[] ControlOnset= new boolean[3];
int[] BotonesOnset = {onset1,onset2,onset3};

///////////////////////////////////////////
////      SETUP
////////////////////////////////////////////
void setup(){
  background(0);
  size(600,400,P3D);
  //fullScreen(P3D);
  background(0);
  
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, 0, 1); // Create a new MidiBus object
  //myBus2 = new MidiBus(this, 1, 0); // Create a new MidiBus object
  
  //OSC
  oscP5 = new OscP5(this,8015);
  oscP5.plug(this,"Bpm","/PrimaveraSoundProto/Bpm");
  myRemoteLocation = new NetAddress("127.0.0.1",50001);
  
  bpm = 120f;
  nextNumBeats = 256;
  
  // ALL INACTIVE AT THE START
  for(int i = 0; i < ControlAnimaciones.length; i++){
    ControlAnimaciones[i]=false;
  }
  for(int i = 0; i < ControlDMX.length; i++){
    ControlDMX[i]=false;
  }
  for(int i = 0; i < ControlMASK.length; i++){
    ControlMASK[i]=false;
  }
  
  
  
}

void draw(){  
  background(0);
  LightMidi();      
}

void Bpm(float bpm2){
  this.bpm = bpm2;
  println("hola bpm : " + bpm);
}

void midiMessage(MidiMessage message) { // You can also use midiMessage(MidiMessage message, long timestamp, String bus_name)
  // Receive a MidiMessage
  // MidiMessage is an abstract class, the actual passed object will be either javax.sound.midi.MetaMessage, javax.sound.midi.ShortMessage, javax.sound.midi.SysexMessage.
  // Check it out here http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/package-summary.html
  int command=message.getStatus();
  int param2;
  int param3;
  println();
  println("MidiMessage Data:");
  println("--------");
  println("Status Byte/MIDI Command:"+message.getStatus());
  for (int i = 1;i < message.getMessage().length;i++) {
    println("Param "+(i+1)+": "+(int)(message.getMessage()[i] & 0xFF));
    
  }
  param2=(int)(message.getMessage()[1] & 0xFF);
  param3=(int)(message.getMessage()[2] & 0xFF);
  
    
  
  //MAPEO DE MIDI SLIDERS 
  if(command ==176){
    if(param2==slider1){ //MIN BRIGHT
      float a=valueMap(param3,0,4);
      //MinBrightness(a);
    }
    if(param2==slider2){ //FADE TIME
      float a=valueMap(param3,0,5);
      FadeTime(a);
    }
    if(param2==slider3){ //BRIGHt SCALE
      float a=valueMap(param3,0,4);
      AudioBrightnessScale(a);
    }
    if(param2==slider4){ //DMX ALPHA
      float a=valueMap(param3,0,10);
      //DmxAlpha(a);
    }
    if(param2==slider5){ //SMOotHING
      float a=valueMap(param3,0,1);
      AudioSmoothing(a);
    }
    if(param2==slider6){ //ONSET SILENCE THRESOL
      float a=valueMap(param3,0,1);
      OnsetSilenceThreshold(a);
    }
    if(param2==slider7){ //ONSET TIME THRESOLD
      float a=valueMap(param3,0,1000);
      OnsetTimeThreshold(a);
    }
    if(param2==slider8){ //Audio Brightness SCALE
      float a=valueMap(param3,0,4);
      AudioBrightnessScale(a);
    }
    
  }//end command 176
  
  //MAPEO DE MIDI BOTONES 
  if(command ==144){
    
    //ANIMACIONES
    for(int i = 0; i < ControlAnimaciones.length; i++){
      if(param2==BotonesAnimaciones[i]){ 
        ControlAnimaciones[i]=!ControlAnimaciones[i];
        println(ControlAnimaciones[i]);
        SelectAnimations(ControlAnimaciones);
      } 
    }
    
    
    //ANIMATION LENGth
    if(param2==animLengthMas){ 
        //NoteDuration(3);
        
      } 
      if(param2==animLengthMenos){ 
        //NoteDuration(2);
        
      } 
      if(param2==animLengthRapido){ 
        //NoteDuration(0);
        
      } 
      if(param2==animLengthLento){ 
        
        //NoteDuration(1);
      } 
      
      
      //DMXMODE
      for(int i = 0; i < ControlDMX.length; i++){
         ControlDMX[i]=false; 
        if(param2==BotonesDMX[i]){ 
          ControlDMX[i]=true;
          println(ControlDMX[i]);
          DmxMode(i);
        } 
      }
      
      //MASKMode
      for(int i = 0; i < ControlMASK.length; i++){
         ControlMASK[i]=false; 
        if(param2==BotonesMASK[i]){ 
          ControlMASK[i]=true;
          println(ControlMASK[i]);
          MaskMode(i);
        } 
     }
     
     //ONSET MODE
      for(int i = 0; i < ControlOnset.length; i++){
         ControlOnset[i]=false; 
        if(param2==BotonesOnset[i]){ 
          ControlOnset[i]=true;
          println(ControlOnset[i]);
          OnsetMode(i);
        } 
     }
     
     //EFFECTS 
      for(int i = 0; i < ControlEffects.length; i++){
         //ControlEffects[i]=false; 
        if(param2==BotonesEffects[i]){ 
          ControlEffects[i]=!ControlEffects[i];
          println(ControlEffects[i]);
          if(i==0) TrailEffect(ControlEffects[i]);
          else if(i==1) BrightnessEffect(ControlEffects[i]);
          else if(i==2) NoiseEffect(ControlEffects[i]);
          
        } 
     }
     
     //NeXt animation
     if(param2==nextAnim){ 
        isNextAnim=!isNextAnim;
        NextAnimation();
        println(isNextAnim);
        //LightMidi();
      } 
      
      //NeXt MASK
     if(param2==nextMask){ 
        isNextMask=!isNextMask;
        //NextMask();
        println(isNextMask);
        //LightMidi();
      } 
      
      //BLOCK
     if(param2==block){ 
        isBlock=!isBlock;
        BlockAnimation(isBlock);
        /*myBus.sendNoteOn(90,param2,01);
        myBus.sendNoteOn(9,param2,01);
        myBus.sendNoteOn(0x90,param2,01);
        myBus.sendNoteOn(0x90,param2,0x01);*/
        //LightMidi();
      } 
      
      //NEXT NUM BEATS
       if(param2==nextNumBeatsMas){ 
        // float a=valueMap(param3,0,4);
          NextNumBeats(0);
          //LightMidi();
        } 
        
        if(param2==nextNumBeatsMenos){ 
        // float a=valueMap(param3,0,4);
          NextNumBeats(1);
          //LightMidi();
        } 
        
        
        //RESYNC
        if(param2==resync){ 
          Resync();
        }
     
    
  }//End command 144
  
  
}//END midi


void LightMidi(){
  for(int i=0;i<ControlAnimaciones.length;i++){
    if(ControlAnimaciones[i]){
          myBus.sendNoteOn(9,BotonesAnimaciones[i],01); // Send a Midi noteOn  //VERDE
          println("VErDE");
     }
      else{
         myBus.sendNoteOn(9, BotonesAnimaciones[i], 03);  //RED
       println("Rojo");
   }
  }
  
  /*for(int i=0;i<60;i++){
    
      myBus.sendNoteOn(9,i,03); // Send a Midi noteOn  //VERDE
      myBus.sendNoteOn(90,i,01);
      //println("VErDE");
  }*/
}

float valueMap(float x,float a,float b){
  float v=map(x,0,127,a,b);
  return v;
}


///////////////OSC///////////////////////////

void ColorMode(int val) 
{
  myMessage= new OscMessage("/PrimaveraSoundProto/ColorMode");
  String[] types = {"Random", "Fixed"};  
  myMessage.add(types[val]);
  oscP5.send(myMessage, myRemoteLocation);
}

void MaskMode(int val) {
   myMessage= new OscMessage("/PrimaveraSoundProto/MaskMode");
   String[] types = {"Full", "Medium", "Centre"};
   myMessage.add(types[val]);
   oscP5.send(myMessage, myRemoteLocation);
}  

void DmxMode(int val){
  myMessage= new OscMessage("/PrimaveraSoundProto/DmxMode");
  String[] types = {"Calm", "Normal", "Intense"};
  myMessage.add(types[val]);
  oscP5.send(myMessage, myRemoteLocation);
}
 
void OnsetMode(int val){
  myMessage= new OscMessage("/PrimaveraSoundProto/OnsetMode");
  String[] types = {"Free", "Quantized", "Automatic"};
  myMessage.add(types[val]);
  oscP5.send(myMessage, myRemoteLocation);
} 

void FadeTime(float val){
  myMessage= new OscMessage("/PrimaveraSoundProto/FadeTime"); 
  myMessage.add(val);
  oscP5.send(myMessage, myRemoteLocation);
}

void BlockAnimation (boolean val) {
  int a;
  if(val) a=1;
  else a=0;
  myMessage= new OscMessage("/PrimaveraSoundProto/BlockAnimation");
  myMessage.add(a);
  oscP5.send(myMessage, myRemoteLocation);
}

void NextAnimation () {
  myMessage= new OscMessage("/PrimaveraSoundProto/NextAnimation");
  myMessage.add(1);
  oscP5.send(myMessage, myRemoteLocation);
}

void SelectAnimations(boolean[] anims) {
  myMessage= new OscMessage("/PrimaveraSoundProto/SelectAnimations");
  for(int i = 0; i < anims.length; i++){
    if (anims[i]) myMessage.add(i+1);
  }
  oscP5.send(myMessage, myRemoteLocation);
}

void Resync(){
  myMessage= new OscMessage("/PrimaveraSoundProto/Bpm");
  myMessage.add(bpm);
  oscP5.send(myMessage, myRemoteLocation);
}

//Won't implement
void BeatsPerBar() {
  
} 

void NextNumBeats(int val){    
  if (val == 1 && nextNumBeats < 256) nextNumBeats *= 2;  
  else if (val == 0 && nextNumBeats > 1)  nextNumBeats /= 2;  
  print ("next num beats : " + nextNumBeats);
  
  myMessage = new OscMessage("/PrimaveraSoundProto/NextNumBeats");
  myMessage.add(nextNumBeats);
  oscP5.send(myMessage, myRemoteLocation);
}

void TriggerAnimation(){
  myMessage = new OscMessage("/PrimaveraSoundProto/TriggerAnimation");
  myMessage.add(1);
  oscP5.send(myMessage, myRemoteLocation);
}

//Deprecated, don't implement
void NextNumOnsets(){}

void TrailEffect(boolean val){
  myMessage = new OscMessage("/PrimaveraSoundProto/TrailEffect");
  int a;
  if(val) a=1;
  else a=0;
  myMessage.add(a);
  oscP5.send(myMessage, myRemoteLocation);
}

void BrightnessEffect(boolean val) {
  int a;
  if(val) a=1;
  else a=0;
  myMessage = new OscMessage("/PrimaveraSoundProto/BrightnessEffect");
  myMessage.add(a);
  oscP5.send(myMessage, myRemoteLocation);
}

void NoiseEffect(boolean val){
  int a;
  if(val) a=1;
  else a=0;
  myMessage = new OscMessage("/PrimaveraSoundProto/NoiseEffect");
  myMessage.add(a);
  oscP5.send(myMessage, myRemoteLocation);
}

void AudioSmoothing(float val) {
  myMessage = new OscMessage("/PrimaveraSoundProto/AudioSmoothing");
  myMessage.add(val);
  oscP5.send(myMessage, myRemoteLocation);
}

void AudioBrightnessScale(float val){
  myMessage = new OscMessage("/PrimaveraSoundProto/AudioBrightnessScale");
  myMessage.add(val);
  oscP5.send(myMessage, myRemoteLocation);
}

void OnsetAlpha(float val) {
  myMessage = new OscMessage("/PrimaveraSoundProto/OnsetAlpha");
  myMessage.add(val);
  oscP5.send(myMessage, myRemoteLocation);
}

void OnsetSilenceThreshold (float val) {
  myMessage = new OscMessage("/PrimaveraSoundProto/OnsetSilenceThreshold");
  myMessage.add(val);
  oscP5.send(myMessage, myRemoteLocation);
}

void OnsetTimeThreshold (float val) {
  myMessage = new OscMessage("/PrimaveraSoundProto/OnsetTimeThreshold");
  myMessage.add(val);
  oscP5.send(myMessage, myRemoteLocation);
}

void Panic() {
  myMessage = new OscMessage("/PrimaveraSoundProto/Panic");
  myMessage.add(1);
  oscP5.send(myMessage, myRemoteLocation);
}

//missing 
void MinBright(){
}

//missing
void TriggerMask()
{}