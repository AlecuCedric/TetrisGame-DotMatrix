#include <mega164a.h>
#include <delay.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

// Declare your global variables here

int mMatrix[10][12] = {
        {9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 9, 9},
        {9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 9, 9},
        {9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 9, 9},
        {9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 9, 9},
        {9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 9, 9},
        {9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 9, 9},
        {9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 9, 9},
        {9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 9, 9},
        {9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9},
        {9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9},
};

int const mTetromino[7][4][4] = {
        { // I
                {0, 1, 0, 0},
                {0, 1, 0, 0},
                {0, 1, 0, 0},
                {0, 1, 0, 0}
        },
        { // O
                {0, 0, 0, 0},
                {0, 1, 1, 0},
                {0, 1, 1, 0},
                {0, 0, 0, 0}
        },
        { // T
                {0, 0, 1, 0},
                {0, 1, 1, 0},
                {0, 0, 1, 0},
                {0, 0, 0, 0}
        },
        { // Z
                {0, 0, 1, 0},
                {0, 1, 1, 0},
                {0, 1, 0, 0},
                {0, 0, 0, 0}
        },
        { // S
                {0, 1, 0, 0},
                {0, 1, 1, 0},
                {0, 0, 1, 0},
                {0, 0, 0, 0}
        },
        { // L
                {0, 1, 0, 0},
                {0, 1, 0, 0},
                {0, 1, 1, 0},
                {0, 0, 0, 0}
        },
        { // J
                {0, 0, 1, 0},
                {0, 0, 1, 0},
                {0, 1, 1, 0},
                {0, 0, 0, 0}
        }
};

int mCurrentPiece[4][4] = {
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0}
};

//Variable for the position of top left cell of the piece on the board
int nPosX, nPosY;
bool nGetNextPiece, GameOver = false;;

// Assign a Tetromino to our current piece
void mAssignTetromino(int Index) {
    int i, j;
    for (i = 0; i < 4; i++) {
        for (j = 0; j < 4; j++) {
            mCurrentPiece[i][j] = mTetromino[Index][i][j];
        }
    }
}

// Place the piece on the board (useful for display)
void mPlacePiece(){
    int i, j;
    for(i = 0; i < 4; i++){
        for(j = 0; j < 4; j++){
            if(mCurrentPiece[i][j] == 1){ //Place rewrite cell only if its 0
                mMatrix[nPosX + i][nPosY + j] = mCurrentPiece[i][j];
            }
        }
    }
}

// Remove piece from the board
void mRemovePiece(){
    int i, j;
    for(i = 0; i < 4; i++){
        for(j = 0; j < 4; j++){
            if(mCurrentPiece[i][j] == 1) { //Place rewrite cell only if its 0
                mMatrix[nPosX + i][nPosY + j] = 0;
            }
        }
    }
}

// Lock piece in place on the board
void mLockPiece(){
    mPlacePiece();
    nGetNextPiece = true;
}

// Rotate the piece left 0 or right 1
void mRotate(int direction) {
    int temp[4][4];  
    int i, j;

    // Rotate right (clockwise)
    if (direction == 1) { 
        for (i = 0; i < 4; i++) {
            for (j = 0; j < 4; j++) {
                temp[j][3 - i] = mCurrentPiece[i][j];
            }
        }
    }
        // Rotate left (counterclockwise)
    else if (direction == -1) { 
        for (i = 0; i < 4; i++) {
            for (j = 0; j < 4; j++) {
                temp[3 - j][i] = mCurrentPiece[i][j];
            }
        }
    }

    // Copy the result back to McurrentPiece
    for (i = 0; i < 4; i++) {
        for (j = 0; j < 4; j++) {
            mCurrentPiece[i][j] = temp[i][j];
        }
    }
}

//Display The Dot Matrix 
void mPrintMatrix(){ //Dot Matrix Display print
    int i, j;
    for(i = 0; i < 8; i++){  
        PORTA = ~(1 << i);
        PORTB = 0x00;
        for(j = 2; j < 10; j++){
            PORTB |= mMatrix[i][j] << j-2;
        }
        delay_ms(2);
    }
}

// Check if piece fits in the location (doesn't overlap with other pieces and is in the boarder)
bool mDoesPieceFit() {
    int i, j, boardX, boardY;
    for (i = 0; i < 4; i++) {
        for (j = 0; j < 4; j++) {
            // Skip if the block in the piece is empty
            if (mCurrentPiece[i][j] == 0) {
                continue;
            }

            boardX = nPosX + i;
            boardY = nPosY + j;

            // Ensure that the block is within the board boundaries
            if (boardX < 0 || boardX >= 10 || boardY < 0 || boardY >= 12) {
                return false;
            }

            // If the block is outside the playable 8x8 area or it overlaps with any non-zero value in the board
            if (mMatrix[boardX][boardY] != 0) {
                return false;
            }
        }
    }
    return true;
}

// Move piece left or right
void mPieceMove(int nDirection){
    mRemovePiece();
    nPosY += nDirection;
    if(mDoesPieceFit()){ // If the new position is valid, move
        mPlacePiece();
    }else{ // If not then return to last position
        nPosY -= nDirection;
        mPlacePiece();
    }
}

// Push The piece down by 1 cell
void mPushPieceDown() {
    mRemovePiece();
    nPosX++;
    if (mDoesPieceFit() == true) {
        mPlacePiece();
    } else {
        nPosX--;  // Revert the move
        mPlacePiece();  // Place the piece back
        mLockPiece();  // Lock the piece in place
    }
}

// Get user Input TO DO //// TO DO /////////////////////////////////////
void mGetUserInput(int input){
    switch (input) {
        case 1:
            mPieceMove(-1);
            break;
        case 2:
            mPieceMove(1);
            break;
        case 3:
            mRemovePiece();
            mRotate(1);
            if(!mDoesPieceFit()){
                mRotate(-1);
            }
            mPlacePiece();
            break;
        case 4:
            mPushPieceDown();
            break;
        default:
            printf("Invalid command!\n");
            break;
    }
}

// Clear full rows from the board
void mClearFullRows() {
    int i, j, k;
    // Loop through each row from the second last row (index 7) to the top row (index 0)
    for (i = 7; i >= 0; i--) {
        bool isFull = true;
        // Check if the row is full, ignoring the left and right borders
        for (j = 1; j < 9; j++) {
            if (mMatrix[i][j] == 0) {
                isFull = false;
                break;
            }
        }
        // If the row is full, clear it and shift everything above it down
        if (isFull) {
            // Clear Row and print ===============
            for (j = 2; j < 10; j++) {
                k = i;
                mMatrix[k][j] = 0;
            }
            mPrintMatrix();
            // Shift all rows above the current one down
            for (k = i; k > 0; k--) {
                for (j = 2; j < 10; j++) {
                    mMatrix[k][j] = mMatrix[k - 1][j];
                }
            }
            // Clear the top row after shifting
            for (j = 2; j < 10; j++) {
                mMatrix[0][j] = 0;
            }
            // Since the current row has been cleared, check the same row again
            i++;
        }
    }
}

// Function to generate a random number between 0 and 6
int mGetRandomTetrominoIndex() {
    return rand() % 7;
}

// Function to check if the game is over
void mGetGameOver() {
    int j;
    // Check the top two rows (0 and 1) for any non-zero values within the playable area (columns 2 to 9)
    for (j = 2; j < 10; j++) {
        if (mMatrix[0][j] != 0 || mMatrix[1][j] != 0) {
            GameOver = true;
            printf("Game Over!\n");
            return;
        }
    }
    GameOver = false;
}

// Function to read button input and change Input Variable
int read_buttons()
{
    // Check each button
    if (!(PINC & (1 << 7)))
    {
        delay_ms(60);  // Debounce delay
        if (!(PINC & (1 << 7)))  // Check again after delay
        {
            return 1;  // Button on PC7 pressed
        }
    }
    else if (!(PINC & (1 << 6)))
    {
        delay_ms(60);  // Debounce delay
        if (!(PINC & (1 << 6)))  // Check again after delay
        {
            return 2;  // Button on PC6 pressed
        }
    }
    else if (!(PINC & (1 << 5)))
    {
        delay_ms(60);  // Debounce delay
        if (!(PINC & (1 << 5)))  // Check again after delay
        {
            return 3;  // Button on PC5 pressed
        }
    }
    else if (!(PINC & (1 << 4)))
    {
        delay_ms(60);  // Debounce delay
        if (!(PINC & (1 << 4)))  // Check again after delay
        {
            return 4;  // Button on PC5 pressed
        }
    }

    return 0;  // No button pressed
}

void mPrintGameOver(){
    int i, j;
    for(i = 0; i < 8; i++){
        for(j = 2; j < 10; j++){
            mMatrix[i][j] = 1;
        }
    }
    mPrintMatrix();
}

void main(){
    int randomIndex;
    int input;
    GameOver = false;
    
    DDRA = 0xFF; //Set port A pins as output
    DDRB = 0xFF; //Set port B pins as output
    
    PORTA = 0x00; //Set A pins to low
    PORTB = 0xFF; //Set B pins to high 
                                      
    DDRC |= (1 << 3); // Set PC3 as output for the buzzer
    
    // Configure Buttons
    // Configure PC7, PC6, PC5, PC4 as input
    DDRC &= ~((1 << 7) | (1 << 6) | (1 << 5) | (1 << 4));

    // Enable internal pull-up resistors for PC7, PC6, PC5 and PC4
    PORTC |= (1 << 7) | (1 << 6) | (1 << 5) | (1 << 4);
              
    //play_tetris_theme(); // Play the Tetris theme at the start

    //Main Game Loop
    while (!GameOver){ 
        // Game Timing ////////////////////////////////////////////
        
        // Initial Game parameters ////////////////////////////////

        // Check if the game is over before spawning a new piece
        mGetGameOver();
        if (GameOver) {
            break;
        }
        // Spawn the new piece in the middle of the board
        nPosX = 0;
        nPosY = 4;

        // Get a random piece
        randomIndex = mGetRandomTetrominoIndex();
        mAssignTetromino(randomIndex);

        // Place the piece in the top middle and display the initial move
        mPlacePiece();
        mPrintMatrix();
        
        // Reset nGetNextPiece to false
        nGetNextPiece = false;

        // Initial Game parameters ////////////////////////////////
        // ////////////////////////////////////////////////////////
        // Current Piece Logic ////////////////////////////////////

        // While there is no need for a new piece
        while(!nGetNextPiece){      
            input = read_buttons();
            mGetUserInput(input);
            mPrintMatrix();
            // Add a small delay to avoid high CPU usage (optional)
            delay_ms(10);
        }
        // Current Piece Logic ////////////////////////////////////
        
        mClearFullRows(); 
    }   
    mPrintGameOver();
    while(true){
        mPrintMatrix();
    }
}