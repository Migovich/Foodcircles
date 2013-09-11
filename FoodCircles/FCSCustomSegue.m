//
//  FCSCustomSegue.m
//  FoodCircles
//
//  Created by Bruno Guidolim on 9/11/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSCustomSegue.h"
#import <QuartzCore/QuartzCore.h>

@implementation FCSCustomSegue

-(void)perform {
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [sourceViewController.navigationController.view.layer addAnimation:transition
                                                                forKey:kCATransition];
    
    [sourceViewController.navigationController pushViewController:destinationController animated:NO];
    
}

@end