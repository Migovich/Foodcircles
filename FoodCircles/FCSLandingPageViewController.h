//
//  FCSLandingPageViewController.h
//  FoodCircles
//
//  Created by David Groulx on 5/12/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCSStyledViewController.h"
#import "iCarousel.h"

@interface FCSLandingPageViewController : FCSStyledViewController
<iCarouselDataSource, iCarouselDelegate>

@end
