DUCKS DucksRowA = new DUCKS(20);
DUCKS DucksRowB = new DUCKS(20);
class DUCKS
  {
  int maxDuckCount = 30;
  COLOR_RAMP ramp = new COLOR_RAMP(maxDuckCount);
  PNT [] Duckling = new PNT[maxDuckCount];  
  int duckCount = 12;

  DUCKS(int newCount)
    {
    duckCount = newCount; 
    init();
    ramp = new COLOR_RAMP(duckCount);
    }
    
  void incrementCount()
    {
    duckCount++; 
    ramp = new COLOR_RAMP(duckCount);
    }
    
  void decrementCount()
    {
    duckCount=max(3,duckCount-1);  
    ramp = new COLOR_RAMP(duckCount);
    }
    
  void init()
    {
    for(int d=0; d<duckCount; d++) Duckling[d]=P();
    }
  
  void init(PNT P)
    {
    for(int d=0; d<duckCount; d++) Duckling[d]=P(P);
    }
  
  PNT move(PNT M)
    {
    Duckling[0].setTo(M);
    for(int d=1; d<duckCount; d++) Duckling[d].dilateWrtPNT(0.5,Duckling[d-1]); 
    return Duckling[duckCount-1];
    }
 
  void showRow()
    {
    for(int d=0; d<duckCount; d++) 
      {
      cwf(black,1,ramp.col(d));
      show(Duckling[d],5);
      }
    }
  
  }
  
  
