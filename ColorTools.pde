import g4p_controls.*;//buttons
import controlP5.*;//sliders and color wheel
ControlP5 UIControls;//ui controls
final int UIscl = 32;

public class ColorTools{
  PApplet parent;
  
  boolean visible = true;
  
  ColorTools(PApplet parent_){
    parent = parent_;
    parent.registerMethod("pre", this);
    parent.registerMethod("draw", this);
    parent.registerMethod("post", this);
    parent.registerMethod("mouseEvent", this);
    parent.registerMethod("keyEvent", this);
    parent.registerMethod("stop", this);
    parent.registerMethod("dispose", this);
    parent.registerMethod("pause", this);
    parent.registerMethod("resume", this);
    
    createGUI();
    UIControls = new ControlP5(parent_);//set up all the control stuff
    setupUI();//Setup all of the UI stuff
    
    //colorToolsVisible = !colorToolsVisible;
    colorToolsVisible(visible);
  }
  
  public void pre(){
    //called after beginDraw(), can affect drawing
  }
  
  public void draw(){
    //called at end of draw(), but before endDraw()
    if(currentTileColor != oldTileColor){
      updateColorTools();
      oldTileColor = currentTileColor;
    }
  }
  
  public void post(){
    //called after drawing has completed, no drawing allowed
  }
  
  public void mouseEvent(MouseEvent event_){
    //called when mouse event occurs in parent, drawing allowed, unless noLoop() has been called
    int x = event_.getX();
    int y = event_.getY();
    
    switch(event_.getAction()){
      case MouseEvent.PRESS:
        // do something for the mouse being pressed
        break;
      case MouseEvent.RELEASE:
        // do something for mouse released
        currentColorSlider = editor_slider_NONE;
        break;
      case MouseEvent.CLICK:
        // do something for mouse clicked
        break;
      case MouseEvent.DRAG:
        // do something for mouse dragged
        break;
      case MouseEvent.MOVE:
        // do something for mouse moved
        break;
    }
  }
  
  public void keyEvent(KeyEvent event_){
    //called when key event occurs in parent, drawing allowed, unless noLoop() has been called
    int keyCode = event_.getKeyCode();
    int modifiers = event_.getModifiers();
    
  }
  
  public void stop(){
    //called to halt execution, may be called multiple times
  }
  
  public void dispose() {
     //Anything in here will be called automatically when 
     //the parent sketch shuts down. For instance, this might
     //shut down a thread used by this library.
     println("Exiting");
  }
  
  public void pause(){
    //called on android when paused
  }
  
  public void resume(){
    //called on android when resumed
  }
  
  color getColor(){
    return currentTileColor.getColor();
  }
  
  void setVisible(boolean value_){
    colorToolsVisible(value_);
    visible = value_;
  }
  
  boolean isVisible(){
    return visible;
  }
}

GPanel editor_colorTools_panel;
final int editor_colorTools_panel_Width = UIscl * 11 + 12;
final int editor_colorTools_panel_Height = UIscl * 7 - 3;
final int editor_slider_NONE = -1;
final int editor_slider_red = 0;
final int editor_slider_green = 1;
final int editor_slider_blue = 2;
final int editor_slider_hue = 3;
final int editor_slider_saturation = 4;
final int editor_slider_brightness = 5;
final int editor_slider_alpha = 6;
final int editor_slider_size = 6;
GCustomSlider[] editor_sliders;
int currentColorSlider = editor_slider_NONE;

PImage alphaBack;
PImage hueBack;

PGraphics tmpGradient;

GLabel rgbLabel;

GLabel redLabel;
GLabel greenLabel;
GLabel blueLabel;

GLabel hsbLabel;

GLabel hueLabel;
GLabel saturationLabel;
GLabel brightnessLabel;

GLabel alphaLabelText;
GLabel alphaLabel;

tileColor currentTileColor = new tileColor(0, 255, 255);
tileColor oldTileColor = currentTileColor;

Controller colorInputR, colorInputG, colorInputB;//number input
Controller colorInputH, colorInputS, colorInputV;//number input
Controller colorInputA;
Controller colorWheel;//color wheel

String colorToolsVersion = "ALPHA V0.0.0";

void setupUI(){
  UIControls.addSlider("scrollSlider").setVisible(false).setDecimalPrecision(0).setPosition(32, 0).setSliderMode(Slider.FLEXIBLE).setSize(UIscl * 2, UIscl).setRange(1, 10).setValue(5).setColorBackground(color(50)).setCaptionLabel("");//create Slider

  UIControls.addColorWheel("colorWheel").setVisible(false).setRGB(currentTileColor.getColor()).setCaptionLabel("");//create ColorWheel
  colorWheel = UIControls.getController("colorWheel");//make it easier to use ColorWheel

  UIControls.addTextfield("colorInputR").setSize(UIscl, UIscl / 2).setVisible(false).setCaptionLabel("");//.setColorLabel(color(255, 0, 0));
  UIControls.addTextfield("colorInputG").setSize(UIscl, UIscl / 2).setVisible(false).setCaptionLabel("");//.setColorLabel(color(0, 255, 0));
  UIControls.addTextfield("colorInputB").setSize(UIscl, UIscl / 2).setVisible(false).setCaptionLabel("");//.setColorLabel(color(0, 0, 255));
  colorInputR = UIControls.getController("colorInputR");//make it easier to use Textfield
  colorInputG = UIControls.getController("colorInputG");//make it easier to use Textfield
  colorInputB = UIControls.getController("colorInputB");//make it easier to use Textfield
  
  UIControls.addTextfield("colorInputH").setSize(UIscl, UIscl / 2).setVisible(false).setCaptionLabel("");//.setColorLabel(color(255, 0, 0));
  UIControls.addTextfield("colorInputS").setSize(UIscl, UIscl / 2).setVisible(false).setCaptionLabel("");//.setColorLabel(color(0, 255, 0));
  UIControls.addTextfield("colorInputV").setSize(UIscl, UIscl / 2).setVisible(false).setCaptionLabel("");//.setColorLabel(color(0, 0, 255));
  colorInputH = UIControls.getController("colorInputH");//make it easier to use Textfield
  colorInputS = UIControls.getController("colorInputS");//make it easier to use Textfield
  colorInputV = UIControls.getController("colorInputV");//make it easier to use Textfield
  
  UIControls.addTextfield("colorInputA").setSize(UIscl, UIscl / 2).setVisible(false).setCaptionLabel("");//.setColorLabel(color(0, 0, 255));
  colorInputA = UIControls.getController("colorInputA");//make it easier to use Textfield
}//void setup() END

void controlEvent(ControlEvent theEvent) {
  if(theEvent.isAssignableFrom(Textfield.class)) {
    //println("controlEvent: accessing a string from controller '"
    //        +theEvent.getName()+"': "
    //        +theEvent.getStringValue()
    //        );
    switch(theEvent.getName()){
      case "colorInputR":
        currentTileColor.setRed(Integer.valueOf(theEvent.getStringValue()));
        break;
      
      case "colorInputG":
        currentTileColor.setGreen(Integer.valueOf(theEvent.getStringValue()));
        break;
      
      case "colorInputB":
        currentTileColor.setBlue(Integer.valueOf(theEvent.getStringValue()));
        break;
      
      case "colorInputH":
        currentTileColor.setHue(Integer.valueOf(theEvent.getStringValue()));
        break;
      
      case "colorInputS":
        currentTileColor.setSaturation(Integer.valueOf(theEvent.getStringValue()));
        break;
      
      case "colorInputV":
        currentTileColor.setBrightness(Integer.valueOf(theEvent.getStringValue()));
        break;
      
      case "colorInputA":
        currentTileColor.setAlpha(Integer.valueOf(theEvent.getStringValue()));
        break;
    }
    oldTileColor = null;
  }else if(theEvent.isAssignableFrom(ColorWheel.class)) {
    if(currentColorSlider == editor_slider_NONE){
      currentColorSlider = 99;
    }
    
    if(currentColorSlider == 99){
      currentTileColor.setColorNoAlpha(UIControls.get(ColorWheel.class, "colorWheel").getRGB());
      
      editor_sliders[editor_slider_red].setValue(currentTileColor.getRed());
      editor_sliders[editor_slider_green].setValue(currentTileColor.getGreen());
      editor_sliders[editor_slider_blue].setValue(currentTileColor.getBlue());
      editor_sliders[editor_slider_hue].setValue(currentTileColor.getHue());
      editor_sliders[editor_slider_saturation].setValue(currentTileColor.getSaturation());
      editor_sliders[editor_slider_brightness].setValue(currentTileColor.getBrightness());
    }
  }
}

public void createGUI(){
  G4P.messagesEnabled(false);
  GButton.useRoundCorners(false);
  G4P.mouseWheelDirection(G4P.REVERSE);
  
  editor_colorTools_panel = new GPanel(this, UIscl * 16, 0, editor_colorTools_panel_Width, editor_colorTools_panel_Height, "Color Tools" + " - " + colorToolsVersion);// -------------------------------------------------------------------------");
  editor_colorTools_panel.addEventHandler(this, "editor_colorTools_panel_handler");
  editor_colorTools_panel.setCollapsible(true);
  editor_colorTools_panel.setVisible(false);
  
  File assetsFolder = new File(sketchPath() + "/assets/");
  File customSlider = new File(assetsFolder + "/sliders/blank3/");
  editor_sliders = new GCustomSlider[editor_slider_size + 1];
  for(int i = 0; i < editor_sliders.length; i++){
    int tmpY = 36 + (i * 16) + ((i >= editor_slider_hue)?32:0) + ((i >= editor_slider_alpha)?32:0);
    editor_sliders[i] = new GCustomSlider(this, 204, tmpY, 122, 16, customSlider.getAbsolutePath());
    editor_sliders[i].setLimits(127, 0, 255);
    editor_sliders[i].addEventHandler(this, "editor_HSBSlider_handler");
    editor_colorTools_panel.addControl(editor_sliders[i]);
    switch(i){
      case editor_slider_red:
        editor_sliders[i].setValue(currentTileColor.getRed());
        break;
      
      case editor_slider_green:
        editor_sliders[i].setValue(currentTileColor.getGreen());
        break;
      
      case editor_slider_blue:
        editor_sliders[i].setValue(currentTileColor.getBlue());
        break;
      
      case editor_slider_hue:
        editor_sliders[i].setValue(currentTileColor.getHue());
        break;
      
      case editor_slider_saturation:
        editor_sliders[i].setValue(currentTileColor.getSaturation());
        break;
      
      case editor_slider_brightness:
        editor_sliders[i].setValue(currentTileColor.getBrightness());
        break;
      
      case editor_slider_alpha:
        editor_sliders[i].setValue(currentTileColor.getAlpha());
        break;
    }
  }
  
  
  alphaBack = loadImage(assetsFolder + "/alphaBack.png");
  hueBack = loadImage(assetsFolder + "/hueBack.png");
  
  
  tmpGradient = createGraphics(100,16);
  
  rgbLabel = new GLabel(this, 215, 20, 150, 16, "RGB ----------------------------");
  
  redLabel = new GLabel(this, 215, 36, 100, 16, "");
  greenLabel = new GLabel(this, 215, 52, 100, 16, "");
  blueLabel = new GLabel(this, 215, 68, 100, 16, "");
  
  hsbLabel = new GLabel(this, 215, 100, 150, 16, "HSB ----------------------------");
  
  hueLabel = new GLabel(this, 215, 116, 100, 16, "");
  saturationLabel = new GLabel(this, 215, 132, 100, 16, "");
  brightnessLabel = new GLabel(this, 215, 148, 100, 16, "");
  
  hueLabel.setIcon(hueBack, 1, null, null);
  
  alphaLabelText = new GLabel(this, 215, 180, 150, 16, "ALPHA -------------------------");
  alphaLabel = new GLabel(this, 215, 196, 100, 16, "");
  
  editor_colorTools_panel.addControl(rgbLabel);
  editor_colorTools_panel.addControl(redLabel);
  editor_colorTools_panel.addControl(greenLabel);
  editor_colorTools_panel.addControl(blueLabel);
  editor_colorTools_panel.addControl(hsbLabel);
  editor_colorTools_panel.addControl(hueLabel);
  editor_colorTools_panel.addControl(saturationLabel);
  editor_colorTools_panel.addControl(brightnessLabel);
  editor_colorTools_panel.addControl(alphaLabelText);
  editor_colorTools_panel.addControl(alphaLabel);
}

public void editor_colorTools_panel_handler(GPanel source, GEvent event){
  //GEvent.COLLAPSED, EXPANDED, DRAGGED
  if(event == GEvent.COLLAPSED){
    colorInputVisible(false);
  }else if(event == GEvent.EXPANDED){
    colorInputVisible(true);
    colorInputPosition();
  }else
  if(event == GEvent.DRAGGED){
    colorInputPosition();
  }
}

void colorToolsVisible(boolean value_){
  editor_colorTools_panel.setVisible(value_);
  colorInputVisible(value_);
  if(value_ == true){
    colorInputPosition();
  }
}

void colorInputVisible(boolean value_){
  colorWheel.setVisible(value_);
  colorInputR.setVisible(value_);//change visibility
  colorInputG.setVisible(value_);//change visibility
  colorInputB.setVisible(value_);//change visibility
  colorInputH.setVisible(value_);//change visibility
  colorInputS.setVisible(value_);//change visibility
  colorInputV.setVisible(value_);//change visibility
  colorInputA.setVisible(value_);//change visibility
}

void colorInputPosition(){
  float tmpX = editor_colorTools_panel.getX() + editor_sliders[editor_slider_red].getX() + editor_sliders[editor_slider_red].getWidth() + (UIscl / 8);
  float tmpY = editor_colorTools_panel.getY();
  colorWheel.setPosition(editor_colorTools_panel.getX() + 1, editor_colorTools_panel.getY() + 20);
  colorInputR.setPosition(tmpX, editor_sliders[editor_slider_red].getY() + tmpY);
  colorInputG.setPosition(tmpX, editor_sliders[editor_slider_green].getY() + tmpY);
  colorInputB.setPosition(tmpX, editor_sliders[editor_slider_blue].getY() + tmpY);
  colorInputH.setPosition(tmpX, editor_sliders[editor_slider_hue].getY() + tmpY);
  colorInputS.setPosition(tmpX, editor_sliders[editor_slider_saturation].getY() + tmpY);
  colorInputV.setPosition(tmpX, editor_sliders[editor_slider_brightness].getY() + tmpY);
  colorInputA.setPosition(tmpX, editor_sliders[editor_slider_alpha].getY() + tmpY);
}

public void editor_HSBSlider_handler(GCustomSlider source, GEvent event){
  //GEvent.VALUE_STEADY
  colorMode(HSB, 255);
  if(currentColorSlider == editor_slider_hue){
    currentTileColor.setHue(editor_sliders[editor_slider_hue].getValueF());
  }
  if(currentColorSlider == editor_slider_saturation){
    currentTileColor.setSaturation(editor_sliders[editor_slider_saturation].getValueF());
  }
  if(currentColorSlider == editor_slider_brightness){
    currentTileColor.setBrightness(editor_sliders[editor_slider_brightness].getValueF());
  }
  colorMode(RGB, 255);
  
  if(currentColorSlider == editor_slider_red){
    currentTileColor.setRed(editor_sliders[editor_slider_red].getValueF());
  }
  if(currentColorSlider == editor_slider_green){
    currentTileColor.setGreen(editor_sliders[editor_slider_green].getValueF());
  }
  if(currentColorSlider == editor_slider_blue){
    currentTileColor.setBlue(editor_sliders[editor_slider_blue].getValueF());
  }
  
  if(currentColorSlider == editor_slider_alpha){
    currentTileColor.setAlpha(editor_sliders[editor_slider_alpha].getValueF());
  }
  
  if(currentColorSlider == editor_slider_NONE){
    for(int i = 0; i < editor_sliders.length; i++){
      if(source == editor_sliders[i]){
        currentColorSlider = i;
      }
    }
  }
  
  oldTileColor = null;
}

void updateColorTools(){
  drawRedGradient();
  redLabel.setIcon(tmpGradient, 1, null, null);
  
  drawGreenGradient();
  greenLabel.setIcon(tmpGradient, 1, null, null);
  
  drawBlueGradient();
  blueLabel.setIcon(tmpGradient, 1, null, null);
  
  
  drawSaturationGradient();
  saturationLabel.setIcon(tmpGradient, 1, null, null);
  
  drawBrightnessGradient();
  brightnessLabel.setIcon(tmpGradient, 1, null, null);
  
  
  drawAlphaGradient();
  alphaLabel.setIcon(tmpGradient, 1, null, null);
  
  if(currentColorSlider == editor_slider_red || currentColorSlider == editor_slider_green || currentColorSlider == editor_slider_blue || currentColorSlider == editor_slider_NONE){
    editor_sliders[editor_slider_hue].setValue(currentTileColor.getHue());
    editor_sliders[editor_slider_saturation].setValue(currentTileColor.getSaturation());
    editor_sliders[editor_slider_brightness].setValue(currentTileColor.getBrightness());
    UIControls.get(ColorWheel.class,"colorWheel").setRGB(currentTileColor.getColor());
  }
  
  if(currentColorSlider == editor_slider_hue || currentColorSlider == editor_slider_saturation || currentColorSlider == editor_slider_brightness || currentColorSlider == editor_slider_NONE){
    editor_sliders[editor_slider_red].setValue(currentTileColor.getRed());
    editor_sliders[editor_slider_green].setValue(currentTileColor.getGreen());
    editor_sliders[editor_slider_blue].setValue(currentTileColor.getBlue());
    UIControls.get(ColorWheel.class,"colorWheel").setRGB(currentTileColor.getColor());
  }
  
  updateTextFields();
}

void updateTextFields(){
  UIControls.get(Textfield.class,"colorInputR").setText(splitTokens(str(currentTileColor.getRed()),".")[0]);
  UIControls.get(Textfield.class,"colorInputG").setText(splitTokens(str(currentTileColor.getGreen()),".")[0]);
  UIControls.get(Textfield.class,"colorInputB").setText(splitTokens(str(currentTileColor.getBlue()),".")[0]);
  UIControls.get(Textfield.class,"colorInputH").setText(splitTokens(str(currentTileColor.getHue()),".")[0]);
  UIControls.get(Textfield.class,"colorInputS").setText(splitTokens(str(currentTileColor.getSaturation()),".")[0]);
  UIControls.get(Textfield.class,"colorInputV").setText(splitTokens(str(currentTileColor.getBrightness()),".")[0]);
  UIControls.get(Textfield.class,"colorInputA").setText(splitTokens(str(currentTileColor.getAlpha()),".")[0]);
}

void drawRedGradient(){
  updateGradient(currentTileColor.getMinRed(), currentTileColor.getMaxRed());
}

void drawGreenGradient(){
  updateGradient(currentTileColor.getMinGreen(), currentTileColor.getMaxGreen());
}

void drawBlueGradient(){
  updateGradient(currentTileColor.getMinBlue(), currentTileColor.getMaxBlue());
}

void drawSaturationGradient(){
  updateGradient(currentTileColor.getMinSaturation(), currentTileColor.getMaxSaturation());
}

void drawBrightnessGradient(){
  updateGradient(currentTileColor.getMinBrightness(), currentTileColor.getMaxBrightness());
}

void updateGradient(color min_, color max_){
  tmpGradient.beginDraw();
  tmpGradient.noStroke();
  for(float i = 0; i <= 1; i+=0.02){
    tmpGradient.fill(lerpColor(min_, max_, i));
    tmpGradient.rect((i*100), 0, 2, 16);
  }
  tmpGradient.endDraw();
}

void drawAlphaGradient(){
  tmpGradient.beginDraw();
  tmpGradient.noStroke();
  tmpGradient.clear();
  tmpGradient.image(alphaBack, 0, 0);
  for(float i = 0; i <= 1; i+=0.020001){
    tmpGradient.fill(currentTileColor.getDiffAlpha(i * 255));
    tmpGradient.rect((i*100), 0, 2, 16);
  }
  tmpGradient.endDraw();
}

class tileColor{
  color COLOR;
  
  tileColor(int r_, int g_, int b_){
    COLOR = color(r_, g_, b_);
  }
  
  void setColor(color c_){
    COLOR = c_;
  }
  
  void setColorNoAlpha(color c_){
    COLOR = color(red(c_),green(c_),blue(c_),alpha(COLOR));
  }
  
  void setRed(float r_){
    COLOR = color(r_,green(COLOR),blue(COLOR),alpha(COLOR));
  }
  
  void setGreen(float g_){
    COLOR = color(red(COLOR),g_,blue(COLOR),alpha(COLOR));
  }
  
  void setBlue(float b_){
    COLOR = color(red(COLOR),green(COLOR),b_,alpha(COLOR));
  }
  
  void setHue(float h_){
    colorMode(HSB);
    COLOR = color(h_,saturation(COLOR),brightness(COLOR),alpha(COLOR));
    colorMode(RGB);
  }
  
  void setSaturation(float s_){
    colorMode(HSB);
    COLOR = color(hue(COLOR),s_,brightness(COLOR),alpha(COLOR));
    colorMode(RGB);
  }
  
  void setBrightness(float b_){
    colorMode(HSB);
    COLOR = color(hue(COLOR),saturation(COLOR),b_,alpha(COLOR));
    colorMode(RGB);
  }
  
  void setAlpha(float a_){
    COLOR = color(red(COLOR),green(COLOR),blue(COLOR),a_);
  }
  
  color getColor(){
    return COLOR;
  }
  
  float getRed(){
    return red(COLOR);
  }
  
  float getGreen(){
    return green(COLOR);
  }
  
  float getBlue(){
    return blue(COLOR);
  }
  
  float getHue(){
    return hue(COLOR);
  }
  
  float getSaturation(){
    return saturation(COLOR);
  }
  
  float getBrightness(){
    return brightness(COLOR);
  }
  
  float getAlpha(){
    return alpha(COLOR);
  }
  
  color getMinRed(){
    return color(0, green(COLOR), blue(COLOR));
  }
  
  color getMaxRed(){
    return color(255, green(COLOR), blue(COLOR));
  }
  
  color getMinGreen(){
    return color(red(COLOR), 0, blue(COLOR));
  }
  
  color getMaxGreen(){
    return color(red(COLOR), 255, blue(COLOR));
  }
  
  color getMinBlue(){
    return color(red(COLOR), green(COLOR), 0);
  }
  
  color getMaxBlue(){
    return color(red(COLOR), green(COLOR), 255);
  }
  
  color getMinSaturation(){
    colorMode(HSB);
    color tmp = color(hue(COLOR), 0, brightness(COLOR));
    colorMode(RGB);
    return tmp;
  }
  
  color getMaxSaturation(){
    colorMode(HSB);
    color tmp = color(hue(COLOR), 255, brightness(COLOR));
    colorMode(RGB);
    return tmp;
  }
  
  color getMinBrightness(){
    colorMode(HSB);
    color tmp = color(hue(COLOR), saturation(COLOR), 0);
    colorMode(RGB);
    return tmp;
  }
  
  color getMaxBrightness(){
    colorMode(HSB);
    color tmp = color(hue(COLOR), saturation(COLOR), 255);
    colorMode(RGB);
    return tmp;
  }
  
  color getDiffAlpha(float i_){
    return color(red(COLOR), green(COLOR), blue(COLOR), i_);
  }
}