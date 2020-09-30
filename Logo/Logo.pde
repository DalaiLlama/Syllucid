/*
 * Copyright (C) 2020 Syllucid B.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// Code originally taken from https://thecodingtrain.com/CodingInTheCabana/003-hilbert-curve.html

import java.awt.event.KeyEvent;

/**
 * Enum handling all colour related activities.
 */
enum Color {

  BLACK(#000000),
  OBSIDIAN(#262626),
  HEMATITE(#3C3C3C),
  BASALT(#878787),
  ALUMINIMUM(#C6C6C6),
  SILVER(#F8F8F8),
  WHITE(#FFFFFF),
  GREEN_DARK(#007C67),
  GREEN_MID(#3B9F89),
  GREEN_LIGHT(#78C3AC),
  YELLOW_DARK(#E9B671),
  YELLOW_MID(#F4CC92),
  YELLOW_LIGHT(#FFE2B3),
  TRANSPARENT(#FFFFFF);

  private color mHex;

  private Color(color hex) {
    mHex = hex;
  }

  color getHex() {
    return mHex;
  }

  Color switchColor(boolean increment) {
    Color c;

    switch(this) {
      case BLACK:
        c = increment ? OBSIDIAN : YELLOW_LIGHT;
        break;

      case OBSIDIAN:
        c = increment ? HEMATITE : BLACK;
        break;

      case HEMATITE:
        c = increment ? BASALT : OBSIDIAN;
        break;

      case BASALT:
        c = increment ? ALUMINIMUM : HEMATITE;
        break;

      case ALUMINIMUM:
        c = increment ? SILVER : BASALT;
        break;

      case SILVER:
        c = increment ? WHITE : ALUMINIMUM;
        break;

      case WHITE:
        c = increment ? GREEN_DARK : SILVER;
        break;

      case GREEN_DARK:
        c = increment ? GREEN_MID : WHITE;
        break;

      case GREEN_MID:
        c = increment ? GREEN_LIGHT : GREEN_DARK;
        break;

      case GREEN_LIGHT:
        c = increment ? YELLOW_DARK : GREEN_MID;
        break;

      case YELLOW_DARK:
        c = increment ? YELLOW_MID : GREEN_LIGHT;
        break;

      case YELLOW_MID:
        c = increment ? YELLOW_LIGHT : YELLOW_DARK;
        break;

      case YELLOW_LIGHT:
        c = increment ? BLACK : YELLOW_MID;
        break;

      case TRANSPARENT:
      default:
        c = TRANSPARENT;
        break;
    }

    return c;
  }

  Color getGradientColor(boolean startColor) {
    Color c;

    switch(this) {
      case BLACK:
      case OBSIDIAN:
      case HEMATITE:
      case BASALT:
      case ALUMINIMUM:
      case SILVER:
      case WHITE:
        c = startColor ? ALUMINIMUM : OBSIDIAN;
        break;

      case GREEN_DARK:
      case GREEN_MID:
      case GREEN_LIGHT:
        c = startColor ? GREEN_LIGHT : GREEN_DARK;
        break;

      case YELLOW_DARK:
      case YELLOW_MID:
      case YELLOW_LIGHT:
        c = startColor ? YELLOW_LIGHT : YELLOW_DARK;
        break;

      default:
        c = startColor ? ALUMINIMUM : OBSIDIAN;
        break;
    }

    return c;
  }

  /**
   * Convert enum name to something resembling camel case.
  */
  @Override
  public String toString(){
    return this.name().substring(0, 1).toUpperCase() + this.name().substring(1).toLowerCase();
  }
}

/**
 * Class managing the logo composition.
 */
class Icon {

  private static final float sScale = 5.3; // Number to match line width with width found in branding
  private static final float sSocialMediaScale = 0.85; // Number to match icon size found in branding

  PGraphics mLayerDisplay;
  PGraphics mLayerBg;
  PGraphics mLayerFg;
  PGraphics mHilbertMask;

  PGraphics mLayerFgScaled;
  PGraphics mHilbertMaskScaled;

  HilbertCurve mHilbertCurve;

  boolean mHasBorder;
  boolean mSave;
  boolean mForSocialMedia;

  Color mBgColor;
  boolean mBgGradient;

  Color mFgColor;
  boolean mFgGradient;

  Icon(boolean hasBorder, Color bgColor, Color fgColor) {
    mLayerDisplay = initLayer(false);
    mLayerBg = initLayer(false);
    mLayerFg = initLayer(false);
    mHilbertMask = initLayer(false);

    mLayerFgScaled = initLayer(true);
    mHilbertMaskScaled = initLayer(true);

    mHilbertCurve = new HilbertCurve(3);

    mHasBorder = hasBorder;
    mSave = false;
    mForSocialMedia = false;

    mBgColor = bgColor;
    mBgGradient = false;

    mFgColor = fgColor;
    mFgGradient = false;
  }

  void draw(boolean animate) {

    drawLayerBg();

    drawLayerFg(animate);

    compositeLayers();

    //Render to display
    image(mLayerDisplay, 0, 0);

    if (mSave) {
      String fileName = icon.getFileName();
      print("Saving: " + fileName + "\n");
      mLayerDisplay.save(fileName);
    }
  }

  void setOrder(int order){
    mHilbertCurve.setOrder(order < 1 ? 1 : order);
  }

  void switchBgColor(boolean up) {
    mBgColor = mBgColor.switchColor(up);
  }

  void switchFgColor(boolean up) {
    mFgColor = mFgColor.switchColor(up);
  }

  void toggleBorder() {
    mHasBorder = !mHasBorder;
  }

  void toggleSave() {
    mSave = !mSave;
    print("Save: ", mSave, "\n");
  }

  void toggleTransparency() {
    if (Color.TRANSPARENT.equals(mBgColor)) {
      mBgColor = Color.OBSIDIAN;
    } else {
      mBgColor = Color.TRANSPARENT;
    }
    print("Background: " + mBgColor + "\n");
  }

  void toggleBgGradient() {
    mBgGradient = !mBgGradient;
    print("BgGradient: " + mBgGradient, "\n");
  }

  void toggleFgGradient() {
    mFgGradient = !mFgGradient;
    print("FgGradient: " + mFgGradient, "\n");
  }

  void toggleSocialMedia() {
    mForSocialMedia = !mForSocialMedia;
    print("Social Media: " + mForSocialMedia, "\n");
  }

  private PGraphics initLayer(boolean scaled) {
    int w = scaled ? int((pow(2 * pow(width, 2), 0.5)/2) * sSocialMediaScale) : width;
    int h = scaled ? w : height;

    return createGraphics(w, h);
  }

  private void drawLayerBg() {
    mLayerBg.beginDraw();
    mLayerBg.clear();

    if (mBgColor == Color.TRANSPARENT) {
      mLayerBg.noStroke();
      mLayerBg.fill(0, 0);
      mLayerBg.rect(0, 0, width, height);
    } else {
      if(mBgGradient) {
        // Stroke
        for (int i = 0; i < width; i++) {
          color colorStart = mBgColor.getGradientColor(true).getHex();
          color colorEnd = mBgColor.getGradientColor(false).getHex();

          mLayerBg.stroke(lerpColor(colorStart, colorEnd, map(i, 0, width, 0, 1)));
          mLayerBg.line(i, 0, i, height);
        }
        mLayerBg.noFill();
      } else {
        mLayerBg.noStroke();
        mLayerBg.fill(mBgColor.getHex());
        mLayerBg.rect(0, 0, width, height);
      }
    }

    mLayerBg.endDraw();
  }

  private void drawLayerFg(boolean animate) {
    PGraphics layer = mForSocialMedia ? mLayerFgScaled : mLayerFg;

    layer.beginDraw();
    layer.clear();

    if(mFgGradient) {
      layer.noFill();
      for (int i = 0; i < layer.width; i++) {
        color colorStart = mFgColor.getGradientColor(true).getHex();
        color colorEnd = mFgColor.getGradientColor(false).getHex();

        layer.stroke(lerpColor(colorStart, colorEnd, map(i, 0, layer.width, 0, 1)));
        layer.line(i, 0, i, layer.height);
      }
    } else {
      layer.noStroke();
      layer.fill(mFgColor.getHex());
      layer.rect(0, 0, layer.width, layer.height);
    }

    layer.mask(createHilbertMask(animate));

    layer.endDraw();
  }

  private void compositeLayers() {
    mLayerDisplay.beginDraw();
    mLayerDisplay.clear();

    mLayerDisplay.image(mLayerBg, 0, 0);

    if (mForSocialMedia) {
      int pos = (mLayerDisplay.width/2)-mLayerFgScaled.width/2;
      mLayerDisplay.image(mLayerFgScaled, pos, pos, mLayerFgScaled.width, mLayerFgScaled.height);
    } else {
      mLayerDisplay.image(mLayerFg, 0, 0);
    }

    mLayerDisplay.endDraw();
  }

  /**
   * To correctly display the foreground colour gradient, a mask of the pattern must be used.
   */
  private PGraphics createHilbertMask(boolean animate) {
    PGraphics mask = mForSocialMedia ? mHilbertMaskScaled : mHilbertMask;
    mask.beginDraw();
    mask.clear();

    //Calcualte line parameters
    int vertexRowCount = mHilbertCurve.getVertexRowCount();

    int lineWidth = int((mask.width / vertexRowCount) / sScale);
    int lineLenght = mask.width / (vertexRowCount + (mHasBorder ? 1 : 0));

    float offset = mHasBorder ? lineLenght : lineLenght/2;

    //Border
    if (mHasBorder) {
      mask.stroke(255);
      mask.strokeWeight(lineWidth * 2);
    } else {
      mask.noStroke();
    }
    mask.fill(0, 0);
    mask.rect(0, 0, mask.width, mask.height);

    // Hilbert Curve
    mask.stroke(255);
    mask.strokeWeight(lineWidth);
    mask.strokeCap(PROJECT);

    mask.noFill();

    mask.beginShape();

    PVector vOut = new PVector();

    // Translate path for image space
    int count = 0;
    for (PVector vIn : mHilbertCurve.getPath()) {
      vOut = vIn.copy();
      vOut.mult(lineLenght);
      vOut.add(offset, offset);
      mask.vertex(vOut.x, vOut.y);
      if (animate && frameCount <= count++) {
        break;      
      }
    }

    mask.endShape();

    mask.endDraw();

    return mask;
  }

  private String getFileName() {
    StringBuilder fileName = new StringBuilder();

    //Order
    fileName.append("Order" + String.valueOf(mHilbertCurve.getOrder()));

    fileName.append("-");

    if (mForSocialMedia) {
      fileName.append("SocialMedia-");
    }

    //Colours
    //Background Colour
    fileName.append("Bg_");
    if (mBgGradient) {
      fileName.append(mBgColor.getGradientColor(true) + "_to_" + mBgColor.getGradientColor(false));
    } else {
      fileName.append(String.valueOf(mBgColor));
    }

    fileName.append("-");

    //Foreground colour
    fileName.append("Fg_");
    if (mFgGradient) {
      fileName.append(mFgColor.getGradientColor(true) + "_to_" + mFgColor.getGradientColor(false));
    } else {
      fileName.append(String.valueOf(mFgColor));
    }

    fileName.append("-");

    //Size
    fileName.append(String.valueOf(width) + "x" + String.valueOf(height));
    
    //Frame
    if (mAnimate) {
      fileName.append("-" + String.format("%03d", frameCount));
    }

    //File type
    fileName.append(".png");

    return fileName.toString();
  }
}

/**
 *
 */
class HilbertCurve {

  int mOrder;
  int mVertexCount;
  int mVertexRowCount;
  PVector[] mPath;

  HilbertCurve(final int order) {
    setOrder(order);
  }

  int getOrder() {
    return mOrder;
  }

  void setOrder(int order) {
    mOrder = order;

    mVertexRowCount = int(pow(2, order));

    mVertexCount = int(pow(mVertexRowCount, 2));

    mPath = new PVector[mVertexCount];

    // Calculate position of each vertex
    for (int i = 0; i < mVertexCount; i++) {
      mPath[i] = calculateVector(i);
    }
  }

  PVector[] getPath() {
    return mPath;
  }

  int getVertexCount() {
    return mVertexCount;
  }

  int getVertexRowCount() {
    return mVertexRowCount;
  }

  private PVector calculateVector(int i) {

    final PVector[] points = {
      new PVector(0, 0),
      new PVector(0, 1),
      new PVector(1, 1),
      new PVector(1, 0)
    };

    int index = i & 3;
    PVector v = points[index];

    for (int j = 1; j < mOrder; j++) {
      i = i >>> 2;
      index = i & 3;
      float len = pow(2, j);
      if (index == 0) {
        float temp = v.x;
        v.x = v.y;
        v.y = temp;
      } else if (index == 1) {
        v.y += len;
      } else if (index == 2) {
        v.x += len;
        v.y += len;
      } else if (index == 3) {
        float temp = len - 1 - v.x;
        v.x = len - 1 - v.y;
        v.y = temp;
        v.x += len;
      }
    }

    return v;
  }
}

Icon icon;
boolean mAnimate = false;

/**
 *
 */
void setup() {
  size(1024, 1024);

  noFill();
  
  if (mAnimate) {
    frameRate(10);  
  } else {
    noLoop();
  }

  icon = new Icon(true, Color.OBSIDIAN, Color.GREEN_DARK);
}

/**
 *
 */
void draw() {
  clear();
  icon.draw(mAnimate);
}

/**
 *
 */
void keyPressed() {
  if (key == CODED) {
    switch(keyCode) {
      case UP:
        icon.switchBgColor(true);
        break;

      case DOWN:
        icon.switchBgColor(false);
        break;

      case LEFT:
        icon.switchFgColor(false);
        break;

      case RIGHT:
        icon.switchFgColor(true);
        break;

      default:
        break;
    }
  } else if (keyCode >= KeyEvent.VK_1 && keyCode <= KeyEvent.VK_9) {
    // Hilbert Order 1 to 9
    icon.setOrder(keyCode - 48);
  } else if (keyCode == KeyEvent.VK_B) {
    icon.toggleBorder();
  } else if (keyCode == KeyEvent.VK_G) {
    icon.toggleBgGradient();
  } else if (keyCode == KeyEvent.VK_H) {
    icon.toggleFgGradient();
  } else if (keyCode == KeyEvent.VK_M) {
    icon.toggleSocialMedia();
  } else if (keyCode == KeyEvent.VK_S) {
    icon.toggleSave();
  } else if (keyCode == KeyEvent.VK_T) {
    icon.toggleTransparency();
  }

  redraw();
}
