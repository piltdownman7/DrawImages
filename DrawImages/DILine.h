//
//  DILine.h
//  DrawImages
//
/* !
 @class DILine
 
 DIIconEngine is a class that stores the data of a line object to be drawn on the screen
 
 @author Created by Brett Graham on 12-07-10.
 @copyright Copyright (c) 2012 Mobile Map Solutions. All rights reserved.
 @updated 12-07-09.
 */

#import <Foundation/Foundation.h>
#import "DIObject.h"

@interface DILine : DIObject{
    @public
        int x0;
        int y0;
        int x1;
        int y1;
}

@property int x0;
@property int y0;
@property int x1;
@property int y1;

/* !
     @function initWithX0 withY0 withIcon
     @abstact Creates a Line Object
     @param WithX0:(int) x_0
     The First X-coordinate on the Screen
     @param WithY0:(int) y_0
     The First Y-coordinate on the Screen
     @param WithX1:(int) x_1
     The Second X-coordinate on the Screen
     @param WithY1:(int) y_1
     The Second Y-coordinate on the Screen
     @return (id)
     A DILine object or nil if init failed
 */
-(id) initWithX0:(int) x_0 withY0: (int) y_0 withX1:(int) x_1 withY1:(int) y_1 withIcon:(DIIcon *) ic;

@end
