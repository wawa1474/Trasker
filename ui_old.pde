/*
general idea:
  deal with all the ui crap
*/

final int error_NONE = -1;

final int func_NONE = -1;
final int func_EXIT = 0;
class thing{
  int error = error_NONE;
  int function = func_NONE;
}

final int uiType_NONE = -1;
final int uiType_terminal = 0;
final int uiType_cardGame = 1;

class ui{
  int x,y,w,h;
  int oX,oY,oW,oH;
  color bgColor,fgColor;
  String title = "";
  String text = "";
  Boolean fullscreen = false;
  thing ret = new thing();
  int uiType = uiType_NONE;
  
  ui(){}
  
  ui(int x_, int y_, int w_, int h_, String title_, color bg_, color fg_, int type_){
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    title = title_;
    bgColor = bg_;
    fgColor = fg_;
    uiType = type_;
  }
  
  ui(int x_, int y_, int w_, int h_, String title_){
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    title = title_;
  }
  
  void draw(){
    fill(255);
    noStroke();
    rect(x,y-13,w,13);
    fill(0);
    text(title,x+2,y-2);
    image(img_exit,x+w-12,y-12);
    image(img_max,x+w-25,y-12);
    image(img_min,x+w-38,y-12);
  }
  
  void setFullscreen(boolean value_){
    if(value_ == true){
      oX = x;
      oY = y;
      oW = w;
      oH = h;
      x = 0;
      y = 13;
      w = width;
      h = height;
      fullscreen = true;
    }else{
      x = oX;
      y = oY;
      w = oW;
      h = oH;
      fullscreen = false;
    }
  }
  
  boolean mousePressed(){return false;}
  void mouseMoved(){}
  void mouseDragged(){}
  void mouseReleased(){}
  void keyPressed(){}
  void keyTyped(){}
  void keyReleased(){}
}

boolean checkSqr(int x_, int y_, int w_){
  return checkBounds(x_,y_,w_,w_,mX,mY);
}

boolean checkTB(int x_, int y_, int w_){
  return checkBounds(x_,y_,w_,13,mX,mY);
}

boolean checkTR(int x_, int y_, int w_){
  return checkBounds(x_+w_-40,y_,40,13,mX,mY);
}

boolean checkBR(int x_, int y_, int w_, int h_){
  return checkBounds(x_+w_-8,y_+h_-8,8,8,mX,mY);
}

boolean checkBounds(int x_, int y_, int w_, int h_, int tX_, int tY_){
  return (tX_ >= x_ && tX_ <= x_ + w_ && tY_ >= y_ && tY_ <= y_ + h_);
}

final int up = 1;
final int down = 2;
final int left = 4;
final int right = 8;
final int upLeft = 5;
final int upRight = 9;
final int downLeft = 6;
final int downRight = 10;

class draggable extends ui{
  boolean draggable = true;
  boolean dragging = false;
  boolean rescalable = true;
  boolean rescaling = false;
  boolean stickSide = false;
  int side = 0;
  int clickTime = 0;
  int offsetX,offsetY;
  

  
  draggable(){
    super();
  }
  
  draggable(int x_, int y_, int w_, int h_, String title_, color bg_, color fg_, int type_){
    super(x_,y_,w_,h_,title_,bg_,fg_,type_);
  }
  
  draggable(int x_, int y_, int w_, int h_, String title_){
    super(x_,y_,w_,h_,title_);
  }
  
  void draw(){
    //fill(bgColor);
    //noStroke();
    //rect(x,y,w,h);
    if(fullscreen == false && rescalable == true){
      image(img_drag,x+w-8,y+h-8);
    }
    super.draw();
    fill(255,0,255);
    //rect(x+w-38,y-12,11,11);//min
    //rect(x+w-25,y-12,11,11);//max
    //rect(x+w-12,y-12,11,11);//exit
  }
  
  boolean mousePressed(){
    if(checkBounds(x,y-13,w,h+13,mX,mY)){
      if(checkBR(x,y,w,h)){
        rescaling = rescalable;
      }else if(checkTR(x, y-13, w)){
        if(checkSqr(x+w-38,y-12,11)){
          //minimize
        }else if(checkSqr(x+w-25,y-12,11)){
          //maximize
          setFullscreen(!fullscreen);
        }else if(checkSqr(x+w-12,y-12,11)){
          //exit
          ret.function = func_EXIT;
        }
      }else{
        dragging = draggable;
      }
      offsetX = mX - x;
      offsetY = mY - y;
      
      if(clickTime + 10 >= frameCount && rescalable == true){
        setFullscreen(!fullscreen);
      }
      
      clickTime = frameCount;
      
      return true;
    }
    
    return false;
  }
  
  void mouseMoved(){
    
  }
  
  void mouseDragged(){
    if(dragging == true){
      x = mX - offsetX;
      y = mY - offsetY;
      
      side = 0;
      if(mY <= 4){side += up; stickSide = true;}
      if(mY >= height-4){side += down; stickSide = true;}
      if(mX <= 4){side += left; stickSide = true;}
      if(mX >= width-4){side += right; stickSide = true;}
    }else if(rescaling == true){
      w = max(mX - x,100);
      h = max(mY - y,100);
    }
  }
  
  void mouseReleased(){
    dragging = false;
    rescaling = false;
    
    if(stickSide == true){
      switch(side){
        case up:
          x = y = 0;
          w = width;
          h = height / 2;
          break;
        
        case down:
          x = 0;
          y = height / 2;
          w = width;
          h = height / 2;
          break;
        
        case left:
          x = y = 0;
          w = width / 2;
          h = height;
          break;
        
        case right:
          x = width / 2;
          y = 0;
          w = width / 2;
          h = height;
          break;
        
        case upLeft:
          x = y = 0;
          w = width / 2;
          h = height / 2;
          break;
        
        case upRight:
          x = height / 2;
          y = 0;
          w = width / 2;
          h = height / 2;
          break;
        
        case downLeft:
          x = 0;
          y = height / 2;
          w = width / 2;
          h = height / 2;
          break;
        
        case downRight:
          x = width / 2;
          y = height / 2;
          w = width / 2;
          h = height / 2;
          break;
        
      }
    }
    stickSide = false;
  }
}

call caller = new call();

class textInterface extends draggable{  
  textInterface(){
    super();
  }
  
  textInterface(int x_, int y_, int w_, int h_){
    super(x_,y_,w_,h_,"Terminal",0xFF000000,0xFFFFCC00,uiType_terminal);
  }
  
  void draw(){
    fill(bgColor);
    noStroke();
    rect(x,y,w,h);
    fill(fgColor);
    text(text,x+2,y+12);
    //image(drag,x+w-8,y+h-8);
    super.draw();
  }
  
  void keyTyped(){
    if ((key >= ' ' && key <= '~')) {
      text += key;
    }else if ((key == BACKSPACE && text.length() != 0)) {
      text = text.substring(0, text.length() - 1);
    }else if ((key == ENTER)) {
      //method(ti.text);
      parseInput();
    }
  }
}

class call{
  int terminal;
  String[] info;
}

class img extends draggable{
  PImage image;
  
  img(){
    super();
  }
  
  img(int x_, int y_, int w_, int h_, String title_, PImage img_){
    super(x_, y_, w_, h_, title_);
    image = img_;
  }
  
  void draw(){
    //super.draw();
    if(image != null){
      image(image,x,y,w,h);
      //image(drag,x+w-8,y+h-8);
      super.draw();
    }
  }
}