int xrob = 230;
int yrob = 230;
int xit = 3;
int yit = 3;
int count = 0;
int lastleftx=0;
int lastlefty=0;
int lastrightx=0;
int lastrighty=0;
int roofVal = 0;
int rightVal=0;
int leftVal=0;
int floorVal=0;
int RUPVal=0;
int LUPVal=0;
int LDWNVal=0;
int RDWNVal=0;
int xprairie = 150;
int yprairie = 650;
int robsize = 10;                                //initializing all starting values

boolean leftmode;
boolean rightmode;
boolean prairieright = false;
boolean prairieleft = false;
boolean prairierightmode=true;
boolean prairieleftmode=false;
boolean normal = true;
boolean mapping =false;
boolean automatic =true;


color orange = color(255, 165, 0);
color white  = color(255, 255, 255);
color brown = color(205, 133, 63);                //defining colors
color darkbrown = color(139, 69, 19);
color zwart = color(0, 0, 0);
color green = color(0, 255, 0);


PImage prairiehol;   //background image


ArrayList<Integer> xlines = new ArrayList<Integer>();   //arraylists for remembering coordinates of walls found
ArrayList<Integer> ylines = new ArrayList<Integer>();
ArrayList<Integer> xroof = new ArrayList<Integer>();
ArrayList<Integer> yroof = new ArrayList<Integer>();
ArrayList<Integer> xfloor = new ArrayList<Integer>();
ArrayList<Integer> yfloor= new ArrayList<Integer>();
ArrayList<Integer> xleft= new ArrayList<Integer>();
ArrayList<Integer> yleft = new ArrayList<Integer>();
ArrayList<Integer> xright = new ArrayList<Integer>();
ArrayList<Integer> yright = new ArrayList<Integer>();
ArrayList<Integer> xrdwn = new ArrayList<Integer>();
ArrayList<Integer> yrdwn = new ArrayList<Integer>();
ArrayList<Integer> xrup = new ArrayList<Integer>();
ArrayList<Integer> yrup = new ArrayList<Integer>();
ArrayList<Integer> xldwn = new ArrayList<Integer>();
ArrayList<Integer> yldwn = new ArrayList<Integer>();
ArrayList<Integer> xlup = new ArrayList<Integer>();
ArrayList<Integer> ylup = new ArrayList<Integer>();

void setup() {
  size(980, 980);
  prairiehol = loadImage("burrow.png");        //paint burrow as background, may change for experimentation
  rightmode=true;
}
void draw() {
  if (normal==true) {         //normal is boolean to switch between mapping mode and normal mode
    background(prairiehol);
    noStroke();
    fill(orange);
    ellipse(xrob, yrob, robsize,robsize);     //moving circle symbolizing the robot
    fill(green);
    ellipse(xprairie, yprairie, 20, 20);
    if (prairieleftmode==true) {
      prairieleftmode();
    }
    if (prairierightmode==true) {
      prairierightmode();
    }
    if (dist(xrob, yrob, xprairie, yprairie)<=5) {
      prairierightmode=false;
      prairieleftmode=false;
      print("Prarie dog ded oh no ");
    }

    if (automatic==true) {
      if (rightmode == true) {         //alternate between main movement to right and to left
        rightmode();
      }
      if (leftmode == true) {
        leftmode();
      }
    }

    if (automatic==false) {
      if (keyPressed==true & key=='w' & get(xrob, yrob-6)!=darkbrown) {
        yrob-=1;
      }
      if (keyPressed==true & key=='s' & get(xrob, yrob+6)!=darkbrown) {
        yrob+=1;
      }
      if (keyPressed==true & key=='a' & get(xrob-6, yrob)!=darkbrown) {
        xrob-=1;
      }
      if (keyPressed==true & key=='d' & get(xrob+6, yrob)!=darkbrown) {
        xrob+=1;
      }
    }
    xlines.add(xrob);                       //adds values for robot and closest walls coordinates to corresponding lists
    ylines.add(yrob);

    xroof.add(xrob);
    yroof.add(yrob-getClosestRoof(xrob, yrob));

    xfloor.add(xrob);
    yfloor.add(yrob+getClosestFloor(xrob, yrob));

    xright.add(xrob+getClosestRight(xrob, yrob));
    yright.add(yrob);

    xleft.add(xrob-getClosestLeft(xrob, yrob));
    yleft.add(yrob);

    xrdwn.add(xrob+getClosestRDWN(xrob, yrob));
    yrdwn.add(yrob+getClosestRDWN(xrob, yrob));

    xrup.add(xrob+getClosestRUP(xrob, yrob));
    yrup.add(yrob-getClosestRUP(xrob, yrob));

    xlup.add(xrob-getClosestLUP(xrob, yrob));
    ylup.add(yrob-getClosestLUP(xrob, yrob));

    xldwn.add(xrob-getClosestLDWN(xrob, yrob));
    yldwn.add(yrob+getClosestLDWN(xrob, yrob));


    if (mousePressed==true) {               // use mousepress to alternate between normal and mapping mode
      normal =false;
      mapping=true;
    }
  }
  if (mapping == true) {                   // mapping mode part
    background(white);
    for (int i = 0; i<= xlines.size()-1; i++) {
      fill(orange);
      rect(xlines.get(i), ylines.get(i), 1, 1);     //robot path has been saved in these arrays, print it in orange
      fill(darkbrown);
      rect(xroof.get(i), yroof.get(i), 1, 1);
      rect(xfloor.get(i), yfloor.get(i), 1, 1);      // print saved walls in darkbrown
      rect(xldwn.get(i), yldwn.get(i), 1, 1);
      rect(xrdwn.get(i), yrdwn.get(i), 1, 1);
      rect(xlup.get(i), ylup.get(i), 1, 1);
      rect(xrup.get(i), yrup.get(i), 1, 1);
      if (prairieright==true) {
        xrob=-230;
        yrob =-230;
        print("prairie right"); //prairie dog escape manoeuvre
        prairieright=false;
      }
      rect(xright.get(i), yright.get(i), 1, 1);
      if (prairieleft==true) {
        xrob=-100;
        yrob =-100;              //prairie dog escape manoeuvre
        print("prairie left");
        prairieleft=false;
      }
      rect(xleft.get(i), yleft.get(i), 1, 1);
    }
    if (mousePressed==true) {                    //mousepress to show mapping
      normal =true;
      mapping=false;
    }
  }
}
void prairierightmode() {
  if (get(xprairie, yprairie+11) != darkbrown) {      //gravity
    yprairie+=1;
  }
  if (get(xprairie, yprairie+17) != darkbrown) {      //gravity stronger, consider this as a fall
    yprairie+=6;
  }
  if (get(xprairie+11, yprairie) != darkbrown) {    //right side free
    xprairie+=1;
  }
  if (get(xprairie+11, yprairie) == darkbrown & get(xprairie, yprairie-11)!=darkbrown) { //right side not free but space above
    yprairie-=10;
  }
  if (get(xprairie+11, yprairie) == darkbrown & get(xprairie, yprairie-11)==darkbrown) {       //right and above both blocked
    prairieleftmode=true;
    prairierightmode=false;
  }
}

void prairieleftmode() {
  if (get(xprairie, yprairie+11) != darkbrown) {      //gravity
    yprairie+=1;
  }
  if (get(xprairie, yprairie+17) != darkbrown) {      //gravity stronger
    yprairie+=6;
  }
  if (get(xprairie-11, yprairie) != darkbrown) {    //left side free
    xprairie-=1;
  }
  if (get(xprairie-11, yprairie) == darkbrown & get(xprairie, yprairie-11)!=darkbrown) { //left side not free but space above
    yprairie-=10  ;
  }
  if (get(xprairie-11, yprairie) == darkbrown & get(xprairie, yprairie-11)==darkbrown) { //left and above both blocked
    prairieleftmode=false;
    prairierightmode=true;
  }
}
void rightmode() {
  if (get(xrob, yrob+ (robsize/2)+ 1) != darkbrown) {      //gravity
    yrob+=1;
  }
  if (get(xrob, yrob+(robsize/2)+ 3) != darkbrown) {      //gravity stronger
    yrob+=3;
  }
  if (get(xrob+(robsize/2)+ 1, yrob) != darkbrown) {    //right side free
    xrob+=1;
  }
  if (get(xrob+(robsize/2)+ 1, yrob) == darkbrown & get(xrob, yrob-(robsize/2)- 1)!=darkbrown) { //right side not free but space above
    yrob-=5;
  }
  if (get(xrob+(robsize/2)+ 1, yrob) == darkbrown & get(xrob, yrob-(robsize/2)- 1)==darkbrown) {       //right and above both blocked
    if ( abs(xrob - lastrightx) <= 5 & abs(yrob - lastrighty) <= 5) {
      xrob=230;
      yrob=230;
      leftmode=true;
    } else {
      rightmode =false;
      leftmode =true;
      lastrightx=xrob;       //switching mechanism
      lastrighty=yrob;
    }
  }
}
void leftmode() {
  if (get(xrob, yrob+(robsize/2)+ 1) != darkbrown) {      //gravity
    yrob+=1;
  }
  if (get(xrob, yrob+(robsize/2)+ 3) != darkbrown) {      //gravity stronger
    yrob+=3;
  }
  if (get(xrob-(robsize/2)- 1, yrob) != darkbrown) {    //left side free
    xrob-=1;
  }
  if (get(xrob-(robsize/2)- 1, yrob) == darkbrown & get(xrob, yrob-(robsize/2)-1)!=darkbrown) { //left side not free but space above
    yrob-=5  ;
  }
  if (get(xrob-(robsize/2)- 1, yrob) == darkbrown & get(xrob, yrob-(robsize/2)-1)==darkbrown) { //left and above both blocked
    if ( abs(xrob - lastleftx) <= 5 & abs(yrob - lastlefty) <= 5) {
      xrob=230;
      yrob=230;
      leftmode=true;
    } else {
      rightmode =true;
      leftmode =false;     //switching mechanism
      lastleftx=xrob;
      lastlefty=yrob;
    }
  }
}

int getClosestRoof(int x, int y) {    //following methods are all for extracting distance of closest wall or floor or roof in some direction.
  roofVal=0;
  for (int i = 0; i<=1000; i++) {
    if (get(x, y-i)==darkbrown) {
      roofVal = i;
      break;
    }
  }
  return roofVal;
}


int getClosestFloor(int x, int y) {
  floorVal=0;
  for (int i = 0; i<=1000; i++) {
    if (get(x, y+i)==darkbrown) {
      floorVal = i;
      break;
    }
  }
  return floorVal;
}

int getClosestLeft(int x, int y) {
  leftVal=0;
  for (int j = 0; j<=1000; j++) {
    if (get(x-j, y)==green& j<200) {
      prairieleft=true;
      break;
    }
  }
  for (int i = 0; i<=1000; i++) {
    if (get(x-i, y)==darkbrown ||get(x-i, y)==green) {
      leftVal = i;
      break;
    }
  }
  return leftVal;
}

int getClosestRight(int x, int y) {
  rightVal=0;
  for (int j = 0; j<=1000; j++) {
    if (get(x+j, y)==green& j<200) {
      prairieright=true;
      break;
    }
  }
  for (int i = 0; i<=1000; i++) {
    if (get(x+i, y)==darkbrown || get(x+i, y)==green) {
      rightVal = i;
      break;
    }
  }
  return rightVal;
}

int getClosestRUP(int x, int y) {
  RUPVal=0;
  for (int j = 0; j<=1000; j++) {
    if (get(x+j, y-j)==green& j<200) {
      prairieright=true;
      break;
    }
  }
  for (int i = 0; i<=1000; i++) {
    if (get(x+i, y-i)==darkbrown || get(x+i, y-i)==green) {
      RUPVal = i;
      break;
    }
  }
  return RUPVal;
}

int getClosestLUP(int x, int y) {
  LUPVal=0;
  for (int j = 0; j<=1000; j++) {
    if (get(x-j, y-j)==green& j<200) {
      prairieleft=true;
      break;
    }
  }
  for (int i = 0; i<=1000; i++) {
    if (get(x-i, y-i)==darkbrown || get(x-i, y-i)==green) {
      LUPVal = i;
      break;
    }
  }
  return LUPVal;
}

int getClosestLDWN(int x, int y) {
  LDWNVal=0;
  for (int j = 0; j<=1000; j++) {
    if (get(x-j, y+j)==green & j<200) {
      prairieleft=true;
      break;
    }
  }
  for (int i = 0; i<=1000; i++) {
    if (get(x-i, y+i)==darkbrown || get(x-i, y+i)==green) {
      LDWNVal = i;
      break;
    }
  }
  return LDWNVal;
}

int getClosestRDWN(int x, int y) {
  RDWNVal=0;
  for (int j = 0; j<=1000; j++) {
    if (get(x-j, y+j)==green & j<200) {
      prairieright=true;
      break;
    }
  }
  for (int i = 0; i<=1000; i++) {
    if (get(x+i, y+i)==darkbrown || get(x+i, y+i)==green) {
      RDWNVal = i;
      break;
    }
  }
  return RDWNVal;
}
