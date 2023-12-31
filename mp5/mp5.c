/*									tab:8
 *
 * main.c - skeleton source file for ECE220 picture drawing program
 *
 * "Copyright (c) 2018 by Charles H. Zega, and Saransh Sinha."
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice and the following
 * two paragraphs appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE AUTHOR OR THE UNIVERSITY OF ILLINOIS BE LIABLE TO 
 * ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL 
 * DAMAGES ARISING OUT  OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, 
 * EVEN IF THE AUTHOR AND/OR THE UNIVERSITY OF ILLINOIS HAS BEEN ADVISED 
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE AUTHOR AND THE UNIVERSITY OF ILLINOIS SPECIFICALLY DISCLAIM ANY 
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE 
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND NEITHER THE AUTHOR NOR
 * THE UNIVERSITY OF ILLINOIS HAS ANY OBLIGATION TO PROVIDE MAINTENANCE, 
 * SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Author:	    Charles Zega, Saransh Sinha
 * Version:	    1
 * Creation Date:   12 February 2018
 * Filename:	    mp5.h
 * History:
 *	CZ	1	12 February 2018
 *		First written.
 */
#include "mp5.h"
#include <stdio.h>
#include <stdlib.h>
/*
	You must write all your code only in this file, for all the functions!
*/

//Introduction paragraph

/* 
	This is the program for ECE220 MP5 written by Liang Zhixiang.
	This program writes a selection of functions that act as simple drawing tools to create a PNG image.
	More specifically, this program writes functions that can draw lines, rectangles, triangles, parallelograms, 
	and circles, as well as a color gradient in a rectangular shape.

	The program mainly consists of these parts of functions:
	Type	Function		Parameters							Functionality
	1		near_horizontal	(x_start, y_start, x_end, y_end)	draw a pixel to all points in between the two given pixels including the end points 
	2		near_vertical	(x_start, y_start, x_end, y_end)	draw a pixel to all points in between the two given pixels including the end points  
	3		draw_line		(x_start, y_start, x_end, y_end)	draw a line through choosing two functions above 
	4		draw_rect		(x_A, y_A, width, height)			draw a pixel to every point of the edges of the rectangle
	5		draw_triangle	(x_A, y_A, x_B, y_B, x_C, y_C)		draw a pixel to every point of the edges of the triangle
	6		draw_parallelogram	(x_A, y_A, x_B, y_B, x_C, y_C)	draw a pixel to every point of the edges of the parallelogram
	7		draw_circle		(x_cntr, y_cntr, r_inner, r_outer)	draw a ring of circle with given inner radius and outer radius 
	8		rect_gradient	(x_start, y_start, width, height, start_color, end_color)	draw a rectangle with a horizontal gradient. 
	default	draw_picture	None								draw the image by calling any of the other functions in the file
	These functions both have RETURN VALUE 0 if any of the pixels drawn are out of bounds, otherwise 1.

*/

/* 
 *  near_horizontal
 *	 
 *	 
 *	
 *	
 * INPUTS: x_start,y_start -- the coordinates of the pixel at one end of the line
 * 	   x_end, y_end    -- the coordinates of the pixel at the other end
 * OUTPUTS: draws a pixel to all points in between the two given pixels including
 *          the end points
 * RETURN VALUE: 0 if any of the pixels drawn are out of bounds, otherwise 1
 * SIDE EFFECTS: none
 */

int32_t
near_horizontal(int32_t x_start, int32_t y_start, int32_t x_end, int32_t y_end){
	/* Your code goes here! */
	uint32_t ret_value = 1;		//init return value
	int32_t sign = (y_end-y_start>0 ?1:-1);		//calulcate the sign of (y_end-y_start)
	if (y_end==y_start) sign=0;
	int32_t y_temp,x_temp;
	if (x_start<=x_end)		//the condition that x_start on the left
	{	
		x_temp = x_start;
		while(x_temp<=x_end)
		{	
			y_temp= (2*(y_end-y_start)*(x_temp-x_start)+(x_end-x_start)*sign)/(2*(x_end-x_start))+y_start;	//int division
			ret_value &= draw_dot(x_temp,y_temp);	//draw dot on the line using draw_dot function
			x_temp++;
		}
	}
	else		//the condition that x_start on the right
	{	
		x_temp = x_start;
		while(x_temp>=x_end)
		{
			y_temp= (2*(y_end-y_start)*(x_temp-x_start)+(x_end-x_start)*sign)/(2*(x_end-x_start))+y_start;
			ret_value &= draw_dot(x_temp,y_temp);
			x_temp--;
		}
	}
	return ret_value;
}
/* 
 *  near_vertical
 *	 
 *	 
 *	
 *	
 * INPUTS: x_start,y_start -- the coordinates of the pixel at one end of the line
 * 	   x_end, y_end    -- the coordinates of the pixel at the other end
 * OUTPUTS: draws a pixel to all points in between the two given pixels including
 *          the end points
 * RETURN VALUE: 0 if any of the pixels drawn are out of bounds, otherwise 1
 * SIDE EFFECTS: none
 */

int32_t
near_vertical(int32_t x_start, int32_t y_start, int32_t x_end, int32_t y_end){
	/* Your code goes here! */
	uint32_t ret_value = 1;
	if (x_end==x_start && y_start==y_end) return 0;	//when two points are identical, return 0
	int32_t sign = (x_end-x_start>0 ?1:-1);			//calulcate the sign of (x_end-x_start)
	if (x_end==x_start) sign=0;
	int32_t y_temp,x_temp;
	if (y_start<=y_end) //the conditon that y_start on the top
	{	
		y_temp = y_start;
		while(y_temp<=y_end)
		{	
			x_temp = (2*(x_end-x_start)*(y_temp-y_start)+(y_end-y_start)*sign)/(2*(y_end-y_start))+x_start;
			ret_value &= draw_dot(x_temp,y_temp);	//draw dot on the line using draw_dot function
			y_temp++;
		}
	}
	else		//the conditon that y_start on the bottom
	{	
		y_temp = y_start;
		while(y_temp>=y_end)
		{
			x_temp = (2*(x_end-x_start)*(y_temp-y_start)+(y_end-y_start)*sign)/(2*(y_end-y_start))+x_start;
			ret_value &= draw_dot(x_temp,y_temp);
			y_temp--;
		}
	}
	return ret_value;
}

/* 
 *  draw_line
 *	 
 *	 
 *	
 *	
 * INPUTS: x_start,y_start -- the coordinates of the pixel at one end of the line
 * 	   x_end, y_end    -- the coordinates of the pixel at the other end
 * OUTPUTS: draws a pixel to all points in between the two given pixels including
 *          the end points
 * RETURN VALUE: 0 if any of the pixels drawn are out of bounds, otherwise 1
 * SIDE EFFECTS: none
 */

int32_t
draw_line(int32_t x_start, int32_t y_start, int32_t x_end, int32_t y_end){
	/* Your code goes here! */
	float y_change = (float)(y_end-y_start);
	float x_change = (float)(x_end-x_start); //convert int to float to get a accurate slope
	uint32_t ret_value = 1;
	if (x_end == x_start) ret_value = near_vertical(x_start,y_start,x_end,y_end); //when slope is not defined we use near_vertical function.
	else
	{	
		float slope = y_change/x_change;
		if(slope <-1.0 || slope >1.0) ret_value = near_vertical(x_start,y_start,x_end,y_end); //when slope belongs to [-1,1], using near_horizontal otherwise near_vertical.
		else ret_value = near_horizontal(x_start,y_start,x_end,y_end);	
	}
	return ret_value;
}


/* 
 *  draw_rect
 *	 
 *	 
 *	
 *	
 * INPUTS: Y,y -- theYcoordinates of the of the top-left pixel of the YectaYgle
 *         w,h -- the width and height, respectively, of the rectangle
 * OUTPUTS: draws a pixel to every point of the edges of the rectangle
 * RETURN VALUE: 0 if any of the pixels drawn are out of bounds, otherwise 1
 * SIDE EFFECTS: none
 */

int32_t
draw_rect(int32_t x, int32_t y, int32_t w, int32_t h){
	/* Your code goes here! */
	if ((w<0 || h<0)||(w==0 && h==0)) return 0; //when w or h is negative or both of them is 0, return 0
	uint32_t ret_value = 1;
	ret_value &= draw_line(x,y,x+w,y); 	//draw 4 lines to make a rectangle
	ret_value &= draw_line(x,y,x,y+h);
	ret_value &= draw_line(x,y+h,x+w,y+h);
	ret_value &= draw_line(x+w,y,x+w,y+h);
	return ret_value;
}


/* 
 *  draw_triangle
 *	 
 *	 
 *	
 *	
 * INPUTS: x_A,y_A -- the coordinates of one of the vertices of the triangle
 *         x_B,y_B -- the coordinates of another of the vertices of the triangle
 *         x_C,y_C -- the coordinates of the final of the vertices of the triangle
 * OUTPUTS: draws a pixel to every point of the edges of the triangle
 * RETURN VALUE: 0 if any of the pixels drawn are out of bounds, otherwise 1
 * SIDE EFFECTS: none
 */

int32_t
draw_triangle(int32_t x_A, int32_t y_A, int32_t x_B, int32_t y_B, int32_t x_C, int32_t y_C){
	/* Your code goes here! */
	uint32_t ret_value = 1;
	ret_value &= draw_line(x_A, y_A, x_B, y_B);	//draw 3 lines connecting 4 vertexs to make a triangle
	ret_value &= draw_line(x_A, y_A, x_C, y_C);
	ret_value &= draw_line(x_B, y_B, x_C, y_C);
	return ret_value;
}

/* 
 *  draw_parallelogram
 *	 
 *	 
 *	
 *	
 * INPUTS: x_A,y_A -- the coordinates of one of the vertices of the parallelogram
 *         x_B,y_B -- the coordinates of another of the vertices of the parallelogram
 *         x_C,y_C -- the coordinates of another of the vertices of the parallelogram
 * OUTPUTS: draws a pixel to every point of the edges of the parallelogram
 * RETURN VALUE: 0 if any of the pixels drawn are out of bounds, otherwise 1
 * SIDE EFFECTS: none
 */

int32_t
draw_parallelogram(int32_t x_A, int32_t y_A, int32_t x_B, int32_t y_B, int32_t x_C, int32_t y_C){
	/* Your code goes here! */
	uint32_t ret_value = 1;
	int32_t x_D = x_A+(x_C-x_B), y_D = y_A+(y_C-y_B); //(x_D,y_D)=(x_A,y_A)+(vectorBC)=(x_A+(x_C-x_B),y_A+(y_C-y_B))
	ret_value &= draw_line(x_A, y_A, x_B, y_B);	//draw 4 lines connecting 4 vertexs to make parallelogram
	ret_value &= draw_line(x_A, y_A, x_D, y_D);
	ret_value &= draw_line(x_B, y_B, x_C, y_C);
	ret_value &= draw_line(x_D, y_D, x_C, y_C);
	return ret_value;
}


/* 
 *  draw_circle
 *	 
 *	 
 *	
 *	
 * INPUTS: x,y -- the center of the circle
 *         inner_r,outer_r -- the inner and outer radius of the circle
 * OUTPUTS: draws a pixel to every point whose distance from the center is
 * 	    greater than or equal to inner_r and less than or equal to outer_r
 * RETURN VALUE: 0 if any of the pixels drawn are out of bounds, otherwise 1
 * SIDE EFFECTS: none
 */

int32_t
draw_circle(int32_t x, int32_t y, int32_t inner_r, int32_t outer_r){
	/* Your code goes here!*/
	uint32_t ret_value = 1;
	if (inner_r>outer_r || inner_r<0) return 0;
	for (int32_t i=x-outer_r;i<=x+outer_r;i++)
	{
		for(int32_t j=y-outer_r;j<=y+outer_r;j++)	//(x0,y0) in the ring must have the property that x-outer_r=<x0<=x+outer and y-outer_r=<y0<=y0+outer
		{
			if (((i-x)*(i-x)+(j-y)*(j-y)>=inner_r*inner_r)&&((i-x)*(i-x)+(j-y)*(j-y)<=outer_r*outer_r))//use Pythagorean theorem to determine whether (x0,y0) is in the ring
			{
				ret_value &= draw_dot(i,j);		
			}
		}
	}
	return ret_value;
}


/* 
 *  rect_gradient
 *	 
 *	 
 *	
 *	
 * INPUTS: x,y -- the coordinates of the of the top-left pixel of the rectangle
 *         w,h -- the width and height, respectively, of the rectangle
 *         start_color -- the color of the far left side of the rectangle
 *         end_color -- the color of the far right side of the rectangle
 * OUTPUTS: fills every pixel within the bounds of the rectangle with a color
 *	    based on its position within the rectangle and the difference in
 *          color between start_color and end_color
 * RETURN VALUE: 0 if any of the pixels drawn are out of bounds, otherwise 1
 * SIDE EFFECTS: none
 */

int32_t
rect_gradient(int32_t x, int32_t y, int32_t w, int32_t h, int32_t start_color, int32_t end_color){
	/* Your code goes here! */
	if(h<0 || w<1) return 0;
	uint32_t ret_value = 1;
	int32_t MASK_R = 0x00FF0000,MASK_G = 0x0000FF00,MASK_B = 0x000000FF;
	uint8_t start_R = (start_color & MASK_R) >> 16;		//decode the color vector		 
	uint8_t start_G = (start_color & MASK_G) >> 8;
	uint8_t start_B = start_color & MASK_B;
	uint8_t end_R = (end_color & MASK_R) >> 16;
	uint8_t end_G = (end_color & MASK_G) >> 8;
	uint8_t end_B = end_color & MASK_B;
	int32_t sign_R = (end_R>start_R?1:-1);			//calculate the color sign
	if (start_R==end_R) sign_R=0;
	int32_t sign_G = (end_G>start_G?1:-1);
	if (start_G==end_G) sign_G=0;
	int32_t sign_B = (end_B>start_B?1:-1);
	if (start_B==end_B) sign_B=0;
	for(int32_t i=x;i<=x+w;i++)
	{
		for (int32_t j=y;j<=y+h;j++)
		{
			uint8_t level_R =(2*(i-x)*(end_R-start_R)+w*sign_R)/(2*(w))+start_R;	//calculate the color in this vertical line
			uint8_t level_G =(2*(i-x)*(end_G-start_G)+w*sign_G)/(2*(w))+start_G;
			uint8_t level_B =(2*(i-x)*(end_B-start_B)+w*sign_B)/(2*(w))+start_B;
			int32_t level = (level_R << 16) | (level_G << 8) | (level_B << 0);	//encode the coloe vector
			set_color(level);
			ret_value &= draw_dot(i,j);
		}
	}

	return ret_value;
}


/* 
 *  draw_picture
 *	 
 *	 
 *	
 *	
 * INPUTS: none
 * OUTPUTS: alters the image by calling any of the other functions in the file
 * RETURN VALUE: 0 if any of the pixels drawn are out of bounds, otherwise 1
 * SIDE EFFECTS: none
 */

#define max(a, b) ((a) > (b) ? (a) : (b))
#define min(a, b) ((a) < (b) ? (a) : (b))
#define cross(x_0, y_0, x_1, y_1) ((x_0) * (y_1) - (y_0) * (x_1))

int32_t
draw_picture(){
	/* Your code goes here! */
	int32_t r = 75;
	uint32_t return_value = 1;
	int32_t root3r = (int32_t)(1.732050 * r);		// sqrt(3) * r
	set_color(0x5c8ebd);					// light blue
	int32_t x_A = WIDTH / 2, y_A = HEIGHT / 2, x_B = WIDTH / 2, y_B = HEIGHT / 2 - 2 * r, x_C = WIDTH / 2 - root3r, y_C = HEIGHT / 2 - r;
	int32_t maxX = max(x_A, max(x_B, x_C));
	int32_t minX = min(x_A, min(x_B, x_C));
	int32_t maxY = max(y_A, max(y_B, y_C));
	int32_t minY = min(y_A, min(y_B, y_C));
	for(int32_t x = minX; x <= maxX; x++) {
		for(int32_t y = minY; y <= maxY; y++) {
			if(
				cross(x - x_A, y - y_A, x_B - x_A, y_B - y_A) * 
				cross(x - x_A, y - y_A, x_C - x_A, y_C - y_A) <= 0 && 
				cross(x - x_B, y - y_B, x_A - x_B, y_A - y_B) * 
				cross(x - x_B, y - y_B, x_C - x_B, y_C - y_B) <= 0
			)	// if 2 cross products have different sign,
				// (x, y) lies between two edges.
				// if (x, y) is between B-A, C-A and between A-B, C-B
				// then (x,y) lies in the triangle
			{
				return_value &= draw_dot(x, y);
			}
		}
	}
	x_A = WIDTH / 2, y_A = HEIGHT / 2, x_B = WIDTH / 2, y_B = HEIGHT / 2 - 2 * r, x_C = WIDTH / 2 + root3r, y_C = HEIGHT / 2 - r;
	maxX = max(x_A, max(x_B, x_C));
	minX = min(x_A, min(x_B, x_C));
	maxY = max(y_A, max(y_B, y_C));
	minY = min(y_A, min(y_B, y_C));
	for(int32_t x = minX; x <= maxX; x++) {
		for(int32_t y = minY; y <= maxY; y++) {
			if(
				cross(x - x_A, y - y_A, x_B - x_A, y_B - y_A) * 
				cross(x - x_A, y - y_A, x_C - x_A, y_C - y_A) <= 0 && 
				cross(x - x_B, y - y_B, x_A - x_B, y_A - y_B) * 
				cross(x - x_B, y - y_B, x_C - x_B, y_C - y_B) <= 0
			)	// if 2 cross products have different sign,
				// (x, y) lies between two edges.
				// if (x, y) is between B-A, C-A and between A-B, C-B
				// then (x,y) lies in the triangle
			{
				return_value &= draw_dot(x, y);
			}
		}
	}
	x_A = WIDTH / 2, y_A = HEIGHT / 2, x_B = WIDTH / 2 - root3r, y_B = HEIGHT / 2 - r, x_C = WIDTH / 2 - root3r, y_C = HEIGHT / 2 + r;
	maxX = max(x_A, max(x_B, x_C));
	minX = min(x_A, min(x_B, x_C));
	maxY = max(y_A, max(y_B, y_C));
	minY = min(y_A, min(y_B, y_C));
	for(int32_t x = minX; x <= maxX; x++) {
		for(int32_t y = minY; y <= maxY; y++) {
			if(
				cross(x - x_A, y - y_A, x_B - x_A, y_B - y_A) * 
				cross(x - x_A, y - y_A, x_C - x_A, y_C - y_A) <= 0 && 
				cross(x - x_B, y - y_B, x_A - x_B, y_A - y_B) * 
				cross(x - x_B, y - y_B, x_C - x_B, y_C - y_B) <= 0
			)	// if 2 cross products have different sign,
				// (x, y) lies between two edges.
				// if (x, y) is between B-A, C-A and between A-B, C-B
				// then (x,y) lies in the triangle
			{
				return_value &= draw_dot(x, y);
			}
		}
	}
	//return_value &= filled_triangle(WIDTH / 2, HEIGHT / 2, WIDTH / 2, HEIGHT / 2 - 2 * r, WIDTH / 2 - root3r, HEIGHT / 2 - r);
	//return_value &= filled_triangle(WIDTH / 2, HEIGHT / 2, WIDTH / 2, HEIGHT / 2 - 2 * r, WIDTH / 2 + root3r, HEIGHT / 2 - r);
	//return_value &= filled_triangle(WIDTH / 2, HEIGHT / 2, WIDTH / 2 - root3r, HEIGHT / 2 - r, WIDTH / 2 - root3r, HEIGHT / 2 + r);
	set_color(0x14588f);					// blue
	x_A = WIDTH / 2, y_A = HEIGHT / 2, x_B = WIDTH / 2, y_B = HEIGHT / 2 + 2 * r, x_C = WIDTH / 2 - root3r, y_C = HEIGHT / 2 + r;
	maxX = max(x_A, max(x_B, x_C));
	minX = min(x_A, min(x_B, x_C));
	maxY = max(y_A, max(y_B, y_C));
	minY = min(y_A, min(y_B, y_C));
	for(int32_t x = minX; x <= maxX; x++) {
		for(int32_t y = minY; y <= maxY; y++) {
			if(
				cross(x - x_A, y - y_A, x_B - x_A, y_B - y_A) * 
				cross(x - x_A, y - y_A, x_C - x_A, y_C - y_A) <= 0 && 
				cross(x - x_B, y - y_B, x_A - x_B, y_A - y_B) * 
				cross(x - x_B, y - y_B, x_C - x_B, y_C - y_B) <= 0
			)	// if 2 cross products have different sign,
				// (x, y) lies between two edges.
				// if (x, y) is between B-A, C-A and between A-B, C-B
				// then (x,y) lies in the triangle
			{
				return_value &= draw_dot(x, y);
			}
		}
	}
	x_A = WIDTH / 2, y_A = HEIGHT / 2, x_B = WIDTH / 2, y_B = HEIGHT / 2 + 2 * r, x_C = WIDTH / 2 + root3r, y_C = HEIGHT / 2 + r;
	maxX = max(x_A, max(x_B, x_C));
	minX = min(x_A, min(x_B, x_C));
	maxY = max(y_A, max(y_B, y_C));
	minY = min(y_A, min(y_B, y_C));
	for(int32_t x = minX; x <= maxX; x++) {
		for(int32_t y = minY; y <= maxY; y++) {
			if(
				cross(x - x_A, y - y_A, x_B - x_A, y_B - y_A) * 
				cross(x - x_A, y - y_A, x_C - x_A, y_C - y_A) <= 0 && 
				cross(x - x_B, y - y_B, x_A - x_B, y_A - y_B) * 
				cross(x - x_B, y - y_B, x_C - x_B, y_C - y_B) <= 0
			)	// if 2 cross products have different sign,
				// (x, y) lies between two edges.
				// if (x, y) is between B-A, C-A and between A-B, C-B
				// then (x,y) lies in the triangle
			{
				return_value &= draw_dot(x, y);
			}
		}
	}
	//return_value &= filled_triangle(WIDTH / 2, HEIGHT / 2, WIDTH / 2, HEIGHT / 2 + 2 * r, WIDTH / 2 - root3r, HEIGHT / 2 + r);
	//return_value &= filled_triangle(WIDTH / 2, HEIGHT / 2, WIDTH / 2, HEIGHT / 2 + 2 * r, WIDTH / 2 + root3r, HEIGHT / 2 + r);
	set_color(0xffffff);					// white
	return_value &= draw_circle(WIDTH / 2, HEIGHT / 2,(int32_t)(0.6 * r), (int32_t)(1.2 * r));
	set_color(0x134475);					// dark blue
	x_A = WIDTH / 2, y_A = HEIGHT / 2, x_B = WIDTH / 2 + root3r, y_B = HEIGHT / 2 - r, x_C = WIDTH / 2 + root3r, y_C = HEIGHT / 2 + r;
	maxX = max(x_A, max(x_B, x_C));
	minX = min(x_A, min(x_B, x_C));
	maxY = max(y_A, max(y_B, y_C));
	minY = min(y_A, min(y_B, y_C));
	for(int32_t x = minX; x <= maxX; x++) {
		for(int32_t y = minY; y <= maxY; y++) {
			if(
				cross(x - x_A, y - y_A, x_B - x_A, y_B - y_A) * 
				cross(x - x_A, y - y_A, x_C - x_A, y_C - y_A) <= 0 && 
				cross(x - x_B, y - y_B, x_A - x_B, y_A - y_B) * 
				cross(x - x_B, y - y_B, x_C - x_B, y_C - y_B) <= 0
			)	// if 2 cross products have different sign,
				// (x, y) lies between two edges.
				// if (x, y) is between B-A, C-A and between A-B, C-B
				// then (x,y) lies in the triangle
			{
				return_value &= draw_dot(x, y);
			}
		}
	}
	return_value &= rect_gradient(WIDTH / 2 -27 + (int32_t)(1.2*r), HEIGHT/2 - 4, 24, 8, 0xffffff, 0xffffff);
	return_value &= rect_gradient(WIDTH / 2 +7 +(int32_t)(1.2*r), HEIGHT/2 - 4, 24, 8, 0xffffff, 0xffffff);		//first '+'
	int32_t tempx1 = WIDTH / 2 -27 + (int32_t)(1.2*r)+ 12 - 4;
	int32_t tempy1 = HEIGHT/2 - 12;
	int32_t tempx2 = WIDTH / 2 -27 + (int32_t)(1.2*r)+ 12 - 4 + 34;
	int32_t tempy2 = tempy1;
	return_value &= rect_gradient(tempx1, tempy1, 8, 24, 0xffffff, 0xffffff);		//second '+'
	return_value &= rect_gradient(tempx2, tempy2, 8, 24, 0xffffff, 0xffffff);

	//return_value &= filled_triangle(WIDTH / 2, HEIGHT / 2, WIDTH / 2 + root3r, HEIGHT / 2 - r, WIDTH / 2 + root3r, HEIGHT / 2 + r);
	return return_value;

}
