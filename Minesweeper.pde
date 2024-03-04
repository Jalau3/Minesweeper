import de.bezier.guido.*;
private int NUM_ROWS = 10;
private int NUM_COLS = 10;
private int NUM_MINES = 5;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton> (); //ArrayList of just the minesweeper buttons that are mined
private int notMines = NUM_ROWS*NUM_COLS-NUM_MINES;
private int count;

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i<NUM_ROWS; i++){
      for(int j = 0; j<NUM_COLS; j++)
        buttons[i][j] = new MSButton(i,j);
    }
    setMines();
    count = 0;
}
public void setMines()
{
    //your code
    while(mines.size()<NUM_MINES){
      int r = (int)(Math.random()*NUM_ROWS);
      int c = (int)(Math.random()*NUM_COLS);
      if(!mines.contains(buttons[r][c])){
        mines.add(buttons[r][c]);
      }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
     if(count==notMines){
       return true;
     }
    return false;
}
public void displayLosingMessage()
{
    for(int i = 0; i<mines.size(); i++){
      if(mines.get(i).clicked == false)
        mines.get(i).mousePressed();
      mines.get(i).setLabel("Bomb");
    }
}
public void displayWinningMessage()
{
    buttons[NUM_ROWS/2-1][NUM_COLS/2-3].setLabel("Y");
    buttons[NUM_ROWS/2-1][NUM_COLS/2-2].setLabel("o");
    buttons[NUM_ROWS/2-1][NUM_COLS/2-1].setLabel("u");
    buttons[NUM_ROWS/2-1][NUM_COLS/2].setLabel("");
    buttons[NUM_ROWS/2-1][NUM_COLS/2+1].setLabel("w");
    buttons[NUM_ROWS/2-1][NUM_COLS/2+2].setLabel("o");
    buttons[NUM_ROWS/2-1][NUM_COLS/2+3].setLabel("n");

}
public boolean isValid(int r, int c)
{
    //your code here
    return(r>=0 && r < NUM_ROWS && c>=0 && c < NUM_COLS);
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r=row-1; r<row+2; r++){
      for(int c=col-1; c<col+2; c++){
        if(isValid(r,c) && mines.contains(buttons[r][c])){
          numMines++;
        }
      }
    }
    return numMines;
  }
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        //your code here
        if(mouseButton==RIGHT){
          if(clicked==false)
            flagged=!flagged;
        }
        else if(flagged == true){
        }
        else{
          count++;
          clicked = true;
          if(mines.contains(this)){
            displayLosingMessage();
          }
          else if(countMines(myRow,myCol)>0){
            setLabel(countMines(myRow,myCol));
          }
          else{
            for(int r=myRow-1; r<myRow+2; r++){
              for(int c=myCol-1; c<myCol+2; c++){
                if(isValid(r,c) && buttons[r][c].isFlagged()==false && buttons[r][c].clicked==false){
                  buttons[r][c].mousePressed();
                }
              }
            }  
          }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public void setFill(color rgb){
        fill(rgb); 
    }
}
