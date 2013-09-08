//
//  FCSPickerTableViewController.h
//  FoodCircles
//
//  Created by Simon Gislen on 08/09/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FCSPickerTableViewControllerDelegate;

@interface FCSPickerTableViewController : UITableViewController
@property (nonatomic) NSArray *titles;
@property (nonatomic, weak) id <FCSPickerTableViewControllerDelegate> delegate;
@end

@protocol FCSPickerTableViewControllerDelegate <NSObject>
- (void)picker: (FCSPickerTableViewController*)picker didSelectRowAtIndex: (NSUInteger)index;
@end
