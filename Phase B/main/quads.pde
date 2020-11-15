PNT QuadVanishingPoint(PNT A, PNT B, PNT C, PNT D){return LineLineIntersection(A,D,B,C);}
PNT QuadCenter(PNT A, PNT B, PNT C, PNT D) {return LineLineIntersection(A,C,B,D); }
PNT QuadEdgeSplitPoint(PNT A, PNT B, PNT E, PNT G) {return LineLineIntersection(A,B,G,E);}
float quadEdgeSplitRatio(PNT A, PNT B, PNT H) {return d(A,H)/d(A,B);}
float s(float t, float b) {return b*t / ((b*2.-1.)*t+1.-b);}
