//
//  DILine.m
//  DrawImages
//
//  Created by Brett Graham on 12-07-09.
//  Copyright (c) 2012 Mobile Map Solutions. All rights reserved.
//

#import "DILine.h"
#import "DIIcon.h"

@implementation DILine

@synthesize x0;
@synthesize y0;
@synthesize x1;
@synthesize y1;


-(id) initWithX0:(int) x_0 withY0: (int) y_0 withX1:(int) x_1 withY1:(int) y_1 withIcon:(DIIcon *) ic{
    self = [super init];
    if(self){
        icon = ic;
        x0 = x_0;
        y0 = y_0;
        x1 = x_1;
        y1 = y_1;
        
    }
    
    return self;
}

@end
