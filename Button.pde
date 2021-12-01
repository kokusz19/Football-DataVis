/**
 * Button. 
 * 
 * Click on one of the colored shapes in the 
 * center of the image to change the color of 
 * the background. 
 */
 class Button{
  int rectX, rectY;      // Position of square button
  int rectXSize, rectYSize;     // Diameter of rect
  color currentColor, baseColor, selectedColor, highlightColor;
  boolean rectOver = false;
  String text;
  int TEXT_SIZE = 20;

  Button(int x, int y, int x2, int y2){
    this(x, y, x2, y2, "");
  }

  Button(int x, int y, int x2, int y2, String tText){
    rectX = x;
    rectY = y;
    rectXSize = x2;
    rectYSize = y2;
    currentColor = baseColor = color(185);
    highlightColor = color(200);
    selectedColor = color(230);
    text = tText;
  }

  void update() {
    if (mouseX == 0 && mouseY == 0);
    else if ( overRect(rectX, rectY, (rectXSize-rectX), (rectYSize-rectY)) ) {
      rectOver = true;
      currentColor = highlightColor;
    } else {
      rectOver = false;
      currentColor = baseColor;
    }
    textAlign(CENTER, CENTER);
    textSize(TEXT_SIZE);
    fill(0);
    text(text, this.rectX+(this.rectXSize-this.rectX)/2, this.rectY+(this.rectYSize-this.rectY)/2);
  }
    
  boolean overRect(int x, int y, int width, int height)  {
    if (mouseX >= x && mouseX <= x+width && 
        mouseY >= y && mouseY <= y+height) {
      return true;
    } else {
      return false;
    }
  }

  void label(String s){
    text = s;
  }
}
