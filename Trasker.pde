/*
Trasker: The task tracker
general idea:
  be an agile way of keeping track of tasks
*/

ArrayList<ui> uis = new ArrayList<ui>();
IntList level = new IntList();
IntList level2 = new IntList();
boolean redoLevel = false;
PImage img_drag;
PImage img_exit;
PImage img_max;
PImage img_min;
PImage img_plus;
PImage img_color;
PImage test;

int mX, mY;

int lastKey = 0;
boolean ctrlHeld = false;
boolean altHeld = false;
boolean shiftHeld = false;

int halfHeight = 0;
int halfWidth = 0;
int oldHeight = 0;
int oldWidth = 0;

File programDirectory;
File assetsFolder;

ColorTools tool;

void setup(){
  size(1000, 1000);
  surface.setResizable(true);
  surface.setTitle(_PROGRAM_TITLE_ + " - " + _PROGRAMVERSION_TITLE_);
  noSmooth();
  
  programDirectory = new File(sketchPath());
  assetsFolder = new File(programDirectory + "/assets/");
  
  img_drag = loadImage("drag.png");
  img_exit = loadImage("exit.png");
  img_max = loadImage("max.png");
  img_min = loadImage("min.png");
  img_plus = loadImage("plus.png");
  img_color = loadImage("color.png");
  
  LoadFonts();
  tool = new ColorTools(this);
  
  //spawn(new textInterface(10, 210, 512, 512));
  //r = new retainer();
  
  holders = new ArrayList<retainer>(0);
  holders.add(new retainer());
}

void draw(){
  if(oldWidth != width || oldHeight != height){
    oldWidth = width;
    oldHeight = height;
    halfHeight = height / 2;
    halfWidth = width / 2;
  }
  
  background(127);
  //test.draw();

  if (redoLevel == true) {
    level.clear();
    level.append(level2);
    redoLevel = false;
  }

  for (int d = 0; d < level.size(); d++) {
    uis.get(level.get(d)).draw();
  }
  
  //if(r != null){
  //  r.draw();
  //}
  for(int i = 0; i < holders.size(); i++){
    holders.get(i).draw((i == currentRetainer)?true:false);
  }
  
  if(frameCount % 30 == 0){
    showCursor = !showCursor;
  }
  
  image(img_plus,0,0);
  
  if(currentRetainer != NONE && tool.isVisible()){
    holders.get(currentRetainer).updateColor();
  }
  
  //fill(currentTileColor.getColor());
  //rect(10,10,32,32);
}

void test() {
  uis.get(level.get(level.size() - 1)).text = "Hello Terminal " + caller.terminal + ", Thanks For Calling " + caller.info[1] + "!";
  //println(uis.size() + ":" + level.size() + ":" + level2.size());
  //printArray(uis);
}

void shiftLevel(int d_) {
  level2.clear();
  level2.append(level);
  level2.remove(d_);
  level2.append(level.get(d_));
  redoLevel = true;
}

void removeLevel(int d_) {
  level2.clear();
  level2.append(level);
  level2.remove(d_);
  //level2.append(level.get(d_));
  redoLevel = true;
}

void spawn(ui s_){
  uis.add(s_);
  level.append(uis.size() - 1);
}

void kill(int u_, int l_){
  uis.remove(u_);
  removeLevel(l_);
  
  for(int i = 0; i < level2.size(); i++){
    if(level2.get(i) > u_){
      level2.sub(i,1);
    }
  }
}

//void kill(int u_){
  
//}

void killAll(){
  uis.clear();
  level2.clear();
  redoLevel = true;
}

void parseInput() {
  int term = level.get(level.size() - 1);
  caller.terminal = term;
  String[] tmp = splitTokens(uis.get(term).text, " ");
  caller.info = tmp;
  if (tmp.length == 0) {
    return;
  }
  switch(tmp[0]) {
    case "call":
      if (tmp.length == 2) {
        method(tmp[1]);
      } else {
        uis.get(term).text = "Wrong number of arguments";
      }
      break;
  
    case "spawn":
      switch(tmp[1]) {
        case "img":
          //img1 = new img(10,110,100,100,"img",loadImage("test.png"));
          spawn(new img(10, 110, 100, 100, "img", test));
          //uis.add(new img(10,110,100,100,"img",test));
          //level.append(uis.size() - 1);
          break;
    
        case "terminal":
          spawn(new textInterface(10, 210, 512, 512));
          //uis.add(new textInterface(10,210,512,512));
          //level.append(uis.size() - 1);
          break;
        
        case "retainer":
          //r = new retainer();
          break;
    
        default:
          uis.get(term).text = "Unknown App";
          return;
      }
      uis.get(term).text = "";
      break;
  
    case "level":
      switch(tmp[1]) {
        case "append":
          level.append(int(tmp[2]));
          break;
      }
      uis.get(term).text = "";
      break;

    case "kill":
      switch(tmp[1]){
        case "all":
          term = -1;
          killAll();
          break;
        //case "img":
          //img1 = new img();
          //break;

        //case "terminal":
        //  for(int i = 0; i < level.size(); i++){
        //    if(level.get(i) == uis.size()){
        //      level.remove(i);
        //    }
        //  }
        //  uis.remove(uis.size() - 1);
        //  break;

        default:
          uis.get(term).text = "Unknown App";
      }
    if(term != -1){
      uis.get(level.get(level.size() - 1)).text = "";
    }
    break;
    
    case "exit":
      kill(term, level.size() - 1);
      term = -1;
      break;
    
    case "shutdown":
      exit();
      break;

    default:
      if(term != -1){
        uis.get(term).text = "Unknown Command...";
      }
  }
}