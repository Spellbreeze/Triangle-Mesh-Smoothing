//************************************************************************
//**** SPIRAL
//************************************************************************

// POINT ON SPIRAL FROM A WITH FIXED POINT G
PNT spiralPt(PNT A, PNT G, float s, float a, float t) {return L(G,R(A,t*a,G),pow(s,t));}  //  A rotated by at and scaled by s^t wrt G

// COMPUTE PARAMETERS OF SPIRAL MOTION THAT MORPHS EDGE(A,B) TO EDGE(C,D)
float spiralAngle(PNT A, PNT B, PNT C, PNT D) {return angle(V(A,B),V(C,D));}

float spiralScale(PNT A, PNT B, PNT C, PNT D) {return d(C,D)/d(A,B);}

PNT spiralCenter(PNT A, PNT B, PNT C, PNT D)  // computes center of spiral that takes A to C and B to D
  {
  float a = spiralAngle(A,B,C,D); 
  float z = spiralScale(A,B,C,D);
  return spiralCenter(a,z,A,C);
  }
 
PNT spiralCenter(float a, float z, PNT A, PNT C) 
  {
  float c=cos(a), s=sin(a);
  float D = sq(c*z-1)+sq(s*z);
  float ex = c*z*A.x - C.x - s*z*A.y;
  float ey = c*z*A.y - C.y + s*z*A.x;
  float x=(ex*(c*z-1) + ey*s*z) / D;
  float y=(ey*(c*z-1) - ex*s*z) / D;
  return P(x,y);
  }


// IMAGE OF POINT Q BY SPIRAL MOTION THAT MORPHS EDGE(A,B) AND EDGE(C,D)
PNT spiral(PNT A, PNT B, PNT C, PNT D, float t, PNT Q) 
  {
  float a =spiralAngle(A,B,C,D); 
  float s =spiralScale(A,B,C,D);
  PNT G = spiralCenter(a, s, A, C); 
  return L(G,R(Q,t*a,G),pow(s,t));
  }
  
// IMAGE OF POINT A BY SPIRAL MOTION THAT MORPHS EDGE(A,B) AND EDGE(C,D)
PNT spiralA(PNT A, PNT B, PNT C, PNT D, float t) 
  {
  float a =spiralAngle(A,B,C,D); 
  float s =spiralScale(A,B,C,D);
  PNT G = spiralCenter(a, s, A, C); 
  return L(G,R(A,t*a,G),pow(s,t));
  }
    
  
// IMAGE OF POINT B BY SPIRAL MOTION THAT MORPHS EDGE(A,B) AND EDGE(C,D)
PNT spiralB(PNT A, PNT B, PNT C, PNT D, float t) 
  {
  float a =spiralAngle(A,B,C,D); 
  float s =spiralScale(A,B,C,D);
  PNT G = spiralCenter(a, s, A, C); 
  return L(G,R(B,t*a,G),pow(s,t));
  }
 
 
// IMAGE OF POINT B BY SPIRAL MOTION THAT MORPHS EDGE(A,B) AND EDGE(B,C): USED FOR SPIRALINE SUBDIVISION
PNT spiral(PNT A, PNT B, PNT C, float t) 
  {
  float a =spiralAngle(A,B,B,C); 
  float s =spiralScale(A,B,B,C);
  PNT G = spiralCenter(a, s, A, B); 
  return L(G,R(B,t*a,G),pow(s,t));
  }

// DRAWS SPIRAL SEGMENT THROUGH 3 POINTS
void showSpiral(PNT A, PNT B, PNT C) 
  {
  beginShape();
    for(float t=-1.0; t<=1.05; t+=0.05) 
      vert(spiral(A,B,C,t));
  endShape();
  }
 
// SPHERICAL INTERPOLATION USED (WRONGLY) FOR VECTORS U AND V THAT MAY NOT HAVE SAME MAGNITUDE
VCT slerp(VCT U, float t, VCT V) 
  {
  float a = angle(U,V);
  float b=sin((1.-t)*a),c=sin(t*a),d=sin(a);
  return V(b/d,U,c/d,V); 
  }
  
