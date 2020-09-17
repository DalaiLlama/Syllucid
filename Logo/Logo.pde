// Hilbert Curve
// Coding in the Cabana
// The Coding Train / Daniel Shiffman
// https://thecodingtrain.com/CodingInTheCabana/003-hilbert-curve.html
// https://youtu.be/

// Processing Sketch: https://github.com/CodingTrain/website/tree/master/CodingInTheCabana/Cabana_003_Hilbert_Curve/Processing
// p5js Sketch: https://editor.p5js.org/codingtrain/sketches/LPf9PLmp

// Greens
color greenDark = #007C67;
color greenMid = #3B9F89;
color greenLight = #78C3AC;

// Yellows
color yellowDark = #E9B671;
color yellowMid = #F4CC92;
color yellowLight = #FFE2B3;

// Greys
color obsidian = #262626;
color hematite = #3C3C3C;
color basalt = #878787;
color aluminium = #C6C6C6;
color silver = #F8F8F8;
color white = #FFFFFF;

int order = 9;
int N = int(pow(2, order));
int total = N * N;

PVector[] path = new PVector[total];

void setup() {
  size(1024, 1024);
  background(0);
  float len = width / N;

  for (int i = 0; i < total; i++) {
    path[i] = hilbert(i);
    path[i].mult(len);
    path[i].add(len/2, len/2);
  }

  noLoop();
}

int counter = 0;
void draw() {
  background(0);

  stroke(255);
  strokeWeight(1);
  noFill();
  beginShape();
  for (int i = 1; i < total; i++) {
    stroke(aluminium);
    line(path[i].x, path[i].y, path[i-1].x, path[i-1].y);
  }
  endShape();
}


PVector hilbert(int i) {
  PVector[] points = {
    new PVector(0, 0),
    new PVector(0, 1),
    new PVector(1, 1),
    new PVector(1, 0)
  };

  int index = i & 3;
  PVector v = points[index];

  for (int j = 1; j < order; j++) {
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
