// Course template for 2D projects provided by Prof. Jarek ROSSIGNAC
import processing.pdf.*;    // to save screen shots as PDFs, does not always work: accuracy problems, stops drawing or messes up some curves !!!
import java.awt.Toolkit;
import java.awt.datatransfer.*;

//**************************** global variables ****************************
// FONT TEXT
PFont font;
String MyText=""; // string copied from clipboard to be printed on canvas FAST
float stringX=0, stringY=0;
Boolean scribeText=true; // toggle for displaying of help text

// Editable Control points (used for Voronoi sites or vertices of polyline or polyloop)
PNTS Sites = new PNTS(); // class containing array of points, used to standardize GUI
PNTS R;
boolean showIDs = false;

// Arrows
ARROW ArrowRed=Arrow(), ArrowGreen=Arrow(), ArrowBlue=Arrow(), ArrowMagenta=Arrow(), ArrowMetal=Arrow(), ArrowBanana=Arrow();
boolean first=true; // used to distinguish creation and update of arrows
boolean showFaceWarp=false; // used to distinguish creation and update of arrows
boolean showControlArrows=false;

// Animation
boolean animate=false;
float currentTime=0, warpedTime=0;  // current and warped time
int currentFrame=0; // frame to advance timing
int framesInAnimation=360; // intermediate frames for the whole animation 
boolean easeInOut=true;

//**************************** initialization ****************************
void setup()               // executed once at the beginning 
  {
  size(1000, 1000, P2D);     // window size (need P2D for texture mapping)
  //fullScreen(P2D, 2);
  //size(800, 800, P2D);     // window size (need P2D for texture mapping)

  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing for drawing curves
  PictureOfMyFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  //PictureOfMyFace = loadImage("data/JR.jpg");  // load image from file JR.jpg in folder data *** replace that file with your pic of your own face
  PictureOfBanner = loadImage("data/GTbanner.jpg");  // load image from file GTbanner.jpg in folder data *** replace that file with your pic of your own face
  Sites.declare(); // declares all ControlPoints. MUST BE DONE BEFORE ADDING POINTS 
  Sites.loadControlPointsFromFile("data/pts");  // loads points form file saved with this program
  //Sites.placeWxWpointsOnHexGrid(10);
  //ControlPoints.resetPointsOnCircle(18); // uncomment to create new config with 8 or whatever number of points. Then edit them and save with 'S'
  //for(int i=0; i<10; i++) ControlPoints.saveControlPointsToFile("data/pts"+str(i));
  declareArrows();
  //loadControlArrows("data/arrows0");
  //setPointsToArrows(ControlPoints); 
  colorMode(HSB, 360, 100, 100); // Hue, saturation, brightness
  textureMode(NORMAL);
  font = loadFont("ChalkboardSE-Regular-32.vlw"); textFont(font, 24);
  //loadControlArrows("data/arrows"+str(partShown)); 
  //setPointsToArrows(ControlPoints);
  R=Sites;
  mySetup();
  
  } // end of setup

//**************************** display current frame ****************************
void draw()      // executed at each frame
  {
  int i=0;
  background(white); // clear screen by painting white background 
  textAlign(CENTER,CENTER);

  // advance animation (toggled on/off using 'a')
  if(animate) 
    {
    if(currentFrame==framesInAnimation) currentFrame=0;
    currentFrame++; 
    if (currentFrame>framesInAnimation) {currentFrame=0; animate=false;}
    float t = (float)currentFrame/framesInAnimation;
    float ct=(1.-cos(TWO_PI*t))/2;
    if(easeInOut) currentTime=easeInOut(0,0.5,1,ct); 
    else currentTime=ct;
    }

  if(recordingPDF) startRecordingPDF(); // starts recording graphics to make a PDF
  if(showQuadGrid) drawQuadGrid(50);
  if(showHexGrid) drawHexGrid(50);
  if(showKagomeGrid) drawKagomeGrid(50);




  showMyProject(Sites);  // executes the active steps of your project using the set "sites" of points




  showTextFromClipBoard();  
  showPointer(); // show mouse pointer and mouse and key pressed (will not show on pictures)

  textAlign(LEFT,BOTTOM);
  //f(red); scribeHeader("Part "+str(partShown)+": "+titleOfStep[partShown],3);
  //f(black); scribeHeader("time = "+nf(currentTime,0,2),2);
  if(scribeText) if(live) scribeFooter("LIVE",3);

  if(scribeText) displayGuide(); // shows help for selected PART of myProject

  fill(black);  if(scribeText) displayHeader(); // displays header
  if(scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 
  if(recordingPDF) endRecordingPDF();  // end saving a .pdf file with the image of the canvas


  if(filmingTIF && (animate || changed)) snapFrameToTIF(); // saves image on canvas as movie frame 
  if(filmingJPG && (animate || changed)) snapFrameToJPG(); // saves image on canvas as movie frame 
  if(snapTIFpicture) snapPictureToTIF();   
  if(snapJPGpicture) snapPictureToJPG();   
  changed=false; // to avoid capturing movie frames when nothing happens
  }  // end of draw
  
