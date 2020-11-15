// Class: CS 3451 
// Semester: Fall 2020
// Project number: 04
// Project title: Working with Triangle Meshes
// Student(s): Alexander Goebel

//======================= My global variables
PImage PictureOfMyFace; // picture of author's face, should be: data/pic.jpg in sketch folder
PImage PictureOfBanner; // picture of banner, should be: data/pic.jpg in sketch folder

boolean lerp=true, spiral=true; // toggles to display vector interpoations
float b=0, c=0.5, d=1; // initial knots
//String [] PartTitle = new String[10];
String [] titleOfStep = {"?","?","?","?","?","?","?","?","?","?"};
int partShown = 0;

// My Animation
int MyFramesInAnimation=63;
int myCurrentFrame=0; // counting frames for animating my arrow morphs 
float myTime=0; // my time for animating my arrow morphs 

int numberOfParts = titleOfStep.length;
PNTS DrawnPoints = new PNTS(); // class containing array of points, used to standardize GUI
PNTS SmoothenedPoints = new PNTS(); // class containing array of points, used to standardize GUI
DUCKS DucksRow = new DUCKS(20);

float ringRadius=100;
//**************************** My text  ****************************
String title ="Class: 3451, Year: 2020, Project 04 (individual)",            
       name ="Alexander GOEBEL";
String subtitle = "Smoothing a Delaunay Triangulation";    
String guide="MyProject keys: '0' through '9' to activate steps"; // help info

//**************************** Color Ramp  ****************************
COLOR_RAMP colors = new COLOR_RAMP(65);

// Toggles for the project
Boolean 
  showDisks=true, 
  showPillars=true,
  showRobot=true,
  showTriangles=false,
  showVertices=true,
  showEdges=true,
  showVisitedTriangles=false,
  showCorner=true,
  showOpposite=false,
  showVoronoiFaces=true,
  showVoronoiEdges=true,
  showVoronoiArcs=true,

  step0=true,
  step1=true,
  step2=false,
  step3=false,
  step4=false,
  step5=false,
  step6=false,
  step7=false, 
  step8=true,
  step9=true,

  live=true;   // updates mesh at each frame

//======================= my setup, executed once at the beginning 
void mySetup()
  {
  DrawnPoints.declare(); // declares all ControlPoints. MUST BE DONE BEFORE ADDING POINTS 
  SmoothenedPoints.declare(); // declares all ControlPoints. MUST BE DONE BEFORE ADDING POINTS 
  DrawnPoints.empty(); // reset pont list P
  SmoothenedPoints.empty(); // reset pont list P
  //initDucklings(); // creates Ducling[] points
  ringRadius=0.4*width;
  M.reset();   
  M.loadVertices(Sites.G,Sites.pointCount); 
  M.computeDelaunayTriangulation(); 
  M.computeOfast();
  }

//======================= called in main() and executed at each frame to redraw the canvas
void showMyProject(PNTS MySites) // four points used to define 3 vectors
  {
  if(myCurrentFrame==MyFramesInAnimation) myCurrentFrame=0;
  myTime = (float)myCurrentFrame++/MyFramesInAnimation;
  if(easeInOut) myTime = easeInOut(0,0.5,1,myTime);    
    
  if(step0) doStep0(); 
  if(step1) doStep1(); 
  if(step2) doStep2(); 
  if(step3) doStep3(); 
  if(step4) doStep4(); 
  if(step5) doStep5(); 
  if(step6) doStep6(); 
  if(step7) doStep7(); 
  if(step8) doStep8(); 
  if(step9) doStep9(); 
  
  textAlign(LEFT,BOTTOM);
  f(red); 
  int line=2, s=0;
  if(scribeText)
    {
    if(step0) scribeHeader("Step 0: "+titleOfStep[0],line++); 
    if(step1) scribeHeader("Step 1: "+titleOfStep[1],line++); 
    if(step2) scribeHeader("Step 2: "+titleOfStep[2],line++); 
    if(step3) scribeHeader("Step 3: "+titleOfStep[3],line++); 
    if(step4) scribeHeader("Step 4: "+titleOfStep[4],line++); 
    if(step5) scribeHeader("Step 5: "+titleOfStep[5],line++); 
    if(step6) scribeHeader("Step 6: "+titleOfStep[6],line++); 
    if(step7) scribeHeader("Step 7: "+titleOfStep[7],line++); 
    if(step8) scribeHeader("Step 8: "+titleOfStep[8],line++); 
    if(step9) scribeHeader("Step 9: "+titleOfStep[9],line++); 
    }
  textAlign(CENTER,CENTER);
  }


//====================================================================== PART 0
void doStep0() //
  {
  titleOfStep[0] = "Show sites and IDs and copy them into mesh vertices. 'I' vertex IDs";
  M.loadVertices(Sites.G,Sites.pointCount); 
  guide="My keys: '0'...'9' to activate/deactivate step";
  }

//====================================================================== PART 1
void doStep1() //
  {
  titleOfStep[1] = "Recompute Delaunay Triangulation at each frame";
  M.reset();   
  M.loadVertices(Sites.G,Sites.pointCount); 
  M.computeDelaunayTriangulation(); 
  M.computeOfast();
  guide="My keys: '0'...'9' to activate/deactivate step";
  }
  
//====================================================================== PART 2 //*** STUDENT: Phase A 
void doStep2() //
  {
  titleOfStep[2] = "Label mesh vertices as interior (yellow) or border (red)";
  cw(grey,3);
  M.labelVerticesAsInteriorOrBorder(); //*** STUDENT MUST PROVIDE THE CODE FOR THIS METHOD   
  guide="My keys: '0'...'9' to activate/deactivate step";
  }

 //====================================================================== PART 3 //*** STUDENT: Phase B
void doStep3() //
  {
  titleOfStep[3] = "Redistribute interior vertices (towards neighbors)";
  M.redistributeInteriorVerticesTowardsNeighbors(0.1);     //*** STUDENT MUST PROVIDE THE CODE FOR THIS METHOD  
  M.redistributeInteriorVerticesTowardsNeighbors(-0.1); 
  M.writeVerticesTo(Sites);  
  guide="My keys: '0'...'9' to activate/deactivate step";
  }
  

 //====================================================================== PART 4 //*** STUDENT: Phase B (extra credit)
void doStep4() //
  {
  titleOfStep[4] = "Redistribute interior vertices (towards link)";
  M.redistributeInteriorVerticesTowardsLink(0.6);     //*** STUDENT MUST PROVIDE THE CODE FOR THIS METHOD  
  M.redistributeInteriorVerticesTowardsLink(-0.6); 
  guide="My keys: '0'...'9' to activate/deactivate step";
  }

 //====================================================================== PART 5 //*** STUDENT: Phase C (preliminary)
void doStep5() //
  {
  titleOfStep[5] = "Show left & right neighbors of beach-facing corner (disables step 1)";
  fill(magenta); M.showCurrentCorner(5); 
  M.showBeachNeighbors(5);     //*** STUDENT MUST PROVIDE THE CODE FOR THIS METHOD  
  noStroke();
  guide="My keys: '0'...'9' to activate/deactivate step";
  }
  
 //====================================================================== PART 6 //*** STUDENT: Phase C (tuck/untuck)
void doStep6() //
  {
  titleOfStep[6] = "Border smoothing (Tuck & Untuck)";
  cw(blue,2); // color of arrows showing smoothing vectors
  M.smoothenBorderWithTuck(0.3); //*** STUDENT MUST PROVIDE THE CODE FOR THIS METHOD 
  M.smoothenBorderWithTuck(-0.3); 
  guide="My keys: '0'...'9' to activate/deactivate step";
  }

 //====================================================================== PART 7 //*** STUDENT: Phase C (extra credit)
void doStep7() //
  {
  titleOfStep[7] = "Border smoothing (Cubic predictor)";
  cw(dred,2); // color of arrows showing smoothing vectors
    M.smoothenBorderWithCubicPredictor(0.3); //*** STUDENT MUST PROVIDE THE CODE FOR THIS METHOD 
    M.smoothenBorderWithCubicPredictor(-0.3); 
   guide="My keys: '0'...'9' to activate/deactivate step";
  }

 //====================================================================== PART 8
void doStep8() //
  {
  titleOfStep[8] = "Update sites from smoothened mesh vertices";
  M.writeVerticesTo(Sites);  
  guide="My keys: '0'...'9' to activate/deactivate step";
  }
    
  
//====================================================================== PART 9
void doStep9() //
  {
  titleOfStep[9] = "Show triangles, edges, and color-coded vertices. 'T' triangle fill, 'o' opposites"; 
  if(showTriangles) M.showTriangles();
  if(showEdges) {cw(dgreen,4); M.showEdges(); }
  if(showEdges) {cw(dred,8); M.showBorderEdges();}
  if(showVertices) M.showVertices(6);
  cwF(grey,1); if(showOpposite) M.showOpposites();  
  cwF(dgreen,1); if(showIDs) Sites.writeIDsInEmptyDisks();
  cwF(dred,1); if(showIDs) Sites.showPickedPoint(16);
  guide="My keys: '0'...'9' to activate/deactivate step";
  }
  

//======================= called when a key is pressed
void myKeyPressed()
  {
  if(key=='<') MyFramesInAnimation=max(9,MyFramesInAnimation/2);
  if(key=='>') MyFramesInAnimation*=2;
  println(MyFramesInAnimation);
  }

  
//======================= called when the mouse is dragged
void myMouseDragged()
  {
  if (keyPressed) 
    {
    }
  }

//======================= called when the mouse is pressed 
void myMousePressed()
  {
  }
  
