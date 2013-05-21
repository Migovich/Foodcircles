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


@interface FCSVenueViewController ()

@property (weak, nonatomic) IBOutlet UILabel *specialNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *specialDetailsTextView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *iWantThisButton;


@end

@implementation FCSVenueViewController

@synthesize venue;


- (void)viewDidLoad
{
  [super viewDidLoad];

  self.specialNameLabel.text = venue.special.name;
  self.specialDetailsTextView.text = venue.special.details;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
  self.navigationController.title = self.venue.name;
  

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"showOptions"]) {
    FCSPurchaseViewController *destinationViewController = (FCSPurchaseViewController *)segue.destinationViewController;
    destinationViewController.special = venue.special;
    destinationViewController.title = venue.special.name;
  } else if ([segue.identifier isEqualToString:@"showRestaurantDetails"]) {
    FCSRestaurantInfoViewController *destinationViewController = (FCSRestaurantInfoViewController *)segue.destinationViewController;
    destinationViewController.venue = venue;
  }
}

@end
