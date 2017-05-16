//
//  FCSFromTopSegue.m
//  FoodCircles
//
//  Created by Bruno Guidolim on 9/13/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSFromTopSegue.h"
#import <QuartzCore/QuartzCore.h>

@implementation FCSFromTopSegue

-(void)perform {
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    
    [sourceViewController.navigationController.view.layer addAnimation:transition
                                                                forKey:kCATransition];
    
    [sourceViewController.navigationController pushViewController:destinationController animated:NO];
    
}

@end
