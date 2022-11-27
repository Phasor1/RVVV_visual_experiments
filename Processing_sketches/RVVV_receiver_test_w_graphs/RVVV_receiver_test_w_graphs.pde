// maybe useful in the next future:
// https://discourse.processing.org/t/get-height-of-text-with-wrapping/16087/5   

// future improvements will use also audio 
// take a look at this reference
// https://discourse.processing.org/t/midi-from-processing-to-daw-linux/5411

import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
int MY_PORT = 45000;

int FONT_HEIGHT = 48;
int text_Y_pos = FONT_HEIGHT;
int LEFT_MARGIN = 20;

// fonts
PFont fontA; // davide 
PFont fontB; // nicola
PFont fontC; // daniele

// colors
color colorA = color(255,   0,   0); // davide
color colorB = color(  0, 255,  0); // nicola
color colorC = color( 0, 110, 255 ); // daniele - blue navy
//color colorC = color( #71f0f9 ); // daniele

Scroller scroller;
PImage logo;
boolean USE_ALPHA_RECTS = false;


// GRAPHS STUFF
int PRESHARED_MESSAGE_SIZE = 2048;
Graph graphs[];
boolean SHOW_SEPARATED = true;


// SETUP /////////////////////////////////////////////////////
void setup() {
  //size(1920,1080);
  size(1600,900);
  //fullScreen(1);
  frameRate(25);
  
  
  // check this to solve the oversized datagram limit
  // https://github.com/sojamo/oscp5/issues/6
  OscProperties op = new OscProperties();
  op.setListeningPort(MY_PORT);
  op.setDatagramSize(15000);
  // even if I change it to a grater number
  // I continue to get the same
  // ArrayIndexOutOfBoundsException
  // error. Maybe better to reduce the '~chunkSize'
  // on the SuperCollider side
  oscP5 = new OscP5(this, op);
  // start oscP5, an OSC server listening for incoming messages at port 12000
  //oscP5 = new OscP5(this, MY_PORT);
  
  // font stuff
  fontA = createFont("fonts/ttf/JetBrainsMono-Regular.ttf", 48); // davide
  fontB = createFont("fonts/ttf/JetBrainsMono-Regular.ttf", 48); // nicola
  fontC = createFont("fonts/ttf/JetBrainsMono-Regular.ttf", 48); // daniele
  
  //textFont(font, FONT_HEIGHT);
  textAlign( LEFT, TOP );
  //Sets the spacing between lines of text in units of pixels
  // ref: https://py.processing.org/reference/textLeading.html
  textLeading(FONT_HEIGHT);
  
  scroller = new Scroller( height, FONT_HEIGHT);
  
  logo = loadImage("RVVV_logo_white_alpha.png");
  //logo = loadImage("RVVV_logo_white_stroke_alpha.png");

  // graphs stuff
  graphs = new Graph[3];
  for( int i=0; i<3; i++ ) {
    if( SHOW_SEPARATED ) {
      graphs[i] = new Graph( PRESHARED_MESSAGE_SIZE, new PVector(0, i*(height/3.0) ), new PVector(width, height/3));
    } else {
      graphs[i] = new Graph( PRESHARED_MESSAGE_SIZE, new PVector(0, 0 ), new PVector(width, height));
    }
    graphs[i].setWeight( 1 );
    graphs[i].setAlpha( 255 );
  }

  graphs[0].setColor( colorA );
  graphs[1].setColor( colorB );
  graphs[2].setColor( colorC );
}




// DRAW //////////////////////////////////////////////////////
void draw() {
  background(0); 
  
  imageMode(CENTER);
  tint(120, 30);
  image( logo, width*0.5, height*0.5);
  
  pushMatrix();
  //translate( 0, (-1)*frameCount );
  pushStyle();
  
  
  // display graphs
  blendMode( BLEND );
  for( int i=0; i<3; i++ ) {
    graphs[i].display();
    //if( graphs[i].getTimeToDisplay( true ) ) {
    //  
    //}
  }
  blendMode( BLEND );
  
  
 
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
    fill( r,g,b);
    //fill(254, 114, 114);
    //fill(255, 0, 0);
    text( s, LEFT_MARGIN, text_Y_pos);
    text_Y_pos += FONT_HEIGHT;
  }
  popStyle();
  popMatrix(); 
}

// OSC METHODS //////////////////////////////////////////////////////////////////////////////////////////////

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
        scroller.push( list[i], fontA, int(red( colorA )), int(green( colorA )), int(blue( colorA )) );
      }
      scroller.push( "\n", fontA, int(red( colorA )), int(green( colorA )), int(blue( colorA )) );
      return;
    }  
  } 
  
  if(theOscMessage.checkAddrPattern("/nicola/history")==true) {
    // check if the typetag is the right one.
    if(theOscMessage.checkTypetag("s")) {
      // parse theOscMessage and extract the values from the osc message arguments.
      String s = theOscMessage.get(0).stringValue();
      // the string is distributed over "countLinebreaks(s)+1" lines
      String[] list = split(s, '\n');
      for(int i=0; i<list.length;i++) {
        scroller.push( list[i], fontB, int(red( colorB )), int(green( colorB )), int(blue( colorB )) );
      }
      scroller.push( "\n", fontB, int(red( colorB )), int(green( colorB )), int(blue( colorB )) );
      return;
    }  
  }
  
  
  if(theOscMessage.checkAddrPattern("/daniele/history")==true) {
    // check if the typetag is the right one.
    if(theOscMessage.checkTypetag("s")) {
      // parse theOscMessage and extract the values from the osc message arguments.
      String s = theOscMessage.get(0).stringValue();
      // the string is distributed over "countLinebreaks(s)+1" lines
      String[] list = split(s, '\n');
      for(int i=0; i<list.length;i++) {
        scroller.push( list[i], fontC, int(red( colorC )), int(green( colorC )), int(blue( colorC )) );
      }
      scroller.push( "\n", fontC, int(red( colorC )), int(green( colorC )), int(blue( colorC )) );
      return;
    }  
  }
  
  // graphs stuff
  
  if (theOscMessage.checkAddrPattern("/davide/waveform")==true) {
    int MESSAGE_LENGTH = theOscMessage.typetag().length();
    
    if( MESSAGE_LENGTH == PRESHARED_MESSAGE_SIZE ) {
      for(int i=0; i<MESSAGE_LENGTH; i++) {
        //graph.set(i,theOscMessage.get(i).floatValue());
        graphs[0].setValue(i,theOscMessage.get(i).intValue());
      }  
    }
    graphs[0].setTimeToDisplay( true );
    return;
  } 
  
  
  if (theOscMessage.checkAddrPattern("/nicola/waveform")==true) {
    int MESSAGE_LENGTH = theOscMessage.typetag().length();
    
    if( MESSAGE_LENGTH == PRESHARED_MESSAGE_SIZE ) {
      for(int i=0; i<MESSAGE_LENGTH; i++) {
        //graph.set(i,theOscMessage.get(i).floatValue());
        graphs[1].setValue(i,theOscMessage.get(i).intValue());
      }  
    }
    graphs[1].setTimeToDisplay( true );
    return;
  } 
  
  
  if (theOscMessage.checkAddrPattern("/daniele/waveform")==true) {
    int MESSAGE_LENGTH = theOscMessage.typetag().length();
    
    if( MESSAGE_LENGTH == PRESHARED_MESSAGE_SIZE ) {
      for(int i=0; i<MESSAGE_LENGTH; i++) {
        //graph.set(i,theOscMessage.get(i).floatValue());
        graphs[2].setValue(i,theOscMessage.get(i).intValue());
      }  
    }
    graphs[2].setTimeToDisplay( true );
    return;
  } 
  
}


// returns the number of linebreaks in a string
int countLinebreaks(String s) {
  return s.length() - s.replace("\n", "").length();
}



void keyPressed() {
  if( key == 'c' ) {
    scroller.clearList();
  }
}
