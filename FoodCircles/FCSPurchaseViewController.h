//
//  FCSPurchaseViewController.h
//  FoodCircles
//
//  Created by David Groulx on 5/6/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PayPalMobile.h"

@interface FCSPurchaseViewController : UIViewController
<PayPalPaymentDelegate>

@property (strong, nonatomic) NSString *description;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UISlider *priceSlider;

- (IBAction)buy:(id)sender;
- (IBAction)updatePrice:(UISlider *)sender;


# pragma mark -
# pragma mark PayPalPaymentDelegate

- (void)payPalPaymentDidCancel;
- (void)payPalPaymentDidComplete:(PayPalPayment *)completedPayment;
@end
