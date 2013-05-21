//
//  FCSLandingPageViewController.m
//  FoodCircles
//
//  Created by David Groulx on 5/12/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSLandingPageViewController.h"
#import "FCSRemoteAPI.h"

const CGFloat CAROUSEL_WIDTH = 320.0; // pixels
const CGFloat CAROUSEL_HEIGHT = 172.0; // pixels
const int CAROUSEL_DELAY = 5; // seconds

@interface FCSLandingPageViewController ()

@property NSArray *carouselImageArray;

@end


@implementation FCSLandingPageViewController

@synthesize carouselImageArray;
@synthesize carouselView;


- (void)viewDidLoad {
  [super viewDidLoad];
  
  carouselImageArray = [FCSRemoteAPI landingImages];

  // Manually set the content size of the scroll view. This is necessary with autolayout since
  // constraints are not loaded until later
//  carouselView.contentSize = CGSizeMake(CAROUSEL_WIDTH * carouselImageArray.count, CAROUSEL_HEIGHT);

  // Initialize the scrollview's content
  [carouselImageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:carouselImageArray[idx]];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    // Manually set  image view sizes as well to force the scroll view to expand to hold the images
    imageView.frame = CGRectMake(CAROUSEL_WIDTH * idx, 0, CAROUSEL_WIDTH, CAROUSEL_HEIGHT);
    [carouselView addSubview:imageView];
  }];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [NSTimer scheduledTimerWithTimeInterval:CAROUSEL_DELAY target:self selector:@selector(advanceTheScroller:) userInfo:nil repeats:YES];
}

- (void)advanceTheScroller:(NSTimer *)timer {
  CGPoint offset = carouselView.contentOffset;
  // Determine if scroll has reached the end
  if (offset.x >= CAROUSEL_WIDTH * (carouselImageArray.count - 1)) { // loop back to the start
    offset = CGPointZero;
  } else {
    offset.x += CAROUSEL_WIDTH;
  }
  [carouselView setContentOffset:offset animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"showVenueList"]) {
  }
}

@end
