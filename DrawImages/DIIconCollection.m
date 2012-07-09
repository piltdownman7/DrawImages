//
//  DIIconCollection.m
//  DrawImages
//
//  Created by Brett Graham on 12-07-05.
//  Copyright (c) 2012 Mobile Map Solutions. All rights reserved.
//

#import "DIIconCollection.h"

#import "DIIcon.h"

@interface DIIconCollection()

-(void) setup; 

@end

@implementation DIIconCollection

@synthesize currentIcon;

-(id) initWithClickedSelector:(SEL)selector onObject:(id)objectA{
    self = [super init];
    if(self){
        vIcons = [NSMutableArray new];
        [self setup];
        selectorAfter = selector;
        objectAfter = objectA;
    }
    
    return self;
}


-(void) setup{
    [vIcons addObject:[[DIIcon alloc] initWithName:@"Box" withFileName:@"Box"]];
    [vIcons addObject:[[DIIcon alloc] initWithName:@"Bus" withFileName:@"Bus"]];
    [vIcons addObject:[[DIIcon alloc] initWithName:@"Check" withFileName:@"Check"]];
    [vIcons addObject:[[DIIcon alloc] initWithName:@"Fire" withFileName:@"Fire"]];
    [vIcons addObject:[[DIIcon alloc] initWithName:@"Gift" withFileName:@"Gift"]];
    [vIcons addObject:[[DIIcon alloc] initWithName:@"Golf" withFileName:@"Golf"]];
    [vIcons addObject:[[DIIcon alloc] initWithName:@"No Circle" withFileName:@"No"]];
    [vIcons addObject:[[DIIcon alloc] initWithName:@"Question Mark" withFileName:@"Question"]];
    [vIcons addObject:[[DIIcon alloc] initWithName:@"Refresh" withFileName:@"Refresh"]];
    [vIcons addObject:[[DIIcon alloc] initWithName:@"Shield" withFileName:@"Box"]];
    [vIcons addObject:[[DIIcon alloc] initWithName:@"Smoke" withFileName:@"Smoke"]];
    [vIcons addObject:[[DIIcon alloc] initWithName:@"Train" withFileName:@"Train"]];
    [vIcons addObject:[[DIIcon alloc] initWithName:@"X" withFileName:@"X"]];
    
    currentIcon = [vIcons objectAtIndex:0];
}

#pragma mark - Table Delagates and Data Providers

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [vIcons count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if([vIcons count] <= indexPath.row){
        return;
    }
    
    if(indexPath.row%2 == 0){
        [cell setBackgroundColor:[UIColor colorWithRed:.75 green:.75 blue:.90 alpha:0.75]];
        cell.textLabel.textColor =  [UIColor colorWithRed:0 green:0 blue:.1 alpha:1.0];
    }else{
        [cell setBackgroundColor:[UIColor colorWithRed:.9 green:.9 blue:0.9 alpha:0.75]];
        cell.textLabel.textColor =  [UIColor colorWithRed:0 green:0 blue:.1 alpha:1.0];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * strId = [[NSString alloc] initWithFormat:@"%d",indexPath.row]; //@"MyIdentifier"
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = YES;
    }
    
    if([vIcons count] <= indexPath.row){
        return cell;
    }
    
    DIIcon * icon  = [vIcons objectAtIndex:indexPath.row];
    
    cell.textLabel.text = icon.strName;
   
    NSString *path = [[NSBundle mainBundle] pathForResource:icon.strFilename ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    cell.imageView.image = theImage; 
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    
    if([vIcons count] <= indexPath.row){
        return; //out of bounds
    }
    //1. set the current object
    currentIcon = [vIcons objectAtIndex:indexPath.row];
    
    //2. fire the selector
     [objectAfter performSelector:selectorAfter withObject:self];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}


@end
