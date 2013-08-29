//
//  FCSLandingPageViewController.h
//  FoodCircles
//
//  Created by David Groulx on 5/12/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCSStyledViewController.h"


@interface FCSLandingPageViewController : FCSStyledViewController

@property (weak, nonatomic) IBOutlet UIScrollView *carouselView;
@property (weak, nonatomic) IBOutlet UIImageView *shareButton;

- (IBAction)swipeRecognized:(id)sender;

@end
