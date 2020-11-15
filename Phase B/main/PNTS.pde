//*****************************************************************************
// TITLE:         Point sequence for editing polylines and polyloops  
// AUTHOR:        Prof Jarek Rossignac
// DATE CREATED:  September 2012
// EDITS:         Last revised Sept 10, 2016
//*****************************************************************************
class PNTS 
  {
  int pointCount=0;                                // number of vertices in the sequence
  int pv = 0;                              // picked vertex 
  int iv = 0;                              // insertion index 
  int maxnv = 100*2*2*2*2*2*2*2*2;         //  max number of vertices
  Boolean loop=false;                       // is a closed loop

  PNT[] G = new PNT [maxnv];                 // geometry table (vertices)

 // CREATE


  PNTS() {}
  
  void declare() {for (int i=0; i<maxnv; i++) G[i]=P(); }               // creates all points, MUST BE DONE AT INITALIZATION

  void empty() {pointCount=0; pv=0; }                                                 // empties this object
  
  void addPoint(PNT P) { G[pointCount].setTo(P); pv=pointCount; pointCount++;  }                    // appends a point at position P
  
  void addPoint(float x,float y) { G[pointCount].x=x; G[pointCount].y=y; pv=pointCount; pointCount++; }    // appends a point at position (x,y)
  
  PNT lastPoint() {if(pointCount>0) return P(G[pointCount-1]); else return P();}                                    // returns copy of the last point
  
  int pointCount() {return pointCount;}                                    // returns copy of the last point
  
  void insertPoint(PNT P)  // inserts new point after point pv
    { 
    for(int v=pointCount-1; v>pv; v--) G[v+1].setTo(G[v]); // slide all points after pv to make room
    pv++;  // select the new point
    G[pv].setTo(P); // set the new point
    pointCount++; // update point count
    }
     
  void splitEdgeAtProjection(PNT M) // inserts point that is the closest to M on the curve
    {
    insertPoint(closestProjectionOfPoint(M));
    }
  
  void resetPointsOnCircle() {resetPointsOnCircle(pointCount); } 
  
  void resetPointsOnCircle(int k)                                                         // init the points to be on a well framed circle
    {
    empty();
    PNT C = ScreenCenter(); 
    for (int i=0; i<k; i++)
      addPoint(R(P(C,V(0,-width*3/9)),2.*PI*i/k,C));
    } 
  
  void placeWxWpointsOnQuadGrid (int w) // make a 2D grid of w x w vertices
   {
   empty();
   for (int i=0; i<w; i++) 
     for (int j=0; j<w; j++) 
       addPoint(P(.7*height*j/(w-1)+.1*height,.7*height*i/(w-1)+.1*height));
   }    

  void placeWxWpointsOnHexGrid (int w) // make a 2D grid of w x w vertices
   {
   empty();
   float dx = .7*height/(w-1);
   float h = sqrt(3)/2;
   float dy = dx*h;
   for (int i=0; i<w/h; i++) 
     for (int j=0; j<w; j++) 
       if(i%2==0) addPoint(P(dx*j+.1*height,dy*i+.1*height));
       else  addPoint(P(dx*j+dx/2+.1*height,dy*i+.1*height));
   }    


  // PICK AND EDIT INDIVIDUAL POINT
  
  void pickPointClosestTo(PNT M) 
    {
    pv=0; 
    for (int i=1; i<pointCount; i++) 
      if (d(M,G[i])<d(M,G[pv])) pv=i;
    }

  void dragPickedPoint()  // moves selected point (index pv) by the amount by which the mouse moved recently
    { 
    G[pv].moveWithMouse(); 
    }     
  
  void dragPickedArrow()  // moves selected point (index pv) by the amount by which the mouse moved recently
    { 
    G[pv].moveWithMouse(); 
    if(showControlArrows) if(pv%2==0) G[pv+1].moveWithMouse(); 
    }     
  
  void deletePickedPoint() {
    for(int i=pv; i<pointCount; i++) G[i].setTo(G[i+1]);
    pv=max(0,pv-1);       // reset index of picked point to previous
    pointCount--;  
    }
  
  void setPointOfGivenIndex(PNT P, int i) 
    { 
    G[i].setTo(P); 
    }
  
  
  // DISPLAY
  
  void writeIDsInEmptyDisks() 
    {
    for (int v=0; v<pointCount; v++) 
      { 
      fill(white); 
      show(G[v],13); 
      fill(black); 
      label(G[v],str(v));  
      }
    noFill();
    }

  PNT Point(int  i) 
    {
    if(0<=i && i<pointCount) return G[i]; // editing the result will change this point! Use P(OBJECT.Point(k)) to avoid this
    else return P();
    }
  

  void showPickedPoint(float r) 
    {
    show(G[pv],r); 
    }
  
  void drawAllVerticesInColor(float r, color c) 
    {
    fill(c); 
    drawAllVertices(r);
    }
  
  void drawAllVertices(float r)
    {
    for (int v=0; v<pointCount; v++) show(G[v],r); 
    }
   
  void drawCurve() 
    {
    if(loop) drawPolyloop(); 
    else drawPolyline(); 
    }
    
  void drawPolyline() 
    {
    beginShape(); 
      for (int v=0; v<pointCount; v++) G[v].v(); 
    endShape(); 
    }
    
  void drawPolyloop()   
    {
    beginShape(); 
      for (int v=0; v<pointCount; v++) G[v].v(); 
    endShape(CLOSE); 
    }

  // EDIT ALL POINTS TRANSALTE, ROTATE, ZOOM, FIT TO CANVAS
  
  void translate() // moves all points to mimick mouse motion
    { 
    for (int i=0; i<pointCount; i++) G[i].moveWithMouse(); 
    }      
  
  void fudgeAll(float d) // moves all points by V
    {
    for (int i=0; i<pointCount; i++) G[i].translate(V(random(-d,d),random(-d,d))); 
    }   

  void moveAll(VCT V) // moves all points by V
    {
    for (int i=0; i<pointCount; i++) G[i].translate(V); 
    }   

  void rotateAllPoints(float a, PNT C) // rotates all points around pt G by angle a
    {
    for (int i=0; i<pointCount; i++) G[i].rotateWrtPNT(a,C); 
    } 
  
  void rotateAllPointsAroundCentroid(float a) // rotates points around their center of mass by angle a
    {
    rotateAllPoints(a,CentroidOfPolygon()); 
    }
    
  void rotateAllPointsAroundCentroid(PNT P, PNT Q) // rotates all points around their center of mass G by angle <GP,GQ>
    {
    PNT C = CentroidOfPolygon();
    rotateAllPoints(angle(V(C,P),V(C,Q)),C); 
    }

  void scaleAllPoints(float s, PNT C) // scales all pts by s wrt C
    {
    for (int i=0; i<pointCount; i++) G[i].dilateWrtPNT(s,C); 
    }  
  
  void scaleAllPointsAroundCentroid(float s) 
    {
    scaleAllPoints(s,CentroidOfPolygon()); 
    }
  
  void scaleAllPointsScreenCenter(float s) 
    {
    scaleAllPoints(s,ScreenCenter()); 
    }
  
  void scaleAllPointsAroundCentroid(PNT M, PNT P) // scales all points wrt centroid G using distance change |GP| to |GM|
    {
    PNT C=CentroidOfPolygon(); show(C,60);
    float m=d(C,M),p=d(C,P); 
    scaleAllPoints(m/p,C); 
    }
    
  void swirlAroundScreenCenter(PNT M, PNT P) // scales all points wrt centroid G using distance change |GP| to |GM|
    {
    PNT C=ScreenCenter();
    //rotateAllPoints(angle(V(C,M),V(C,P)),C); 
    rotateAllPoints(angle(V(C,P),V(C,M)),C);
    float m=d(C,M),p=d(C,P); 
    scaleAllPoints(m/p,C); 
    }
    
  void swirlAroundCentroid(PNT M, PNT P) // scales all points wrt centroid G using distance change |GP| to |GM|
    {
    PNT C=CentroidOfPolygon(); show(C,60);
    rotateAllPoints(angle(V(C,M),V(C,P)),C); 
    float m=d(C,M),p=d(C,P); 
    scaleAllPoints(m/p,C); 
    }

  PNT CentroidOfPolygon () // center of mass of face
      {
      PNT C=P(); 
      PNT O=P(); 
      float area=0;
      for (int i=pointCount-1, j=0; j<pointCount; i=j, j++) 
        {
        float a = triangleArea(O,G[i],G[j]); 
        area+=a; 
        C.add(a,P(O,G[i],G[j])); 
        }
      C.divideBy(area); 
      return C; 
      }
        
  PNT CentroidOfVertices() 
    {
    PNT C=P(); // will collect sum of points before division
    for (int i=0; i<pointCount; i++) C.add(G[i]); 
    return P(1./pointCount,C); // returns divided sum
    }
 

  // MEASURES 
  float lengthOfPerimeter () // length of perimeter
    {
    float L=0; 
    for (int i=pointCount-1, j=0; j<pointCount; i=j++) L+=d(G[i],G[j]); 
    return L; 
    }
    
  float areaEnclosedByPolyloop()  // area enclosed
    {
    PNT O=P(); 
    float a=0; 
    for (int i=pointCount-1, j=0; j<pointCount; i=j++) a+=det(V(O,G[i]),V(O,G[j])); 
    return a/2;
    }   
    
  PNT closestProjectionOfPoint(PNT M) 
    {
    int c=0; PNT C = P(G[0]); float d=d(M,C);       
    for (int i=1; i<pointCount; i++) if (d(M,G[i])<d) {c=i; C=P(G[i]); d=d(M,C); }  
    for (int i=pointCount-1, j=0; j<pointCount; i=j++) 
      { 
      PNT A = G[i], B = G[j];
      if(projectsBetween(M,A,B) && disToLine(M,A,B)<d) 
          {
          d=disToLine(M,A,B); 
          c=i; 
          C=projectionOnLine(M,A,B);
          }
       } 
     pv=c;    
     return C;    
     }  

  Boolean contains(PNT Q) {
    Boolean in=true;
    // provide code here
    return in;
    }
  

  float alignentAngle(PNT C) { // of the perimeter
    float xx=0, xy=0, yy=0, px=0, py=0, mx=0, my=0;
    for (int i=0; i<pointCount; i++) {xx+=(G[i].x-C.x)*(G[i].x-C.x); xy+=(G[i].x-C.x)*(G[i].y-C.y); yy+=(G[i].y-C.y)*(G[i].y-C.y);};
    return atan2(2*xy,xx-yy)/2.;
    }


  // FILE I/O   
     
  void saveControlPointsToFile(String fn) 
    {
    println("Saving: "+pointCount+" points to "+fn); 
    String [] inppts = new String [pointCount+1];
    int s=0;
    inppts[s++]=str(pointCount);
    for (int i=0; i<pointCount; i++) {inppts[s++]=str(G[i].x)+","+str(G[i].y);}
    saveStrings(fn,inppts);
    };
  

  void loadControlPointsFromFile(String fn) 
    {
    print("Reading points from "+fn); 
    String [] ss = loadStrings(fn);
    String subpts;
    int s=0;   int comma, comma1, comma2;   float x, y;   int a, b, c;
    pointCount = int(ss[s++]); 
    for(int k=0; k<pointCount; k++) {
      int i=k+s; 
      comma=ss[i].indexOf(',');   
      x=float(ss[i].substring(0, comma));
      y=float(ss[i].substring(comma+1, ss[i].length()));
      G[k].setTo(x,y);
      };
    pv=0;
    println(" ... Loaded: "+pointCount+" points."); 
    }; 
  
  }  // end class PNTS
