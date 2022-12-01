class Graph {
  
  int SIZE; // number of stored values
  float values[];
  
  PVector pos; // position of the graph on the canvas
  PVector dims; // dimensions of the graphs
  float spaceBetween;
  color c;
  float sw; // stroke width
  float alpha;
  
  boolean DRAW_AS_POINTS = false;
  boolean DRAW_AS_LINE = true;
  boolean DRAW_AS_LINES = false;
  
  boolean TIME_TO_DISPLAY = false;
  
  
  // CONSTRUCTOR ///////////////////////////////////////////////////////
  Graph(int _size, PVector _pos, PVector _dims) {
    SIZE = _size;
    values = new float[SIZE];
    clear();
    pos  =  _pos.copy();
    dims = _dims.copy();
    spaceBetween = dims.x / (SIZE-1);
    c = color(255, 255, 255);
    sw = 1;
    alpha = 255;
  }
  
  void setValue(int index, int value) {
    values[index] = (value / 127.0);
  }
  
  void display() {
    pushMatrix();
    pushStyle();
    translate( pos.x, pos.y);
    translate(0, dims.y*0.5);
    //fill(255);
    stroke( c, alpha );
    strokeWeight( sw );
    
    if( DRAW_AS_POINTS ) {
      // draw as Point
      for(int i=0; i<SIZE; i++) {
        point(i*spaceBetween, values[i]* (dims.y*0.5) );
      }  
    }
    
    if( DRAW_AS_LINE ) {
      // draw as Line
      for(int i=0; i<SIZE-1; i++) {
        float x1 = i*spaceBetween;
        float y1 = values[i]* (dims.y*0.5);
        float x2 = (i+1)*spaceBetween;
        float y2 = values[i+1]* (dims.y*0.5);
        line(x1, y1, x2, y2); //(i*spaceBetween, values[i]* (dims.y*0.5) );
      }
    }
    
    if( DRAW_AS_LINES ) {
      // draw as Line
      for(int i=0; i<SIZE; i++) {
        float x1 = i*spaceBetween;
        float y1 = values[i]* (dims.y*0.5);
        float x2 = (i+1)*spaceBetween;
        float y2 = 0;
        line(x1, y1, x2, y2); //(i*spaceBetween, values[i]* (dims.y*0.5) );
      }
    }
    
    
    
    popStyle();
    popMatrix();
  }
  
  boolean getTimeToDisplay() {
    return TIME_TO_DISPLAY;
  }
  
  void setTimeToDisplay( boolean _TIME_TO_DIPLAY ) {
    TIME_TO_DISPLAY = _TIME_TO_DIPLAY;
  }
  
  void setColor( color _c ) {
    c = _c;
  }
  
  void setWeight( int _w ) {
    sw = _w;
  }
  
  void setAlpha( float _alpha ) {
    alpha = _alpha;
  }
  
  void clear() {
    for(int i=0; i<SIZE; i++) {
      values[i] = 0.0; 
    }
  }
}
