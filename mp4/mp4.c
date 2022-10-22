#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include "mp4.h"

//In this mp4 program, we try to solve a row of a nano program
//In particular, given the number of pixels in up to four regions and the number of pixels in the 
//corresponding row, we need to identify those pixels known to be part of one of the regions. 
//First i will make a row array to identify which one of the space need to be marked with 'X' or '.'
//and this row array should be initialized with all '.'
//Then i use 4 array to calculate which space must be marked with 'X',
//To do this, we need to determine whether this grid is passed in each movement
//In the end, we marked all the grid that passed in each movement in the row array and output with 'X' else '.'

int32_t print_row (int32_t r1, int32_t r2, int32_t r3, int32_t r4, int32_t width)
{
    bool row[51]={false};   //first we need to initialize all grid to be false which means '.'
    int32_t space=(r2!=0)+(r3!=0)+(r4!=0);//calculate the minimum length of th grid we need to have
    int32_t sum=r1+r2+r3+r4+space;
    if (width<sum) return 0;                //if the pixels that needed is more than width, we exit the subroutine and return 0 
    int32_t row1[51]={0},row2[51]={0},row3[51]={0},row4[51]={0};   
    for(int32_t i=1;i<=width-r4-r2-r3-r1-space+1;i++){   //first black region can be moved in [1,width-r4-r2-r3-r1-space+1]
        for(int32_t j=0;j<r1;j++) row1[i+j]+=1;         //if this region passed one grid, we add grid with 1
    }
    for(int32_t i=1;i<=width-r4-r2-r3-space;i++){
        if(row1[i]==width-r4-r2-r3-r1-space+1) row[i]=true;     //if the value of certain grid == (width-r4-r2-r3-r1-space+1)
    }                                                           //it means that in every movement this grid is black, it msut be 'X'
    if(r2!=0){      //if r2==0, we don't need to process the second black region
        for(int32_t i=r1+1+(r2!=0);i<=width-r4-r3-r2-(r3!=0)-(r4!=0)+1;i++){ //second black region can be moved in [r1+1+(r2!=0),width-r4-r3-r2-(r3!=0)-(r4!=0)+1]
            for(int32_t j=0;j<r2;j++) row2[i+j]+=1;             //if this region passed one grid, we add grid with 1
        }
        for(int32_t i=r1+1+(r2!=0);i<=width-r4-r3-(r3!=0)-(r4!=0);i++){
            if(row2[i]==width-r4-r2-r3-r1-space+1) row[i]=true; //the meaning of this loop is as same as above
        }
    }
    if(r3!=0){      //if r3==0, we don't need to process the third black region
        for(int32_t i=r1+r2+1+(r2!=0)+(r3!=0);i<=width-r4-r3-(r4!=0)+1;i++){ //third black region can be moved in [r1+r2+1+(r2!=0)+(r3!=0),width-r4-r3-(r4!=0)+1]
            for(int32_t j=0;j<r3;j++) row3[i+j]+=1;                         //if this region passed one grid, we add grid with 1
        }
    for(int32_t i=r1+r2+1+(r2!=0)+(r3!=0);i<=width-r4-(r4!=0);i++){
            if(row3[i]==width-r4-r2-r3-r1-space+1) row[i]=true;   //the meaning of this loop is as same as above           
        }
    }
    if(r4!=0){      //if r3==0, we don't need to process the fourth black region
        for(int32_t i=r1+r2+r3+1+(r2!=0)+(r3!=0)+(r4!=0);i<=width-r4+1;i++){ //fourth black region can be moved in [r1+r2+r3+1+(r2!=0)+(r3!=0)+(r4!=0),width-r4+1]
            for(int32_t j=0;j<r4;j++) row4[i+j]+=1;                         //if this region passed one grid, we add grid with 1
        }
        for(int32_t i=r1+r2+r3+1+(r2!=0)+(r3!=0)+(r4!=0);i<=width;i++){
            if(row4[i]==width-r4-r2-r3-r1-space+1) row[i]=true;        //the meaning of this loop is as same as above 
        }
    }  
    for(int32_t i = 1; i <= width; i++){
        if(row[i])  putchar('X');       //output the grid we must marked with 'X' 
        else  putchar('.');     //others with '.'
    }
    putchar('\n');
    return 1;   //return 1 means we successfully finish the subroutine
}
