int arrowCountMax = 9;
int arrowCount = 0;
ARROW [] Arrow = new ARROW[arrowCountMax];

void declareArrows() {for(int i=0; i<arrowCountMax; i++) Arrow[i] = new ARROW();}

void makeArrows(PNTS ControlPoints)
  {
  arrowCount = 0;
  int i=0, j=0;
  while(ControlPoints.pointCount>i+1)
    {
    Arrow[j++] = Arrow(ControlPoints.Point(i),ControlPoints.Point(i+1)); 
    i+=2;
    arrowCount++;
    }
  }
  
void updateArrows(PNTS ControlPoints)
  {
  int i=0, j=0;
   while(j<arrowCount && ControlPoints.pointCount>i+1)
    {
    Arrow[j++].update(ControlPoints.Point(i),ControlPoints.Point(i+1)); 
    i+=2;
    }
  }

void setPointsToArrows(PNTS ControlPoints)
  {
  ControlPoints.empty();
  for(int j=0; j<arrowCount; j++)
    {
    ControlPoints.addPoint(Arrow[j].rP());
    ControlPoints.addPoint(Arrow[j].rQ());
    }
  }

 
void showArrows()
  {
  COLOR_RAMP CR = new COLOR_RAMP(arrowCount);
  for(int i=0; i<arrowCount; i++) show(Arrow[i],CR.col(i));
  }

void showArrowIDs()
  {
  cwf(black,1,black);
  for(int i=0; i<arrowCount; i++) circledLabel(Arrow[i].rP(),str(i));
  }

void saveControlArrows(String fn) 
  {
  println("Saving: "+arrowCount+" arrows to "+fn); 
  String [] inppts = new String [arrowCount+1];
  int s=0;
  inppts[s++]=str(arrowCount);
  for (int i=0; i<arrowCount; i++) {inppts[s++]=Arrow[i].arrowToString();}
  saveStrings(fn,inppts);
  };


void loadControlArrows(String fn) 
  {
  print("Reading arrows from "+fn); 
  String [] ss = loadStrings(fn);
  String subpts;
  int s=0;   int comma, comma1, comma2;   float x, y;   int a, b, c;
  arrowCount = int(ss[s++]); 
  for(int k=0; k<arrowCount; k++) {
    int i=k+s; 
    float[] vals = float(split(ss[i],','));
    Arrow[k].set(vals[0],vals[1],vals[2],vals[3]);
    };
  println(" ... Loaded: "+arrowCount+" arrows."); 
  }; 


class ARROW 
  {
  PNT P = P(0,0);
  float m=1;
  float w=0; 
  boolean showWinding = true;

  // CREATE methods
  ARROW() {}
  ARROW(PNT Q, float pm, float pw) {P=P(Q); m=pm; w=pw;}
  ARROW(PNT Q, VCT V) {P=P(Q); m=n(V); w=angle(V); if(m<0) {m=abs(m); w+=PI/2;} }
  ARROW(PNT Q, PNT R) {P=P(Q); VCT V=V(Q,R); m=n(V); w=angle(V);}

  // SET and UPDATE methods
  ARROW translate(VCT V) {P.translate(V); return this;}
  ARROW rotate(float pw) {w+=pw;  return this;}
  ARROW scale(float pm) {m*=pm;  return this;}

  String arrowToString() {return str(P.x)+","+str(P.y)+","+str(m)+","+str(w);}
  
  void set(PNT Q, PNT R) 
    {
    P=P(Q); 
    VCT V=V(Q,R); 
    m=n(V); 
    w=angle(V); 
    }

  void set(float x, float y, float pm, float pw) 
    {
    P=P(x,y); 
    m=pm; 
    w=pw; 
    }

  void update(PNT Q, PNT R) 
    {
    P=P(Q); 
    VCT V=V(Q,R); 
    m=n(V); 
    w+=angle(rV(),V); 
    }
    
  void update(ARROW A) 
    {
    P=A.rP(); 
    VCT V=A.rV(); 
    m=n(V); 
    w+=angle(rV(),V); 
    }
  
   void resetBranch() 
     {
     while(w<-PI) w+=TWO_PI; 
     while(w>PI)  w-=TWO_PI; 
     }
  
  
  // EXTRACT methods
  float ra() {return w;}
  float rm() {return m;}
  VCT rV() {return V(m*cos(w),m*sin(w));}
  PNT rP() {return P;}
  PNT rQ() {return P(rP(),rV());}
  PNT rM() {return P(rP(),0.5,rV());}
  PNT rT() {return TipOfEquilateralTriangle(rP(),rQ());}
  
  // SHOW methods
  void drawSegment() {edge(rP(),rV()); show(rP(),2); }    
  void drawEquilateralTriangle() {showLoop(rP(), rQ(), rT());}
  void drawArrow() {show(rP(),rV()); } 
  void drawWinding() 
    {
    float s=100;
    if(!showWinding) return;
    float wl = -ra();
    VCT V = rV();
    float ml = min(80.,0.4*n(V));
    PNT Q; 
    if(n(V)>100) Q = P(P,ml*(1.25-0.5),U(R(V,wl*1))); 
    else Q =  P(P,ml*(1.25-0.5),U(R(V,wl)));
    w(2); show(Q,1); //edge(P,Q);
    int k = 2+ceil(abs(ra())*64/TWO_PI); // k=16;
    float dt = 1./k;
    w(1);
    beginShape();
    for(float t = 0; t<=1+dt/2; t+=dt)
      {
      Q =  P(P,ml*(1.25-t/2),U(R(V,wl*t))); // show(Q,6);
      vert( Q ); 
      }
    endShape();
    }
  } // end ARROW class
  
// CREATE functions
ARROW CopyOf(ARROW A) {return Arrow(A.rP(),A.rm(),A.ra());}
ARROW Arrow() {return new ARROW();}
ARROW Arrow(PNT Q, float m, float w) {return new ARROW(Q,m,w); }
ARROW Arrow(PNT Q, VCT V) {return new ARROW(Q,V);  }
ARROW Arrow(PNT Q, PNT R) {return new ARROW(Q,R); }
ARROW Shift(ARROW W) {PNT P = W.rP(); VCT V = W.rV(); return Arrow(P(P,0.5,V),V); }
ARROW Unshift(ARROW W) {PNT P = W.rP(); VCT V = W.rV(); return Arrow(P(P,-0.5,V),V); }

// SHOW functions
void showSegment(ARROW A, color c) {cw(c,2); A.drawSegment();}
void showSegment(ARROW A) {A.drawSegment();}
void showArrow(ARROW A) {A.drawArrow();}
void showArrow(ARROW A, color c) { fo(c,250); A.drawArrow();}
void showArrow(ARROW A, int w, color c) { cwf(c,w,c); A.drawArrow();}
void show(ARROW A, color c) { cWf(c,c); A.drawArrow(); cwF(c,2); A.drawWinding();}
void show(ARROW A, int w, color c) { cwf(c,w,c); A.drawArrow(); noFill(); A.drawWinding();}
void show(ARROW A) {A.drawArrow(); w(2); noFill(); A.drawWinding();}

ARROW ArrowLinearMorph(ARROW A0, ARROW A1, float t)
  {
  PNT P0 = A0.rP(), P1 = A1.rP(), Pt = L(P0,t,P1);
  PNT Q0 = A0.rQ(), Q1 = A1.rQ(), Qt = L(Q0,t,Q1);
  return Arrow(Pt,Qt);
  }
  
ARROW ArrowPolarMorph(ARROW A0, ARROW A1, float t)
  {
  float w = A1.ra() - A0.ra();
  float m = A1.rm() / A0.rm();
  PNT P0 = A0.rP(), P1 = A1.rP();
  PNT Q0 = A0.rQ(), Q1 = A1.rQ();
  float mt = t*(A1.rm() - A0.rm());
  float wt = t*w;
  PNT Pt;
  if( ( w%PI <0.001 ) && (abs(m-1.)<0.01) ) 
    Pt = L(P0,t,P1);
  else
    {
    PNT F = spiralCenter(w,m,P0,P1);  // ws(2,cyan); show(F,5);
    //VCT Vt = W((A0.myLength()+mt)/A0.myLength(),R(V(F,P0),wt)); show(F,Vt);
    VCT Vt = V((1+mt/A0.rm()),R(V(F,P0),wt)); // show(F,Vt);
    Pt = P(F,Vt);
    }
  return Arrow(Pt,(1.+mt)+A0.rm(),A0.ra()+wt);
  }

ARROW ArrowSteadyMorph(float a, ARROW A, float b, ARROW B, float t)
  {
  return ArrowSteadyMorph(A,B,(t-a)/(b-a));
  }

ARROW ArrowSteadyMorph(ARROW A0, ARROW A1, float t)
  {
  float w = A1.ra() - A0.ra();
  float m = A1.rm() / A0.rm();
  PNT P0 = A0.rP(), P1 = A1.rP();
  PNT Q0 = A0.rQ(), Q1 = A1.rQ();
  float mt = pow(m,t);
  float wt = t*w;
  PNT Pt;
  //if( ( w%PI <0.001 ) && (abs(m-1.)<0.001) ) 
  //if( ( w%PI <0.0001 ) && (abs(1.-m)<1) ) 
  if( (abs(PI - (w+PI)%TWO_PI) <0.01  ) && (abs(m-1.)<0.01) )
    {
    Pt = L(P0,t,P1);
    //s(orange);
    }
  else
    {
    PNT F = spiralCenter(w,m,P0,P1);  // ws(2,orange); show(F,5);
    VCT Vt = V(mt,R(V(F,P0),wt)); // show(F,Vt);
    Pt = P(F,Vt);
    }
  return Arrow(Pt,mt*A0.rm(),A0.ra()+wt);
  }


ARROW NevilleThroughThreeArrows(float a, ARROW A, float b, ARROW B, float c, ARROW C, float t)
  {
  return ArrowSteadyMorph(a,ArrowSteadyMorph(a,A,b,B,t),c,ArrowSteadyMorph(b,B,c,C,t),t);  
  }


ARROW TransformArrow(ARROW A, PNT F, float m, float w, float t) 
  {
  VCT FPo = V(F,A.rP());
  PNT P = P(F, V(pow(m,t),R(FPo,t*w)) );
  return Arrow(P,A.rm()*pow(m,t),A.ra()+(t*w));
  }


ARROW SAT(ARROW A, ARROW B, float t, ARROW W) // Steady Arrow Transport
  {
  float m = B.rm()/A.rm();
  float w = B.ra()-A.ra();
  if( (abs(PI - (w+PI)%TWO_PI) <0.01  ) && (abs(m-1.)<0.01) )
    {
    PNT Pt = L(A.P,t,B.P);
    return Arrow(Pt,m,w);
    }
  else
    {
    PNT Fa = spiralCenter(w, m, A.rP(), B.rP());  
    PNT Fw = EvaluatePtInArrow(RegisterPtToArrow(Fa,A),W );
    return TransformArrow(W,Fw,m,w,t);
    }
  }

ARROW SAM(ARROW A, ARROW B, float t) // Steady Arrow Transport
  {
  float m = B.rm()/A.rm();
  float w = B.ra()-A.ra();
  PNT F = spiralCenter(w, m, A.rP(), B.rP());  
  return TransformArrow(A,F,m,w,t);
  }
  

PNT RegisterPtToArrow(PNT Q, ARROW D) // local formulation of D in the frame of O 
  {
  VCT V = D.rV();
  VCT PQ = V(D.rP(),Q);
  float n2=n2(V);
  if(n2>0.01) return P(dot(V,PQ)/n2,det(V,PQ)/n2); 
  else return P();
  }
  
VCT RegisterVecToArrow(VCT U, ARROW D) // local formulation of D in the frame of O: : register V to W V/W, express V/W in U: (V/W)*U, (AoCo/AoBo)*A1B1+A1
  {
  VCT V = D.rV();
  float n2=n2(V);
  if(n2>0.01) return V(dot(V,U)/n2,det(V,U)/n2); 
  else return V(1,0);
  }

ARROW RegisterArrowToArrow(ARROW A, ARROW D) // local formulation of D in the frame of O
  {
  return  Arrow( RegisterPtToArrow(A.rP(),D) , RegisterVecToArrow(A.rV(),D) );
  }

PNT EvaluatePtInArrow(PNT P, ARROW D) // *
  {
  return P(D.rP(),V(P.x,D.rV(),P.y,R(D.rV())));
  }

ARROW EvaluateArrowInArrow(ARROW A, ARROW O) // local formulation of D in the frame of O
  {
  VCT V = V(A.rV().x,O.rV(),A.rV().y,R(O.rV()));
  PNT P = P(O.rP(),V(A.rP().x,O.rV(),A.rP().y,R(O.rV())));
  return  Arrow(P,V);
  }

void showPictureOnArrow(ARROW D, PImage PIX)
  {
  showPictureOnArrow(P(0,0),P(0,1),P(1,1),P(1,0),D,PIX);
  }

void showPictureOnArrow(PNT APr, PNT BPr, PNT CPr, PNT DPr, ARROW D, PImage PIX)
  {
  PNT APl = EvaluatePtInArrow(APr,D);
  PNT BPl = EvaluatePtInArrow(BPr,D);
  PNT CPl = EvaluatePtInArrow(CPr,D);
  PNT DPl = EvaluatePtInArrow(DPr,D);
  beginShape();
    texture(PIX);
    vert(APl,0,1);
    vert(BPl,1,1);
    vert(CPl,1,0);
    vert(DPl,0,0);
  endShape(CLOSE); 
  }
  
void showBannerBetweenArrows(ARROW A, ARROW B, PImage PIX, int quads)
  {
  noStroke(); noFill();
  beginShape(QUAD_STRIP); 
  texture(PIX);
  for(int f=0; f<=quads; f++)
      {
      float s=(float)f/quads; 
      ARROW N =  SAM(A,B,s); 
      PNT rP = N.rP();
      PNT rQ = N.rQ();
      vert(rP,s,1);
      vert(rQ,s,0);
      }
  endShape();
  }
  
void showSteadyPatternOfArrows(ARROW A, ARROW B,int quads)
  {
  cwf(black,2,cyan);
  beginShape(QUAD_STRIP); 
  for(int f=0; f<=quads; f++)
      {
      float s=(float)f/quads; 
      ARROW N =  ArrowSteadyMorph(A,B,s); 
      vert(N.rP());
      vert(N.rQ());
      }
  endShape();
  }

void showLinearPatternOfArrows(ARROW A, ARROW B,int quads)
  {
  cwf(black,2,cyan);
  beginShape(QUAD_STRIP); 
  for(int f=0; f<=quads; f++)
      {
      float s=(float)f/quads; 
      ARROW N =  ArrowLinearMorph(A,B,s); 
      PNT rP = N.rP();
      PNT rQ = N.rQ();
      vert(rP);
      vert(rQ);
      }
  endShape();
  }
