//
//  DIObject.h
//  DrawImages
//
/* !
 @class DIObject
 
 DIObject is a class that stores the data of an object on the screen in the form of it's three subclasses
  @see DIPoint
 @see DILine
 @see DIArea
 
 @author Created by Brett Graham on 12-07-10.
 @copyright Copyright (c) 2012 Mobile Map Solutions. All rights reserved.
 @updated 12-07-09.
 */


#import <Foundation/Foundation.h>

@class DIIcon;

@interface DIObject : NSObject{
    @public
        DIIcon * icon;
}

@property DIIcon * icon;

@end
