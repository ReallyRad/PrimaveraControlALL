import themidibus.*; //Import the library
import javax.sound.midi.MidiMessage; //Import the MidiMessage classes http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/MidiMessage.html
import javax.sound.midi.SysexMessage;
import javax.sound.midi.ShortMessage;



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

int channel=9;

// MIDI
MidiBus myBus; // The MidiBus

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
    
    }
    if(param2==slider2){ //FADE TIME
      
    }
    if(param2==slider3){ //BRIGHt SCALE
      int a=(int)valueMap(param3,0,4);
      //AudioBrightnessScale(a);
    }
    if(param2==slider4){ //DMX ALPHA
      
    }
    if(param2==slider5){ //SMOotHING
      
    }
    if(param2==slider6){ //ONSET SILENCE THRESOL
      
    }
    if(param2==slider7){ //THRESOLD
      
    }
    if(param2==slider8){ //SCALE
      
    }
    
  }//end command 176
  
  //MAPEO DE MIDI BOTONES 
  if(command ==144){
    
    //ANIMACIONES
    for(int i = 0; i < ControlAnimaciones.length; i++){
      if(param2==BotonesAnimaciones[i]){ 
        ControlAnimaciones[i]=!ControlAnimaciones[i];
        println(ControlAnimaciones[i]);
        //SelectAnimations(ControlAnimaciones);
      } 
    }
    
    
    //ANIMATION LENGth
    if(param2==animLengthMas){ 
        //AnimationTime();
        
      } 
      if(param2==animLengthMenos){ 
        //AnimationTime();
        
      } 
      if(param2==animLengthRapido){ 
        //AnimationTime();
        
      } 
      if(param2==animLengthLento){ 
        
        //AnimationTime();
      } 
      
      
      //DMXMODE
      for(int i = 0; i < ControlDMX.length; i++){
         ControlDMX[i]=false; 
        if(param2==BotonesDMX[i]){ 
          ControlDMX[i]=true;
          println(ControlDMX[i]);
          //DmxMode(i);
        } 
      }
      
      //MASKMode
      for(int i = 0; i < ControlMASK.length; i++){
         ControlMASK[i]=false; 
        if(param2==BotonesMASK[i]){ 
          ControlMASK[i]=true;
          println(ControlMASK[i]);
          //MaskMode(i);
        } 
     }
     
     //ONSET MODE
      for(int i = 0; i < ControlOnset.length; i++){
         ControlOnset[i]=false; 
        if(param2==BotonesOnset[i]){ 
          ControlOnset[i]=true;
          println(ControlOnset[i]);
          //OnsetMode(i);
        } 
     }
     
     //EFFECTS 
      for(int i = 0; i < ControlEffects.length; i++){
         //ControlEffects[i]=false; 
        if(param2==BotonesEffects[i]){ 
          ControlEffects[i]=!ControlEffects[i];
          println(ControlEffects[i]);
         /* if(i==0) //TrailEffect(ControlEffects[i]);
          else if(i==1) //BrightnessEffect(ControlEffects[i]);
          else if(i==2) //NoiseEffect(ControlEffects[i]);
          */
        } 
     }
     
     
    
  }//End command 144
  
  
}//END midi
void LightMidi(){
  for(int i=0;i<ControlAnimaciones.length;i++){
    if(ControlAnimaciones[i]){
          myBus.sendNoteOn(9,BotonesAnimaciones[i],01); // Send a Midi noteOn  //VERDE
          //println("VErDE");
     }
      else{
         myBus.sendNoteOn(9, BotonesAnimaciones[i], 03);  //RED
       //println("Rojo");
   }
  }
  
  for(int i=0;i<60;i++){
    
      myBus.sendNoteOn(9,i,03); // Send a Midi noteOn  //VERDE
      myBus.sendNoteOn(90,i,01);
      //println("VErDE");
    
  }
}

float valueMap(float x,float a,float b){
  float v=map(x,0,127,a,b);
  return v;
}