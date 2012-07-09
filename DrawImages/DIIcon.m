//
//  DIIcon.m
//  DrawImages
//
//  Created by Brett Graham on 12-07-05.
//  Copyright (c) 2012 Mobile Map Solutions. All rights reserved.
//

#import "DIIcon.h"

@implementation DIIcon

@synthesize strName;
@synthesize strFilename;

-(id) initWithName:(NSString *) name withFileName:(NSString *) filename{
    self = [super init];
    
    if(self){
        self.strName = name;
        self.strFilename = filename;
    }
    return self;
}


@end
