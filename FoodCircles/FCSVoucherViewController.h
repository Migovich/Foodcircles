//
//  FCSVoucherViewController.h
//  FoodCircles
//
//  Created by David Groulx on 5/10/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCSStyledViewController.h"
#import "FCSHeaderLabel.h"

@class PayPalPayment;

@interface FCSVoucherViewController : FCSStyledViewController

@property (nonatomic) PayPalPayment *completedPayment;
@property (nonatomic) NSUInteger selectedVenueIndex;
@property (nonatomic) NSUInteger selectedOffer;
@end