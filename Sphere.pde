class Sphere {

  // Spherical Geometry
  // The Coding Train / Daniel Shiffman
  // https://thecodingtrain.com/CodingChallenges/025-spheregeometry.html
  // https://youtu.be/RkuBWEkBrZA
  // https://editor.p5js.org/codingtrain/sketches/qVs1hxtc
  
  ArrayList<ArrayList<PVector>> globe;
  int r = 200;
  int total = 50;
  float angleX = 0;
  float angleY = 0;
  ArrayList<Float>wave;
  
  void setup() {
    wave = new ArrayList<Float>(100);
    globe = new ArrayList<ArrayList<PVector>>();
    ArrayList<PVector> c;
    PVector mario = new PVector(0,0,0);
    for (int i = 0; i < total + 1; i++) {
      c = new ArrayList();
      float lat = map(i, 0, total, 0, PI);
      for (int j = 0; j < total + 1; j++) {
        
        float lon = map(j, 0, total, 0, TWO_PI);
        float x = r * sin(lat) * cos(lon);
        float y = r * sin(lat) * sin(lon);
        float z = r * cos(lat);
        mario = new PVector(x, y, z);
        c.add(mario);
        // globe.set(i, .set(new PVector(x, y, z)));
      }
      globe.add(c);
    }
  }
  
  void draw() {
    push();
    translate(width/2 - r/2, height/2 - r/2);
    rotateX(angleX);
    rotateY(angleY);
    translate(-(width/2 - r/2), -(height/2 - r/2));
    noFill();
    strokeWeight(2);
    stroke(200);
    beginShape(POINTS);
    for (int i = 0; i < total; i++) {
      for (int j = 0; j < total + 1; j++) {
        ArrayList<PVector> c = globe.get(i);
        PVector v1 = c.get(j);
        // vertex(v1.x, v1.y, v1.z);
        c = globe.get(i + 1);
        PVector v2 = c.get(j);
        vertex(width/2 + v1.x, height/2 + v1.y, v1.z);
      }
    }
    endShape();
    //for(int z = 0; z < wave.size(); z++) {
      //ArrayList<PVector> c = globe.get(0);
      //PVector v1 = c.get(z);
      //line(v1.x, v1.y, v1.z, v1.x, v1.y, v1.z + 100);
    //}
    pop();
    angleX += 0.005;
    angleY += 0.006;
  }
}
  
