//************************************************************************
//**** CIRCLES
//************************************************************************
// create 
PNT CircumCenter (PNT A, PNT B, PNT C) // CircumCenter(A,B,C): center of circumscribing circle, where medians meet)
  {
  VCT AB = V(A,B); VCT AC = R(V(A,C)); 
  return P(A,1./2/dot(AB,AC),V(-n2(AC),R(AB),n2(AB),AC)); 
  }
  
float circumRadius (PNT A, PNT B, PNT C)     // radiusCircum(A,B,C): radius of circumcenter 
  {
  float a=d(B,C), b=d(C,A), c=d(A,B), 
  s=(a+b+c)/2, 
  d=sqrt(s*(s-a)*(s-b)*(s-c)); 
  return a*b*c/4/d;
  } 

// display 
void drawCircleFast(int n) 
  {  
  float x=1, y=0; float a=TWO_PI/n, t=tan(a/2), s=sin(a); 
  beginShape(); 
    for (int i=0; i<n; i++) 
      {
      x-=y*t; y+=x*s; x-=y*t; 
      vertex(x,y);
      } 
  endShape(CLOSE);
  }


void showArcThrough (PNT A, PNT B, PNT C) 
  {
  if (abs(dot(V(A,B),R(V(A,C))))<0.01*d2(A,C)) {show(A,C); return;}
  PNT O = CircumCenter ( A,  B,  C); 
  float r=d(O,A);
  VCT OA=V(O,A), OB=V(O,B), OC=V(O,C);
  float b = angle(OA,OB), c = angle(OA,OC); 
  if(0<c && c<b || b<0 && 0<c)  c-=TWO_PI; 
  else if(b<c && c<0 || c<0 && 0<b)  c+=TWO_PI; 
  beginShape(); 
    vert(A); 
    for (float t=0; t<1; t+=0.01) vert(R(A,t*c,O)); 
    vert(C); 
  endShape();
  }

PNT pointOnArcThrough (PNT A, PNT B, PNT C, float t) 
   { 
   if (abs(dot(V(A,B),R(V(A,C))))<0.001*d2(A,C)) {show(A,C); return L(A,C,t);}
   PNT O = CircumCenter ( A,  B,  C); 
   float r=(d(O,A) + d(O,B)+ d(O,C))/3;
   VCT OA=V(O,A), OB=V(O,B), OC=V(O,C);
   float b = angle(OA,OB), c = angle(OA,OC); 
   if(0<b && b<c) {}
   else if(0<c && c<b) {b=b-TWO_PI; c=c-TWO_PI;}
   else if(b<0 && 0<c) {c=c-TWO_PI;}
   else if(b<c && c<0) {b=TWO_PI+b; c=TWO_PI+c;}
   else if(c<0 && 0<b) {c=TWO_PI+c;}
   else if(c<b && b<0) {}
   return R(A,t*c,O);
   }
   
// Apollonius graph in CGAL: https://doc.cgal.org/latest/Apollonius_graph_2/index.html   


boolean RayHitsPillar(PNT S, VCT D, PNT C, float r)
  {
  return abs(det(D,V(S,C)))<r;
  }
  
float distanceToPillarAlongRay(PNT S, VCT D, PNT C, float r)
  {
  VCT CS= V(C,S);
  float c = dot(CS,CS)-sq(r);
  float b = dot(CS,D);
  float t1 = -b - sqrt(sq(b)-c);
  float t2 = -b + sqrt(sq(b)-c);
  if(t1>0) return t1;
  else return t2;
  }
