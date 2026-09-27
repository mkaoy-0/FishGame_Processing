PImage img;
PImage img_yuka;
PShape box;

float[] cameraPos = {0, 5.5, 9};
float[] cameraDir = {0, 0, -1};
float fov = 45;
PVector camPos = new PVector(0, 5.5, 9);
PVector camDir = new PVector(0, 0, -1);
float camdirx = 400, camdiry = 300;
float[] camCenter = {0, 0, 0};  // 中心点
PVector objPos = new PVector(-1, 0, -1);
ArrayList<DrawFish> fishes = new ArrayList<DrawFish>();
ArrayList<DrawPoint> points = new ArrayList<DrawPoint>();
int traceMode = 1;
float timer = 0;
float baseTime = 0;
float rdTime = 2;
DrawFish targetFish = null;
float spsx = 0.3, spsz = 0.3, spsv = 0.003;

PVector myBox = new PVector(1, 0, -1);
float boxAngle = 0;

int myCount = 0, eneCount = 0;

void setup() {
  size(800, 600, P3D);
  img = loadImage("fish_texture.png");
  img_yuka = loadImage("yuka.jpg");
}

void draw() {
  background(255, 255, 255);
  KeyCamMove();
  // ----- ----- ----- ----- -----
  // カメラの設定
  perspective(
    radians(fov), // 視野角
    float(width)/float(height), // アスペクト比
    0.1, 1000.0                   // クリッピング距離
    );

  /**/  // 視点を動かす
  cameraDir[0] = sin(radians( (camdirx - width / 2.0) / (width / 2.0) * 90 ));
  cameraDir[1] = sin(radians( (camdiry - height / 2.0) / (height /  2.0) * 90 ));
  cameraDir[2] = -(1 - sqrt(cameraDir[0]*cameraDir[0] + cameraDir[1]*cameraDir[1]));
  /**/
  camCenter[0] = cameraPos[0] + cameraDir[0];
  camCenter[1] = cameraPos[1] + cameraDir[1] - 5.5;
  camCenter[2] = cameraPos[2] + cameraDir[2] - 9;
  camera(
    cameraPos[0], cameraPos[1], cameraPos[2], // 視点：カメラの位置
    camCenter[0], camCenter[1], camCenter[2], // 中心点：ここが視界の中心に映るようにする
    0, -1, 0   // 上向き：この向きが視界の上向きになるようにする
    );
  // ----- ----- ----- ----- -----
  // 光源の設定
  directionalLight(
    255, 255, 255, // 照明光の色
    1, -1, -2        // 照明の向き
    );
   noLights();
  // ----- ----- ----- ----- -----

  float time = millis() - baseTime;

  // 三次元オブジェクトの描画   
  {
    // 床
    fill(255);
    stroke(0);
    noStroke();
    pushMatrix();
    translate(0, -0.8, -5);
    box = createShape(BOX, 20);
    box.setTexture(img_yuka);
    scale(1, 1/80.0, 1);
    shape(box);
    //box(20, 0.5, 20);
    popMatrix();
  }

  {
    if ( time/1000.0 > rdTime ) {
      baseTime = millis();
      rdTime = random(0.2, 2.5);
      DrawFish newfobj = new DrawFish(random(-8, 8), 5, random(-13, 3));
      fishes.add(newfobj);
      newfobj.reset();
      DrawPoint newpoint = new DrawPoint(newfobj.posx, 0, newfobj.posz);
      points.add(newpoint);
      newpoint.reset();
    }
    for (int i = 0; i < fishes.size(); i++ ) {
      pushMatrix();
      DrawFish fobj = fishes.get(i);
      fobj.move();
      popMatrix();
    }
    if ( fishes.size() > 10 ) {
      fishes.remove(fishes.get(0));
    }
    for (int i = 0; i < points.size(); i++ ) {
      pushMatrix();
      DrawPoint pobj = points.get(i);
      pobj.update();
      if ( pobj.sx < 0 ) {
        points.remove(pobj);
      }
      popMatrix();
    }
  }
  
  {
    // 箱
    timer++;
    pushMatrix();
    if ( timer % 100 == 0 ) {
      timer = 0;
      if ( traceMode == 0 ) {
        float minDistance = 999;
        for ( int i = 0; i < fishes.size(); i++ ) {
          DrawFish fobj = fishes.get(i);
          PVector fishpos = new PVector(fobj.posx, fobj.posy, fobj.posz);
          if ( fishes.size() > 0 ) {
            float fishDistance = ( fishpos.copy().sub(objPos) ).mag();
            if ( fishDistance < minDistance ) {
              targetFish = fobj;
              minDistance = fishDistance;
            }
          }
        }
      } else {
        if ( fishes.size() > 0 ) {
          int index = (int)random(0, fishes.size());
          targetFish = fishes.get(index);
        }
      }
    }
    float angle = 0;
    if ( targetFish != null ) {
      PVector targetPos = new PVector( targetFish.posx, targetFish.posy, targetFish.posz );
      PVector targetDir = ( targetPos.copy().sub(objPos) ).normalize();
      angle = atan2(targetDir.x, targetDir.z);
      for ( int i = 0; i < fishes.size(); i++ ) {
        float fishDistance = ( targetPos.copy().sub(objPos) ).mag();
        if ( fishDistance > 0.5 ) {
          objPos.add( targetDir.mult(0.08) );
        }
        if ( abs(targetFish.posx-objPos.x) < 0.8 && abs(targetFish.posz-objPos.z) < 0.8 ) {
          fishes.remove(targetFish);
          traceMode = (int)random(0, 2);
        }
      }
    }
    for (int i = 0; i < fishes.size(); i++ ) {
      DrawFish fobj = fishes.get(i);
      float disx = abs(objPos.x - fobj.posx);
      float disz = abs(objPos.z - fobj.posz);
      if ( disx < 1 && disz < 1 ) {
        fishes.remove(fobj);
        eneCount++;
      }
    }
    translate( objPos.x, 0, objPos.z );
    rotateY( angle );
    fill(100, 100, 200);
    drawBox();
    popMatrix();
  }
  
  {
    // 自機
    pushMatrix();
    if(keyPressed) {
      if ( key == 's' && myBox.z < 5) {
        myBox.z += 0.1;
        boxAngle = 0;
      }
      if ( key == 'w' && myBox.z > -15) {
        myBox.z -= 0.1;
        boxAngle = 180;
      }
      if ( key == 'd' && myBox.x > -10) {
        myBox.x -= 0.1;
        boxAngle = -90;
      }
      if ( key == 'a' && myBox.x < 10) {
        myBox.x += 0.1;
        boxAngle = 90;
      }
    }
    translate( myBox.x, myBox.y, myBox.z );
    rotateY(radians(boxAngle));
    fill(230);
    drawBox();
    
    for (int i = 0; i < fishes.size(); i++ ) {
      DrawFish fobj = fishes.get(i);
      float disx = abs(myBox.x - fobj.posx);
      float disz = abs(myBox.z - fobj.posz);
      if ( disx < 0.8 && disz < 0.8 ) {
        fishes.remove(fobj);
        myCount++;
      }
    }
    
    popMatrix();
  }

  // ======= ============= =============
  // 二次元オブジェクトの描画
  // 平行投影モードに切り替え
  camera(
    0, 0, 1, 
    0, 0, 0, 
    0, 1, 0 
    );
  ortho(0, width, -height, 0);
  noLights();
  // 塗りつぶし・線の色の指定・形状の描画
  fill(0); 
  stroke(0);
  ellipse(80, 350, 40, 40); 
  ellipse(80, 420, 40, 40);
  ellipse(35, 385, 40, 40); 
  ellipse(125, 385, 40, 40);
  rect(80, 460, 50, 50); 
  rect(80, 520, 50, 50); 
  rect(20, 520, 50, 50); 
  rect(140, 520, 50, 50);
  pushMatrix();
  translate( 20+40/2.0, 425+40/2.0 );
  rotate( radians(45) );
  rect(0, 0, 45, 45);
  popMatrix();
  pushMatrix();
  translate( 150+40/2.0, 425+40/2.0 );
  rotate( radians(45) );
  rect(0, 0, 45, 45);
  popMatrix();

  fill(255); 
  textAlign(CENTER, CENTER); 
  textSize(16);
  text("↑", 80, 350); 
  text("↓", 80, 420); 
  text("←", 35, 385); 
  text("→", 125, 385);
  text("Q\n+", 20+40/2.0, 455+40/2.0);
  text("E\n-", 150+40/2.0, 455+40/2.0);
  fill(200, 0, 0);
  stroke(0);
  
  textSize(30);
  fill(0);
  text(myCount + "pt", 60, 50);
  fill(0, 0, 150);
  text(eneCount + "pt", width-80, 50);
  // ======= ============= =============
}
