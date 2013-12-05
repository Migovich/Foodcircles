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
#import "MBProgressHUD.h"

@class MBProgressHUD;

@interface FCSPurchaseViewController : FCSStyledViewController <PayPalPaymentDelegate> {
    MBProgressHUD *HUD;
}

@property int selectedVenueIndex;
@property int pickerType;
@property int selectedOffer;
@property int selectedCharity;
@property (strong, nonatomic) NSDictionary *voucherContent;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mealsProvidedLabel;
@property (weak, nonatomic) IBOutlet UISlider *priceSlider;
@property (weak, nonatomic) IBOutlet UILabel *localCharityLabel;
@property (weak, nonatomic) IBOutlet UILabel *internationalCharityLabel;
@property (weak, nonatomic) IBOutlet UISwitch *charitySelectorSwitch;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIButton *offerButton;
@property (weak, nonatomic) IBOutlet UIButton *charityButton;
@property (weak, nonatomic) IBOutlet UILabel *minPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *medPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxPriceLabel;

- (IBAction)buy:(id)sender;
- (IBAction)updatePrice:(UISlider *)sender;
- (IBAction)donationChanged:(UISwitch *)sender;
- (IBAction)selectOffer:(id)sender;
- (IBAction)selectCharity:(id)sender;
- (void)update:(int)value;

@end
