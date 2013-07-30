//
//  FCSVenueViewController.m
//  FoodCircles
//
//  Created by David Groulx on 5/2/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSVenueViewController.h"
#import "FCSSpecial.h"
#import "FCSPurchaseViewController.h"
#import "FCSRestaurantInfoViewController.h"
#import "FCSAppDelegate.h"


@interface FCSVenueViewController ()

@property (weak, nonatomic) IBOutlet UILabel *specialNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *specialDetailsTextView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *iWantThisButton;


@end

@implementation FCSVenueViewController

@synthesize selectedVenueIndex;


- (void)viewDidLoad
{
  [super viewDidLoad];
    self.title = [[UIAppDelegate.venues objectAtIndex:selectedVenueIndex] objectForKey:@"name"];
    self.specialNameLabel.text = [[[[UIAppDelegate.venues objectAtIndex:selectedVenueIndex] objectForKey:@"offers"] objectAtIndex:0] objectForKey:@"title"];
    self.specialDetailsTextView.text = [[[[UIAppDelegate.venues objectAtIndex:selectedVenueIndex] objectForKey:@"offers"] objectAtIndex:0] objectForKey:@"details"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"showOptions"]) {
    FCSPurchaseViewController *destinationViewController = (FCSPurchaseViewController *)segue.destinationViewController;
    destinationViewController.selectedVenueIndex = selectedVenueIndex;
  } else if ([segue.identifier isEqualToString:@"showRestaurantDetails"]) {
    FCSRestaurantInfoViewController *destinationViewController = (FCSRestaurantInfoViewController *)segue.destinationViewController;
    destinationViewController.selectedVenueIndex = selectedVenueIndex;
  }
}

@end
