//
//  FCSRestaurantInfoViewController.m
//  FoodCircles
//
//  Created by David Groulx on 5/21/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSRestaurantInfoViewController.h"
#import "FCSVenueAnnotation.h"
#import "FCSAppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "constants.h"

@interface FCSRestaurantInfoViewController ()

@end

@implementation FCSRestaurantInfoViewController

@synthesize selectedVenueIndex;
@synthesize restaurantName;
@synthesize restaurantDescription;
@synthesize restaurantAmenities;
@synthesize imageView;
@synthesize mapView;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.restaurantName.text = [[UIAppDelegate.venues objectAtIndex:selectedVenueIndex] objectForKey:@"name"];
    self.restaurantDescription.text = [[UIAppDelegate.venues objectAtIndex:selectedVenueIndex] objectForKey:@"description"];

    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,[[UIAppDelegate.venues objectAtIndex:selectedVenueIndex] objectForKey:@"main_image"]]] placeholderImage:[UIImage imageNamed:@"transparent_box.png"]];

    FCSVenueAnnotation *venueAnn = [[FCSVenueAnnotation alloc] initWithVenueIndex:selectedVenueIndex];
    [mapView addAnnotation:venueAnn];
}

-(void)viewDidAppear:(BOOL)animated {
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = [[[UIAppDelegate.venues objectAtIndex:selectedVenueIndex] objectForKey:@"lat"] doubleValue];
    zoomLocation.longitude= [[[UIAppDelegate.venues objectAtIndex:selectedVenueIndex] objectForKey:@"lon"] doubleValue];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.2*1609.344, 0.2*1609.344);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustedRegion animated:YES];
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
    NSURL *url = [NSURL URLWithString:[[UIAppDelegate.venues objectAtIndex:selectedVenueIndex] objectForKey:@"web"]];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)getPhoneInfo:(id)sender {
    NSString *URLString = [@"tel://" stringByAppendingString:[[UIAppDelegate.venues objectAtIndex:selectedVenueIndex] objectForKey:@"phone"]];
    NSURL *URL = [NSURL URLWithString:URLString];
    [[UIApplication sharedApplication] openURL:URL];
}

@end
