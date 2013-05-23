//
//  FCSRestaurantInfoViewController.m
//  FoodCircles
//
//  Created by David Groulx on 5/21/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSRestaurantInfoViewController.h"
#import "FCSVenueAnnotation.h"

@interface FCSRestaurantInfoViewController ()

@end

@implementation FCSRestaurantInfoViewController

@synthesize venue;
@synthesize restaurantName;
@synthesize restaurantAmenities;
@synthesize imageView;
@synthesize mapView;


- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
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
  
  CLLocationCoordinate2D restaurantCoord = CLLocationCoordinate2DMake([venue.lat doubleValue], [venue.lon doubleValue]);
  MKCoordinateSpan restaurantSpan = MKCoordinateSpanMake(0.1, 0.1);
  MKCoordinateRegion restaurantRegion = MKCoordinateRegionMake(restaurantCoord, restaurantSpan);
  [mapView addAnnotation:[[FCSVenueAnnotation alloc] initWithVenue:venue]];
  mapView.region = restaurantRegion;
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

- (IBAction)visitWebsite:(id)sender {
}

- (IBAction)getPhoneInfo:(id)sender {
}

@end
