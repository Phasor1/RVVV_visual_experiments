// maybe useful in the next future:
// https://discourse.processing.org/t/get-height-of-text-with-wrapping/16087/5   

// future improvements will use also audio 
// take a look at this reference
// https://discourse.processing.org/t/midi-from-processing-to-daw-linux/5411

import oscP5.*;
import netP5.*;
import processing.opengl.*; 
  
OscP5 oscP5;
int MY_PORT = 45000;

PFont fontA, fontB, fontC;
int FONT_HEIGHT = 48;
int text_Y_pos = FONT_HEIGHT;

Scroller scroller;
PImage logo;
PShape logo2;
int LEFT_MARGIN = 20;
boolean USE_ALPHA_RECTS = false;
ArrayList<Wave> ws;

int numSquares = 10;

Sphere sp;

Squares sq;

// SETUP /////////////////////////////////////////////////////
void setup() {
  size(1920,1080, P3D);
  ws = new ArrayList<Wave>();
  ws.add(new Wave(0, 0, -10));
  ws.add(new Wave(0, 0, 0));
  ws.add(new Wave(0, 0, 20));
  // ws.add(new Wave(0, 0, 30));
  //fullScreen(1);
  frameRate(60);
  
  sp = new Sphere();
  sp.setup();
  
  // start oscP5, an OSC server listening for incoming messages at port 12000
  oscP5 = new OscP5(this, MY_PORT);
  
  // font stuff
  //font = createFont("FreeMonoBold.ttf", 48);
  fontA = createFont("fonts/ttf/JetBrainsMono-ExtraBoldItalic.ttf", 48); // davide
  fontB = createFont("fonts/ttf/JetBrainsMono-Regular.ttf", 48); // nicola
  fontC = createFont("fonts/ttf/JetBrainsMono-Regular.ttf", 48); // daniele
  
  //textFont(font, FONT_HEIGHT);
  textAlign( LEFT, TOP );
  //Sets the spacing between lines of text in units of pixels
  // ref: https://py.processing.org/reference/textLeading.html
  textLeading(FONT_HEIGHT);
  
  scroller = new Scroller( height, FONT_HEIGHT);
  
  logo = loadImage("RVVV_logo_white_alpha.png");
  logo2 = loadShape("logo_black.svg");
  //logo = loadImage("RVVV_logo_white_stroke_alpha.png");
  
  sq = new Squares(numSquares);
}




// DRAW //////////////////////////////////////////////////////
void draw() {
  background(0);
  
  imageMode(CENTER);
  // tint(120, 30);
  //image( logo, width*0.5, height*0.5);
  shapeMode(CENTER);
  shape(logo2, width/2, height/2);
  ws.get(0).draw();
  ws.get(1).draw();
  ws.get(2).draw();
  sp.draw();
  // sq.draw();
  // ws.get(3).draw();
  pushMatrix();
  //translate( 0, (-1)*frameCount );
  pushStyle();
  text_Y_pos = 0;
  for( int i=0; i<scroller.getNumberOfLines(); i++) {
    String s = scroller.getLineAt(i).getText();
    int r = scroller.getLineAt(i).getR();
    int g = scroller.getLineAt(i).getG();
    int b = scroller.getLineAt(i).getB();
    PFont font = scroller.getLineAt(i).getFont();
    textFont(font, FONT_HEIGHT);
    if( USE_ALPHA_RECTS ) {
      noStroke();
      fill( 0, 200);
      rect(LEFT_MARGIN, text_Y_pos, textWidth(s), FONT_HEIGHT );
    }
    //fill( r,g,b);
    //fill(254, 114, 114);
    fill(255, 0, 0);
    text( s, LEFT_MARGIN, text_Y_pos);
    text_Y_pos += FONT_HEIGHT;
  }
  popStyle();
  popMatrix();
}

// incoming osc message are forwarded to the oscEvent method.
void oscEvent(OscMessage theOscMessage) {

  if(theOscMessage.checkAddrPattern("/davide/history")==true) {
    // check if the typetag is the right one. 
    if(theOscMessage.checkTypetag("s")) {
      // parse theOscMessage and extract the values from the osc message arguments.
      String s = theOscMessage.get(0).stringValue();
      // count the number of lines in a string
      String[] list = split(s, '\n');
      
      for(int i=0; i<list.length;i++) {
        //println( list[i], list[i].length() );
        scroller.push( list[i], fontA, 255, 0, 0 );
      }
      scroller.push( "\n", fontA, 255, 0, 0 );
      return;
    }
    ws.get(0).sounds.add(new Sound(3, 500, 10));
  } 
  
  if(theOscMessage.checkAddrPattern("/nicola/history")==true) {
    // check if the typetag is the right one.
    if(theOscMessage.checkTypetag("s")) {
      // parse theOscMessage and extract the values from the osc message arguments.
      String s = theOscMessage.get(0).stringValue();
      // the string is distributed over "countLinebreaks(s)+1" lines
      String[] list = split(s, '\n');
      for(int i=0; i<list.length;i++) {
        scroller.push( list[i], fontB, 0, 255, 0 );
      }
      scroller.push( "\n", fontB, 0, 255, 0 );
      return;
    }  
    ws.get(1).sounds.add(new Sound(3, 500, 10));
  }
  
  
  if(theOscMessage.checkAddrPattern("/daniele/history")==true) {
    // check if the typetag is the right one.
    if(theOscMessage.checkTypetag("s")) {
      // parse theOscMessage and extract the values from the osc message arguments.
      String s = theOscMessage.get(0).stringValue();
      // the string is distributed over "countLinebreaks(s)+1" lines
      String[] list = split(s, '\n');
      for(int i=0; i<list.length;i++) {
        scroller.push( list[i], fontC, 0, 0, 255 );
      }
      scroller.push( "\n", fontC, 0, 0, 255 );
      return;
    }  
    ws.get(2).sounds.add(new Sound(3, 500, 10));
  }
  
}

void mousePressed(){
  // ws.sounds = (Sound[])append(ws.sounds, new Sound(10, 200));
  Wave w = ws.get(int(random(3)));  
  w.sounds.add(new Sound(4, 200, int(random(10, 100))));
  switch(w.currentRot){
    case 'x':
      w.currentRot = 'y';
      break;
    case 'y':
      w.currentRot = 'z';
      break;
    case 'z':
      w.currentRot = 'x';
      break;
  }
  w.fillColor = color(int(random(50, 255)), int(random(40, 255)), int(random(50, 255)));
  //ws.sounds.add(new Sound(3, 500));
}


// returns the number of linebreaks in a string
int countLinebreaks(String s) {
  return s.length() - s.replace("\n", "").length();
}
