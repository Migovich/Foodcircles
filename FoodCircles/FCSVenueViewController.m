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

#import "FCSDrawUtilities.h"
#import <QuartzCore/QuartzCore.h>
#import "FCSStyles.h"


@interface FCSVenueViewController ()

@property (weak, nonatomic) IBOutlet UILabel *specialNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *specialDetailsTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *iWantThisButton;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImage;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;


@end

@implementation FCSVenueViewController

@synthesize selectedVenueIndex;


- (void)viewDidLoad
{
  [super viewDidLoad];
    
    self.title = [[UIAppDelegate.venues objectAtIndex:selectedVenueIndex] objectForKey:@"name"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem infoBarButtonItemWithTarget:self selector:@selector(infoPressed:)];
    
    NSDictionary *venueOffer = [[[UIAppDelegate.venues objectAtIndex:selectedVenueIndex] objectForKey:@"offers"] objectAtIndex:0];
    
    self.specialNameLabel.text = venueOffer[@"title"];
    
    //Set detail text line spacing...
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
    
    //Prices
    self.priceLabel.font = [UIFont fontWithName:@"NeutrafaceSlabText-Book" size:46];
    self.oldPriceLabel.font = [UIFont fontWithName:@"NeutrafaceSlabText-Book" size:25];
    
    self.priceLabel.text = [NSString stringWithFormat:@"$%@", venueOffer[@"price"]];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"$%@", venueOffer[@"original_price"]];
    
    CGSize textSize = [self.oldPriceLabel.text sizeWithFont:self.oldPriceLabel.font];
    //Draw a diagonal line over the old price
    UIBezierPath *diagonalPath = [UIBezierPath bezierPath];
    [diagonalPath moveToPoint:CGPointMake(textSize.width + 4, 10)];
    [diagonalPath addLineToPoint:CGPointMake(0, 22)];
    CAShapeLayer *diagonalShapeLayer = [CAShapeLayer layer];
    diagonalShapeLayer.path = [diagonalPath CGPath];
    diagonalShapeLayer.strokeColor = [[FCSStyles darkRed] CGColor];
    diagonalShapeLayer.opacity = 0.8;
    diagonalShapeLayer.lineWidth = 3.0;
    diagonalShapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [self.oldPriceLabel.layer addSublayer:diagonalShapeLayer];
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

- (void)infoPressed: (id)sender {
    [self performSegueWithIdentifier:@"showRestaurantDetails" sender:nil];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    CGFloat textHeight = [self.specialDetailsTextView.text sizeWithFont:self.specialDetailsTextView.font constrainedToSize:CGSizeMake(280, MAXFLOAT)].height;
    NSUInteger spacing = 10;
    self.detailTextViewHeightConstraint.constant = textHeight + spacing;
}

@end
