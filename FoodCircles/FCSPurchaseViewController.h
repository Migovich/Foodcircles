//
//  FCSPurchaseViewController.h
//  FoodCircles
//
//  Created by David Groulx on 5/6/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FCSSpecial.h"
#import "FCSStyledViewController.h"
#import "PayPalMobile.h"

@interface FCSPurchaseViewController : FCSStyledViewController <PayPalPaymentDelegate>

@property int selectedVenueIndex;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mealsProvidedLabel;
@property (weak, nonatomic) IBOutlet UISlider *priceSlider;
@property (weak, nonatomic) IBOutlet UILabel *localCharityLabel;
@property (weak, nonatomic) IBOutlet UILabel *internationalCharityLabel;
@property (weak, nonatomic) IBOutlet UISwitch *charitySelectorSwitch;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

- (IBAction)buy:(id)sender;
- (IBAction)updatePrice:(UISlider *)sender;
- (IBAction)donationChanged:(UISwitch *)sender;

@end
