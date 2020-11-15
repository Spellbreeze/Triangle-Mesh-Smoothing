// LINES in 2D
PNT LineLineIntersection(PNT A, PNT B, PNT P, PNT Q)
  {
  VCT AP = V(A,P);
  VCT AB = V(A,B);
  VCT PQ = V(P,Q);
  float s = -det(AP,AB)/det(PQ,AB);
  return P(P,s,PQ);
  }

float disToLine(PNT P, PNT A, PNT B) {return abs(det(U(A,B),V(A,P))); };
