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


@interface FCSVenueViewController ()

@property (weak, nonatomic) IBOutlet UILabel *specialTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *specialDetailsTextField;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UISlider *priceSlider;

@end

@implementation FCSVenueViewController

@synthesize venue;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.specialTitleLabel.text = venue.special.title;
  self.specialDetailsTextField.text = venue.special.details;
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
  if ([segue.identifier isEqualToString:@"showBuy"]) {
     //((FCSPurchaseViewController *)segue.destinationViewController).navigationController.backItem.text = @"WTF";
    NSLog(@"showBuy transition");
    ((FCSPurchaseViewController *)segue.destinationViewController).description = venue.special.title;
  }
}

@end
