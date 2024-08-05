#include <mega164a.h>
#include <delay.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

// Declare your global variables here

int Matrix[8][8]; //Dot Matrix Display

int pattern[8][8] = {
        {0, 1, 1, 1, 1, 1, 1, 0},
        {1, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 1},
        {1, 1, 1, 1, 1, 1, 1, 1},
        {1, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 1}
    }; 
    
int pattern2[8][8] = {
        {1, 1, 1, 1, 1, 1, 0, 0},
        {1, 0, 0, 0, 0, 0, 1, 0},
        {1, 0, 0, 0, 0, 0, 1, 0},
        {1, 1, 1, 1, 1, 1, 0, 0},
        {1, 0, 0, 0, 0, 0, 1, 0},
        {1, 0, 0, 0, 0, 0, 1, 0},
        {1, 0, 0, 0, 0, 0, 1, 0},
        {1, 1, 1, 1, 1, 1, 0, 0}
    }; 

void MatrixInit(){ //Dot Matrix Display initialization
    int i, j;
    for(i = 0; i < 8; i++){
        for(j = 0; j < 8; j++){
            Matrix[i][j] = 0;
        }
    }
}

void MatrixPrint(){ //Dot Matrix Display print
    int i, j;
    for(i = 0; i < 8; i++){  
        PORTA = ~(1 << i);
        PORTB = 0x00;
        for(j = 0; j < 8; j++){
            PORTB |= Matrix[i][j] << j;
        }
        delay_ms(60);
    }
}

void MatrixSet(){
    int i, j;
    for (i = 0; i < 8; i++) {
            for (j = 0; j < 8; j++) {
                Matrix[i][j] = pattern[i][j];
            }
        }
}

void MatrixSet2(){
    int i, j;
    for (i = 0; i < 8; i++) {
            for (j = 0; j < 8; j++) {
                Matrix[i][j] = pattern2[i][j];
            }
        }
}
   
void main(void){
    DDRA = 0xFF; //Set port A pins as output
    DDRB = 0xFF; //Set port B pins as output
    
    PORTA = 0x00; //Set A pins to low
    PORTB = 0xFF; //Set B pins to high

    while (1){ 
        //Snake(); 
        MatrixSet(); 
        MatrixPrint(); 
        MatrixPrint();
        MatrixInit();
        MatrixPrint();
        delay_ms(2000);
        MatrixSet2();
        MatrixPrint();
        MatrixPrint();
        MatrixInit();
        MatrixPrint(); 
        delay_ms(1000);
    }
}