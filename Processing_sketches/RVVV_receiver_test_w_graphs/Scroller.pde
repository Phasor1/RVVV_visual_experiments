class Scroller {
  int N_LINES;
  int fH;
  int vSize;
  ArrayList<LineAndColor> LineList = new ArrayList();
  
  // CONSTRUCTOR //////////////////////////////////////////////////////////////////////////
  Scroller( int _vSize, int _fH ) {
    vSize = _vSize;
    fH = _fH;
    N_LINES = (vSize / fH) - 1;
    println("Scroller has a number of lines = " + N_LINES );
  }
  
  // PUSH /////////////////////////////////////////////////////////////////////////////////
  void push( String newline, PFont font, int r, int g, int b ) {
    LineList.add( new LineAndColor(newline, font, r,g,b) );
    
    // check if have to shrink the array removing the first element
    if( getNumberOfLines() >  N_LINES ) {
      pop( 0 );
    }
  }
  
  void pop( int index ) {
    LineList.remove( index );
  }
  
  int getNumberOfLines() {
    return LineList.size();
  }
  
  void printLines() {
    for (int i = 0; i <LineList.size(); i++) {
      println( LineList.get(i).getText() );
    }
  }
  
  /*
  String getTextInLine( int index ) {
    return LineList.get( index ).getText();
  }
  */
  
  void clearList() {
    for (int i = 0; i <LineList.size(); i++) {
      pop( 0 );
    }
  }
  
  
  LineAndColor getLineAt( int index ) {
    return LineList.get( index );
  }
  
  
  /*
  void setColorByLine( int index ) {
    int r = LineList.get( index ).getR();
    int g = LineList.get( index ).getG();
    int b = LineList.get( index ).getB();
    stroke( r, g, b );
    fill( r, g, b );
  }
  */
}
