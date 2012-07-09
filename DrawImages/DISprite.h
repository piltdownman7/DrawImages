//
//  DISprite.h
//  Mobile Map Navigator
/* !
	@class DISprite
	
	This class stores and draws a sprite 
	This code is based on work by Ray Wenderlich from his tutorial
	http://www.raywenderlich.com/9743/how-to-create-a-simple-2d-iphone-game-with-opengl-es-2-0-and-glkit-part-1
	It however has been changed so will not work the same as that code 
	
	@author Created by Brett Graham on 12-04-14.
	@copyright Copyright (c) 2012 Mobile Map Solutions. All rights reserved.
	@updated 12-07-09.
*/
//  

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>


@interface DISprite : NSObject{
    @public float rotation;
}

/* !
	@property GLKVector2 position
	@abstact The onscreen position of the sprite centre
	@discussion The Lower-Left corner of the screen has the coordinate (0,0)
*/
@property (assign) GLKVector2 position;

/* !
	@property GLKVector2 scale
	@abstact The Scale of the icon.  1.0 is normal scale; 0.5 is half normal scale; 2.0 is double normal scale
*/
@property (assign) GLKVector2 scale;
/* !
	@property CGSize contentSize
	@abstact The true dimentions of the image sprite as loaded. Which will be multiplied by the scale
*/
@property (assign) CGSize contentSize;

/* !
	@function initWithFile effect
	@abstact Creates a new DISprite file with a filenmane and gl effect
	@param WithFile:(NSString *)fileName
		The text to of the filename of the image
	@param effect:(GLKBaseEffect *)effect
		The effext to use for drawing
	@return (id)
		A DISprite object or nil if init failed
*/
- (id) initWithFile:(NSString *)fileName effect:(GLKBaseEffect *)effect;

/* !
	@function render
	@abstact draws the image sprite onto the screen
*/
- (void) render;

/* !
	@function resetEffect
	@abstact Creates a new DISprite file with a filenmane and gl effect
	@param (GLKBaseEffect *)effect_i
		The effect to replace the old one
*/
- (void) resetEffect:(GLKBaseEffect *)effect_i;

@end
