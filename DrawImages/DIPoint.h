//
//  DIPoint.h
//  DrawImages
//
/* !
 @class DIPoint
 
 DIIconEngine is a class that stores the data of a point object to be drawn on the screen
 
 @author Created by Brett Graham on 12-07-10.
 @copyright Copyright (c) 2012 Mobile Map Solutions. All rights reserved.
 @updated 12-07-09.
 */

#import <Foundation/Foundation.h>
#import "DIObject.h"

@interface DIPoint : DIObject{
    @public
    int x;
    int y;
}

@property int x;
@property int y;

/* !
     @function initWithX0 withY0 withIcon
     @abstact Creates a Point Object
     @param WithX0:(int) x_0
     The X-coordinate on the Screen
     @param WithY0:(int) y_0
     The Y-coordinate on the Screen
     @return (id)
     A DIPoint object or nil if init failed
 */
-(id) initWithX0:(int) x_0 withY0: (int) y_0 withIcon:(DIIcon *) ic;


@end
