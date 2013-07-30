//
//  FCSRestaurantInfoViewController.h
//  FoodCircles
//
//  Created by David Groulx on 5/21/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "FCSVenue.h"
#import "FCSStyledViewController.h"

@interface FCSRestaurantInfoViewController : FCSStyledViewController

@property int selectedVenueIndex;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *contactByPhone;
@property (weak, nonatomic) IBOutlet UIButton *conactByWebsite;
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAmenities;

- (IBAction)followFacebook:(id)sender;
- (IBAction)followTwitter:(id)sender;
- (IBAction)followYelp:(id)sender;
- (IBAction)visitWebsite:(id)sender;
- (IBAction)getPhoneInfo:(id)sender;

@end