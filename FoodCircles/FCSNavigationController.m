//
//  FCSNavigationController.m
//  FoodCircles
//
//  Created by David Groulx on 5/3/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSNavigationController.h"
#import "FCSStyles.h"

@implementation FCSNavigationController

- (void)viewWillAppear:(BOOL)animated {
  self.navigationBar.tintColor = [FCSStyles darkRed];
  self.navigationBar.titleTextAttributes = @{ UITextAttributeFont : [UIFont fontWithName:@"Neutraface Slab Text" size:22] };
}

@end
