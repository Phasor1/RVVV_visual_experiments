class LineAndColor {
  String line;
  int r, g, b;
  PFont font;
  
  // CONSTRUCTOR //////////////////////////////////////////////////////////////////////////
  LineAndColor( String _line, PFont _font, int _r, int _g, int _b ) {
    line = _line;
    font = _font;
    r = _r;
    g = _g;
    b = _b;
  }
  
  int getR() { return r; }
  
  int getG() { return g; }
  
  int getB() { return b; }
  
  String getText() {
    return line;
  }
  
  PFont getFont() {
    return font;
  }
}
