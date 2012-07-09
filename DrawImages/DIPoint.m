//
//  DIPoint.m
//  DrawImages
//
//  Created by Brett Graham on 12-07-09.
//  Copyright (c) 2012 Mobile Map Solutions. All rights reserved.
//

#import "DIPoint.h"

@implementation DIPoint 

    @synthesize x;
    @synthesize y;

-(id) initWithX0:(int) x_0 withY0: (int) y_0 withIcon:(DIIcon *) ic{
    self = [super init];
    if(self){
        icon = ic;
        x = x_0;
        y = y_0;
    }
    
    return self;
}
@end
