/*
general idea:
  deal with all the mouse crap
*/

void mousePressed() {
  if(checkSqr(0, 0, 16)){
    holders.add(new retainer());
  }
  //test.mousePressed();
  for (int d = level.size() - 1; d >= 0; d--) {
    ui tmp = uis.get(level.get(d));
    if (tmp.mousePressed() == true) {
      shiftLevel(d);
      switch(tmp.ret.function){
        case func_EXIT:
          kill(level.get(d), d);
      }
      break;
    }
  }
  //img1.mousePressed();
  
  //if(r != null){
  //  r.mousePressed();
  //}
  //currentRetainer = NONE;
  for(int i = 0; i < holders.size(); i++){
    //holders.get(i).mousePressed();
    retainer tmp = holders.get(i);
    if(tmp.mousePressed() == true){
      switch(tmp.ret.function){
        case func_EXIT:
          holders.remove(i);
          i--;
      }
      currentRetainer = i;
      break;
    }
  }
}

void mouseMoved() {
  //cursor(img, x, y)
  updateMousePos();
  //test.mouseDragged();
  for (int d : level) {
    uis.get(d).mouseMoved();
  }
  //img1.mouseMoved();
}

void mouseDragged() {
  updateMousePos();
  //test.mouseDragged();
  for (int d : level) {
    uis.get(d).mouseDragged();
  }
  //img1.mouseDragged();
  
  //if(r != null){
  //  r.mouseDragged();
  //}
  for(int i = 0; i < holders.size(); i++){
    holders.get(i).mouseDragged();
  }
}

void mouseReleased() {
  //test.mouseReleased();
  for (int d : level) {
    uis.get(d).mouseReleased();
  }
  //img1.mouseReleased();
  
  //if(r != null){
  //  r.mouseReleased();
  //}
  for(int i = 0; i < holders.size(); i++){
    holders.get(i).mouseReleased();
  }
}

void updateMousePos() {
  if (mouseX <= 100) {
    mX = max(mouseX, 0);
  } else {
    mX = min(mouseX, width);
  }

  if (mouseY <= 100) {
    mY = max(mouseY, 0);
  } else {
    mY = min(mouseY, height);
  }
}