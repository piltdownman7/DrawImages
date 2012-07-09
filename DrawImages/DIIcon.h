//
//  DIIcon.h
//  DrawImages
/* !
	@class DIIcon
	
	DIIcon is a class to hold info on an icons name and filename to be used by the table
	
	@author Created by Brett Graham on 12-07-05.
	@copyright Copyright (c) 2012 Mobile Map Solutions. All rights reserved.
	@updated 12-07-09.
*/

#import <Foundation/Foundation.h>

@interface DIIcon : NSObject{
    NSString * strName;
    NSString * strFilename;
    
}

@property NSString * strName;
@property NSString * strFilename;

/* !
	@function initWithName withFile
	@abstact Creates a New DIIcon file with a name and Filename
	@param WithName:(NSString *) name
		The text to show up in the table as the name
	@param withFileName:(NSString *) filename
		The text to of the filename of the image
	@return (id)
		A DIIcon object or nil if init failed
*/
-(id) initWithName:(NSString *) name withFileName:(NSString *) filename;


@end
