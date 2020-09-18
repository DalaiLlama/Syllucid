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
  YELLOW_LIGHT(#FFE2B3);

  private color mHex;

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

      default:
        c = BLACK;
        break;
    }

    return c;
  }

  private Color(color hex) {
    mHex = hex;
  }
}

/**
*/
class Icon {

  private static final float sScale = 5.3; // Number to match line width with width found in branding

  HilbertCurve mHilbertCurve;
  boolean mHasBorder;

  Color mBgColor;
  Color mFgColor;

  Icon(boolean hasBorder, Color bgColor, Color fgColor) {
    mHasBorder = hasBorder;
    mBgColor = bgColor;
    mFgColor = fgColor;

    mHilbertCurve = new HilbertCurve(3);
  }

  void draw() {

    int vertexRowCount = mHilbertCurve.getVertexRowCount();


    int lineWidth = int((width / vertexRowCount) / sScale);

    // Background
    fill(mBgColor.getHex());

    if (mHasBorder) {
      stroke(mFgColor.getHex());
      strokeWeight(lineWidth * 2);
    } else {
      noStroke();
    }

    rect(0, 0, width, height);

    float len = width / (vertexRowCount);
    if (mHasBorder) {
      len = width / (vertexRowCount + 1);
    }

    float offset = len/2;
    if (mHasBorder) {
      offset = len;
    }

    // Hilbert Curve
    noFill();
    stroke(mFgColor.getHex());
    strokeWeight(lineWidth);
    strokeCap(PROJECT);

    beginShape();

    PVector vOut = new PVector();

    // Translate path for image space
    for (PVector vIn : mHilbertCurve.getPath()) {
      vOut = vIn.copy();
      vOut.mult(len);
      vOut.add(offset, offset);
      vertex(vOut.x, vOut.y);
    }

    endShape();
  }

  void switchBgColor(boolean up) {
    mBgColor = mBgColor.switchColor(up);
  }

  void switchFgColor(boolean up) {
    mFgColor = mFgColor.switchColor(up);
  }

  void setOrder(int order){
    mHilbertCurve.setOrder(order < 1 ? 1 : order);
  }

  void toggleBorder() {
    mHasBorder = !mHasBorder;
  }
}

/**
*/
class HilbertCurve {

  int mOrder;
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

    int vertexCount = int(pow(mVertexRowCount, 2));

    mPath = new PVector[vertexCount];

    // Calculate position of each vertex
    for (int i = 0; i < vertexCount; i++) {
      mPath[i] = calculateVector(i);
    }
  }

  PVector[] getPath() {
    return mPath;
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

void setup() {
  size(1024, 1024);

  background(0);

  noLoop();

  icon = new Icon(false, Color.OBSIDIAN, Color.GREEN_DARK);
}

void draw() {
  background(0);

  icon.draw();
}

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
    icon.setOrder(keyCode - 48);
  } else if (keyCode == KeyEvent.VK_B) {
    icon.toggleBorder();
  }

  redraw();
}
