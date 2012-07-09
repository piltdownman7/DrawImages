//
//  DIIconCollection.h
//  DrawImages
/* !
	@class DIIconCollection
	
	DIIconCollection holds a collection of icons for use as a a tableView Delegate and Data Source
	
	@author Created by Brett Graham on 12-07-05.
	@copyright Copyright (c) 2012 Mobile Map Solutions. All rights reserved.
	@updated 12-07-09.
*/

#import <Foundation/Foundation.h>

@class DIIcon;

@interface DIIconCollection : NSObject <UITableViewDataSource, UITableViewDelegate>{
    @private
        NSMutableArray * vIcons;
        SEL selectorAfter;
        NSObject * objectAfter;
    @public
        DIIcon * currentIcon;
}

/* !
	@property DIIcon * currentIcon
	@abstact this is the currently selected element in the table and will be the icon used to draw
*/
@property DIIcon * currentIcon;

-(id) initWithClickedSelector:(SEL)selector onObject:(id)object;

@end
