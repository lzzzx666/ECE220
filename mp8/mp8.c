#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "mp8.h"

/* Introduction Paragraph:
 * This mp8 program uses recursion to implement various flood fill processes. 
 * These operations are applicable to example images. 
 * This mp8.c file implement the flood operation, in which the user selects one pixel 
 * in the image along with an RGB color. In a painting analogy, the chosen color floods out 
 * in all directions from the chosen pixel until it reaches a boundary by calling a recursive function.
 */

/*
 * basicFlood -- wrapper for flood filling recursively from a point until 
 *               reaching white or the image border
 * INPUTS: width -- width of the input image
 *         height -- height of the input image
 *         inRed -- pointer to the input red channel (1-D array)
 *         inGreen -- pointer to the input green channel (1-D array)
 *         inBlue -- pointer to the input blue channel (1-D array)
 *         startX -- starting x position of the flood
 *         startY -- starting y position of the flood
 *         floodR -- red component of the flood color
 *         floodG -- green component of the flood color
 *         floodB -- blue component of the flood color
 * OUTPUTS: outRed -- pointer to the output red channel (1-D array)
 *          outGreen -- pointer to the output green channel (1-D array)
 *          outBlue -- pointer to the output blue channel (1-D array)
 * RETURN VALUE: none
 * SIDE EFFECTS: none
 */
void 
basicFlood (int32_t width, int32_t height,
	    const uint8_t* inRed, const uint8_t* inGreen, 
	    const uint8_t* inBlue, 
	    int32_t startX, int32_t startY, 
	    uint8_t floodR, uint8_t floodG, uint8_t floodB,
	    uint8_t* outRed, uint8_t* outGreen, 
	    uint8_t* outBlue)
{
	memset(outRed, 0, width * height);	//initialize the array with 0
	basicRecurse(width, height, inRed, inGreen, inBlue, startX, startY, outRed);	//use recursion to fill the outred array 
	outRed[width * startY + startX] = 1;	//start position must be filled
	for(int32_t h_i = 0 ;h_i < height; h_i++)
	{
		for (int32_t w_i = 0; w_i < width; w_i++)
		{
			if (outRed[h_i * width + w_i])	//if pixels marked, fill it with flood color
			{
				outRed[h_i * width + w_i] = floodR;
				outGreen[h_i * width + w_i] = floodG;
				outBlue[h_i * width + w_i] = floodB;
			}
			else		//if pixels aren't marked, fill it wit the original color
			{
				outRed[h_i * width + w_i] = inRed[h_i * width + w_i];
				outGreen[h_i * width + w_i] = inGreen[h_i * width + w_i];
				outBlue[h_i * width + w_i] = inBlue[h_i * width + w_i];
			}
		}
	}

}


/*
 * colorsWithinDistSq -- returns 1 iff two colors are within Euclidean
 *                       distance squared of one another in RGB space
 * INPUTS: r1 -- red component of color 1
 *         g1 -- green component of color 1
 *         b1 -- blue component of color 1
 *         r2 -- red component of color 2
 *         g2 -- green component of color 2
 *         b2 -- blue component of color 2
 *         distSq -- maximum distance squared for the check
 * RETURN VALUE: 1 if the sum of the squares of the differences in the 
 *               three components is less or equal to distSq; 0 otherwise
 * SIDE EFFECTS: none
 */
int32_t
colorsWithinDistSq (uint8_t r1, uint8_t g1, uint8_t b1,
                    uint8_t r2, uint8_t g2, uint8_t b2, uint32_t distSq)
{
	if ((r1-r2)*(r1-r2)+(g1-g2)*(g1-g2)+(b1-b2)*(b1-b2)<=(distSq)) return 1;	//use Euclidean Distance to judge whether within distance
    return 0;
}


/*
 * greyFlood -- wrapper for flood filling recursively from a point until 
 *              reaching near-white pixels or the image border
 * INPUTS: width -- width of the input image
 *         height -- height of the input image
 *         inRed -- pointer to the input red channel (1-D array)
 *         inGreen -- pointer to the input green channel (1-D array)
 *         inBlue -- pointer to the input blue channel (1-D array)
 *         startX -- starting x position of the flood
 *         startY -- starting y position of the flood
 *         floodR -- red component of the flood color
 *         floodG -- green component of the flood color
 *         floodB -- blue component of the flood color
 *         distSq -- maximum distance squared between white and boundary
 *                   pixel color
 * OUTPUTS: outRed -- pointer to the output red channel (1-D array)
 *          outGreen -- pointer to the output green channel (1-D array)
 *          outBlue -- pointer to the output blue channel (1-D array)
 * RETURN VALUE: none
 * SIDE EFFECTS: none
 */
void 
greyFlood (int32_t width, int32_t height,
	   const uint8_t* inRed, const uint8_t* inGreen, 
	   const uint8_t* inBlue, 
	   int32_t startX, int32_t startY, 
	   uint8_t floodR, uint8_t floodG, uint8_t floodB, uint32_t distSq,
	   uint8_t* outRed, uint8_t* outGreen, 
	   uint8_t* outBlue)
{
	memset(outRed, 0, width * height);	//initialize the array with 0
	greyRecurse(width, height, inRed, inGreen, inBlue, startX, startY, distSq, outRed);	//use recursion to fill the outred array 
	outRed[width * startY + startX] = 1;	//start position must be filled
	for(int32_t h_i = 0 ;h_i < height; h_i++)
	{
		for (int32_t w_i = 0; w_i < width; w_i++)
		{
			if (outRed[h_i * width + w_i])		//if pixels marked, fill it with flood color
			{
				outRed[h_i * width + w_i] = floodR;
				outGreen[h_i * width + w_i] = floodG;
				outBlue[h_i * width + w_i] = floodB;
			}
			else		//if pixels aren't marked, fill it wit the original color
			{
				outRed[h_i * width + w_i] = inRed[h_i * width + w_i];
				outGreen[h_i * width + w_i] = inGreen[h_i * width + w_i];
				outBlue[h_i * width + w_i] = inBlue[h_i * width + w_i];
			}
		}
	}
}


/*
 * limitedFlood -- wrapper for flood filling recursively from a point until 
 *                 reaching pixels too different (in RGB color) from the 
 *                 color at the flood start point, too far away 
 *                 (> 35 pixels), or beyond the image border
 * INPUTS: width -- width of the input image
 *         height -- height of the input image
 *         inRed -- pointer to the input red channel (1-D array)
 *         inGreen -- pointer to the input green channel (1-D array)
 *         inBlue -- pointer to the input blue channel (1-D array)
 *         startX -- starting x position of the flood
 *         startY -- starting y position of the flood
 *         floodR -- red component of the flood color
 *         floodG -- green component of the flood color
 *         floodB -- blue component of the flood color
 *         distSq -- maximum distance squared between pixel at origin 
 *                   and boundary pixel color
 * OUTPUTS: outRed -- pointer to the output red channel (1-D array)
 *          outGreen -- pointer to the output green channel (1-D array)
 *          outBlue -- pointer to the output blue channel (1-D array)
 * RETURN VALUE: none
 * SIDE EFFECTS: none
 */
void 
limitedFlood (int32_t width, int32_t height,
	      const uint8_t* inRed, const uint8_t* inGreen, 
	      const uint8_t* inBlue, 
	      int32_t startX, int32_t startY, 
	      uint8_t floodR, uint8_t floodG, uint8_t floodB, uint32_t distSq,
	      uint8_t* outRed, uint8_t* outGreen, 
	      uint8_t* outBlue)
{
	memset(outRed, 0, width * height);	//initialize the array with 0
	limitedRecurse(width, height, inRed, inGreen, inBlue, startX, startY, startX, startY, distSq, outRed);	//use recursion to fill the outred array 
	for(int32_t h_i = 0 ;h_i < height; h_i++)
	{
		for (int32_t w_i = 0; w_i < width; w_i++)
		{
			if (outRed[h_i * width + w_i])	//if pixels marked, fill it with flood color
			{
				outRed[h_i * width + w_i] = floodR;
				outGreen[h_i * width + w_i] = floodG;
				outBlue[h_i * width + w_i] = floodB;
			}
			else		//if pixels aren't marked, fill it wit the original color
			{
				outRed[h_i * width + w_i] = inRed[h_i * width + w_i];
				outGreen[h_i * width + w_i] = inGreen[h_i * width + w_i];
				outBlue[h_i * width + w_i] = inBlue[h_i * width + w_i];
			}
		}
	}
}

