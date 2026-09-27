
/**/  // カメラ移動  /**/
float[] crossProduct(float[] a, float[] b) {
  float[] c = new float[3];
  c[0] = a[1]*b[2] - a[2]*b[1];
  c[1] = a[2]*b[0] - a[0]*b[2];
  c[2] = a[0]*b[1] - a[1]*b[0];
  return c;
}

float[] normalized(float[] a) {
  float norm = sqrt(a[0]*a[0] + a[1]*a[1] + a[2]*a[2]);
  float[] c = new float[3];
  c[0] = a[0] / norm;
  c[1] = a[1] / norm;
  c[2] = a[2] / norm;
  return c;
}


void KeyCamMove() {
  if (keyPressed) {
    if ((key == 'Q' || key == 'q') && fov > 0) {
      fov -= 1;
    }
    if ((key == 'E' || key == 'e') && fov < 180) {
      fov += 1;
    }
    
    if (keyCode == RIGHT && camdirx > 0) {
      camdirx -= 10;
    }
    if (keyCode == LEFT && camdirx < width) {
      camdirx += 10;
    }
    if (keyCode == UP && camdiry < height) {
      camdiry += 10;
    }
    if (keyCode == DOWN && camdiry > 0) {
      camdiry -= 10;
    }
  }
  if( mousePressed) {
    if ( colRect(80, 460, 50) ) {
      for (int i=0; i<3; i++) { cameraPos[i] += cameraDir[i] * 0.1; }
    }
    if ( colRect(80, 520, 50) ) {
      for (int i=0; i<3; i++) { cameraPos[i] -= cameraDir[i] * 0.1; }
    }
    if ( colRect(20, 520, 50) ) {
      float[] up = {0, 1, 0};
      float[] left = normalized(crossProduct(cameraDir, up));
      for (int i=0; i<3; i++) { cameraPos[i] += left[i] * 0.1; }
    }
    if ( colRect(140, 520, 50) ) {
      float[] up = {0, 1, 0};
      float[] left = normalized(crossProduct(cameraDir, up));
      for (int i=0; i<3; i++) { cameraPos[i] -= left[i] * 0.1; }
    }
    
    if ( colEl(80, 350, 40) && camdiry < height){
      camdiry += 10;
    }
    if ( colEl(80, 420, 40) && camdiry > 0){
      camdiry -= 10;
    }
    if ( colEl(35, 385, 40) && camdirx < width){
      camdirx += 10;
    }
    if ( colEl(125, 385, 40) && camdirx > 0){
      camdirx -= 10;
    }
    
    if ( colEl(20+40/2.0, 455+40/2.0, 40) && fov > 0 ) {
      fov -= 1;
    }
    if ( colEl(150+40/2.0, 455+40/2.0, 40) && fov < 180 ) {
      fov += 1;
    }
  }
  if ( !keyPressed && !mousePressed ) {
    if (camdirx < width/2) camdirx += 15;
    if (camdirx >= width/2) camdirx -= 15;
    if (camdiry < height/2) camdiry += 15;
    if (camdiry >= height/2) camdiry -= 15;
  }
}

boolean colRect(float x, float y, float w) {
  if( x < mouseX && mouseX < x+w && y < mouseY && mouseY < y+w ) {
    return true;
  }
  return false;
}
boolean colEl(float x, float y, float r) {
  if( dist(mouseX, mouseY, x, y) < r/2.0 ) {
    return true;
  }
  return false;
}
