//*****************************************************************************
// TITLE:         GEOMETRY UTILITIES IN 2D  
// DESCRIPTION:   Classes and functions for manipulating points, vectors, edges, triangles, quads, frames, and circular arcs  
// AUTHOR:        Prof Jarek Rossignac
// DATE CREATED:  September 2009
// EDITS:         Revised July 2017
//*****************************************************************************
//************************************************************************
//**** POINT CLASS
//************************************************************************
class PNT 
  { 
  float x=0,y=0; 
  
  // CREATE
  PNT () {}
  PNT (float px, float py) {x = px; y = py;};

  // MODIFY
  PNT setTo(float px, float py) {x = px; y = py; return this;};  
  PNT setTo(PNT P) {x = P.x; y = P.y; return this;}; 
  PNT translate(VCT V) {x += V.x; y += V.y; return this;}                              // P.add(V): P+=V
  PNT translate(float s, VCT V) {x += s*V.x; y += s*V.y; return this;}                 // P.add(s,V): P+=sV
  PNT translateTowardsPNT(float d, PNT F) {x+=d*(F.x-x);  y+=d*(F.y-y);  return this;};  // transalte by ratio s towards P
  PNT dilateWrtPNT(float s, PNT F) {x=F.x+s*(x-F.x); y=F.y+s*(y-F.y); return this;}    // P.scale(s,C): scales wrt C: P=L(C,P,s);
  //PNT rotateWrtPNT(float a, PNT F) {float dx=x-F.x, dy=y-F.y, c=cos(a), s=sin(a); x=F.x+c*dx+s*dy; y=F.y-s*dx+c*dy; return this;};   // P.rotate(a,G): rotate P around G by angle a in radians
  PNT rotateWrtPNT(float a, PNT F) {float dx=x-F.x, dy=y-F.y, c=cos(a), s=sin(a); x=F.x+c*dx-s*dy; y=F.y+s*dx+c*dy; return this;};
  PNT moveWithMouse() { x += mouseX-pmouseX; y += mouseY-pmouseY;  return this;}; 

  // for computing centroid of vertices or of polygons
  PNT add(PNT P) {x += P.x; y += P.y; return this;};                              // incorrect notation, but useful for computing weighted averages
  PNT add(float s, PNT P)   {x += s*P.x; y += s*P.y; return this;};               // adds s*P
  PNT add(float s, VCT V)   {x += s*V.x; y += s*V.y; return this;};               // adds s*V
  PNT mul(float f) {x*=f; y*=f; return this;};
  PNT translateTowardsByRatio(float s, PNT P) {x+=s*(P.x-x);  y+=s*(P.y-y); return this;};  // transalte by ratio s towards P
  PNT translateTowardsByDistance(float s, PNT P) {VCT V=U(this,P); add(s,V); return this;};  // transalte by ratio s towards P
  PNT divideBy(float s) {x/=s; y/=s; return this;}                                  // P.scale(s): P*=s
     
  // DRAW 
  PNT v() {vertex(x,y); return this;};  // used for drawing polygons between beginShape(); and endShape();
  PNT show(float r) {ellipse(x, y, 2*r, 2*r); return this;}; // shows point as disk of radius r
  PNT show() {show(3); return this;}; // shows point as small dot
  PNT label(String s, VCT V) {fill(black); text(s, x+V.x, y+V.y); noFill(); return this; };
  PNT label(String s) {label(s,5,4); return this; };
  PNT label(String s, float u, float v) {fill(black); text(s, x+u, y+v); noFill(); return this; };
  void circledLabel(String S) {circledLabel(S,black);}
  void circledLabel(String S, color c)
      {
      float h = 14;
      float w = textWidth(S)*0.6;
      cwf(c,2,white); 
      ellipse(x, y, 2*max(w,h), 2*h);
      f(c); 
      text(S,x,y); 
      noFill();
      }

  // for debugging
  PNT write() {print("("+x+","+y+")"); return this;};  // writes point coordinates in text window
  
  
  } // end of PNT class


//************************************************************************
//**** VECTOR CLASS
//************************************************************************
class VCT 
  { 
  float x=0,y=0; 
  
 // CREATE
  VCT () {};
  VCT (float px, float py) {x = px; y = py;};
 
 // MODIFY
  VCT setTo(float px, float py) {x = px; y = py; return this;}; 
  VCT setTo(VCT V) {x = V.x; y = V.y; return this;}; 
  VCT zero() {x=0; y=0; return this;}
  VCT scaleBy(float u, float v) {x*=u; y*=v; return this;};
  VCT scaleBy(float f) {x*=f; y*=f; return this;};
  VCT reverse() {x=-x; y=-y; return this;};
  VCT divideBy(float f) {x/=f; y/=f; return this;};
  VCT normalize() {float n=sqrt(sq(x)+sq(y)); if (n>0.000001) {x/=n; y/=n;}; return this;};
  VCT add(float u, float v) {x += u; y += v; return this;};
  VCT add(VCT V) {x += V.x; y += V.y; return this;};   
  VCT add(float s, VCT V) {x += s*V.x; y += s*V.y; return this;};   
  VCT rotateBy(float a) {float xx=x, yy=y; x=xx*cos(a)-yy*sin(a); y=xx*sin(a)+yy*cos(a); return this;};
  VCT left() {float m=x; x=-y; y=m; return this;};
 
  // OUTPUT VEC
  VCT clone() {return(new VCT(x,y));}; 

  // OUTPUT TEST MEASURE
  float norm() {return(sqrt(sq(x)+sq(y)));}
  boolean isNull() {return((abs(x)+abs(y)<0.000001));}
  float angle() {return(atan2(y,x)); }

  // DRAW, PRINT
  void write() {println("<"+x+","+y+">");};
  void showAt (PNT P) {line(P.x,P.y,P.x+x,P.y+y); }; 
  void showArrowFrom (PNT P) 
      {
      line(P.x,P.y,P.x+x,P.y+y); 
      float n=min(this.norm()/10.,height/50.); 
      PNT Q=P(P,this); 
      VCT U = V(-n,U(this));
      VCT W = V(.3,R(U)); 
      beginShape(); Q.translate(U).translate(W).v(); Q.v(); Q.translate(U).translate(M(W)).v(); endShape(CLOSE); 
      }
      
  void label(String s, PNT P) {P(P).translate(0.5,this).translate(3,R(U(this))).label(s); };

  } // end VCT class


//************************************************************************
//**** POINTS FUNCTIONS
//************************************************************************
// create 
PNT P() {return P(0,0); };                                                                            // make point (0,0)
PNT P(float x, float y) {return new PNT(x,y); };                                                       // make point (x,y)
PNT P(PNT P) {return P(P.x,P.y); };                                                                    // make copy of point A

// measure 
float d(PNT P, PNT Q) {return sqrt(d2(P,Q));  };                                                       // ||AB|| (Distance)
float d2(PNT P, PNT Q) {return sq(Q.x-P.x)+sq(Q.y-P.y); };                                             // AB*AB (Distance squared)
boolean isSame(PNT A, PNT B) {return (A.x==B.x)&&(A.y==B.y) ;}                                         // A==B
boolean isSame(PNT A, PNT B, float e) {return d2(A,B)<sq(e);}                                          // |AB|<e

// transform 
PNT R(PNT Q, float a) {float dx=Q.x, dy=Q.y, c=cos(a), s=sin(a); return new PNT(c*dx+s*dy,-s*dx+c*dy); };  // Q rotated by angle a around the origin
PNT R(PNT Q, float a, PNT C) {float dx=Q.x-C.x, dy=Q.y-C.y, c=cos(a), s=sin(a); return P(C.x+c*dx-s*dy, C.y+s*dx+c*dy); };  // Q rotated by angle a around point C
PNT P(PNT P, VCT V) {return P(P.x + V.x, P.y + V.y); }                                                 //  P+V (P transalted by vector V)
PNT P(PNT P, float s, VCT V) {return P(P,V(s,V)); }                                                    //  P+sV (P transalted by sV)
PNT P(PNT Q, float u, VCT U, float v, VCT V) {return P(P(Q,u,U),v,V); }                                                    //  P+sV (P transalted by sV)
PNT MoveByDistanceTowards(PNT P, float d, PNT Q) { return P(P,d,U(V(P,Q))); };                          //  P+dU(PQ) (transLAted P by *distance* s towards Q)!!!

// average 
PNT P(PNT A, PNT B) {return P((A.x+B.x)/2.0,(A.y+B.y)/2.0); };                                          // (A+B)/2 (average)
PNT P(PNT A, PNT B, PNT C) {return P((A.x+B.x+C.x)/3.0,(A.y+B.y+C.y)/3.0); };                            // (A+B+C)/3 (average)
PNT P(PNT A, PNT B, PNT C, PNT D) {return P(P(A,B),P(C,D)); };                                            // (A+B+C+D)/4 (average)

// weighted average 
PNT P(float a, PNT A) {return P(a*A.x,a*A.y);}                                                         // aA (used to collect weighted average) 
PNT P(float a, PNT A, float b, PNT B) {return P(a*A.x+b*B.x,a*A.y+b*B.y);}                              // aA+bB, (assumes a+b=1) 
PNT P(float a, PNT A, float b, PNT B, float c, PNT C) {return P(a*A.x+b*B.x+c*C.x,a*A.y+b*B.y+c*C.y);}   // aA+bB+cC, (assumes a+b+c=1) 
PNT P(float a, PNT A, float b, PNT B, float c, PNT C, float d, PNT D){return P(a*A.x+b*B.x+c*C.x+d*D.x,a*A.y+b*B.y+c*C.y+d*D.y);} // aA+bB+cC+dD (assumes a+b+c+d=1)
     
// display 
void show(PNT P, float r) {ellipse(P.x, P.y, 2*r, 2*r);};                                               // draws circle of center r around P
void show(PNT P) {ellipse(P.x, P.y, 6,6);};                                                             // draws small circle around point
void label(PNT P, String S) {text(S, P.x,P.y); }                                                         // writes string S next to P on the screen ( for example label(P[i],str(i));)
void circledLabel(PNT P, String S) {P.circledLabel(S);}                                                         // writes string S next to P on the screen ( for example label(P[i],str(i));)
void showId(PNT P, String S) {fill(white); show(P,13); fill(black); label(P,S);}                         // sows disk with S written inside
void vert(PNT P) {vertex(P.x,P.y);};                                                                        // vertex for drawing polygons between beginShape() and endShape()
void vert(PNT P, float u, float v) {vertex(P.x,P.y,u,v);};                                                    // vertex for drawing polygons between beginShape() and endShape()
void show(PNT P, PNT Q) {line(P.x,P.y,Q.x,Q.y); };                                                      // draws edge (P,Q)
void show(PNT A, PNT B, PNT C)  {beginShape();  A.v(); B.v(); C.v(); endShape();}                  // render quad A, B, C, D
void show(PNT A, PNT B, PNT C, PNT D)  {beginShape();  A.v(); B.v(); C.v(); D.v(); endShape();}      // render quad A, B, C, D
void showLoop(PNT A, PNT B, PNT C)  {beginShape();  A.v(); B.v(); C.v(); endShape(CLOSE);}                   // render triangle A, B, C
void showLoop(PNT A, PNT B, PNT C, PNT D)  {beginShape();  A.v(); B.v(); C.v(); D.v(); endShape(CLOSE);}      // render quad A, B, C, D
void arrow(PNT P, PNT Q) {show(P,V(P,Q)); }                                                              // draws arrow from P to Q




//************************************************************************
//**** VECTOR FUNCTIONS
//************************************************************************

// create 
VCT V() {return new VCT(0,0); };                                                             // make copy of vector V
VCT V(VCT V) {return new VCT(V.x,V.y); };                                                             // make copy of vector V
VCT V(PNT P) {return new VCT(P.x,P.y); };                                                              // make vector from origin to P
VCT V(float x, float y) {return new VCT(x,y); };                                                      // make vector (x,y)
VCT V(PNT P, PNT Q) {return new VCT(Q.x-P.x,Q.y-P.y);};                                                 // PQ (make vector Q-P from P to Q

// transformed 
VCT R(VCT V) {return new VCT(-V.y,V.x);};                                                             // V turned right 90 degrees (as seen on screen)
VCT R(VCT V, float a) { return V(cos(a),V,sin(a),R(V)); }                                           // V rotated by angle a in radians

// weighted sum 
VCT M(VCT V) { return V(-V.x,-V.y); }                                                                 // -V
VCT V(float s,VCT V) {return V(s*V.x,s*V.y);}                                                      // sV
VCT V(VCT U, VCT V) {return V(U.x+V.x,U.y+V.y);}                                                   // U+V 
VCT V(VCT U,float s,VCT V) {return V(U,V(s,V));}                                                   // U+sV
VCT V(float u, VCT U, float v, VCT V) {return V(V(u,U),V(v,V));}                                   // uU+vV ( Linear combination)

// measures 
float n(VCT V) {return sqrt(dot(V,V));};                                                               // n(V): ||V|| (norm: length of V)
float angle (VCT U, VCT V) {return atan2(det(U,V),dot(U,V)); };                                   // angle <U,V> (between -PI and PI)
float dot(VCT U, VCT V) {return U.x*V.x+U.y*V.y; }                                                     // dot(U,V): U*V (dot product U*V)
float det(VCT U, VCT V) {return dot(R(U),V); }                                                         // det | U V | = scalar cross UxV 

// Unit vectors 
VCT U(VCT V) {float n = n(V); if (n==0) return new VCT(0,0); else return new VCT(V.x/n,V.y/n);};      // V/||V|| (Unit vector : normalized version of V)
VCT U(PNT P, PNT Q) {return U(V(P,Q));};                                                                // PQ/||PQ| (Unit vector : from P towards Q)

// Linear interpolation of vectors
VCT L(VCT A, float t, VCT B) {return V(A.x+t*(B.x-A.x),A.y+t*(B.y-A.y));}
VCT L(float a, VCT A, float b, VCT B, float t) {return L(A,(t-a)/(b-a),B);}
VCT L(float a, VCT A, float b, VCT B, float c, VCT C, float t) {return L(a,L(a,A,b,B,t),c,L(b,B,c,C,t),t);}

// LPM (Log-Polar Morph) interpolating between two vectors
VCT S(VCT U, float s, VCT V) // steady interpolation from U to V
  {
  float a = angle(U,V); 
  VCT W = R(U,s*a); 
  float u = n(U), v=n(V); 
  return V(pow(v/u,s),W); 
  } 
VCT S(float a, VCT A, float b, VCT B, float t) {return S(A,(t-a)/(b-a),B);}
VCT S(float a, VCT A, float b, VCT B, float c, VCT C, float t) {return S(a,S(a,A,b,B,t),c,S(b,B,c,C,t),t);}


// advanced measures 
float n2(VCT V) {return sq(V.x)+sq(V.y);};                                                             // n2(V): V*V (norm squared)
boolean parallel (VCT U, VCT V) {return dot(U,R(V))==0; }; 
float angle(VCT V) {return(atan2(V.y,V.x)); };                                                       // angle between <1,0> and V (between -PI and PI)
float angle(PNT A, PNT B, PNT C) {return  angle(V(B,A),V(B,C)); }                                       // angle <BA,BC>
float turnAngle(PNT A, PNT B, PNT C) {return  angle(V(A,B),V(B,C)); }                                   // angle <AB,BC> (positive when right turn as seen on screen)
int toDeg(float a) {return int(a*180/PI);}                                                           // convert radians to degrees
float toRad(float a) {return(a*PI/180);}                                                             // convert degrees to radians 
float positive(float a) { if(a<0) return a+TWO_PI; else return a;}                                   // adds 2PI to make angle positive

// display 
void edge(PNT P, VCT V) {line(P.x,P.y,P.x+V.x,P.y+V.y); }                                              // show V as line-segment from P 
void edge(PNT P, float s, VCT V) {edge(P,V(s,V));}                                                     // show sV as line-segment from P 
void show(PNT P, float s, VCT V) {show(P,V(s,V));}                                                   // show sV as arrow from P 
void show(PNT P, VCT V, String S) {show(P,V); P(P(P,0.70,V),15,R(U(V))).label(S);}       // show V as arrow from P and print string S on its side
void show(PNT P, VCT V, color c, String S) {cwf(c,1,c); show(P,V); P(P(P,0.70,V),15,R(U(V))).label(S);}       // show V as arrow from P and print string S on its side
void show(PNT P, VCT V, color c) {cwf(c,1,c); show(P,V); }       // show V as arrow from P and print string S on its side
void show(PNT P, VCT V) 
  {
  float n=n(V); 
  if(n<0.001) return;  // too short a vector
  // otherwise continue
     float s=max(min(0.1,20./n),6./n)/2;       // show V as arrow from P 
     //show(P,V);      
     PNT Q=P(P,V); 
     PNT H = P(Q,-s*4,V);
     VCT W = R(V); 
     PNT R = P(H,s,W), L = P(H,-s,W);
     show(P,s*n/2);
     showLoop(Q,R,L);
     PNT Re = P(P,s/2,W), Le = P(P,-s/2,W);
     showLoop(Q,Re,Le);
  } 
void showThin(PNT P, VCT V) 
  {
  edge(P,V);  
  float n=n(V); 
  if(n<0.01) return;  // too short a vector
  // otherwise continue
     float s=max(min(0.2,20./n),6./n);       // show V as arrow from P 
     PNT Q=P(P,V); 
     VCT U = V(-s,V); 
     VCT W = R(V(.3,U)); 
     beginShape(); 
       vert(P(P(Q,U),W)); 
       vert(Q); 
       vert(P(P(Q,U),-1,W)); 
     endShape(CLOSE);
  } 


// projection of point onto a line throgh two points
boolean projectsBetween(PNT P, PNT A, PNT B) {return dot(V(A,P),V(A,B))>0 && dot(V(B,P),V(B,A))>0 ; };
PNT projectionOnLine(PNT P, PNT A, PNT B) {return P(A,dot(V(A,B),V(A,P))/dot(V(A,B),V(A,B)),V(A,B));}

// reflection
VCT Reflection(VCT V, VCT N) { return V(V,-2.*dot(V,N),N);};                                          // reflection OF V wrt unit normal vector N

//************************************************************************
//**** MOUSE AND SCREEN
//************************************************************************
PNT ScreenCenter() {return P(width/2,height/2);}                                                        //  point in center of  canvas
PNT Mouse() {return P(mouseX,mouseY);};                                                                 // returns point at current mouse location
PNT Pmouse() {return P(pmouseX,pmouseY);};                                                              // returns point at previous mouse location
VCT MouseDrag() {return new VCT(mouseX-pmouseX,mouseY-pmouseY);};                                      // vector representing recent mouse displacement

PNT Start = P(); // start point of pointer shown on screen towards the mouse
PNT End = P();
void showPointer() // shows pointer to current mouse location, which key is pressed, and whether mouse is pressed (useful for demos and videos)
  {
  End = P(Mouse(),1,V(-2,3));
  Start = P(End,100,U(End,Start)); 
  if (mousePressed) {cwf(grey,0,grey); show(Start,20);}
  cwf(grey,5,grey); arrow(Start,End);
  if (keyPressed) Start.circledLabel(str(key));
  }


PNT StartClip=P(), EndClip=P();
void showTextFromClipBoard()                   // writes content of clipboard onto the canvas at start of current arrow
  {
  if(MyText.length()>0) 
    {
    cwf(dred,5,dred); 
    arrow(StartClip,EndClip); 
    writeWrappedText(MyText, P(StartClip,V(0,30)), 24, 300);
    }
  }
  
