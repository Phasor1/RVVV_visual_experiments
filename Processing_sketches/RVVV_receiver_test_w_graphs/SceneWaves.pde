class SceneWaves {
  PFont fontA, fontB, fontC;
  int FONT_HEIGHT = 48;
  int text_Y_pos = FONT_HEIGHT;
  
  Scroller scroller;
  PImage logo;
  PShape logo2;
  int LEFT_MARGIN = 20;
  boolean USE_ALPHA_RECTS = false;
  ArrayList<Wave> ws;
  
  SceneWaves(){
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
    
    ws = new ArrayList<Wave>();
    
    ws.add(new Wave(0, 0, -10));
    ws.add(new Wave(0, 0, 0));
    ws.add(new Wave(0, 0, 20));
  }
  
  void addSound(int index) {
    ws.get(index).sounds.add(new Sound(3, 500, 10));
  }
  
  void changeAmp(float amp, int index) {
    ws.get(index).generalAmplitude = amp;
  }
  
  void changeRotationAxis(int index) {
      switch(ws.get(index).currentRot){
        case 'x':
          ws.get(index).currentRot = 'y';
          break;
        case 'y':
          ws.get(index).currentRot = 'z';
          break;
        case 'z':
          ws.get(index).currentRot = 'x';
          break;
      }
      ws.get(index).fillColor = color(int(random(50, 255)), int(random(40, 255)), int(random(50, 255)));
  }
  
  void draw() {
    //background(0);
    shapeMode(CENTER);
    shape(logo2, width/2, height/2);
    ws.get(0).draw();
    ws.get(1).draw();
    ws.get(2).draw();
  }
}
