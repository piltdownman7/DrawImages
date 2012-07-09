//
//  NSString_Utility.h
//  DrawImages
//
//  Created by Brett Graham on 12-07-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utility)

/* !
 @function contains
 @abstact Is a substring found in a string
 @param (NSString *) strSearch
 The Substring to look for

 @return bool
 True if the substring is found, False if it is not
 */
-(bool) contains:(NSString *) strSearch;
@end

@implementation NSString (Utility)

-(bool) contains:(NSString *) strSearch{
    
    if ([self rangeOfString:strSearch].location == NSNotFound)return false;
    else return true;
}

@end
