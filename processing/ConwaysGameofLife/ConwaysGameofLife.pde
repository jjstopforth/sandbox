/**
* Conway's Game of Life "game" visualiser
* Author: Julius Stopforth
* Date: 08.03.2016
**/

// 0 means empty 1 means alive
byte[][] grid;

color backgroundColor = #39d4f2;
color foregroundColor = #03c03c;

int numcols, numrows;
int population;

void setup ()
{
  frameRate(10);
  size(400,400);
  
  //noLoop();
  noStroke();
  
  numcols = numrows = 100;
  
  grid = new byte[numrows][numcols];
  population = 0;
  
  // General debug/testing seed (Glider)
  
  // T-shape
  grid[50][50] = 1;
  grid[51][50] = 1;
  grid[50][51] = 1;
  grid[50][49] = 1;
  
  //Glider 1
  grid [48][45] = 1;
  grid [48][44] = 1;
  grid [48][43] = 1;
  grid [47][45] = 1;
  grid [46][45] = 1;
  
  //Glider 2
  grid [52][55] = 1;
  grid [52][56] = 1;
  grid [52][57] = 1;
  grid [53][55] = 1;
  grid [54][55] = 1;
  
  population = 14;

}

void draw()
{
  background(backgroundColor);
  grid = update_grid(grid);
  draw_grid(grid);
  println("Population: ", population);
}

byte[][] update_grid(byte[][] oldgrid)
{
  /**
  * ---Rules for updating---
  * For any cell x where number of live neighbours is N:
  * 1. x = 0  if x = 1 && N < 2
  * 2. x = 1  if x = 1 && N e {2,3}
  * 3. x = 0  if x = 1 && N > 3
  * 4. x = 1  if x = 0 && N = 3
  */
  
  byte[][] newgrid = new byte [numrows][numcols];
  
  for (int i=0; i < oldgrid.length; i++)
  {
    
    for (int j=0; j < oldgrid[i].length; j++)
    {
      
      int N = find_neighbours(oldgrid, j, i);
      
      if (N < 0)
      {
        println("Error occurred updating grid!");
        return null;
      }
      
      if (oldgrid[i][j] > 0)
      {
        if ( N < 2 || N > 3) { newgrid[i][j] = 0; population--; }
        else { newgrid[i][j] = 1;}
      }
      else if (oldgrid[i][j] == 0)
      {
        if (N == 3) { newgrid[i][j] = 1; population++;}
      }
      
    }
   
  }
  return newgrid;
}

int find_neighbours(byte[][] agrid, int posx, int posy)
{
  if ((posx >= agrid[0].length || posx < 0)||
  (posy >= agrid.length || posy < 0))
  {
    println("Error: Position of x:", posx, " y:", posy, " is outside the grid!");
    return -1;
  }
  
  /**
  * Cardinal directions to check are:
  *
  * (-1,-1) ( 0,-1) (+1,-1)
  *        \   |   /
  * (-1, 0)-( x,y )-(+1, 0)
  *        /   |   \
  * (-1,+1) ( 0,+1) (+1,+1)
  **/
  
  int num = 0;
  
  for (int y= -1; y <= 1; y++)
  {
    // If the y value is out of bounds then the posistion is right at the top or bottom border of the grid
    if ((posy + y) >= agrid.length || (posy + y) < 0 ) { continue; }
 
    for (int x = -1; x <=1; x++)
    {
      // If the x value is out of bounds skip it
      if ((posx + x) >= agrid[posy].length || (posx + x) < 0 ) { continue; }
      
      if (agrid[posy+y][posx+x] > 0 && !(x==0 && y==0)) { num++; }
    
    }
  }
  
  return num;

}

void draw_grid(byte[][] agrid)
{
  float colwidth = width/(float)numcols;
  float rowheight = height/(float)numrows;

  for(int i=0; i < agrid.length; i++)
  {
    for(int j=0; j < agrid[i].length; j++)
    {
      if (agrid[i][j] == 0) { continue; }
      float xpos = j*colwidth;
      float ypos = i*rowheight;
      
      fill(foregroundColor);
      ellipse(xpos, ypos, colwidth, rowheight );
    }

  }

}