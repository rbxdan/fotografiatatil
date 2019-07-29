//Algoritmo base desenvolvido durante a disciplina de Design Computacional de 2018.1  //<>//
//pela aluna Claires Maia de Paiva com a orientação de Roberto Cesar Cavalcante Vieira
//para aplicação no projeto Fotografia Tátil

import gab.opencv.*;
import processing.video.*;

import ddf.minim.*;
Minim minim;
AudioPlayer ambiente;

PImage menina; // imagem de teste
int num_select = 1;

OpenCV opencv;
Capture video;
int scl = 1;
boolean audio=false;
boolean change_photo = false;
boolean description = true;
PImage foto;
int volume=-13;
int circ_select=0;
int circ_num=10;
float [] circ_radius = new float [circ_num]; 

float [] circ_x = new float [circ_num];
float [] circ_y = new float [circ_num];
boolean [] audio_run = new boolean [circ_num];
boolean playing_audio = false;
AudioPlayer [] circ_audios = new AudioPlayer [circ_num];

void setup() {
  minim = new Minim(this);
  String[] cameras = Capture.list();

  for ( int i = 0; i < circ_num; i++ ) {

    circ_x [i] = -50;
    circ_y [i] = -50;

    circ_radius [i] = 30;
    audio_run[i] = false;
    circ_audios [i] = minim.loadFile("./data/04/"+i+".mp3");
    println(circ_audios [i] );
  }

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i, cameras[i]);
    }
  } 

  foto = loadImage("foto2.jpg");
  size(640, 480);                     // 320 x 240

  video = new Capture(this, width/scl, height/scl, cameras[3]); // 31
  opencv = new OpenCV(this, width/scl, height/scl);

  //  src.resize(800, 0);
  // size(800, 533);
  video.start();
  // opencv = new OpenCV(this, src);  

  ambiente = minim.loadFile("./data/01/d.mp3");


  // ambiente.play();

  menina = loadImage("menina-afega.jpg"); // imagem de teste
}

void draw() {
  // ambiente.setGain(volume);
  // ambiente.setGain(-80+100*mouseX/width);
  scale(scl);
  opencv.loadImage(video);

  //pushMatrix();
  //translate(video.width,0);
  //scale(-1,1); 
  //image(video,0,0);
  //popMatrix();

  image(video, width/2, height/2);
  imageMode(CENTER);
  tint(255, 80);
  image(menina, width/2, height/2); // coloca imagem por cima


  //foto.resize(640, 480);
  //image(foto, 0, 0 );

  // image(opencv.getOutput(), 0, 0); 
  PVector loc = opencv.max();

  stroke(255, 0, 0);
  strokeWeight(4);
  noFill();
  ellipse(loc.x, loc.y, 20, 20);

  stroke(255, 255, 0);
  strokeWeight(1);
  noFill();

  if (change_photo==false) {

    playing_audio = false;
    for ( int i = 0; i < circ_num; i++ ) {
      if (circ_audios[i].isPlaying()) {
        playing_audio = true;
      }
    }

    for ( int i = 0; i < circ_num; i++ ) {
      if (i== circ_select) {
        stroke(0, 255, 0);
      } else {
        stroke(255, 255, 0);
      }
      ellipse(circ_x [i], circ_y [i], circ_radius [i], circ_radius [i]);

      if ((audio_run[i] == false) && (playing_audio==false) && (!ambiente.isPlaying())) {
        if ((dist(loc.x, loc.y, circ_x [i], circ_y [i])< 10+circ_radius [i]/2)) {              // executa audio
          if (!circ_audios[i].isPlaying()) {
            circ_audios[i].rewind();
            circ_audios[i].play();
            audio_run[i] = true;
          }
        }
      }
    }
  }
  // 320 x 240 
  // ellipse(60, 95, 60, 60);                        // cabeça menino


  /* ellipse(300, 160, 30, 30);                         // +
   ellipse(300, 210, 30, 30);                         // -
   
   if ((dist(loc.x, loc.y, 300, 160)<25)) {              // +
   volume++;
   }
   
   if ((dist(loc.x, loc.y, 300, 210)<25)) {              // -
   volume--;
   } */

  /* if ((dist(loc.x, loc.y, 60, 95)<40)) {              // cabeça menino audio
   if (!audio_cabeca.isPlaying()){
   audio_cabeca.rewind();
   audio_cabeca.play();
   }
   }  */
}

String[] parseFile() {
  String[] fileText = loadStrings("mapeamento.txt");

  return fileText;
}

void captureEvent(Capture c) {
  c.read();
}

void mouseClicked() {
  println("x=", mouseX, ",Y=", mouseY);
  circ_y[circ_select]=mouseY;
  circ_x[circ_select]=mouseX;
}

void keyPressed() {

  if (keyCode == UP) {
    circ_radius[circ_select]=circ_radius[circ_select]+10;
  }
  if (keyCode == DOWN) {
    circ_radius[circ_select]=circ_radius[circ_select]-10;
  }

  switch(key) {
    case('q'): 
    circ_select=0; 
    break;
    case('w'): 
    circ_select=1; 
    break;
    case('e'): 
    circ_select=2; 
    break;
    case('r'): 
    circ_select=3; 
    break;
    case('t'): 
    circ_select=4; 
    break;
    case('y'): 
    circ_select=5; 
    break;
    case('u'): 
    circ_select=6; 
    break;
    case('i'): 
    circ_select=7; 
    break;
    case('o'): 
    circ_select=8; 
    break;
    case('p'): 
    circ_select=9; 
    break;
    case('z'):
    for ( int i = 0; i < circ_num; i++ ) {   
      audio_run[i] = false;
    }
    break;
    case('x'):
    for ( int i = 0; i < circ_num; i++ ) {   
      audio_run[i] = true;
    }
    break;
    case('g'):
    String[] fileText = parseFile();
    saveStrings("mapeamento.txt", fileText);

    String str = fileText[fileText.length-2];
    println(str);
    String num = str.replaceAll("[^\\d]", "");
    
    num_select = int(num);
    println(num_select);

    String[] newText = append(fileText, "PECA "+(num_select+1)); 
    newText = append(newText, "");

    for ( int i = 0; i < circ_num; i++ ) { 
      println("circ_x ["+i+"]="+circ_x [i] +";");
      newText = append(newText, "circ_x ["+i+"]="+circ_x [i] +";");
      println("circ_y ["+i+"]="+circ_y [i] +";");
      newText = append(newText, "circ_y ["+i+"]="+circ_y [i] +";");
      println("circ_radius ["+i+"]="+circ_radius [i] +";");
      newText = append(newText, "circ_radius ["+i+"]="+circ_radius [i] +";");
    }
    newText = append(newText, "");
    newText = append(newText, "FIM DO MAPEAMENTO DA PECA "+(num_select+1));
    newText = append(newText, "//////////////////////////////");
    saveStrings("mapeamento.txt", newText);
    break;
    case('a'):
    description = !description;
    if (description == false) {
      ambiente.pause();
      ambiente.rewind();
    }
    break;
    case('1'):
    change_photo=true;
    for ( int i = 0; i < circ_num; i++ ) {
      circ_x [i] = -50;
      circ_y [i] = -50;

      circ_radius [i] = 30;
      audio_run[i] = false;
      circ_audios [i].pause();
      circ_audios [i].rewind();
      circ_audios [i] = minim.loadFile("./data/01/"+i+".mp3");
    }
    ///// mapeamento peca 01
    circ_x [0]=452.0;
    circ_y [0]=171.0;
    circ_radius [0]=100.0;
    circ_x [1]=465.0;
    circ_y [1]=31.0;
    circ_radius [1]=60.0;
    circ_x [2]=448.0;
    circ_y [2]=267.0;
    circ_radius [2]=100.0;
    circ_x [3]=535.0;
    circ_y [3]=394.0;
    circ_radius [3]=70.0;
    circ_x [4]=343.0;
    circ_y [4]=308.0;
    circ_radius [4]=110.0;
    circ_x [5]=102.0;
    circ_y [5]=384.0;
    circ_radius [5]=90.0;
    circ_x [6]=310.0;
    circ_y [6]=223.0;
    circ_radius [6]=70.0;
    circ_x [7]=439.0;
    circ_y [7]=293.0;
    circ_radius [7]=40.0;
    circ_x [8]=448.0;
    circ_y [8]=260.0;
    circ_radius [8]=30.0;
    circ_x [9]=-50.0;
    circ_y [9]=-50.0;
    circ_radius [9]=30.0;
    /// fim mapeamento peca 01

    println("Peça 01");
    if (description == true) {
      ambiente.pause();
      ambiente.rewind();
      ambiente = minim.loadFile("./data/01/d.mp3");
      ambiente.play();
    }
    change_photo=false;
    break;
    case('2'):
    change_photo=true;
    for ( int i = 0; i < circ_num; i++ ) {
      circ_x [i] = -50;
      circ_y [i] = -50;

      circ_radius [i] = 30;
      audio_run[i] = false;
      circ_audios [i].pause();
      circ_audios [i].rewind();
      circ_audios [i] = minim.loadFile("./data/02/"+i+".mp3");
    }
    ///// mapeamento peca 02
    circ_x [0]=137.0;
    circ_y [0]=218.0;
    circ_radius [0]=50.0;
    circ_x [1]=98.0;
    circ_y [1]=211.0;
    circ_radius [1]=50.0;
    circ_x [2]=54.0;
    circ_y [2]=206.0;
    circ_radius [2]=50.0;
    circ_x [3]=118.0;
    circ_y [3]=296.0;
    circ_radius [3]=80.0;
    circ_x [4]=153.0;
    circ_y [4]=239.0;
    circ_radius [4]=20.0;
    circ_x [5]=321.0;
    circ_y [5]=236.0;
    circ_radius [5]=120.0;
    circ_x [6]=-50.0;
    circ_y [6]=-50.0;
    circ_radius [6]=30.0;
    circ_x [7]=-50.0;
    circ_y [7]=-50.0;
    circ_radius [7]=30.0;
    circ_x [8]=-50.0;
    circ_y [8]=-50.0;
    circ_radius [8]=30.0;
    circ_x [9]=-50.0;
    circ_y [9]=-50.0;
    circ_radius [9]=30.0;

    /// fim mapeamento peca 02

    println("Peça 02");
    if (description == true) {
      ambiente.pause();
      ambiente.rewind();
      ambiente = minim.loadFile("./data/02/d.mp3");
      ambiente.play();
    }
    change_photo=false;
    break;
    case('3'):
    change_photo=true;
    for ( int i = 0; i < circ_num; i++ ) {
      circ_x [i] = -50;
      circ_y [i] = -50;

      circ_radius [i] = 30;
      audio_run[i] = false;
      circ_audios [i].pause();
      circ_audios [i].rewind();
      circ_audios [i] = minim.loadFile("./data/03/"+i+".mp3");
    }
    ///// mapeamento peca 03
    circ_x [0]=310.0;
    circ_y [0]=258.0;
    circ_radius [0]=90.0;
    circ_x [1]=205.0;
    circ_y [1]=175.0;
    circ_radius [1]=50.0;
    circ_x [2]=246.0;
    circ_y [2]=360.0;
    circ_radius [2]=60.0;
    circ_x [3]=304.0;
    circ_y [3]=140.0;
    circ_radius [3]=50.0;
    circ_x [4]=535.0;
    circ_y [4]=233.0;
    circ_radius [4]=90.0;
    circ_x [5]=537.0;
    circ_y [5]=362.0;
    circ_radius [5]=50.0;
    circ_x [6]=219.0;
    circ_y [6]=412.0;
    circ_radius [6]=40.0;
    circ_x [7]=-50.0;
    circ_y [7]=-50.0;
    circ_radius [7]=30.0;
    circ_x [8]=-50.0;
    circ_y [8]=-50.0;
    circ_radius [8]=30.0;
    circ_x [9]=-50.0;
    circ_y [9]=-50.0;
    circ_radius [9]=30.0;
    /// fim mapeamento peca 03

    println("Peça 03");
    if (description == true) {
      ambiente.pause();
      ambiente.rewind();
      ambiente = minim.loadFile("./data/03/d.mp3");
      ambiente.play();
    }
    change_photo=false;
    break;
    case('4'):
    change_photo=true;
    for ( int i = 0; i < circ_num; i++ ) {
      audio_run[i] = false;
      circ_audios [i].pause();
      circ_audios [i].rewind();
      circ_audios [i] = minim.loadFile("./data/04/"+i+".mp3");
    }
    ///// mapeamento peca 04
    circ_x [0]=216.0;
    circ_y [0]=170.0;
    circ_radius [0]=170.0;
    circ_x [1]=296.0;
    circ_y [1]=207.0;
    circ_radius [1]=150.0;
    circ_x [2]=335.0;
    circ_y [2]=157.0;
    circ_radius [2]=40.0;
    circ_x [3]=158.0;
    circ_y [3]=324.0;
    circ_radius [3]=90.0;
    circ_x [4]=353.0;
    circ_y [4]=411.0;
    circ_radius [4]=60.0;
    circ_x [5]=396.0;
    circ_y [5]=430.0;
    circ_radius [5]=100.0;
    circ_x [6]=78.0;
    circ_y [6]=416.0;
    circ_radius [6]=120.0;
    circ_x [7]=546.0;
    circ_y [7]=411.0;
    circ_radius [7]=120.0;
    circ_x [8]=206.0;
    circ_y [8]=457.0;
    circ_radius [8]=60.0;
    circ_x [9]=249.0;
    circ_y [9]=35.0;
    circ_radius [9]=70.0;
    /// fim mapeamento peca 04

    if (description == true) {
      ambiente.pause();
      ambiente.rewind();
      ambiente = minim.loadFile("./data/04/d.mp3");
      ambiente.play();
    }
    println("Peça 04");
    change_photo=false;
    break;
    case('5'):
    change_photo=true;
    for ( int i = 0; i < circ_num; i++ ) {
      circ_x [i] = -50;
      circ_y [i] = -50;

      circ_radius [i] = 30;
      audio_run[i] = false;
      circ_audios [i].pause();
      circ_audios [i].rewind();
      circ_audios [i] = minim.loadFile("./data/05/"+i+".mp3");
    }
    ///// mapeamento peca 05
    circ_x [0]=384.0;
    circ_y [0]=57.0;
    circ_radius [0]=150.0;
    circ_x [1]=324.0;
    circ_y [1]=201.0;
    circ_radius [1]=150.0;
    circ_x [2]=307.0;
    circ_y [2]=374.0;
    circ_radius [2]=200.0;
    circ_x [3]=495.0;
    circ_y [3]=160.0;
    circ_radius [3]=80.0;
    circ_x [4]=443.0;
    circ_y [4]=302.0;
    circ_radius [4]=60.0;
    circ_x [5]=-50.0;
    circ_y [5]=-50.0;
    circ_radius [5]=30.0;
    circ_x [6]=-50.0;
    circ_y [6]=-50.0;
    circ_radius [6]=30.0;
    circ_x [7]=-50.0;
    circ_y [7]=-50.0;
    circ_radius [7]=30.0;
    circ_x [8]=-50.0;
    circ_y [8]=-50.0;
    circ_radius [8]=30.0;
    circ_x [9]=-50.0;
    circ_y [9]=-50.0;
    circ_radius [9]=30.0;
    /// fim mapeamento peca 05
    println("Peça 05");
    if (description == true) {
      ambiente.pause();
      ambiente.rewind();
      ambiente = minim.loadFile("./data/05/d.mp3");
      ambiente.play();
    }
    change_photo=false;
    break;
  }
}
