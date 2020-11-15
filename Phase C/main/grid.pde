boolean showQuadGrid = false;
void drawQuadGrid (int w) // draw a 2D grid of w x w vertices
   {
   float s = 0.5*height;
   float d = .7*height/(w-1);
   PNT O = ScreenCenter();
   VCT I = V(height/(w-1),0);
   VCT J = R(I);
    for(int j=0; j<2; j++)
       {
       I = R(I);
       J = R(I);
       cwF(lime,1);
       for (int i=-w; i<w; i++) edge(P(O,i,I),s,J);
       for (int i=-w; i<w; i++) edge(P(O,i,I),-s,J);
       cwF(lime,2);
       for (int i=-w; i<w; i++) edge(P(O,i*4,I),s,J);
       for (int i=-w; i<w; i++) edge(P(O,i*4,I),-s,J);
       }
   }  
   
boolean showHexGrid = false;
void drawHexGrid (int w) // draw a 2D grid of w x w vertices
   {
   float s = 0.7*height; // length of lines
   float z = height/w;
   PNT O = ScreenCenter();
   VCT I = V(z,0);
   VCT J = V(0,0);
   for(int j=0; j<3; j++)
       {
       I = R(I,TWO_PI/3);
       J = R(I,PI/3);
       cwF(lime,1);
       for (int i=-w; i<w; i++) edge(P(O,i,I),s,J);
       for (int i=-w; i<w; i++) edge(P(O,i,I),-s,J);
       cwF(lime,2);
       for (int i=-w; i<w; i++) edge(P(O,i*4,I),s,J);
       for (int i=-w; i<w; i++) edge(P(O,i*4,I),-s,J);
       cwF(lime,3);
       for (int i=-w; i<w; i++) dashedEdge(P(O,i*4,I,-w*2+(i*4)%12,J),4,8,J,w);
       }
  }  

void dashedEdge(PNT P, int d, int o, VCT V, int k) 
  {
  for (int i=0; i<k; i++) edge(P(P,i*(d+o),V),d,V);
  }

boolean showKagomeGrid = false;
void drawKagomeGrid(int w) // draw a 2D grid of w x w vertices
   {
   float s = 0.7*height; // length of lines
   float z = height/w;
   float d = sqrt(5./4);
   PNT O = ScreenCenter();
   VCT I = V(z,0);
   VCT J = V(0,0);
   for(int j=0; j<3; j++)
       {
       I = R(I,TWO_PI/3);
       J = R(I,PI/3);
       cwF(lime,1);
       for (int i=-w; i<w; i++) edge(P(O,i,I),s,J);
       for (int i=-w; i<w; i++) edge(P(O,i,I),-s,J);
       cwF(lime,2);
       for (int i=-w; i<w; i++) edge(P(O,i*4,I),s,J);
       for (int i=-w; i<w; i++) edge(P(O,i*4,I),-s,J);
       cwF(lime,4);
       if(j==1)
         {
         for (int i=-w; i<w; i++) edge(P(O,i*4*2+4,I),s,J);
         for (int i=-w; i<w; i++) edge(P(O,i*4*2+4,I),-s,J);
         }
       else
         {
         for (int i=-w; i<w; i++) edge(P(O,i*4*2+4,I),s,J);
         for (int i=-w; i<w; i++) edge(P(O,i*4*2+4,I),-s,J);
         }
       }
  //for (int i=-w; i<w; i++) {dashedEdge(P(O,i*4,I,-w*2+(i*4)%12,J),4,8,J,w);}
  }  
  
