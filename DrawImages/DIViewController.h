//
//  DIViewController.h
//  DrawImages
//
//  Created by Brett Graham on 12-07-05.
//  Copyright (c) 2012 Mobile Map Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "DIConstants.h"

@class DIIconCollection;
@class DIIconEngine;
@class DIObject;

@interface DIViewController : GLKViewController <UIGestureRecognizerDelegate>{
    
    
@private
    //vector of objects on the screen 
	NSMutableArray * vObjectsOnScreen;
    
    //current mode
    DRAWING_TYPE eDrawMode;
    
    //current object
    DIObject * currentObject;
    
    //Table Data
    DIIconCollection * iconCollection;
    
    //Icon Engine
    DIIconEngine * iconEngine;
    
    //icon rotation
    double dHeading; 
    
@public
    IBOutlet UIToolbar * toolbar;
    UIBarButtonItem * bbIcons;
    UIBarButtonItem * bbPoints;
    UIBarButtonItem * bbLines;
    UIBarButtonItem * bbArea;
    UIBarButtonItem * bbClear;
    UITableView * table;
    
}

//@property  (nonatomic, retain) UIToolbar * toolbar;

#pragma mark - Actions
-(void) bbIconsClicked;
-(void) bbPointsClicked;
-(void) bbLinessClicked;
-(void) bbAreasClicked;
-(void) bbClearClicked;
@end
