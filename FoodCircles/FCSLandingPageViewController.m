//
//  FCSLandingPageViewController.m
//  FoodCircles
//
//  Created by David Groulx on 5/12/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSLandingPageViewController.h"
#import "FCSRemoteAPI.h"

@interface FCSLandingPageViewController ()

@property NSArray *carouselImageArray;

@end


@implementation FCSLandingPageViewController

@synthesize carouselImageArray;

- (void)viewDidLoad {
  [super viewDidLoad];

  self.carouselImageArray = [FCSRemoteAPI landingImages];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
  return [self.carouselImageArray count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
  return [[UIImageView alloc] initWithImage:carouselImageArray[index]];
}

@end
