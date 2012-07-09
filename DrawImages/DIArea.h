//
//  DIArea.h
//  DrawImages
//
/* !
 @class DILine
 
 DIIconEngine is a class that stores the data of a polygon object to be drawn on the screen
 
 @author Created by Brett Graham on 12-07-10.
 @copyright Copyright (c) 2012 Mobile Map Solutions. All rights reserved.
 @updated 12-07-09.
 */
#import <Foundation/Foundation.h>
#import "DIObject.h"

@interface DIArea : DIObject{
    
    @public
        NSMutableArray * vPoints;
    
}

@property NSMutableArray * vPoints;

/* !
     @function initWithX0 withY0 withIcon
     @abstact Creates a Polygon Object with a first point, after this user should call AddPoint to add points
     @param WithX0:(int) x_0
     The X-coordinate on the Screen
     @param WithY0:(int) y_0
     The Y-coordinate on the Screen
     @return (id)
     A DIPoint object or nil if init failed
 */
-(id) initWithX0:(int) x_0 withY0: (int) y_0 withIcon:(DIIcon *) ic;

/* !
     @function addPoint
     @abstact Adds a Point to the polygon at the end
     @param WithX:(int) x_0
     The X-coordinate on the Screen
     @param WithY:(int) y_0
     The Y-coordinate on the Screen
 */
-(void) addPointWithX:(int) x_0 withY: (int) y_0;


/* !
     @function isCloseToWithX
     @abstact determines if a point is close to another point (end polygon create)
     @param WithX:(int) x_0
     The X-coordinate on the Screen
     @param WithY:(int) y_0
     The Y-coordinate on the Screen
 */
-(bool) isCloseToWithX:(int) x_0 withY: (int) y_0;

@end
