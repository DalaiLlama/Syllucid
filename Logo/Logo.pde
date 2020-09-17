// Hilbert Curve
// Coding in the Cabana
// The Coding Train / Daniel Shiffman
// https://thecodingtrain.com/CodingInTheCabana/003-hilbert-curve.html
// https://youtu.be/

// Processing Sketch: https://github.com/CodingTrain/website/tree/master/CodingInTheCabana/Cabana_003_Hilbert_Curve/Processing
// p5js Sketch: https://editor.p5js.org/codingtrain/sketches/LPf9PLmp

// Greens
final color GREEN_DARK = #007C67;
final color GREEN_MID = #3B9F89;
final color GREEN_LIGHT = #78C3AC;

// Yellows
final color YELLOW_DARK = #E9B671;
final color YELLOW_MID = #F4CC92;
final color YELLOW_LIGHT = #FFE2B3;

// Greys
final color OBSIDIAN = #262626;
final color HEMATITE = #3C3C3C;
final color BASALT = #878787;
final color ALUMINIMUM = #C6C6C6;
final color SILVER = #F8F8F8;
final color WHITE = #FFFFFF;

// Dimentions
final int logoWidth = 1024;
final int logoHeight = 1024;

final int HILBERT_ORDER = 3;

HilbertCurve curve;

void setup() {
  size(1024, 1024);

  background(0);

  noLoop();

  curve = new HilbertCurve(HILBERT_ORDER, GREEN_DARK);
}

void draw() {
  background(0);

  noFill();

  curve.draw();
}

/**
*/
class HilbertCurve {

  final int mOrder;
  final color mColor;
  final int mLineWidth;

  final int mVertexTotal;
  final PVector[] mPath;

  HilbertCurve(final int order, final color lineColor) {
    mOrder = order;
    mColor = lineColor;
    mLineWidth = 24;

    int vertexRowCount = int(pow(2, order));
    int vertexColumnCount = vertexRowCount;
    float len = width / vertexRowCount;

    mVertexTotal = vertexRowCount * vertexColumnCount;

    mPath = new PVector[mVertexTotal];

    // Calculate position of each vertex
    for (int i = 0; i < mVertexTotal; i++) {
      mPath[i] = calculateVector(i);
      mPath[i].mult(len);
      mPath[i].add(len/2, len/2);
    }
  }

  void draw() {
    stroke(mColor);
    strokeWeight(mLineWidth);
    strokeCap(PROJECT);

    beginShape();

    for (int i = 0; i < mVertexTotal; i++) {
      vertex(mPath[i].x, mPath[i].y);
    }

    endShape();
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
