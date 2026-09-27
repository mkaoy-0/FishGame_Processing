class DrawFish {
  float posx, posy, posz;
  float fishy = 8;
  float fishsp = 0;
  float fishgrav = 0.002;
  float fishdam = 0.4;

  float anglex = 0, angley = 0, anglez = 0;
  
  float sc = random(0.04, 0.065);
  
  DrawFish (float x, float y, float z) {
    posx = x; 
    posy = y; 
    posz = z;
    
    anglex = random(-PI, PI);
    angley = random(-PI, PI);
    anglez = random(-PI/2, PI/2);
  }
  void move() {
    fishsp += fishgrav;
    fishy = constrain( fishy-fishsp, -0.3, 5 );
    if ( fishy == -0.3 ) {
      fishsp *= -fishdam;
    }
    translate( posx, fishy, posz );
    rotateX(anglex);
    rotateY(angley);
    rotateZ(anglez);
    scale(sc);
    drawfish();
  }
  void reset() {
    fishy = 8;
    fishsp = 0;
  }
  void display() {
    drawfish();
  }
}

class DrawPoint {
  float posx, posy, posz;
  float sx = 1.3, sz = 1.3;
  DrawPoint (float x, float y, float z) {
    posx = x; 
    posy = y; 
    posz = z;
  }
  void move() {
    sx -= 0.015;
    sz -= 0.015;
  }
  void display() {
    fill(100);
    noStroke();
    translate( posx, -0.5, posz );
    scale( sx, map(sx, 1.3, 0, 0.05, 0), sz );
    sphere(1);
  }
  void update() {
    move();
    display();
  }
  void reset() {
    sx = 1;
    sz = 1;
  }
}
    

void drawfish() {
  float[][] vert = {
    {0.0598, 6.7651, 0.0339, 200, 0}, 
    {14.6811, 0.0419, 0.0339, 400, 300}, 
    {-11.2525, 0.0419, 0.0339, 0, 300}, 
    {0.0598, -4.6959, 0.0339, 200, 600}, 
    {22.6590, 3.6296, 0.0075, 600, 0}, 
    {21.9463, 0.0588, -2.1003, 600, 300}, 
    {22.6590, -3.5355, 0.0075, 600, 0}, 
    {0.0866, 0.0198, -3.8651, 200, 300}, 
    {0.0598, 0.0198, 3.8199, 200, 300}, 
    {21.9463, 0.0588, 1.9949, 600, 300}
  };

  int[][] tri = {
    {3, 1, 9}, 
    {10, 6, 5}, 
    {3, 4, 8}, 
    {1, 3, 8}, 
    {4, 2, 8}, 
    {2, 1, 8}, 
    {1, 2, 9}, 
    {3, 9, 4}, 
    {4, 9, 2}, 
    {7, 6, 10}, 
    {7, 2, 6}, 
    {2, 5, 6}, 
    {2, 10, 5}, 
    {7, 10, 2}
  };

  {
    pushMatrix();
    stroke(0);

    // 位置
    translate(0, 0, 0);
  //  scale(0.045);
    // 形状の描画   
    for (int i=0; i<14; i++) {
      beginShape();
      texture(img);
      for (int j=0; j<3; j++) {
        float[] v = vert[tri[i][j] - 1];
        float x = v[0];
        float y = v[1];
        float z = v[2];
        float U = v[3];
        float V = v[4];
        vertex(x, y, z, U, V);
      }
      endShape(CLOSE);
    }
    popMatrix();
  }
}
