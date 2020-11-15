
//************************************************************************
//**** INTERPOLATING PAREMETRIC MOTION
//************************************************************************
// Linear
PNT P(PNT A, float t, PNT B) {return P(A.x+t*(B.x-A.x),A.y+t*(B.y-A.y));}
PNT L(PNT A, PNT B, float t) {return P(A.x+t*(B.x-A.x),A.y+t*(B.y-A.y));}
PNT L(PNT A, float t, PNT B) {return P(A.x+t*(B.x-A.x),A.y+t*(B.y-A.y));}
PNT L(float a, PNT A, float b, PNT B, float t) {return L(A,B,(t-a)/(b-a));}
PNT L(float a, PNT A, float b, PNT B, float c, PNT C, float t) {return L(a,L(a,A,b,B,t),c,L(b,B,c,C,t),t);}
PNT L(float a, PNT A, float b, PNT B, float c, PNT C, float d, PNT D, float t) {return L(a,L(a,A,b,B,c,C,t),d,L(b,B,c,C,d,D,t),t);}
