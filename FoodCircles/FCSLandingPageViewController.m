//
//  FCSLandingPageViewController.m
//  FoodCircles
//
//  Created by David Groulx on 5/12/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSLandingPageViewController.h"


@interface FCSLandingPageViewController ()

@end


@implementation FCSLandingPageViewController


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"showVenueList"]) {
  }
}

- (IBAction)swipeRecognized:(id)sender {
  NSLog(@"swipe is a go");
}

@end
