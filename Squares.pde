class Squares {
 int num;
 ArrayList<Float> indexes;
 
 Squares(int n) {
   num = n;
   indexes = new ArrayList<Float>();
   for(int i = 0; i < num; i++) {
     print("here");
     indexes.add(0.0);
     print("then");
   }
 }
 void draw(){
   for(int i = 0; i < num; i++) {
      push();
      fill(200, 200, 200, 200);
      noStroke();
      //pushMatrix();
      translate((300 * i)+150, (height/2) + 150);
      float index = indexes.get(i);
      index += 0.1;
      rotateY(index);
      translate(-(300 * i)+150, -(height/2) - 150);
      rectMode(CORNER);
      rect((width/num) * i, height/2, 300, 300);
      indexes.set(i, index);
      //popMatrix();
      pop();
   }
 }
}
