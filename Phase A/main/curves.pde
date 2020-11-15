PNT  PointOnBezierCurve(PNT A, PNT B, PNT C, PNT D, float t)
  {
  PNT Pab=L(A,t,B);    PNT Pbc=L(B,t,C);    PNT Pcd=L(C,t,D);
            PNT Pabc=L(Pab,t,Pbc);    PNT Pbcd=L(Pbc,t,Pcd);
                        PNT P=L(Pabc,t,Pbcd); 
  return P;                   
  }
  
ARROW  BezierArrow(PNT A, PNT B, PNT C, PNT D, float t)
  {
  PNT Pab=L(A,t,B);    PNT Pbc=L(B,t,C);    PNT Pcd=L(C,t,D);
            PNT Pabc=L(Pab,t,Pbc);    PNT Pbcd=L(Pbc,t,Pcd);
                        PNT P=L(Pabc,t,Pbcd); 
                        VCT V=V(Pabc,Pbcd);
  return Arrow(P,V);                   
  }
  
void drawBiarc(PNT P0, VCT T0, PNT P1, VCT T1)
   {
   VCT T = V(T0,T1), D = V(P0,P1);
   float a = 4.-n2(T);
   float b = 2 * dot(T,D);
   float c = -n2(D);
   float r = (-b+sqrt(sq(b)-4.*a*c))/(2.*a);
   PNT C0 = P(P0,r,T0), C1 = P(P1,-r,T1), M = P(C0,C1);
   cwF(yellow,12); beginShape(); vert(P0); vert(C0); vert(C1); vert(P1); endShape();
   cwF(cyan,2);  drawCircleInHat(P0,C0,M,true); 
   cwF(orange,2);  drawCircleInHat(M,C1,P1,false);
   cwf(black,1,grey); show(C0,5); show(C1,5); show(M,5);
   noFill(); 
   }
   
void drawCircleInHat(PNT A, PNT B, PNT C,boolean write){
  VCT BA = V(B,A), BC = V(B,C), V = V(BA,BC);
  if(abs(angle(V(A,B),V(B,C)))<0.1) {strokeWeight(4); show(A,C); return; } // flat
  float d = dot(BC,BC) /dot(BC,V) ; 
  PNT X = P(B,d,V); // Center
  float r=d(X,C);
  VCT XA = V(X,A), XC = V(X,C); 
  float a = angle(XA,XC), da=a/60;
  beginShape(); 
   if(a>0) for (float w=0; w<=a; w+=da) vert(P(X,R(XA,w))); 
   else for (float w=0; w>=a; w+=da) vert(P(X,R(XA,w)));
  endShape();
  show(X,2);
  }   

//===== PARABOLA
void drawParabolaInHat(PNT A, PNT B, PNT C, int rec) {
   if (rec==0) { show(A,B); show(B,C); } //if (rec==0) { beam(A,B,rt); beam(B,C,rt); } 
   else { 
     float w = (d(A,B)+d(B,C))/2;
     float l = d(A,C)/2;
     float t = l/(w+l);
     PNT L = L(A,t,B);
     PNT R = L(C,t,B);
     PNT M = P(L,R);
     drawParabolaInHat(A,L,M,rec-1); drawParabolaInHat(M,R,C,rec-1); 
     };
   };
