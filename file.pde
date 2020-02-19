/*
general idea:
  save and load Trasker files

info saved:
  location
  size
  title
  text
  bgColor
  fgColor
  icon
  do we save the icon images?
*/

ArrayList<Byte> mapFile = new ArrayList<Byte>(0);//temporary byte array
String fileName = "test.bin";

void saveTask(){
  if(fileName == null){//if no file was selected
    return;//don't do anything
  }
  
  mapFile.clear();//clear the temporary array
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  //File Version
  mapFile.add((byte)(_FILEVERSION_TASKS_ >> 8));//upper byte
  mapFile.add((byte)_FILEVERSION_TASKS_);//lower byte
  
  //dummy header length bytes
  mapFile.add((byte)0x00);//02
  mapFile.add((byte)0x00);//03
  
  //number of retainers
  mapFile.add((byte)(holders.size() >> 8));//upper byte
  mapFile.add((byte)holders.size());//lower byte
  
  padMapFileArray();//pad to a 16 byte boundary
  
  mapFile.set(2, (byte)(mapFile.size() >> 8));//Header Length
  mapFile.set(3, (byte)mapFile.size());//Header Length
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  
  if(_FILEVERSION_TASKS_ == 0){//whats the file version
    //for(int t = 0; t < holders.size(); t++){
    //  for(int r = 0; r < holders.get(t).tasks.size(); r++){
        
    //  }
    //}
    for(int i = 0; i < holders.size(); i++){
      retainer tmp = holders.get(i);
      //Task Title
      for(int j = 0; j < tmp.title.length(); j++){
        mapFile.add((byte)tmp.title.charAt(j));//??
      }
      mapFile.add((byte)0);//null terminated
      
      //Task Text
      for(int j = 0; j < tmp.text.length(); j++){
        mapFile.add((byte)tmp.text.charAt(j));//??
      }
      mapFile.add((byte)0);//null terminated
      
      mapFile.add((byte)(tmp.x >> 8));//upper byte
      mapFile.add((byte)tmp.x);//lower byte
      
      mapFile.add((byte)(tmp.y >> 8));//upper byte
      mapFile.add((byte)tmp.y);//lower byte
      
      mapFile.add((byte)(tmp.w >> 8));//upper byte
      mapFile.add((byte)tmp.w);//lower byte
      
      mapFile.add((byte)(tmp.h >> 8));//upper byte
      mapFile.add((byte)tmp.h);//lower byte
      
      //bgColor
      mapFile.add((byte)tmp.getFgRed());//red
      mapFile.add((byte)tmp.getFgGreen());//green
      mapFile.add((byte)tmp.getFgBlue());//blue
      mapFile.add((byte)tmp.getFgAlpha());//blue
      
      //fgColor
      mapFile.add((byte)tmp.getBgRed());//red
      mapFile.add((byte)tmp.getBgGreen());//green
      mapFile.add((byte)tmp.getBgBlue());//blue
      mapFile.add((byte)tmp.getBgAlpha());//blue
      
      padMapFileArray();//pad to a 16 byte boundary
    }
    
  }else{
    println("File Version Error (Saving).");//throw error
  }
  
  padMapFileArray();//pad to a 16 byte boundary
  
  for(int l = 0; l < _PROGRAMVERSION_FILE_.length; l++){
    mapFile.add(_PROGRAMVERSION_FILE_[l]);//add the program version
  }
  
  //for(int l = 0; l < _magicText.length(); l++){
  //  mapFile.add((byte)_magicText.charAt(l));//add the 'Magic Text'
  //}
  
  byte[] tmpFile = new byte[mapFile.size()];//temporary variable
  for(int i = 0; i < mapFile.size(); i++){
    tmpFile[i] = mapFile.get(i);//convert from ArrayList to normal Array
  }
  saveBytes(fileName, tmpFile);//save the file
  
  mapFile.clear();//clear up memory
}

void loadTask(){
  if(fileName == null){//if there was an error
    return;//do nothing
  }

  noLoop();//dont allow drawing
  byte[] mapFile = loadBytes(fileName);//temporary array
  
  //if(!checkMagic(subset(mapFile, mapFile.length - _magicText.length()))){
  //  loadingMap = false;//since this file was not ours we're no longer loading a map
  //  loop();
  //  return;//file was not one of ours
  //}
  
  int fileVersion;//what file version is the file
  int headerLength;//how long is the header
  int numberHolders;//how many retainers
  String taskTitle;//what is the task title
  String taskText;//where is the task text
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  //File Version
  fileVersion = int(mapFile[0] << 8);//upper byte
  fileVersion |= int(mapFile[1]);//lower byte
  
  headerLength = int(mapFile[2] << 8);//Header Length
  headerLength |= int(mapFile[3]);//Header Length
  
  //number of retainers
  numberHolders = int(mapFile[4] << 8);//Header Length
  numberHolders |= int(mapFile[5]);//Header Length
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  
  if(fileVersion == 0){//whats the file version
    holders.clear();
    int place = headerLength;
  
    for(int i = 0; i < numberHolders; i++){
      //Task title
      taskTitle = "";
      boolean more = true;
      int current = 0;
      while(more){
        char character = (char)mapFile[current + place];
        if(character == 0){
          more = false;
        }else{
          taskTitle += str(character);//get the name
        }
        current++;
      }
      
      //Task text
      taskText = "";
      int nameLength = current;
      more = true;
      current = 0;
      while(more){
        char character = (char)mapFile[nameLength + current + place];
        if(character == 0){
          more = false;
        }else{
          taskText += str(character);//get the name
        }
        current++;
      }
      
      int textLength = current + nameLength;
      int x = int(mapFile[textLength + 0 + place]) << 8;
      x |= int(mapFile[textLength + 1 + place]);
      
      int y = int(mapFile[textLength + 2 + place]) << 8;
      y |= int(mapFile[textLength + 3 + place]);
      
      int w = int(mapFile[textLength + 4 + place]) << 8;
      w |= int(mapFile[textLength + 5 + place]);
      
      int h = int(mapFile[textLength + 6 + place]) << 8;
      h |= int(mapFile[textLength + 7 + place]);
      
      color fgColor = color(int(mapFile[textLength + 8 + place]),int(mapFile[textLength + 9 + place]),int(mapFile[textLength + 10 + place]),int(mapFile[textLength + 11 + place]));
      color bgColor = color(int(mapFile[textLength + 12 + place]),int(mapFile[textLength + 13 + place]),int(mapFile[textLength + 14 + place]),int(mapFile[textLength + 15 + place]));
      
      holders.add(new retainer(taskTitle, taskText, x, y, w, h, fgColor, bgColor));
      
      place += textLength + 16;
      place += padMapFileArray(place);
      //println(place);
    }
  }else{
    println("File Version Error (Loading).");//throw error
  }
  
  loop();//allow drawing
  
  //fileName = null;
}

//---------------------------------------------------------------------------------------------------------------------------------------

int convertFourBytesToInt(byte a_, byte b_, byte c_, byte d_){//convert from four bytes to an integer
  int returnValue = 0;//start with zero
  
  returnValue = a_ & 0xFF;//set it to the most significant byte
  returnValue = returnValue << 8;//shift it 8 bits to the left
  returnValue |= b_ & 0xFF;//add the upper middle byte
  returnValue = returnValue << 8;//shift it 8 bits to the left
  returnValue |= c_ & 0xFF;//add the lower middle byte
  returnValue = returnValue << 8;//shift it 8 bits to the left
  returnValue |= d_ & 0xFF;//add the least significant byte
  
  return returnValue;//return the int
}

void padMapFileArray(){//pad the array to a 16 byte boundary
  int padding = padMapFileArray(mapFile.size());
  for(int l = 0; l < padding; l++){//add the neccessary number of bytes
    mapFile.add((byte)0xA5);//add a byte
  }
}

int padMapFileArray(int current_){//return padding needed to get on a 16 byte boundary
  return (16 - floor(current_ % 16)) % 16;
}

//void padMapFileArray(){//pad the array to a 16 byte boundary
//  int padding = (16 - floor(mapFile.size() % 16)) % 16;//is the size not on a boundary?
//  for(int l = 0; l < padding; l++){//add the neccessary number of bytes
//    mapFile.add((byte)0xA5);//add a byte
//  }
//}