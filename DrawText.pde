final int nPatch = 8;
color TextFill = 255;

PImage[] font;
PImage[] font2;

void LoadFonts(){
  //font = LoadText("font-alpha.png");
  //font = LoadText("fontTest.png");
  font = LoadText("fontTest_4x4.png");
  font2 = LoadText("custom.png");
}

PImage[] LoadText(String name_){
  return tileMapToTileArray(loadImage(name_), nPatch, nPatch);
}

void TextColor(int c_){
  TextFill = c_;
}

//text(items.get(nTopLeftItem + i).sName, vScreenLocation.x, vScreenLocation.y+7);
//void DrawText(String text_, float x_, float y_){
//  for(int i = 0; i < text_.length(); i++){
//    DrawCharacter(text_.charAt(i), x_ + (i * nPatch), y_);
//  }
//}

void DrawText(String text_, float x_, float y_, boolean cursor){
  String[] tmp = split(text_, '\n');
  for(int y = 0; y < tmp.length; y++){
    for(int x = 0; x < tmp[y].length(); x++){
      DrawCharacter(tmp[y].charAt(x), x_ + (x * nPatch), y_ + (y * nPatch));
    }
  }
  if(showCursor == true && cursor == true){
    //DrawCharacter(char(0x5F), x_ + (tmp[tmp.length - 1].length() * nPatch), y_ + ((tmp.length - 1) * nPatch));
    stroke(255);
    float tmpX = x_ + (tmp[tmp.length - 1].length() * nPatch);
    float tmpY = y_ + ((tmp.length - 1) * nPatch);
    line(tmpX, tmpY, tmpX, tmpY + nPatch);
  }
}

void DrawCharacter(char char_, float x_, float y_){
  pushStyle();
  tint(TextFill);
  if(char_ > 0xFF){
    image(font2[char_ & 0xFF], x_, y_);
  }else{
    image(font[char_], x_, y_);
  }
  popStyle();
}

PImage[] tileMapToTileArray(PImage tileMap_, int tileWidth_, int tileHeight_){
  int cols = tileMap_.width / tileWidth_;
  int rows = tileMap_.height / tileHeight_;
  PImage[] tmpTiles = new PImage[rows * cols];
  int total = 0;
  for(int y = 0; y < rows; y++){//go through all tile map rows
    for(int x = 0; x < cols; x++){//go through all tile map columns
      PImage tmp = createImage(tileWidth_, tileHeight_, ARGB);//create a temporary image
      tmp.copy(tileMap_, x * tileWidth_, y * tileHeight_, tileWidth_, tileHeight_, 0, 0, tileWidth_, tileHeight_);//copy the tile at this xy position
      tmpTiles[total] = tmp;//copy the tile to the temporary array of tiles
      total++;//next tile
    }
  }
  return tmpTiles;
}