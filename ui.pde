/*
general idea:
  replace ui_old with more focused stuff
*/

//retainer r;
ArrayList<retainer> holders;
//ArrayList<taskHolder> holders;
ArrayList<PImage> icons = new ArrayList<PImage>(0);

final int NONE = -1;
final int spotSpacing = 4;
boolean showCursor = false;
int currentRetainer = NONE;

//class taskHolder extends retainer{
//  ArrayList<retainer> tasks = new ArrayList<retainer>(0);
  
//  taskHolder(){
//    super();
//  }
  
//  void draw(){
//    super.draw();
//    for(int i = 0; i < tasks.size(); i++){
//      retainer tmp = tasks.get(i);
//      tmp.draw();
//    }
//  }
  
//  void keyPressed(){
//    for(int i = 0; i < tasks.size(); i++){
//      tasks.get(i).keyPressed();
//    }
//  }
  
//  boolean mousePressed(){
//    for(int i = 0; i < tasks.size(); i++){
//      if(tasks.get(i).mousePressed()){
//        return true;
//      }
//    }
//    return false;
//  }
  
//  void mouseDragged(){
//    for(int i = 0; i < tasks.size(); i++){
//      tasks.get(i).mouseDragged();
//    }
//  }
  
//  void mouseReleased(){
//    for(int i = 0; i < tasks.size(); i++){
//      tasks.get(i).mouseReleased();
//    }
//  }
//}

class retainer{
  String title = "New Task";
  int icon = NONE;
  int x = 100, y = 100;
  int h = 100, w = 256;
  color bgColor = 0;
  String text = "Type your text here...";
  //int cursorPosition = text.length();
  color fgColor = 0xFFFFCC00;
  
  boolean changingTitle = false;
  boolean dragging = false;
  boolean rescaling = false;
  int offsetX,offsetY;
  
  thing ret = new thing();
  
  retainer(){}
  
  retainer(String title_, String text_, int x_, int y_, int w_, int h_, color fgColor_, color bgColor_){
    title = title_;
    text = text_;
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    fgColor = fgColor_;
    bgColor = bgColor_;
  }
  
  void draw(boolean showCursor_){
    if(icon != NONE){
      image(icons.get(icon),x,y);
    }
    
    fill(bgColor);
    noStroke();
    rect(x,y,w,h);
    
    fill(255);
    noStroke();
    rect(x,y-13,w,13);
    TextColor(0);
    DrawText(title,x+2,y-10,changingTitle && showCursor_);
    image(img_color,x+w-24,y-12);
    image(img_exit,x+w-12,y-12);
    image(img_drag,x+w-8,y+h-8);
    
    TextColor(fgColor);
    DrawText(text,x+1,y+1,!changingTitle && showCursor_);
  }
  
  void updateColor(){
    bgColor = tool.getColor();
  }
  
  boolean mousePressed(){
    if(checkBounds(x,y-13,w,h+13,mX,mY)){
      if(checkBR(x,y,w,h)){
        rescaling = true;
      }else if(checkTB(x, y-13, w)){
        if(checkSqr(x+w-12,y-12,11)){
          //exit
          ret.function = func_EXIT;
        }else if(checkSqr(x+w-24,y-12,11)){
          tool.setVisible(!tool.isVisible());
        }
        dragging = true;
        changingTitle = true;
      }else{
        //dragging = true;
        //changingTitle = false;
        changingTitle = false;
        
      }
      offsetX = mX - x;
      offsetY = mY - y;
      
      return true;
    }
    
    return false;
  }
  
  void mouseMoved(){}
  
  void mouseDragged(){
    if(dragging == true){
      x = mX - offsetX;
      y = mY - offsetY;
      
    }else if(rescaling == true){
      String[] tmp = split(text,'\t');
      int l = title.length();
      for(int i = 0; i < tmp.length; i++){
        if(tmp[i].length() > l){
          l = tmp[i].length();
        }
      }
      w = max(mX - x,(l+3)*nPatch);
      h = max(mY - y,(tmp.length+2)*nPatch);
    }
  }
  
  void mouseReleased(){
    dragging = false;
    rescaling = false;
  }
  
  void keyPressed(){}
  
  void keyTyped(){
    String tmp = (changingTitle == true)?title:text;
    if ((key >= ' ' && key <= '~')) {
      tmp += key;
    }else if ((key == BACKSPACE && tmp.length() != 0)) {
      tmp = tmp.substring(0, tmp.length() - 1);
    }else if ((key == ENTER)) {
      //method(ti.text);
      tmp += '\n';
    }else if ((key == TAB)) {
      //method(ti.text);
      //tmp += '\t';
      tmp += "  ";
    }
    if(changingTitle == true){
      title = tmp;
    }else{
      text = tmp;
    }
    int l = (tmp.length() + ((changingTitle == true)?5:1)) * nPatch + 1;
    if(l > w){
      w = l;
    }
  }
  
  void keyReleased(){}
  
  byte getBgRed(){
    return byte(red(bgColor));
  }
  
  byte getBgGreen(){
    return byte(green(bgColor));
  }
  
  byte getBgBlue(){
    return byte(blue(bgColor));
  }
  
  byte getBgAlpha(){
    return byte(alpha(bgColor));
  }
  
  byte getFgRed(){
    return byte(red(fgColor));
  }
  
  byte getFgGreen(){
    return byte(green(fgColor));
  }
  
  byte getFgBlue(){
    return byte(blue(fgColor));
  }
  
  byte getFgAlpha(){
    return byte(alpha(fgColor));
  }
}