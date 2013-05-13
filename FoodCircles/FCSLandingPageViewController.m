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
@synthesize carouselView;


- (void)viewDidLoad {
  [super viewDidLoad];
  
  carouselImageArray = [FCSRemoteAPI landingImages];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (IBAction)swipeRecognized:(id)sender {
  NSLog(@"Swipe detected");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"showVenueList"]) {
//    NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
//    FCSVenue *venue = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    FCSVenueViewController *destinationViewController = (FCSVenueViewController *)segue.destinationViewController;
//    destinationViewController.venue = venue;
//    destinationViewController.title = venue.name;
    NSLog(@"preparing segue showVenueList");
  }
}
@end
