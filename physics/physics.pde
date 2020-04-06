color darkbrown = color(139, 69, 19);
color blue = color(0, 0, 255);
color white = color(255, 255, 255);
color red = color(255, 0, 0);
color green = color(0, 255, 0);
color black = color(0, 0, 0);
color brown = color(205, 133, 63);
boolean rotation_on = true;
boolean axis1 = false;
boolean axis2 = false;
boolean detection = true;
boolean accelerate = true;
boolean while_loop_stop = true; 
boolean[] axis = {false, false};
//white wheel
float wheel1x = 10;
float wheel1y = 600;
float initialw1x = wheel1x;
float initialw1y = wheel1y;

float pAnlge_old;
float gV1;
float gV2;
float acceleration;
int   n = 100;
float r = 10;
float len     = 5*r;
int gcount = 0;
int r1L_1 = 0;

//bluewheel
float start_angle =  0*(-2*PI/360);
float pAngle = 0.5*PI-start_angle;//
//0.5*PI-start_angle; initialize white ball hits first
//0.5*PI+start_angle;  initialize ball hits first
float wheel2x = wheel1x+len*cos(start_angle);
float wheel2y = wheel1y+len*sin(start_angle);
float initialw2x = wheel2x;
float initialw2y = wheel2y;
float angle   = 0;
float g = 0.01*9.81;
float aA;
float aV1;
float aV2;
void setup() {
  size(1000, 1000);
  //axis[1] = true;
  //println(-30%20);
}

boolean[] getAxis(float w1x, float w1y, float w2x, float w2y) {
  boolean[] list = {false, false};
  for (int i = 0; i < n; i++) {
    if (get((int)(w1x+r*cos(i*2*PI/n)), (int)(w1y+r*sin(i*2*PI/n))) == darkbrown) {
      list[0] = true;
    }
  }
  for (int i = 0; i < n; i++) {
    if (get((int)(w2x+r*cos(i*2*PI/n)), (int)(w2y+r*sin(i*2*PI/n))) == darkbrown) {
      list[1] = true;
    }
  }
  return list;
}
boolean[] getTouchGround(float w1x, float w1y, float w2x, float w2y) {
  boolean[] list = {false, false};
  for (int i = 0; i < n; i++) {
    if (get((int)(w1x+(r+1)*cos(i*2*PI/n)), (int)(w1y+(r+1)*sin(i*2*PI/n))) == darkbrown) {
      list[0] = true;
    }
  }
  for (int i = 0; i < n; i++) {
    if (get((int)(w2x+(r+1)*cos(i*2*PI/n)), (int)(w2y+(r+1)*sin(i*2*PI/n))) == darkbrown) {
      list[1] = true;
    }
  }
  return list;
}

void draw() {
  noStroke();
  image(loadImage("burrow1.png"), 0, 0);
  update();
  robot_draw();
}

void update() {
  if (axis[0] && axis[1]) {
    aV1 = 0;
    aV2 = 0;
    gV1 = 0;
    gV2 = 0;
    float speedyboy = 1;
    float ampAngle = pAngle%(2*PI);
    if (ampAngle < 0) {
      ampAngle += 2*PI;
    }
    if (ampAngle-PI > 0) {
      r1L_1 = -1;
    } else {
      r1L_1 = +1;
    }
    if (getAxis(wheel1x+speedyboy*cos(0.5*PI-pAngle), wheel1y+speedyboy*sin(0.5*PI-pAngle), wheel2x+speedyboy*cos(0.5*PI-pAngle), wheel2y+speedyboy*sin(0.5*PI-pAngle))[1]) {
      while (getAxis(wheel1x+speedyboy*cos(0.5*PI-pAngle), wheel1y+speedyboy*sin(0.5*PI-pAngle), wheel2x+speedyboy*cos(0.5*PI-pAngle), wheel2y+speedyboy*sin(0.5*PI-pAngle))[1]) {
        pAngle += r1L_1*0.0001;
        wheel2x = wheel1x+len*cos(0.5*PI-pAngle);
        wheel2y = wheel1y+len*sin(0.5*PI-pAngle);
      }
    } else if (getAxis(wheel1x+speedyboy*cos(0.5*PI-pAngle), wheel1y+speedyboy*sin(0.5*PI-pAngle), wheel2x+speedyboy*cos(0.5*PI-pAngle), wheel2y+speedyboy*sin(0.5*PI-pAngle))[0]) {
      while (getAxis(wheel1x+speedyboy*cos(0.5*PI-pAngle), wheel1y+speedyboy*sin(0.5*PI-pAngle), wheel2x+speedyboy*cos(0.5*PI-pAngle), wheel2y+speedyboy*sin(0.5*PI-pAngle))[0]) {
        pAngle += r1L_1*0.0001;
        wheel1x = wheel2x+len*cos(0.5*PI+pAngle);
        wheel1y = wheel2y+len*sin(0.5*PI+pAngle);
      }
    }
    speedyboy = 1;
    if (0.5*PI-pAngle < 0) {
      speedyboy *= cos(0.5*PI-pAngle);
      speedyboy *= cos(0.5*PI-pAngle);
      speedyboy *= cos(0.5*PI-pAngle);
    }
    wheel1x += speedyboy*cos(0.5*PI-pAngle);
    wheel1y += speedyboy*sin(0.5*PI-pAngle);
    wheel2x += speedyboy*cos(0.5*PI-pAngle);
    wheel2y += speedyboy*sin(0.5*PI-pAngle);

    if (!getTouchGround(wheel1x, wheel1y, wheel2x, wheel2y)[0]) {
      axis[0] = false;
    }
    if (!getTouchGround(wheel1x, wheel1y, wheel2x, wheel2y)[1]) {
      axis[1] = false;
    }
  } else if (axis[0] && !axis[1]) {
    //wheel 1 is rotational centre
    if (rotation_on) {
      float mpAngle = pAngle%(2*PI);
      if (mpAngle < 0) {
        mpAngle += 2*PI;
      }
      if (mpAngle-PI > 0) {
        r1L_1 = -1;
      } else {
        r1L_1 = +1;
      }
      if (gV1 != 0) {
        aV2 = r1L_1*-gV2*sin(pAngle)*sin(pAngle)/len;
      }
      gV1 = 0;

      aA = (1*-g/50) * sin(pAngle);
      aV2 += aA;
      pAngle += aV2;

      if (getAxis(wheel1x, wheel1y, wheel1x+len*cos(0.5*PI-pAngle), wheel1y+len*sin(0.5*PI-pAngle))[1]) {
        axis[1] = true;
        while (getAxis(wheel1x, wheel1y, wheel1x+len*cos(0.5*PI-pAngle), wheel1y+len*sin(0.5*PI-pAngle))[1]) {
          float d = 1*2*PI/360;
          if (r1L_1 > 0) {
            pAngle += d;
          } else {
            pAngle -= d;
          }
        }
        wheel2x = wheel1x+len*cos(0.5*PI-pAngle);
        wheel2y = wheel1y+len*sin(0.5*PI-pAngle);
      } else {
        wheel2x = wheel1x+len*cos(0.5*PI-pAngle);
        wheel2y = wheel1y+len*sin(0.5*PI-pAngle);
      }
    }
  } else if (!axis[0] && axis[1]) {
    //************************************************************************************************
    //white wheel 2 is rotational centre
    float pAngleb = PI-pAngle;
    float mpAngle = pAngleb%(2*PI);
    if (mpAngle < 0) {
      mpAngle += 2*PI;
    }
    if (mpAngle-PI > 0) {
      r1L_1 = 1;
    } else {
      r1L_1 = -1;
    }
    if (gV2 != 0) {
      aV1 = -1*r1L_1*gV1*sin(pAngleb)*sin(pAngleb)/len;
    }
    gV2 = 0;
    aA = (1*g/50) * sin(pAngleb);
    aV1 += aA; 
    pAngle += aV1;
    if (getAxis(wheel2x+len*cos(0.5*PI+pAngleb), wheel2y+len*sin(0.5*PI+pAngleb), wheel2x, wheel2y)[0]) {
      axis[0] = true;
      while (getAxis(wheel2x+len*cos(0.5*PI+pAngleb), wheel2y+len*sin(0.5*PI+pAngleb), wheel2x, wheel2y)[0]) {
        float d = 1*2*PI/360;
        if (r1L_1 > 0) {
          pAngleb -= d;
        } else {
          pAngleb += d;
        }
      }
      wheel1x = wheel2x+len*cos(0.5*PI+pAngleb);
      wheel1y = wheel2y+len*sin(0.5*PI+pAngleb);
    } else {
      wheel1x = wheel2x+len*cos(0.5*PI+pAngleb);
      wheel1y = wheel2y+len*sin(0.5*PI+pAngleb);
    }
    //println("BLUE: "+pAngle);
  } else {
    //************************************************************************************************
    //uravity
    gV1 += g;
    gV2 += g;
    if (!getAxis(wheel1x, wheel1y+gV1, wheel2x, wheel2y+gV1)[0]) {
      wheel1y += gV1;
    } else {
      boolean while_loop_continue = true;
      gcount = 0;
      while (while_loop_continue) {
        if (getAxis(wheel1x, wheel1y+gcount, wheel2x, wheel2y+gcount)[0]) {
          while_loop_continue = false;
        }
        if (while_loop_continue) {
          gcount++;
        }
      }
      axis[0]=true;
      gcount-= 1;

      wheel1y += gcount;
      wheel2y += gcount;
      wheel2y -= gV2;
    }

    //wheel2
    if (!getAxis(wheel1x, wheel1y+gV2, wheel2x, wheel2y+gV2)[1]) {
      wheel2y += gV2;
    } else {
      boolean while_loop_continue = true;
      gcount = 0;
      while (while_loop_continue) {
        if (getAxis(wheel1x, wheel1y+gcount, wheel2x, wheel2y+gcount)[1]) {
          while_loop_continue = false;
        }
        if (while_loop_continue) {
          gcount++;
        }
      }
      gcount--;
      axis[1]=true;

      wheel1y += gcount;
      wheel2y += gcount;
      wheel1y -= gV1;
    }
  }
}

void robot_draw() {
  fill(255);
  stroke(255);
  strokeWeight(r);
  line(wheel1x, wheel1y, wheel2x, wheel2y);
  strokeWeight(1);
  noStroke();
  noStroke();
  fill(white);
  circle(wheel1x, wheel1y, r*2);
  fill(white);
  circle(wheel2x, wheel2y, r*2);
  textSize(14);
  fill(black);
  //text("0", wheel1x-4, wheel1y+5);
  fill(black);
  //text("1", wheel2x-4, wheel2y+5);
  stroke(0);
  //line(wheel1x, wheel1y+7, wheel1x, wheel1y-7);
  noStroke();
}
