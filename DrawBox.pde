
/**/ // 箱を描く  /**/
float t = 0, h = 0, hdown = 0, hup = 0, smap = 0, s1 = 0, s2 = 0;
void drawBox() {
  t += 0.05;
  float ts = sin(t);
  hdown = 0.03; hup = 0.13;
  s1 = 1.05; s2 = 0.95; 
  h = map(ts, -1, 1, hdown, hup);
  smap = map(h, hdown, hup, s1, s2); 
  float sx = (smap / (s1 + s2)) * 2;
  float sy = (1 - sx / 2) * 2; 

  stroke(0);
  pushMatrix();  
  translate(0, h, 0);
  scale(sx * 1.5, sy * 1.5, 1.5);
  box(0.8);
  {
    pushMatrix();
    translate(0.2, 0.03, 0.2);
    box(0.155, 0.35, 0.4); 
    popMatrix();
    pushMatrix();
    translate(-0.2, 0.03, 0.2);
    box(0.155, 0.35, 0.4); 
    popMatrix();
  }
  popMatrix();
  
}
