/*
general idea:
  deal with all the keyboard crap
*/

void keyPressed(){//We pressed a key
  switch(keyCode){
    case SHIFT://shift(16)
      shiftHeld = true;
      break;

    case CONTROL://ctrl(17)
      ctrlHeld = true;
      break;

    case ALT://alt(18)
      altHeld = true;
      break;
    
    case ESC:
      //key = 0;  // Fools! don't let them escape!
      return;
    
    //case DELETE:
    //  deleteHeld = true;
    //  break;
  }
  lastKey = keyCode;
  
  print(hex(key));
  print(", ");
  print(hex(keyCode));
  print(", ");
  println(lastKey);
}//void keyPressed() END

void keyTyped() {
  if(uis.size() != 0){
    ui tmp = uis.get(level.get(level.size() - 1));
    tmp.keyTyped();
  }
  if(keyHandler(lastKey, "CTRL + T")){
    spawn(new textInterface(10, 210, 512, 512));
  }
  if(keyHandler(lastKey, "CTRL + S")){
    saveTask();
  }
  if(keyHandler(lastKey, "CTRL + O")){
    loadTask();
  }
  
  //if(r != null){
  //  r.keyTyped();
  //}
  for(int i = 0; i < holders.size(); i++){
    if(i == currentRetainer){
      holders.get(i).keyTyped();
    }
  }
  
  //if(keyCode == ){
    
  //}
  print(hex(key));
  print(", ");
  print(hex(keyCode));
  print(", ");
  println(lastKey);
}

void keyReleased(){
  switch(keyCode){
    case SHIFT://shift(16)
      shiftHeld = false;
      break;

    case CONTROL://ctrl(17)
      ctrlHeld = false;
      break;

    case ALT://alt(18)
      altHeld = false;
      break;
  }
}

void keyHandler(int key_, int keyCode_, String caller_){
  
}

boolean keyHandler(int key_, String keybind_){
  String[] list = split(keybind_, " ");
  
  if(list.length == 0){
    return false;
  }
  
  if(list.length == 1){
    if(list[0].length() > 1){
      switch(list[0]){
        case "DELETE":
          if(key_ == DELETE){
            return true;
          }
          break;
      }
      return false;
    }
  }
  
  if(str(list[list.length - 1].charAt(0)).toLowerCase().equals(str(char(key_)).toLowerCase())){
    for(int i = 0; i < list.length - 1; i++){
      boolean skip = false;
      String tmp = list[i].toLowerCase();
      if(tmp.equals("ctrl")){
        if(ctrlHeld == false){
          return false;
        }
        skip = true;
      }
      if(tmp.equals("alt") && skip == false){
        if(altHeld == false){
          return false;
        }
        skip = true;
      }
      if(tmp.equals("shift") && skip == false){
        if(shiftHeld == false){
          return false;
        }
      }
    }
  }else{
    return false;
  }
  
  return true;
}