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
#import "UIImageView+AFNetworking.h"
#import "constants.h"


@interface FCSVenueViewController ()

@property (weak, nonatomic) IBOutlet UILabel *specialNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *specialDetailsTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specialDetailsTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *iWantThisButton;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImage;


@end

@implementation FCSVenueViewController

@synthesize selectedVenueIndex;


- (void)viewDidLoad
{
  [super viewDidLoad];
    self.title = [[UIAppDelegate.venues objectAtIndex:selectedVenueIndex] objectForKey:@"name"];
    self.specialNameLabel.text = [[[[UIAppDelegate.venues objectAtIndex:selectedVenueIndex] objectForKey:@"offers"] objectAtIndex:0] objectForKey:@"title"];
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:14.0];
    
    NSMutableAttributedString *detailText = [[NSMutableAttributedString alloc] initWithString:[[[[UIAppDelegate.venues objectAtIndex:selectedVenueIndex] objectForKey:@"offers"] objectAtIndex:0] objectForKey:@"details"] attributes:
                                             @{
                                                NSFontAttributeName: font
                                             }];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:1];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [detailText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, detailText.length)];
    self.specialDetailsTextView.attributedText = detailText;
    
    [self.restaurantImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,[[UIAppDelegate.venues objectAtIndex:selectedVenueIndex] objectForKey:@"restaurant_tile_image"]]] placeholderImage:[UIImage imageNamed:@"transparent_box.png"]];
    
    self.iWantThisButton.titleLabel.font = [self.iWantThisButton.titleLabel.font fontWithSize:21];
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

- (void)updateViewConstraints {
    [super updateViewConstraints];
    self.specialDetailsTextViewHeightConstraint.constant =
    [UIScreen mainScreen].bounds.size.height > 480.0f ? 170 : 77;
}

@end
