#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "mp8.h"

/* Introduction Paragraph:
 * This mp8 program uses recursion to implement various flood fill processes. 
 * These operations are applicable to example images. 
 * This mp8recurse.c file implement the recursive function used to determine 
 * whether the flood operation continues recursively or stops with stopping conditions.
 */


/*
 * basicRecurse -- flood fill recursively from a point until reaching
 *                 white or the image border
 * INPUTS: width -- width of the input image
 *         height -- height of the input image
 *         inRed -- pointer to the input red channel (1-D array)
 *         inGreen -- pointer to the input green channel (1-D array)
 *         inBlue -- pointer to the input blue channel (1-D array)
 *         x -- current x position of the flood
 *         y -- current y position of the flood
 *         marking -- array used to mark seen positions (indexed
 *                    in the same way as the RGB input arrays)
 * OUTPUTS: marking -- marked with flooded pixels
 * RETURN VALUE: none
 * SIDE EFFECTS: none
 */
void 
basicRecurse (int32_t width, int32_t height,
	      const uint8_t* inRed, const uint8_t* inGreen, 
	      const uint8_t* inBlue, 
	      int32_t x, int32_t y, 
	      uint8_t* marking)
{
	if (marking[x+y*width] || (inRed[x+y*width] == 0xFF && inGreen[x+y*width] == 0xFF && inBlue[x+y*width] == 0xFF)) //judge whether to exit
	{
		return;
	}
	marking[x+y*width] = 1;	//marked the pixel
	if (y > 0 )		basicRecurse(width, height, inRed, inGreen, inBlue, x, y - 1, marking);	//search the four directions of this pixel
	if (x < width - 1)	basicRecurse(width, height, inRed, inGreen, inBlue, x + 1, y, marking);
	if (y < height -1)	basicRecurse(width, height, inRed, inGreen, inBlue, x, y + 1, marking);
	if (x > 0)	basicRecurse(width, height, inRed, inGreen, inBlue, x - 1, y, marking);
}


/*
 * greyRecurse -- flood fill recursively from a point until reaching
 *                near-white pixels or the image border
 * INPUTS: width -- width of the input image
 *         height -- height of the input image
 *         inRed -- pointer to the input red channel (1-D array)
 *         inGreen -- pointer to the input green channel (1-D array)
 *         inBlue -- pointer to the input blue channel (1-D array)
 *         x -- current x position of the flood
 *         y -- current y position of the flood
 *         distSq -- maximum distance squared between white and boundary
 *                   pixel color
 *         marking -- array used to mark seen positions (indexed
 *                    in the same way as the RGB input arrays)
 * OUTPUTS: marking -- marked with flooded pixels
 * RETURN VALUE: none
 * SIDE EFFECTS: none
 */
void 
greyRecurse (int32_t width, int32_t height,
	     const uint8_t* inRed, const uint8_t* inGreen, 
	     const uint8_t* inBlue, 
	     int32_t x, int32_t y, uint32_t distSq, 
	     uint8_t* marking)
{
	if (marking[x+y*width] || (colorsWithinDistSq(inRed[x+y*width],inGreen[x+y*width],inBlue[x+y*width],0xFF,0xFF,0xFF,distSq))) //judge whether to exit
	{
		return;
	}
	marking[x+y*width] = 1;	//marked the pixel
	if (y > 0 )		greyRecurse(width, height, inRed, inGreen, inBlue, x, y - 1, distSq,marking);	//search the four directions of this pixel
	if (x < width - 1)	greyRecurse(width, height, inRed, inGreen, inBlue, x + 1, y, distSq, marking);
	if (y < height -1)	greyRecurse(width, height, inRed, inGreen, inBlue, x, y + 1, distSq, marking);
	if (x > 0)	greyRecurse(width, height, inRed, inGreen, inBlue, x - 1, y, distSq, marking);
}


/*
 * limitedRecurse -- flood fill recursively from a point until reaching
 *                   pixels too different (in RGB color) from the color at
 *                   the flood start point, too far away (> 35 pixels), or
 *                   beyond the image border
 * INPUTS: width -- width of the input image
 *         height -- height of the input image
 *         inRed -- pointer to the input red channel (1-D array)
 *         inGreen -- pointer to the input green channel (1-D array)
 *         inBlue -- pointer to the input blue channel (1-D array)
 *         origX -- starting x position of the flood
 *         origY -- starting y position of the flood
 *         x -- current x position of the flood
 *         y -- current y position of the flood
 *         distSq -- maximum distance squared between pixel at origin 
 *                   and boundary pixel color
 *         marking -- array used to mark seen positions (indexed
 *                    in the same way as the RGB input arrays)
 * OUTPUTS: marking -- marked with flooded pixels
 * RETURN VALUE: none
 * SIDE EFFECTS: none
 */
void 
limitedRecurse (int32_t width, int32_t height,
	        const uint8_t* inRed, const uint8_t* inGreen, 
	        const uint8_t* inBlue, 
	        int32_t origX, int32_t origY, int32_t x, int32_t y, 
		uint32_t distSq, uint8_t* marking)
{
	if (marking[x+y*width]||((x-origX)*(x-origX)+(y-origY)*(y-origY)>35*35)||!(colorsWithinDistSq(inRed[x+y*width],inGreen[x+y*width],inBlue[x+y*width],inRed[origX+origY*width],inGreen[origX+origY*width],inBlue[origX+origY*width],distSq)))
	{
		return;	//judge whether to exit
	}
	marking[x+y*width] = 1;	//marked the pixel
	if (y > 0 )		limitedRecurse(width, height, inRed, inGreen, inBlue, origX, origY, x, y - 1, distSq,marking);	//search the four directions of this pixel
	if (x < width - 1)	limitedRecurse(width, height, inRed, inGreen, inBlue, origX, origY, x + 1, y, distSq, marking);
	if (y < height -1)	limitedRecurse(width, height, inRed, inGreen, inBlue, origX, origY, x, y + 1, distSq, marking);
	if (x > 0)	limitedRecurse(width, height, inRed, inGreen, inBlue, origX, origY, x - 1, y, distSq, marking);
}

