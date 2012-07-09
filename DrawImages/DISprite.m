//
//  DISprite.m
//  Mobile Map Navigator
//
//  Created by Brett Graham on 12-04-14.
//  Copyright (c) 2012 Mobile Map Solutions. All rights reserved.
//

#import "DISprite.h"
#import "NSString_Utility.h"

typedef struct {
    CGPoint geometryVertex;
    CGPoint textureVertex;
} TexturedVertex;

typedef struct {
    TexturedVertex bl;
    TexturedVertex br;    
    TexturedVertex tl;
    TexturedVertex tr;    
} TexturedQuad;

@interface DISprite()

@property (strong) GLKBaseEffect * effect;
@property (assign) TexturedQuad quad;
@property (strong) GLKTextureInfo * textureInfo;

@end


@implementation DISprite

@synthesize effect = _effect;
@synthesize quad = _quad;
@synthesize textureInfo = _textureInfo;
@synthesize position = _position;
@synthesize scale = _scale;
@synthesize contentSize = _contentSize;

- (id)initWithFile:(NSString *)fileName effect:(GLKBaseEffect *)effect {
    self = [super init];
    if (self) {  
        
        // 1: Set the effect
        self.effect = effect;
        
        // 2: Set the Open GL Options
        NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithBool:YES],
                                  GLKTextureLoaderOriginBottomLeft, 
                                  nil];
        
        // 3: Load the image and set to a textured quad
        NSError * error;   
        @try{
            if(! [fileName contains:@".png"]){
                fileName = [[NSString alloc] initWithFormat:@"%@.png",fileName];
            }
            
            NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
            
            // 3.1: Try to load from file or return nil if faile
            self.textureInfo = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
            if (self.textureInfo == nil) {
                NSLog(@"Error loading file: %@, %@",fileName, [error localizedDescription]);
                return nil;
            }
            
            //3.2 Set up Textured Quad
            TexturedQuad newQuad;
            newQuad.bl.geometryVertex = CGPointMake(0, 0);
            newQuad.br.geometryVertex = CGPointMake(self.textureInfo.width, 0);
            newQuad.tl.geometryVertex = CGPointMake(0, self.textureInfo.height);
            newQuad.tr.geometryVertex = CGPointMake(self.textureInfo.width, self.textureInfo.height);
            
            newQuad.bl.textureVertex = CGPointMake(0, 0);
            newQuad.br.textureVertex = CGPointMake(1, 0);
            newQuad.tl.textureVertex = CGPointMake(0, 1);
            newQuad.tr.textureVertex = CGPointMake(1, 1);
            self.quad = newQuad;
            
            
            
            //3.4 set the scale to 1.0
            self.contentSize = CGSizeMake(self.textureInfo.width, self.textureInfo.height);
            self.scale = GLKVector2Make(1.0,1.0); 
        }@catch (NSException * ex) {
            return nil;
        } 
    }
    //4: return object
    return self;
}


-(void) resetEffect:(GLKBaseEffect *)effect_i{
    self.effect = effect_i;
}


- (GLKMatrix4) modelMatrix {
    
    //1: Start with the identity
    GLKMatrix4 modelMatrix = GLKMatrix4Identity;   

    //2: Change the model to the potition, rotation and size
    modelMatrix = GLKMatrix4Multiply(
                                     GLKMatrix4Translate(modelMatrix, self.position.x, self.position.y, 0),
                                     GLKMatrix4Multiply(GLKMatrix4MakeRotation(rotation, 0, 0, 1),GLKMatrix4Translate(modelMatrix, -self.contentSize.width/2, -self.contentSize.height/2, 0)));
    
    //3: If there is a scale multipy that
    if((self.scale.x != 1.0)||(self.scale.y != 1.0)){
        modelMatrix = GLKMatrix4Multiply( GLKMatrix4MakeScale(self.scale.x,self.scale.y ,1), modelMatrix);
    }
    
    //4: return our new model matrix
    return modelMatrix;
}

- (void)render { 
    
    // 1: Set the texture as our draw effect
    self.effect.texture2d0.name = self.textureInfo.name;
    self.effect.texture2d0.enabled = YES;
    
    //2: set to our modified model
    self.effect.transform.modelviewMatrix = self.modelMatrix;
    
    // 3: Tell the effect to get ready with these settings
    [self.effect prepareToDraw];
    
    // 4: Enable gl options
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
    // 5: load the texture and position vectors
    long offset = (long)&_quad;        
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void *) (offset + offsetof(TexturedVertex, geometryVertex)));
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void *) (offset + offsetof(TexturedVertex, textureVertex)));
    
    // 6: Draw our sprite 
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    //7: Disable our gl options
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
    
}

@end
