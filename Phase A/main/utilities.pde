// LecturesInGraphics: utilities
// Author: Jarek ROSSIGNAC, last edited on August, 2016 


// ************************************************************************ COLORS 
// ************************************************************************ COLORS 
color  // set more colors using Menu >  Tools > Color Selector
   black=#000000, grey=#5F5F5F, white=#FFFFFF,   
   pink=#FF8B8F, red=#FF0000, dred=#FF0000,
   lime=#9EFF6F, green=#10DE02, dgreen=#076A01, 
   cyan=#00FDFF, blue=#336DFC, dblue=#021FAA,
   yellow=#FEFF00, orange=#FFB217, brown=#815B09,
   magenta=#CE5DFF, dmagenta=#650190,
   metal=#C5DEE3, dmetal=#7A8D90,
   banana=#C7FC1C, dbanana=#77980E,
   gold=#FFE812, dgold=#988A0B,
   rose=#E37C6C, drose=#9D5449
   ;
/**/
color[] myColors = 
 { 
/*0*/ color(197,92,227), // persimon
/*1*/ color(157,176,255), // bleu pastel
/*2*/ color(150,154,82), // moss
/*3*/ color(124,65,7), // *6 flambe *
/*4*/ color(59,86,67), // billiard *
/*5*/ color(0,43,184), // blue
/*6*/ color(113,26,170), // beet 
/*7*/ color(198,106,31), // orange
/*8*/ color(197,171,137), // paper bag
/*9*/ color(206,215,92), // chartreuse
/**/ color(201,57,148), // fuchia 
/**/ color(1,137,135), // atlantic


/**/ color(87,44,41), // chocolate *7
/**/ color(194,129,107), // *8 mesa
/**/ color(0,56,43), // dgreen *

/**/ color(0,101,169), // royal blue *  color(0,101,169), // royal blue *
/**/ color(178,32,55), // red
/**/ color(161,206,94), // clover
/**/ color(119,87,64), // fudge

/**/ color(58,94,118), // baltic
/**/ color(128,84,98), // fig
/**/ color(204,193,219), // plum
 
/**/ color(162,149,176), // wisterin
/**/ color(158,143,102), // sagebush
/**/ color(66,42,74), // gothic grape *

 color(179,142,80), // antique gold
 color(255,226,147), // shimmer gold
 color(154,30,90), // crushed berry 
 color(235,182,175), // coral
 color(219,223,195), // sage

 color(139,116,173), // electric princess
 color(179,177,165), // gravel
 color(251,175,95), // poppy
 color(110,100,108), // officer
 color(249,203,154), // eggnog
 color(0,31,59), // ink *
 color(8,127,195), // bluewillow
 color(250,207,99), // curry *
 color(246,139,105), // papaya *
 color(72,31,37), // cherry mocha *
 color(255,239,108), // sunshine *
 color(57,18,66), // aubergine *
 color(88,87,75), // slate *
 color(10,85,143), // blue blue
 color(86,58,34), // brown
 color(26,134,168), // lake *
 color(0,145,156), // peacock *
 color(200,201,208), // shimmer silver *
 color(141,80,36) // ginger bread *
 };

void showMyColors()    
    {
    cwF(black,2); noFill();   
    int mij=ceil(sqrt(myColors.length));
    float ss = 80;
    for(int i=0; i<mij; i++)
      for(int j=0; j<mij; j++) 
        {
        if(mij*j+i<myColors.length) cwf(black,2,myColors[mij*j+i]); else fill(255);
        rect(20+ss*i, 130+ss*j, ss, ss);
        }
    }

class COLOR_RAMP
  {
  int n=2;
  int hue0=20, hue1=300;
  int sat=90;
  int light=240, dark=40;
  COLOR_RAMP(int np) {n=np;}
  //color C0b=color(hue0,sat,dark), C1b=color(hue1,sat,light);
  color C0b=color(hue0,sat,light), C1b=color(hue1,sat,dark);
  color col(int i) {return lerpColor(C0b,C1b,(float)i/(n-1));}
  }
  


// **************************************************** STROKE COLOR, WIDTH, FILL, OPACITY
void c(color c) {stroke(c);} // color, width, fill with opacity
void w(int w) {strokeWeight(w);}         // color, width, noFill
void f(color f) {fill(f); }                                  // noColor, fill
void fo(color f, int o) {fill(f,o); }                        // noColor, fill with opacity
void cw(color c, int w) {stroke(c); strokeWeight(w);} // color, width, fill
void cwf(color c, int w, color f) {stroke(c); strokeWeight(w); fill(f); } // color, width, fill
void cWf(color c, color f) {stroke(c); strokeWeight(1); fill(f); } // color, width, fill
void cwfo(color c, int w, color f, int o) {stroke(c); strokeWeight(w); fill(f,o); } // color, width, fill with opacity
// uppercase: S means no stroke, F means no fill
void F() {noFill(); }         // color, width, noFill
void cwF(color c, int w) {stroke(c); strokeWeight(w); noFill(); }         // color, width, noFill
void Sf(color f) {noStroke(); fill(f); }                                  // noColor, fill
void Sfo(color f, int o) {noStroke(); fill(f,o); }                        // noColor, fill with opacity


void showDisk(float x, float y, float r) {ellipse(x,y,r*2,r*2);}

// ************************************************************************ SAVING INDIVIDUAL IMAGES OF CANVAS  
int pictureCounter=0;

// these three save number image files with the canvas image at the end of draw

boolean recordingPDF=false; // most compact and great, but does not always work
void startRecordingPDF() {beginRecord(PDF,"IMAGES/PICTURES_PDF/P"+nf(pictureCounter++,3)+".pdf"); }
void endRecordingPDF() {endRecord(); recordingPDF=false;}

boolean snapJPGpicture=false;
void snapPictureToJPG() {saveFrame("IMAGES/PICTURES_JPG/P"+nf(pictureCounter++,3)+".jpg"); snapJPGpicture=false;}

boolean snapTIFpicture=false;   
void snapPictureToTIF() {saveFrame("IMAGES/PICTURES_TIF/P"+nf(pictureCounter++,3)+".tif"); snapTIFpicture=false;}


//***************************************************************************************** MAKING A MOVIE
boolean filming=false, filmingTIF=false, filmingJPG=false;  // when true frames are captured in FRAMES for a movie
boolean changed=false;   // true when the user has presed a key or moved the mouse
boolean animating=false; // must be set by application during animations to force frame capture
int frameCounter=0;
void snapFrameToTIF(){saveFrame("IMAGES/MOVIE_FRAMES_TIF/F"+nf(frameCounter++,4)+".tif");} 
void snapFrameToJPG(){saveFrame("IMAGES/MOVIE_FRAMES_JPG/F"+nf(frameCounter++,4)+".jpg");} 

// ************************************************************************ TEXT 
void scribe(String S, float x, float y) {fill(0); text(S,x,y); noFill();} // writes on screen at (x,y) with current fill color
void scribeHeader(String S, int i) { text(S,10,25+i*25); noFill();} // writes black at line i
void scribeHeaderRight(String S) {fill(0); float w = textWidth(S); text(S,width-w-10,25); noFill();} // writes black on screen top, right-aligned
void scribeFooter(String S, int i) {scribeFooter(S,i,0);} // writes black on screen at line i from bottom
void scribeFooter(String S, int i, color c) {fill(c); text(S,10,height-10-i*25); noFill();} // writes black on screen at line i from bottom
void scribeAtMouse(String S) {fill(0); text(S,mouseX,mouseY); noFill();} // writes on screen near mouse
void scribeMouseCoordinates() {fill(black); text("("+mouseX+","+mouseY+")",mouseX+7,mouseY+25); noFill();}
void displayHeader()  // Displays title and authors face on screen
    {
    //image(PictureOfMyFace, width-PictureOfMyFace.width/2,30,PictureOfMyFace.width/2,PictureOfMyFace.height/2); 
    scribeHeader(title,0);                                                     
    scribeHeaderRight(name); 
    scribeHeader(subtitle,1);    
    float w = PictureOfMyFace.width, h = PictureOfMyFace.height;
    float s = min(150./w,200/h);
    w*=s; h*=s;
    image(PictureOfMyFace, width-w,30,w,h); 
    }
void displayFooter()  // Displays help text at the bottom
    {
    scribeFooter(menu0,1,black); 
    scribeFooter(menu1,2,blue); 
    noFill();
    }
    
void displayGuide()  // Displays help text at the bottom
    {
    scribeFooter(guide,0,red); 
    noFill();
    }

//
// this list contains strings that fit within maxWidth Kokodoko
//
StringList wordWrap(String s, int maxWidth) {
  // Make an empty ArrayList
  StringList a = new StringList();
  float w = 0;    // Accumulate width of chars
  int i = 0;      // Count through chars
  int rememberSpace = 0; // Remember where the last space was
  // As long as we are not at the end of the String
  while (i < s.length()) {
    // Current char
    char c = s.charAt(i);
    w += textWidth(c); // accumulate width
    if (c == ' ') rememberSpace = i; // Are we a blank space?
    if (w > maxWidth) {  // Have we reached the end of a line?
      String sub = s.substring(0,rememberSpace); // Make a substring
      // Chop off space at beginning
      if (sub.length() > 0 && sub.charAt(0) == ' ') sub = sub.substring(1,sub.length());
      // Add substring to the list
      a.append(sub);
      // Reset everything
      s = s.substring(rememberSpace,s.length());
      i = 0;
      w = 0;
    } 
    else {
      i++;  // Keep going!
    }
  }

  // Take care of the last remaining line
  if (s.length() > 0 && s.charAt(0) == ' ') s = s.substring(1,s.length());
  a.append(s);

  return a;
}

void writeWrappedText(String S, PNT P, int fontSize, int w) 
   {
   StringList Lines = wordWrap(S, w);
   float y = P.y;
   for (int i=0; i < Lines.size(); i++) 
      {
      String L = Lines.get(i);
      text(L, P.x, y);
      y += fontSize;
      }
   }

// *********************************************************** TIME WARP: EASE-IN/OUT INTERPOLATING 3 VALUES
float easeInOut( float a, float b, float c, float t)
   {
   return
      a*b*c*(sq(a) - a*b - c*(b - c))/(sq(-c + a)*(b - c)*(-b + a))
    - (2.*sq(a) + 2.*(b - c)*a - 6*sq(b) + 2.*b*c + 2.*sq(c))*a*c/(sq(-c + a)*(b - c)*(-b + a))*t
    + (a*a*a + (b + 2.*c)*sq(a) + (-3*sq(b) - 2.*b*c + 2.*sq(c))*a - 3*sq(b)*c + sq(c)*b + c*c*c)/(sq(-c + a)*(b - c)*(-b + a))*t*t
    + (-2.*sq(a) + (2.*b - 2.*c)*a + 2.*sq(b) + 2.*b*c - 2.*sq(c))/(sq(-c + a)*(b - c)*(-b + a))*t*t*t
    + (a - 2.*b + c)/(sq(-c + a)*(b - c)*(-b + a))*t*t*t*t 
    ;
    }
    
// ************************** Clipboard utilities **************************
public static String getClipboard() {   // returns content of clipboard (if it contains text) or null
       Transferable t = Toolkit.getDefaultToolkit().getSystemClipboard().getContents(null);
       try {if (t != null && t.isDataFlavorSupported(DataFlavor.stringFlavor)) {
               String text = (String)t.getTransferData(DataFlavor.stringFlavor);
               return text; }} 
       catch (UnsupportedFlavorException e) { } catch (IOException e) { }
       return null;
       }
public static void setClipboard(String str) { // This method writes a string to the system clipboard.
       StringSelection ss = new StringSelection(str);
       Toolkit.getDefaultToolkit().getSystemClipboard().setContents(ss, null);
       }
