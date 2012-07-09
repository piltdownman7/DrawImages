//
//  DIIconEngine.h
//  Mobile Map Navigator
/* !
	@class DIIconEngine
	
	DIIconEngine is a class that stores all the sprites that have been written to the screen so far.
	It keeps a store of these icons so we do not have to load them everty time.
	It also manages the loading of new sprites into the store.
	Because of this the user simply needs to send the filename to this class and it works
	out the details as to if the image needs to be loaded or if it can reuse a sprite.
	
	@author Created by Brett Graham on 12-05-10.
	@copyright Copyright (c) 2012 Mobile Map Solutions. All rights reserved.
	@updated 12-07-09.
*/

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>


@class DISprite;

@interface DIIconEngine : NSObject{
    NSMutableDictionary * mObjects;
    NSDictionary * options;
    DISprite * spriteDefault;
}

/* !
	@function initWithEffect
	@abstact Creates a DIIconEngine with no sprites which it will draw using the new effect
	@param WithEffect:(GLKBaseEffect *)effect
		The current effect to draw.
		If the effect changes, this does not need to be changes as long as the new effect has the same dimentions.
	@return (id)
		A DIIconEngine object or nil if init failed
*/
-(id) initWithEffect:(GLKBaseEffect *)effect;

/* !
	@function drawIcon
	@abstact draws the icon of the given filename at the position given. 
	@param (NSString *) strFilename
		The filename of the icon to draw
	@param atX:(int) x
		The x-coordinate on the screen to draw the icon
	@param atY:(int) y
		The y-coordinate on the screen to draw the icon
	@discussion The Lower-Left corner of the screen has the coordinate (0,0)
*/
-(void) drawIcon:(NSString *) strFilename atX:(int) x atY:(int) y;

/* !
	@function drawIcon
	@abstact draws the icon of the given filename at the position given. 
	@param (NSString *) strFilename
		The filename of the icon to draw
	@param atX:(int) x
		The x-coordinate on the screen to draw the icon
	@param atY:(int) y
		The y-coordinate on the screen to draw the icon
	@param  withRotation:(double) r
		The rotation of the icon in radians, CW
	@discussion The Lower-Left corner of the screen has the coordinate (0,0)
*/
-(void) drawIcon:(NSString *) strFilename atX:(int) x atY:(int) y withRotation:(double) r;

/* !
	@function drawIcon
	@abstact draws the icon of the given filename at the position given. 
	@param (NSString *) strFilename
		The filename of the icon to draw
	@param atX:(int) x
		The x-coordinate on the screen to draw the icon
	@param atY:(int) y
		The y-coordinate on the screen to draw the icon
	@param  withScale:(double) dScale
		The Scale of the icon.  1.0 is normal scale; 0.5 is half normal scale; 2.0 is double normal scale
	@discussion The Lower-Left corner of the screen has the coordinate (0,0)
*/
-(void) drawIcon:(NSString *) strFilename atX:(int) x atY:(int) y withScale:(double) dScale;

/* !
	@function drawIcon
	@abstact draws the icon of the given filename at the position given. 
	@param (NSString *) strFilename
		The filename of the icon to draw
	@param atX:(int) x
		The x-coordinate on the screen to draw the icon
	@param atY:(int) y
		The y-coordinate on the screen to draw the icon
	@param  withRotation:(double) r
		The rotation of the icon in radians, CW
	@param  withScale:(double) dScale
		The Scale of the icon.  1.0 is normal scale; 0.5 is half normal scale; 2.0 is double normal scale
	@discussion The Lower-Left corner of the screen has the coordinate (0,0)
*/
-(void) drawIcon:(NSString *) strFilename atX:(int) x atY:(int) y withRotation:(double) r withScale:(double) dScale;


/* !
     @function drawLineWithIcons
     @abstact Draws an array of icons along a set of lines in a polyline
     @param WithIcons:(NSMutableArray *) vIcons
     An array of either Sprites or NSStrings of icons to daw incrementally
     @param withGaps:(int) nGap
     The Gaps between the icons in the line
     @param withPolygon:(float *) vector
     An array of floats of the polygon to draw in [x0,y0,x1,y1...] order
     @param withLength:(int) nSize
     The number of points in the polygon vector
 
 */
-(void) drawLineWithIcons:(NSMutableArray *) vIcons withGaps:(int) nGap withPolygon:(float *) vector withLength:(int) nSize;

/* !
     @function drawLineWithFile
     @abstact Draws a single icons along a set of lines in a polyline
     @param WithFile:(NSString *) strFilename
     The filename to draw along the polylines
     @param withGaps:(int) nGap
     The Gaps between the icons in the line
     @param withPolygon:(float *) vector
     An array of floats of the polygon to draw in [x0,y0,x1,y1...] order
     @param withLength:(int) nSize
     The number of points in the polygon vector
 
 */
-(void) drawLineWithFile:(NSString *) strFilename withGaps:(int) nGap withPolygon:(float *) vector withLength:(int) nSize;

/* !
     @function drawLineWithIcons
     @abstact Draws an array of icons along a set of lines in a polyline
     @param WithIcons:(NSMutableArray *) vIcons
     An array of either Sprites or NSStrings of icons to daw incrementally
     @param withGaps:(int) nGap
     The Gaps between the icons in the line
     @param withPolygonArray:(NSMutableArray *) vPoints
     An array of NSNumber of the polygon to draw in [x0,y0,x1,y1...] order
     @param withLength:(int) nSize
     The number of points in the polygon vector
 
 */
-(void) drawLineWithIcons:(NSMutableArray *) vIcons withGaps:(int) nGap withPolygonArray:(NSMutableArray *) vPoints withLength:(int) nSize;


/* !
     @function drawLineWithFile
     @abstact Draws a single icons along a set of lines in a polyline
     @param WithFile:(NSString *) strFilename
     The filename to draw along the polylines
     @param withGaps:(int) nGap
     The Gaps between the icons in the line
     @param withPolygonArray:(NSMutableArray *) vPoints
     An array of NSNumber of the polygon to draw in [x0,y0,x1,y1...] order
     @param withLength:(int) nSize
     The number of points in the polygon vector
 */
-(void) drawLineWithFile:(NSString *) strFilename withGaps:(int) nGap withPolygonArray:(NSMutableArray *) vPoints withLength:(int) nSize;

/* !
     @function drawLineWithFile
     @abstact Draws a single icons along a single line for (x0,y0) to (x1,y1)
     @param WithFile:(NSString *) strFilename
     The filename to draw along the line
     @param withGaps:(int) nGap
     The Gaps between the icons in the line
     The First X-coordinate on the Screen
     @param WithY0:(int) y_0
     The First Y-coordinate on the Screen
     @param WithX1:(int) x_1
     The Second X-coordinate on the Screen
     @param WithY1:(int) y_1
     The Second Y-coordinate on the Screen
 */
-(void) drawLineWithFile:(NSString *) strFilename withGaps:(int) nGap withX0:(int) x_0 withY0: (int) y_0 withX1:(int) x_1 withY1:(int) y_1;

/* !
    @function drawLineWithFile
     @abstact Draws a single icons along a single line for (x0,y0) to (x1,y1)
     @param WithFile:(NSString *) strFilename
     The filename to draw along the line
     The First X-coordinate on the Screen
     @param WithY0:(int) y_0
     The First Y-coordinate on the Screen
     @param WithX1:(int) x_1
     The Second X-coordinate on the Screen
     @param WithY1:(int) y_1
     The Second Y-coordinate on the Screen
 */
-(void) drawLineWithFile:(NSString *) strFilename withX0:(int) x_0 withY0: (int) y_0 withX1:(int) x_1 withY1:(int) y_1;


/* !
	@function fillPolygonWithFile
	@abstact Fills a polygon with full icons, rather than just doing a texture fill and having parts of the icons clipped
	@param WithFile:(NSString *) strFilename
		The filename of the icon to draw
	@param withPolygon:(float *) vector
		An array of floats of the polygon to draw in [x0,y0,x1,y1...] order
	@param withLength:(int) nSize
		The number of points in the polygon vector
	
*/
-(void) fillPolygonWithFile:(NSString *) strFilename withPolygon:(float *) vector withLength:(int) nSize;

/* !
     @function fillPolygonWithFile
     @abstact Fills a polygon with full icons, rather than just doing a texture fill and having parts of the icons clipped
     @param WithFile:(NSString *) strFilename
     The filename of the icon to draw
     @param withPolygonArray:(NSMutableArray *) vPoints
     An array of NSNumbers of the polygon to draw in [x0,y0,x1,y1...] order
     @param withLength:(int) nSize
     The number of points in the polygon vector
 */
-(void) fillPolygonWithFile:(NSString *) strFilename withPolygonArray:(NSMutableArray *) vPoints withLength:(int) nSize;

/* !
     @function resetEffect
     @abstact if the effect dimentions change calling this pass on this new effect to all the sprites
     @param WithFile:(NSString *) effect_i
     The new effect to use
 */
-(void)resetEffect:(GLKBaseEffect *)effect_i;

@end
