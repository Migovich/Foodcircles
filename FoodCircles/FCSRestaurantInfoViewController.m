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

@interface FCSRestaurantInfoViewController ()

@end

@implementation FCSRestaurantInfoViewController

@synthesize selectedVenueIndex;
@synthesize restaurantName;
@synthesize restaurantAmenities;
@synthesize imageView;
@synthesize mapView;


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

    self.restaurantName.text = [[UIAppDelegate.venues objectAtIndex:selectedVenueIndex] objectForKey:@"name"];
    
    [imageView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[@"http://foodcircles.net" stringByAppendingString:[[UIAppDelegate.venues objectAtIndex:selectedVenueIndex] objectForKey:@"image"]]]]
                                  placeholderImage:[UIImage imageNamed:@"transparent_box.png"]
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                               imageView.image = image;
                                               [imageView setNeedsLayout];
                                           }
                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                               
                                           }];
    
  //imageView.image = venue.thumbnail;
  
  CLLocationCoordinate2D restaurantCoord = CLLocationCoordinate2DMake([[[UIAppDelegate.venues objectAtIndex:selectedVenueIndex] objectForKey:@"lat"] doubleValue], [[[UIAppDelegate.venues objectAtIndex:selectedVenueIndex] objectForKey:@"lon"] doubleValue]);
  MKCoordinateSpan restaurantSpan = MKCoordinateSpanMake(0.1, 0.1);
  MKCoordinateRegion restaurantRegion = MKCoordinateRegionMake(restaurantCoord, restaurantSpan);
  //[mapView addAnnotation:[[FCSVenueAnnotation alloc] initWithVenue:venue]];
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
