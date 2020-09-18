// Hilbert Curve
// Coding in the Cabana
// The Coding Train / Daniel Shiffman
// https://thecodingtrain.com/CodingInTheCabana/003-hilbert-curve.html
// https://youtu.be/

// Processing Sketch: https://github.com/CodingTrain/website/tree/master/CodingInTheCabana/Cabana_003_Hilbert_Curve/Processing
// p5js Sketch: https://editor.p5js.org/codingtrain/sketches/LPf9PLmp


Icon icon;

/**
*/
enum Color {

  BLACK(#000000),
  WHITE(#FFFFFF),
  OBSIDIAN(#262626),
  HEMATITE(#3C3C3C),
  BASALT(#878787),
  ALUMINIMUM(#C6C6C6),
  SILVER(#F8F8F8),
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

  private Color(color hex) {
    mHex = hex;
  }
}

/**
*/
class Icon {

  HilbertCurve mHilbertCurve;
  boolean mHasBorder;

  color mBgColor;
  color mFgColor;


  Icon(boolean hasBorder, Color bgColor, Color fgColor) {
    mHasBorder = hasBorder;
    mBgColor = bgColor.getHex();
    mFgColor = fgColor.getHex();

    mHilbertCurve = new HilbertCurve(3);
  }

  void draw() {

    int vertexRowCount = mHilbertCurve.getVertexRowCount();

    float scale = 5.3; // Number to match line width with width found in branding
    int lineWidth = int((width / vertexRowCount) / scale);

    // Background
    fill(mBgColor);
    if (mHasBorder) {
      stroke(mFgColor);
      strokeWeight(lineWidth * 2);
    }
    rect(0, 0, width, height);

    PVector[] path = mHilbertCurve.getPath();

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
    stroke(mFgColor);
    strokeWeight(lineWidth);
    strokeCap(PROJECT);

    beginShape();

    for (PVector vector : path) {
      // Translate path to image space
      vector.mult(len);
      vector.add(offset, offset);
      vertex(vector.x, vector.y);
    }

    endShape();
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
