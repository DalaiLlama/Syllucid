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
import java.awt.event.KeyEvent;

final String COMPANY_NAME = "SYLLUCID";
boolean DEBUG = false;

color OBSIDIAN = #262626;
color BASALT = #878787;
color SILVER = #F8F8F8;

final int FONT_SIZE = 72;

void setup() {
  size(1024, 720);
  textFont(createFont("./Roboto/RobotoCondensed-Bold.ttf", FONT_SIZE));
  textSize(FONT_SIZE);
}

void draw() {
  background(SILVER);

  float base = height/2;

  reference(base);

  wordmark(base*2 - 20);
  //saveFrame("temp.svg");
}

void reference(float base) {
  textAlign(CENTER);
  fill(OBSIDIAN);
  text(COMPANY_NAME, 0.5*width, base);
}

void wordmark(float base) {
  float scalar = 0.8; // Different for each font
  float a = textAscent() * scalar;
  float d = textDescent() * scalar;

  boolean keepMargin = false;

  float marginLeft = FONT_SIZE*0.04; //Remove space before S
  float marginRight = FONT_SIZE*0.04; //Remove space after D
  float wordmarkWidth = keepMargin ? width : width + marginLeft + marginRight;

  int gaps = COMPANY_NAME.length()-1;

  float expandStart = keepMargin ? 0 : 0 - marginLeft;
  float spaceSize = (wordmarkWidth-textWidth(COMPANY_NAME))/gaps;
  float wordStart = width/2-textWidth(COMPANY_NAME)/2;
  float wordEnd = width/2+textWidth(COMPANY_NAME)-textWidth(COMPANY_NAME)/2;

  expandStart = map(mouseX, 0, width, wordStart, 0);
  float expandEnd = map(mouseX, 0, width, wordEnd, width);
  spaceSize = map(mouseX, 0, width, 0, width-textWidth(COMPANY_NAME))/gaps;

  if (DEBUG) {
    // Bounding box
    noStroke();
    fill(SILVER);
    rect(expandStart, base-a, expandEnd-expandStart, d+a);
    println("Height: " + (d+a), "Width: " + (expandEnd-expandStart), "Space:" + spaceSize);

    // Bounding lines
    stroke(OBSIDIAN);
    line(0, base-a, width, base-a);
    line(0, base+d, width, base+d);
    line(expandStart, 0, expandStart, height);
    line(expandEnd, 0, expandEnd, height);
  }

  textAlign(LEFT);
  textSize(FONT_SIZE);

  fill(OBSIDIAN);
  noStroke();

  float pos = expandStart;
  for(char c : COMPANY_NAME.toCharArray()) {
    if (DEBUG) {
      fill(BASALT);
      stroke(OBSIDIAN);
      rect(pos, base-a, textWidth(c), d+a);

      fill(OBSIDIAN);
      noStroke();
    }
    text(c, pos, base);
    pos += textWidth(c) + spaceSize;
  }
}

void keyPressed() {
  if (keyCode == KeyEvent.VK_D) {
    println("Ping");
    DEBUG = !DEBUG;
  }
}
