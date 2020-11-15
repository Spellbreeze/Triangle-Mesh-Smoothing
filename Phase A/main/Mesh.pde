// TRIANGLE MESH
MESH M = new MESH(); // TRIANGLE MESH USED FOR THE PROJECT
int rb=100;
int rt =3;
int   mcc=10;
float  thickness=1;
float stepSize=5; // step size for locomotion

class MESH 
  {
  // VERTICES
  int nv=0, maxnv = 1000;  
  PNT[] G = new PNT [maxnv];   // geoemtry (vertex location) will be copied from Sites                     
  boolean[] isInterior = new boolean[maxnv];        // lable of the vertex indicating interior or border                              
  float[] sumOfWeights = new float[maxnv];          // for normalizing the weights

  // TRIANGLES 
  int nt = 0;
  int maxnt = maxnv*2;                           
  boolean[] visitedTriangles = new boolean[maxnt];                                      

  // CORNERS 
  int c=0;    // current corner                                                              
  int nc = 0; 
  int[] V = new int [3*maxnt];   
  int[] O = new int [3*maxnt];  
 
  MESH() {for (int i=0; i<maxnv; i++) G[i]=new PNT();}

  void reset() {nv=0; nt=0; nc=0;}               
  void resetVisitedTriangles() {for (int t=0; t<nt; t++) visitedTriangles[t]=false;}
  
  void loadVertices(PNT[] P, int n) {nv=0; for (int i=0; i<n; i++) addVertex(P[i]);}
  void writeVerticesTo(PNTS P) {for (int i=0; i<nv; i++) P.G[i].setTo(G[i]);}
  void addVertex(PNT P) { G[nv++].setTo(P); }                                             // adds a vertex to vertex table G
  void addTriangle(int i, int j, int k) {V[nc++]=i; V[nc++]=j; V[nc++]=k; nt=nc/3; }     // adds triangle (i,j,k) to V table

  // CORNER OPERATORS
  int c (int t) {return t*3;}                   // corner of triangle t
  int t (int c) {int r=int(c/3); return(r);}                   // triangle of corner c
  int n (int c) {int r=3*int(c/3)+(c+1)%3; return(r);}         // next corner
  int p (int c) {int r=3*int(c/3)+(c+2)%3; return(r);}         // previous corner
  int v (int c) {return V[c];}                                // vertex of c
  int o (int c) {return O[c];}                                // opposite corner
  int l (int c) {return o(n(c));}                             // left
  int s (int c) {return n(o(n(c)));}                             // left
  int u (int c) {return p(o(p(c)));}                             // left
  int r (int c) {return o(p(c));}                             // right
  PNT LocationOfVertexOfCorner (int c) {return G[V[c]];}                             // shortcut to get the point where the vertex v(c) of corner c is located
  PNT LocationOfCornerDot(int c) {return P(0.6,LocationOfVertexOfCorner(c),0.2,LocationOfVertexOfCorner(p(c)),0.2,LocationOfVertexOfCorner(n(c)));}   // computes offset location of point at corner c

  boolean isBeachFacing(int c) {return(O[c]==c);};  // a border (beach-facing) corner
  boolean isNotBeachFacing(int c) {return(O[c]!=c);};  // not a border corner

  // CURRENT CORNER OPERATORS
  void next() {c=n(c);}
  void previous() {c=p(c);}
  void opposite() {c=o(c);}
  void left() {c=l(c);}
  void right() {c=r(c);}
  void swing() {c=s(c);} 
  void unswing() {c=u(c);} 
  void printInfo() {println("c = "+c+", nc = "+nc+", 3nt = "+3*nt+", nt = "+nt+", nv="+nv);}

  // DISPLAY
  void showCurrentCorner(float r) { if(isBeachFacing(c)) cwf(black,1,red); else cwf(black,1,grey); show(LocationOfCornerDot(c),r); };   // renders corner c as small ball
  void showEdgeFacingCorner(int c) {w(rt); show(LocationOfVertexOfCorner(p(c)),LocationOfVertexOfCorner(n(c))); };  // draws edge of t(c) opposite to corner c
  void showVertices(float r) // shows all vertices green/yellow inside, red outside
    {
    for (int v=0; v<nv; v++) 
      {
      if(isInterior[v]) cwf(dgreen,2,yellow); else cwf(dred,2,red);
      show(G[v],r);
      }
    }                          
  void drawTriangles() // draws all triangles (edges, or filled)
    { 
    for (int c=0; c<nc; c+=3) show(LocationOfVertexOfCorner(c), LocationOfVertexOfCorner(c+1), LocationOfVertexOfCorner(c+2)); 
    }         
  void showTriangles() // shows nearly flat triangles in magenta
    { 
    for (int c=0; c<nc; c+=3) 
      {
      if(isFlatterThan(LocationOfVertexOfCorner(c), LocationOfVertexOfCorner(c+1), LocationOfVertexOfCorner(c+2), 10)) fill(magenta); 
      else fill(cyan);
      show(LocationOfVertexOfCorner(c), LocationOfVertexOfCorner(c+1), LocationOfVertexOfCorner(c+2)); 
      }
    }         // draws all triangles (edges, or filled)
  void showEdges() {for (int i=0; i<nc; i++) if(i<=o(i)) showEdgeFacingCorner(i); };         // draws all edges of mesh twice
  void showBorderEdges() {for (int i=0; i<nc; i++) {if (isBeachFacing(i)) {showEdgeFacingCorner(i);}; }; };         // draws all border edges of mesh
  void showNonBorderEdges() {for (int i=0; i<nc; i++) {if (!isBeachFacing(i)) {showEdgeFacingCorner(i);}; }; };         // draws all border edges of mesh

  
  
  void showVoronoiEdges () 
    {
    for (int b=0; b<nc; b++) 
      if (isNotBeachFacing(b)) 
        if (b<o(b)) show(triCircumcenter(b),triCircumcenter(o(b)));
    }

void computeDelaunayTriangulation() {     // performs Delaunay triangulation using a quartic algorithm
   c=0;                   // to reset current corner
   PNT X = new PNT(0,0);
   float r=1;
   for (int i=0; i<nv-2; i++) for (int j=i+1; j<nv-1; j++) for (int k=j+1; k<nv; k++)
     if(!isFlatterThan(G[i],G[j],G[k], thickness))
       {    
       X=CircumCenter(G[i],G[j],G[k]);  r = d(X,G[i]);
       boolean found=false; 
       for (int m=0; m<nv; m++) if ((m!=i)&&(m!=j)&&(m!=k)&&(d(X,G[m])<=r)) found=true;  
       if (!found) if (ccw(G[i],G[j],G[k])) addTriangle(i,j,k); else addTriangle(i,k,j); 
       }; 
   }  


  void computeO() {   // slow method to set the O table from the V table, assumes consistent orientation of tirangles
    for (int i=0; i<3*nt; i++) {O[i]=i;};  // init O table to -1: has no opposite (i.e. is a border corner)
    for (int i=0; i<3*nt; i++) {  for (int j=i+1; j<3*nt; j++) {       // for each corner i, for each other corner j
      if( (v(n(i))==v(p(j))) && (v(p(i))==v(n(j))) ) {O[i]=j; O[j]=i;};};}; // make i and j opposite if they match 
   }
  
  void computeOfast() // faster method for computing O
    {                                          
    int nIC [] = new int [maxnv];                            // number of incident corners on each vertex
    //println("COMPUTING O: nv="+nv +", nt="+nt +", nc="+nc );
    int maxValence=0;
    for (int c=0; c<nc; c++) {O[c]=c;};                      // init O table to -1: has no opposite (i.e. is a border corner)
    for (int v=0; v<nv; v++) {nIC[v]=0; };                    // init the valence value for each vertex to 0
    for (int c=0; c<nc; c++) {nIC[v(c)]++;}                   // computes vertex valences
    for (int v=0; v<nv; v++) {if(nIC[v]>maxValence) {maxValence=nIC[v]; };};  // println(" Max valence = "+maxValence+". "); // computes and prints maximum valence 
    int IC [][] = new int [maxnv][maxValence];                 // declares 2D table to hold incident corners (htis can be folded into a 1D table !!!!!)
    for (int v=0; v<nv; v++) {nIC[v]=0; };                     // resets the valence of each vertex to 0 . It will be sued as a counter of incident corners.
    for (int c=0; c<nc; c++) {IC[v(c)][nIC[v(c)]++]=c;}        // appends incident corners to corresponding vertices     
    for (int c=0; c<nc; c++) {                                 // for each corner c
      for (int i=0; i<nIC[v(p(c))]; i++) {                     // for each incident corner a of the vertex of the previous corner of c
        int a = IC[v(p(c))][i];      
        for (int j=0; j<nIC[v(n(c))]; j++) {                   // for each other corner b in the list of incident corners to the previous corner of c
           int b = IC[v(n(c))][j];
           if ((b==n(a))&&(c!=n(b))) {O[c]=n(b); O[n(b)]=c; };  // if a and b have matching opposite edges, make them opposite
           };
        };
      };
    } // end computeOfast  

  PNT triCenter(int c) {return P(LocationOfVertexOfCorner(c),LocationOfVertexOfCorner(n(c)),LocationOfVertexOfCorner(p(c))); }  // returns center of mass of triangle of corner c

  PNT triCircumcenter(int c) {return CircumCenter(LocationOfVertexOfCorner(c),LocationOfVertexOfCorner(n(c)),LocationOfVertexOfCorner(p(c))); }  // returns circumcenter of triangle of corner c

  void showOpposites()
    {
    for (int i=0; i<nc; i++) 
      if(!isBeachFacing(i)) 
        drawParabolaInHat(LocationOfCornerDot(i),P(LocationOfVertexOfCorner(n(i)),LocationOfVertexOfCorner(p(i))),LocationOfCornerDot(o(i)),5);
      
    }
  
  int countBorders()
    {
    int b=0;
    for (int c=0; c<3*nt; c++) if(isBeachFacing(c)) b++;
    return b;
    }

  int cornerIndexFromVertexIndex(int v) {for (int c=0; c<3*nt; c++) if(v(c)==v) return c; return -1;} 
 


//******************************************************** FOR 3451 PROJECT 4 2020 ********************************************************
        
    void labelVerticesAsInteriorOrBorder() 
    { 
    // PROJECT 4 PHASE A:  STUDENT SHIULD PROVIDE THIS CODE
    for (int i = 0; i < nc; i++)
      {
      isInterior[i] = true;
      }
    for (int i = 0; i < nc; i++)
      {
      if(o(i) == i) isInterior[v(n(i))] = false;
      }
        
    }               


  int leftBeachNeighbor(int cc)
    {
    // PROJECT 4 PHASE A:  STUDENT SHIULD PROVIDE THIS CODE
    return 0;
    }

  int rightBeachNeighbor(int cc)
    {
    // PROJECT 4 PHASE A:  STUDENT SHIULD PROVIDE THIS CODE
    return 0;
    }

  void showBeachNeighbors(float r)
    {
    // PROJECT 4 PHASE A:  STUDENT SHIULD PROVIDE THIS CODE
    }

  void smoothenBorderWithTuck(float ratio) { // even  borxer vertiex locations
    VCT[] W = new VCT [nv];    // correction vectors
    // PROJECT 4 PHASE A:  STUDENT SHIULD PROVIDE THIS CODE
    }

  void smoothenBorderWithCubicPredictor(float ratio) { // even b order vertiex locations
    VCT[] W = new VCT [nv];    // correction vectors
    // PROJECT 4 PHASE A:  STUDENT SHIULD PROVIDE THIS CODE
    }

  void redistributeInteriorVerticesTowardsNeighbors(float ratio)  // even interior vertiex locations
    {    
    VCT[] W = new VCT [nv];    // correction vectors
    // PROJECT 4 PHASE A:  STUDENT SHIULD PROVIDE THIS CODE
    }

  void redistributeInteriorVerticesTowardsLink(float ratio)  // even interior vertiex locations
    {    
    VCT[] W = new VCT [nv];    // correction vectors
    // PROJECT 4 PHASE A:  STUDENT SHIULD PROVIDE THIS CODE
    }


  }  
  
  
  
