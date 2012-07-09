//
//  MMNIconEngine.m
//  Mobile Map Navigator
//
//  Created by Brett Graham on 12-05-10.
//  Copyright (c) 2012 Mobile Map Solutions. All rights reserved.
//

#import "DIIconEngine.h"

#import "DISprite.h"
#import "DIConstants.h"

@interface DIIconEngine()

@property (strong) GLKBaseEffect * effect;

-(DISprite *) getSpriteObject:(NSString *) strFile;

@end

@implementation DIIconEngine

@synthesize effect = _effect;

-(id) initWithEffect:(GLKBaseEffect *)effect_i{
    self = [super init];
    if(self){self.effect = effect_i;
        
        //1 : Setup our GL options
        options = [NSDictionary dictionaryWithObjectsAndKeys:
                   [NSNumber numberWithBool:YES],
                   GLKTextureLoaderOriginBottomLeft, 
                   nil];
        //2 : Create the store for all the images and create a default for if the image is not found
        mObjects= [[NSMutableDictionary alloc] init];
        spriteDefault = [[DISprite alloc] initWithFile:@"Unknown.png" effect:self.effect]; 
    }
    return self;
}

#pragma mark - Draw Icons Points

-(void) drawIcon:(NSString *) strFilename atX:(int) x atY:(int) y{
    [self drawIcon:strFilename atX:x atY:y withRotation:0 withScale:1.0];
}

-(void) drawIcon:(NSString *) strFilename atX:(int) x atY:(int) y withRotation:(double) r{
    [self drawIcon:strFilename atX:x atY:y withRotation:r withScale:1.0];
}

-(void) drawIcon:(NSString *) strFilename atX:(int) x atY:(int) y withScale:(double) dScale{
    [self drawIcon:strFilename atX:x atY:y withRotation:0 withScale:dScale];
}
    
-(void) drawIcon:(NSString *) strFilename atX:(int) x atY:(int) y withRotation:(double) r withScale:(double) dScale{
    
    //1: fetch or load the image
    DISprite * sprite;
    sprite = [self getSpriteObject:strFilename];
    
    //2: set the icons scale, position and rotation
    GLKVector2 scale = GLKVector2Make(dScale * kICON_SIZE , dScale * kICON_SIZE);
    float xx = (float)x / kICON_SIZE;
    float yy = (float)y / kICON_SIZE;
    sprite.position = GLKVector2Make(xx,yy);
    sprite.scale = scale;
    sprite->rotation = r;
    
    //3: draw on screen
    [sprite render];
}

#pragma mark - Draw Icons Lines

-(void) drawLineWithIcons:(NSMutableArray *) vIcons withGaps:(int) nGap withPolygon:(float *) vector withLength:(int) nSize{
   
    //1. get all the sprites needes
    int nSpriteIndex = 0;
    NSMutableArray * vImageSprites =[NSMutableArray new]; 
    for(int i = 0; i < [vIcons count]; i++){
        [vImageSprites addObject: [self getSpriteObject:[vIcons objectAtIndex:i]]];
    }
    
    //2. Draw each line segment
    for(int v = 1; v < nSize; v++){
        
		// 2.1 Caculate the maths
		double dDX = vector[2*v] - vector[2*v-2];
		double dDY = vector[2*v+1] - vector[2*v-1];
		
		double dDistance = sqrt(dDX*dDX + dDY*dDY);
		double dAngle = atan2(-dDX, dDY);
        
        //2.2 Along the path
		for(int px = 0; px < dDistance;){
            //2.2.1 Get the Origin
			int nP_X = (int) (px * cos(dAngle + M_PI_2))+vector[2*v-2];
            int nP_Y = (int) (px * sin(dAngle + M_PI_2))+ vector[2*v-1];
            
            float xx = (float)nP_X / kICON_SIZE;
            float yy = (float)nP_Y / kICON_SIZE;
            
            //2.2.2 Get the Sprite
            DISprite * sprite = [vImageSprites objectAtIndex:nSpriteIndex];
            if(sprite != nil){
                sprite->rotation = dAngle+ M_PI_2;
                sprite.position = GLKVector2Make(xx, yy);
                [sprite render];
                    
                 //increment
                px += kICON_SIZE;
            }else{
                if(nGap != 0){
                    px += nGap;
                }else{
                    px += kICON_SIZE_SCREEN;
                }
            }
            //2.2.3 Increment the Gap and the image
			px += nGap;
			nSpriteIndex++;
			nSpriteIndex %= [vImageSprites count];
		}
        
        
    }
}

-(void) drawLineWithFile:(NSString *) strFilename withGaps:(int) nGap withPolygon:(float *) vector withLength:(int) nSize{
    //1. create and Array with the one element
    NSMutableArray * vIcons = [NSMutableArray new];
    [vIcons addObject:strFilename];
    
    //2. Call other method
    [self  drawLineWithIcons:vIcons withGaps:nGap withPolygon:vector withLength:nSize];
}

-(void) drawLineWithIcons:(NSMutableArray *) vIcons withGaps:(int) nGap withPolygonArray:(NSMutableArray *) vPoints withLength:(int) nSize{
    //1. Create Vector
    float * vector = malloc(2*nSize * sizeof(float));
    for(int i = 0; i < 2*nSize; i++){
        vector[i] = [((NSNumber *) [vPoints objectAtIndex:i]) intValue];
    }
    
    //2. Call other method
    [self  drawLineWithIcons:vIcons withGaps:nGap withPolygon:vector withLength:nSize];
    
    //3. Free Memory
    free(vector);
}

-(void) drawLineWithFile:(NSString *) strFilename withGaps:(int) nGap withPolygonArray:(NSMutableArray *) vPoints withLength:(int) nSize{
    //1. create and Array with the one element
    NSMutableArray * vIcons = [NSMutableArray new];
    [vIcons addObject:strFilename];
    
    //2. Call other method
    [self  drawLineWithIcons:vIcons withGaps:nGap withPolygonArray:(NSMutableArray *) vPoints withLength:nSize];
}

-(void) drawLineWithFile:(NSString *) strFilename withGaps:(int) nGap withX0:(int) x_0 withY0: (int) y_0 withX1:(int) x_1 withY1:(int) y_1{
    //1. Create Vector
    float * vector = malloc(4 * sizeof(float));
    vector[0] = x_0;
    vector[1] = y_0;
    vector[2] = x_1;
    vector[3] = y_1;
    
    //2. Call other method
    [self  drawLineWithFile:(NSString *) strFilename withGaps:nGap withPolygon:vector withLength:2];
    
    //3. Free Memory
    free(vector);
}

-(void) drawLineWithFile:(NSString *) strFilename withX0:(int) x_0 withY0: (int) y_0 withX1:(int) x_1 withY1:(int) y_1{
    //1. Create Vector
    float * vector = malloc(4 * sizeof(float));
    vector[0] = x_0;
    vector[1] = y_0;
    vector[2] = x_1;
    vector[3] = y_1;
    
    //2. Call other method
    [self  drawLineWithFile:(NSString *) strFilename withGaps:kDEFAULT_GAP withPolygon:vector withLength:2];
    
    //3. Free Memory
    free(vector);
}
    
#pragma mark - Draw Icons Polygon


-(void) fillPolygonWithFile:(NSString *) strFilename withPolygon:(float *) vector withLength:(int) nSize{    
    //1: fetch or load the image
    DISprite * sprite;
    sprite = [self getSpriteObject:strFilename];
    
    //2: Find the Max/Min of our Polygon
    float fX_max = 1;
    float fX_min = 0;
    float fY_max = 1;
    float fY_min = 0;
    
    for(int i = 0; i < nSize; i++){
        if((fX_max == 1)||(vector[2*i] > fX_max)) fX_max = vector[2*i]; 
        if((fX_min == 0)||(vector[2*i] < fX_min)) fX_min = vector[2*i]; 
        if((fY_max == 1)||(vector[2*i+1] > fY_max)) fY_max = vector[2*i+1]; 
        if((fY_max == 0)||(vector[2*i+1] < fY_min)) fY_min = vector[2*i+1]; 
        
    }
    
    //3: Since we don't want any partial images, this loop will 'stamp' the images repeatedly 
    for(float y = fY_min; y < fY_max; y+= kICON_SIZE_SCREEN){
        for(float x = fX_min; x < fX_max; x+= kICON_SIZE_SCREEN){
            
            //3.1: determine if within the polygon 
            int i = 0;
            int j = nSize -1;
            bool bOddNode = false;
            for(i = 0; i < nSize; i++){
                

                double dIx = vector[2*i];
                double dIy = vector[2*i+1];
                

                double dJx = vector[2*j];
                double dJy = vector[2*j+1];
                
                if ( (dIy > y) != (dJy > y)){
                    if(x < (((dJx - dIx ) * (y - dIy) / (dJy - dIy)) + dIx )){
                        bOddNode = !bOddNode;
                    }
                }
                j=i; 
            }
            if(bOddNode){
                //3.2: set scale, position and rotation 
                GLKVector2 scale = GLKVector2Make(kICON_SIZE , kICON_SIZE);
                float xx = (float)x / kICON_SIZE;
                float yy = (float)y / kICON_SIZE;
                sprite.position = GLKVector2Make(xx,yy);
                sprite.scale = scale;
                sprite->rotation = 0;
                
                //3.3: draw shape
                [sprite render];
            }
        }
    }
}

-(void) fillPolygonWithFile:(NSString *) strFilename withPolygonArray:(NSMutableArray *) vPoints withLength:(int) nSize{
    //1. Screen if less than 3 points
    if([vPoints count] < 6) return;
    
    //2. Create Vector
    float * vector = malloc(2* nSize * sizeof(float));
    for(int i = 0; i < 2* nSize; i++){
        vector[i] = [((NSNumber *) [vPoints objectAtIndex:i]) intValue];
    }
    
    //3. Call other method
    [self  fillPolygonWithFile:strFilename withPolygon:vector withLength:nSize];
    
    //4. Free Memory
    free(vector);
}



-(void)resetEffect:(GLKBaseEffect *)effect_i{
    NSEnumerator *enumerator = [mObjects keyEnumerator];
    
    for(NSString *aKey in enumerator) {
        DISprite * sprite = [mObjects valueForKey:aKey];
        [sprite resetEffect:effect_i];
    }
}

#pragma mark - Private Messages

-(DISprite *) getSpriteObject:(NSString *) strFile{
    //1: find or load sprite
    DISprite * sprite;
    NSObject *temp = [mObjects objectForKey:strFile];
    
    
    if(temp != nil){
        //The image is in the store (previously used) so use it instead of reloading
        sprite = (DISprite *) temp;
    }else{
        //The image is not in the store (previously unused) so load and add to our store
        sprite = [[DISprite alloc] initWithFile:strFile effect:self.effect];
        if(sprite != nil){
            [mObjects setObject:sprite forKey:strFile];
        }else{
            //file can not be found use Default
            sprite = spriteDefault;
            NSLog(@"Missing Icon For \"%@\"",strFile);
        }
    }
    
    //2: reset parameters
    GLKVector2 scale = GLKVector2Make(kICON_SIZE , kICON_SIZE);
    sprite.scale = scale;
    sprite->rotation = 0;
    
    //3: reurn the element to use
    return sprite;
}

@end
