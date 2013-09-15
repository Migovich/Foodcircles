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
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *yelpButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *facebookXConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yelpXConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twitterXConstraint;

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
    
    NSDictionary *venue = [UIAppDelegate.venues objectAtIndex:selectedVenueIndex];
    self.restaurantName.text = [venue objectForKey:@"name"];
    self.restaurantDescription.text = [venue objectForKey:@"description"];
    self.restaurantAmenities.text = venue[@"tags"][0][@"name"];

    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,[[UIAppDelegate.venues objectAtIndex:selectedVenueIndex] objectForKey:@"outside_image"]]] placeholderImage:[UIImage imageNamed:@"transparent_box.png"]];

    FCSVenueAnnotation *venueAnn = [[FCSVenueAnnotation alloc] initWithVenueIndex:selectedVenueIndex];
    [mapView addAnnotation:venueAnn];
    

    
//    if (!facebook && twitter && yelp) {
//        
//    }
//    else if (facebook && !twitter && yelp) {
//        
//    }
//    else if (facebook && twitter && !yelp) {
//        
//    }
//    else if () {
//        
//    }
    
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
    [self openSocialUrlForKey:@"facebook"];
}

- (IBAction)followTwitter:(id)sender {
    [self openSocialUrlForKey:@"twitter"];
}

- (IBAction)followYelp:(id)sender {
    [self openSocialUrlForKey:@"yelp"];
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

#pragma mark - Helpers

- (void)openSocialUrlForKey: (NSString*)key {
    NSString *urlString = [self socialUrlForKey:key];
    
    if (urlString) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else {
        //Fail silently
    }
}
- (NSString*)socialUrlForKey: (NSString*)key {
    NSDictionary *venue = [UIAppDelegate.venues objectAtIndex:selectedVenueIndex];
    NSArray *socialLinks = venue[@"social_links"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"source == %@", key];
    NSArray *link = [socialLinks filteredArrayUsingPredicate:predicate];
    if (link.count) {
        return link[0][@"url"];
    }
    else {
        //Fail silently
        return nil;
    }
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    BOOL facebook = [self socialUrlForKey:@"facebook"] ? YES:NO;
    BOOL twitter = [self socialUrlForKey:@"twitter"] ? YES:NO;
    BOOL yelp = [self socialUrlForKey:@"yelp"] ? YES:NO;
    
    NSMutableArray *buttons = [NSMutableArray array];
    if (facebook) [buttons addObject:self.facebookXConstraint];
    else self.facebookButton.hidden = YES;
    if (twitter) [buttons addObject:self.twitterXConstraint];
    else self.twitterButton.hidden = YES;
    if (yelp) [buttons addObject:self.yelpXConstraint];
    else self.yelpButton.hidden = YES;
    
    //Yup, this code is bad....
    NSUInteger x = 139;
    NSUInteger y = 71;
    NSUInteger centerX = 193;
    NSUInteger xcounter = x;
    for (NSLayoutConstraint *constraint in buttons) {
        constraint.constant = xcounter;
        xcounter += 15 + 39;
    }
    if (buttons.count == 1) {
        NSLayoutConstraint *constraint = buttons[0];
        constraint.constant = centerX;
    }
}

@end
