//
//  DIViewController.m
//  DrawImages
//
//  Created by Brett Graham on 12-07-05.
//  Copyright (c) 2012 Mobile Map Solutions. All rights reserved.
//

#import "DIViewController.h"

#import "DIPoint.h"
#import "DILine.h"
#import "DIArea.h"

#import "DIIconCollection.h"
#import "DIIcon.h"

#import "DIIconEngine.h"
#import "DISprite.h"


@interface DIViewController () {

	//open GL and screen
    GLint backingWidth;
    GLint backingHeight;
    CGRect screenRect;
    GLKBaseEffect * effect;
}

//Open GL
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setupGL;
- (void)tearDownGL;

//Toolbar
-(void) setupToolbar;
-(void) setAllButtonsUnSelected;

//Table
-(void) setupTable;

//Draw Functions
-(void) drawPoint:(DIPoint *) point;
-(void) drawLine:(DILine *) line;
-(void) drawLine2:(DIPoint *) point;
-(void) drawArea:(DIArea *) area;
-(void) drawArea2:(DIArea *) area;
@end

@implementation DIViewController

@synthesize context = _context;
@synthesize effect = _effect;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    //setup Table
    [self setupTable];
    
    //set up toolbar
    [self setupToolbar];
    
    //set up GL
    [self setupGL];
	
	//set up objects
	vObjectsOnScreen = [NSMutableArray new];
    
    //set up touch
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
	[tapRecognizer setNumberOfTapsRequired:1];
	[tapRecognizer setDelegate:self];
	[self.view addGestureRecognizer:tapRecognizer];
}

- (void)viewDidUnload{    
    [super viewDidUnload];
    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
	self.context = nil;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)setupGL{
    
}

- (void)tearDownGL{
    [EAGLContext setCurrentContext:self.context];
    
    self.effect = nil;
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update{
    int nTemp = 2; //(arc4random() % 4); /// not rotating randomly because it makes it look slow
    dHeading += nTemp * 0.025;
    if(dHeading >= 2*M_PI) dHeading -= 2*M_PI;
    if(dHeading < 0) dHeading += 2*M_PI;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
	//1: Grab Screen Parameter
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    screenRect =  self.view.bounds;
    
	//2: Clear Background
    glClearColor(250/255.0, 252/255.0, 245/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
	//2: Setup Open GL to allow images
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	//4: Set the effect
    effect = [[GLKBaseEffect alloc] init];
    effect.transform.projectionMatrix = 
    GLKMatrix4MakeOrtho(0, screenRect.size.width, 0, screenRect.size.height, -1024, 1024);
    
    //5: If DIIconEngine is nil then create
    if(iconEngine == nil){
        iconEngine = [[DIIconEngine alloc] initWithEffect:effect];
    }
    
    //6: Draw all the shapes
    [self drawShapes];
    
}

#pragma mark - GLKView and GLKViewController Draw Methods

-(void) drawShapes{
	//1: Loop through all the objects
    NSEnumerator * enumerator = [vObjectsOnScreen objectEnumerator];
    id element;
    while(element = [enumerator nextObject]){

		//2: sort out by type
        if ([element isKindOfClass:[DIPoint class]]){
			[self drawPoint:element];
		}else if ([element isKindOfClass:[DILine class]]){
			[self drawLine:element];
		}else if ([element isKindOfClass:[DIArea class]]){
			[self drawArea:element];
		}
    }
    
    //3: Draw Current if not nil
    if(currentObject != nil){
        if ([currentObject isKindOfClass:[DIPoint class]]){
            if(eDrawMode == DMODE_LINE2){
                //if still mid line do more work
                [self drawLine2:(DIPoint *)currentObject];
            }
			[self drawPoint:(DIPoint *)currentObject];
		}else if ([currentObject isKindOfClass:[DILine class]]){
			[self drawLine:(DILine *)currentObject];
		}else if ([currentObject isKindOfClass:[DIArea class]]){
            
            if(eDrawMode == DMODE_AREA2){
                //if still mid poly do more work
                [self drawArea2:(DIArea *)currentObject];
            }
			[self drawArea:(DIArea *)currentObject];
		}
    }
}

-(void) drawPoint:(DIPoint *) point{
    [iconEngine drawIcon:point.icon.strFilename atX:point.x atY:point.y withRotation:dHeading];
}

-(void) drawLine:(DILine *) line{
    [iconEngine drawLineWithFile:line.icon.strFilename withX0:line.x0 withY0:line.y0 withX1:line.x1 withY1:line.y1];
}

-(void) drawLine2:(DIPoint *) point{
    [iconEngine drawIcon:@"Selected.png" atX:point.x atY:point.y withRotation:0];
}

-(void) drawArea:(DIArea *) area{
    [iconEngine fillPolygonWithFile:area.icon.strFilename withPolygonArray:area.vPoints withLength:[area.vPoints count]/2];
}

-(void) drawArea2:(DIArea *) area{
    //Draw each point
    for(int i = 0; i < [area.vPoints count]; i+=2){
        int x = [((NSNumber *)[area.vPoints objectAtIndex:i]) intValue];
        int y = [((NSNumber *)[area.vPoints objectAtIndex:i+1]) intValue];
        [iconEngine drawIcon:@"Selected.png" atX:x atY:y withRotation:0];
    }
    
}

#pragma mark - GUI methods - TOOLBAR

-(void) setupToolbar{
    
    //1: Setup all the buttons programmatically
    UIImage * imageNavButton = [UIImage imageNamed:@"Icon_Icons.png"];
    bbIcons = [[UIBarButtonItem alloc] initWithImage:imageNavButton
                                                   style:UIBarButtonItemStyleBordered
                                                  target:self
                                                  action:@selector(bbIconsClicked)];
    
    UIImage * imageLineButton = [UIImage imageNamed:@"Icon_DotTool.png"];
    bbPoints = [[UIBarButtonItem alloc] initWithImage:imageLineButton
                                                    style:UIBarButtonItemStyleDone 
                                                   target:self
                                                   action:@selector(bbPointsClicked)];
    eDrawMode = DMODE_POINT;
    
    UIImage * imageLightButton = [UIImage imageNamed:@"Icon_LineTool.png"];
    bbLines = [[UIBarButtonItem alloc] initWithImage:imageLightButton
                                                     style:UIBarButtonItemStyleBordered
                                                    target:self
                                                    action:@selector(bbLinessClicked)];
    
    UIImage * imageKMLButton = [UIImage imageNamed:@"Icon_AreaTool.png"];
    bbArea = [[UIBarButtonItem alloc] initWithImage:imageKMLButton
                                                   style:UIBarButtonItemStyleBordered
                                                  target:self
                                                  action:@selector(bbAreasClicked)];
    
    bbClear = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                      style:UIBarButtonItemStyleBordered
                                                     target:self
                                                     action:@selector(bbClearClicked)];

    
        
    //2: Create FlexSpace
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    
    //3: Add buttons to the array
    NSArray *items = [NSArray arrayWithObjects: bbIcons, flexItem,bbPoints, bbLines,bbArea, flexItem, bbClear,nil];
    
    
    //4: add array of buttons to toolbar
    [toolbar setItems:items animated:NO];
}

-(void) setAllButtonsUnSelected{
	//1: If table is open close it
	if(bbIcons.style == UIBarButtonItemStyleDone){
		[self hideShapeTable];
	}
	
	//2: turn off all the icons
	[bbIcons setStyle:UIBarButtonItemStyleBordered];
    [bbPoints setStyle:UIBarButtonItemStyleBordered];
    [bbLines setStyle:UIBarButtonItemStyleBordered];
    [bbArea setStyle:UIBarButtonItemStyleBordered];
    [bbClear setStyle:UIBarButtonItemStyleBordered];
    
    //3: Also turn off current object
    currentObject = nil;
}

-(void) bbIconsClicked{
	if(bbIcons.style == UIBarButtonItemStyleBordered){
		//show table
		[bbIcons setStyle:UIBarButtonItemStyleDone];
		[self showShapeTable];
	}else{
		//hide table
		[self hideShapeTable];
		[bbIcons setStyle:UIBarButtonItemStyleBordered];
	}
}

-(void) bbPointsClicked{
	//1: Turn off all the other buttons
	[self setAllButtonsUnSelected];
	
	//2: Change the Mode
	eDrawMode = DMODE_POINT;
	
	//3: Change the Icon to show active
	[bbPoints setStyle:UIBarButtonItemStyleDone];
}

-(void) bbLinessClicked{
	//1: Turn off all the other buttons
	[self setAllButtonsUnSelected];
	
	//2: Change the Mode
	eDrawMode = DMODE_LINE;
	
	//3: Change the Icon to show active
	[bbLines setStyle:UIBarButtonItemStyleDone];
}

-(void) bbAreasClicked{
	//1: Turn off all the other buttons
	[self setAllButtonsUnSelected];
	
	//2: Change the Mode
	eDrawMode = DMODE_AREA;
	
	//3: Change the Icon to show active
	[bbArea setStyle:UIBarButtonItemStyleDone];
}

-(void) bbClearClicked{
	//clear all 
	[vObjectsOnScreen removeAllObjects];
    
    //3: Also turn off current object
    currentObject = nil;
}

#pragma mark - GUI methods - TABLE

-(void) setupTable{
    // 1: Setup Data
    iconCollection = [[DIIconCollection alloc] initWithClickedSelector:@selector(hideShapeTable) onObject:self];
    
    //2: Built Table
    table = [UITableView new];
    [table setDelegate:iconCollection];
    [table setDataSource:iconCollection];
    [self.view addSubview:table];

}

-(void) showShapeTable{
    
    //1: show picker
    [table reloadData];
    table.hidden = false;
    
    //2:  Size up the table view to our screen and compute the start/end frame origin for our slide up animation
    screenRect = self.view.bounds;
    CGRect toolbarsie = [toolbar frame];
    
    CGRect tableStart = CGRectMake(0.0,screenRect.size.height+toolbarsie.size.height,screenRect.size.width,screenRect.size.height-toolbarsie.size.height);    
    CGRect tableEnd = CGRectMake(0.0,0.0,screenRect.size.width,screenRect.size.height-toolbarsie.size.height);
    
	//3: Set the Start 
    table.frame = tableStart;
    
    //4: Start the slide up animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    
	//5: Set End
    table.frame = tableEnd;
    
	//6: Animate
    [UIView commitAnimations];
}

-(void) hideShapeTable{
    
    //1:  Size up the table view to our screen and compute the start/end frame origin for our slide up animation
    screenRect = self.view.bounds;
    CGRect toolbarsie = [toolbar frame];
    CGRect tableEnd = CGRectMake(0.0,screenRect.size.height+toolbarsie.size.height,screenRect.size.width,screenRect.size.height-toolbarsie.size.height);    
    CGRect tableStart = CGRectMake(0.0,0.0,screenRect.size.width,screenRect.size.height-toolbarsie.size.height);    
	//2: Set the Start 
    table.frame = tableStart;
    
    //3: Start the slide up animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    
	//4: Set End
    table.frame = tableEnd;
    
	//5: Animate
    [UIView commitAnimations];
    
    //6: Turn off button
    [bbIcons setStyle:UIBarButtonItemStyleBordered];
    
}

#pragma mark - GUI methods - Touch Listeners

-(void)tapped:(id)sender {
    
    if([(UITapGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {    
        //1.  Get point and flip for open gl
        CGPoint clickPoint = [(UITapGestureRecognizer*)sender locationInView:self.view];
        screenRect =  self.view.bounds;
        clickPoint.y = screenRect.size.height - clickPoint.y;
        
        
        //2. Get current drawing
        DIIcon * icon = iconCollection.currentIcon;
        
        DIObject * obj;
    
        @synchronized(vObjectsOnScreen){
            switch(eDrawMode){
                case DMODE_POINT:
                    //A simple point object
                    obj = [[DIPoint alloc] initWithX0:clickPoint.x withY0:clickPoint.y withIcon:icon];
                    currentObject = nil;
                    [vObjectsOnScreen addObject:obj];
                    break;
                case DMODE_LINE:
                    //First Point of Line: just create a point for now, but save to current object drawing list
                    obj = [[DIPoint alloc] initWithX0:clickPoint.x withY0:clickPoint.y withIcon:icon];
                    currentObject = obj;
                    eDrawMode = DMODE_LINE2;
                    break;
                case DMODE_LINE2:
                    //Second Point of Line: Use the Point stored and create new
                    obj = [[DILine alloc] initWithX0:((DIPoint *)currentObject).x withY0:((DIPoint *)currentObject).y withX1:clickPoint.x withY1:clickPoint.y withIcon:icon];
                    currentObject = nil;
                    [vObjectsOnScreen addObject:obj];
                    eDrawMode = DMODE_LINE;
                    break;
                case DMODE_AREA:
                    //First Point Of Area: just create a point for now, but save to current object drawing list
                    obj = [[DIArea alloc] initWithX0:clickPoint.x withY0:clickPoint.y withIcon:icon];
                    currentObject = obj;
                    eDrawMode = DMODE_AREA2;
                    break;
                case DMODE_AREA2:
                    
                    //Check to see if close to another point (polygon is closed)
                    if([((DIArea *) currentObject) isCloseToWithX:clickPoint.x withY:clickPoint.y]){
                        //Close: close and add
                        [vObjectsOnScreen addObject:currentObject];
                        currentObject = nil;
                        eDrawMode = DMODE_AREA;
                    }else{
                        //Not Close: add point
                       [((DIArea *) currentObject) addPointWithX:clickPoint.x withY:clickPoint.y];
                    }
                    break;
            }
        }// end @synchronized
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
 
    if ([touch.view isKindOfClass:[UIToolbar class]])
        return NO;
    if ([touch.view isKindOfClass:[UIBarButtonItem class]])
        return NO;
    if([touch.view  isDescendantOfView:toolbar])
        return NO;
    if([touch.view  isDescendantOfView:table])
        return NO;
    
    return YES;
    
}



@end
