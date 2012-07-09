//
//  DIArea.m
//  DrawImages
//
//  Created by Brett Graham on 12-07-09.
//  Copyright (c) 2012 Mobile Map Solutions. All rights reserved.
//

#import "DIArea.h"
#import "DIConstants.h"

@implementation DIArea

@synthesize vPoints;

-(id) initWithX0:(int) x_0 withY0: (int) y_0 withIcon:(DIIcon *) ic{
    self = [super init];
    if(self){
        icon = ic;
        vPoints = [NSMutableArray new];
        [vPoints addObject:[[NSNumber alloc] initWithInt:x_0]];
        [vPoints addObject:[[NSNumber alloc] initWithInt:y_0]];
    }
    
    return self;
}

-(void) addPointWithX:(int) x_0 withY: (int) y_0{
    [vPoints addObject:[[NSNumber alloc] initWithInt:x_0]];
    [vPoints addObject:[[NSNumber alloc] initWithInt:y_0]];
}


-(bool) isCloseToWithX:(int) x_0 withY: (int) y_0{
    for(int i = 0; i < [vPoints count]; i+=2){
        int x_1 = [((NSNumber *) [vPoints objectAtIndex:i]) intValue];
        int y_1 = [((NSNumber *) [vPoints objectAtIndex:(i+1)]) intValue];
        double dDistance = sqrt((x_0 - x_1)*(x_0 - x_1) + (y_0 - y_1)*(y_0 - y_1));
        if(dDistance < kDISTANCE_CUTOFF){
            return true;
        }
    }
    return false;
}

@end
