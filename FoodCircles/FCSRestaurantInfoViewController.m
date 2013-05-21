//
//  FCSRestaurantInfoViewController.m
//  FoodCircles
//
//  Created by David Groulx on 5/21/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSRestaurantInfoViewController.h"

@interface FCSRestaurantInfoViewController ()

@end

@implementation FCSRestaurantInfoViewController

@synthesize venue;
@synthesize restaurantName;
@synthesize restaurantAmenities;
@synthesize imageView;


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
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  restaurantName.text = venue.name;
  imageView.image = venue.thumbnail;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)followFacebook:(id)sender {
}

- (IBAction)followTwitter:(id)sender {
}

- (IBAction)followYelp:(id)sender {
}
@end
