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

typedef enum {
    VoucherViewTypeTimeline,
    VoucherViewTypePayment,
} VoucherViewType;

@interface FCSVoucherViewController : FCSStyledViewController


@property (nonatomic) VoucherViewType viewType;

//For payments
@property (nonatomic) PayPalPayment *completedPayment;
@property (nonatomic) NSUInteger selectedVenueIndex;
@property (nonatomic) NSUInteger selectedOffer;
@property (nonatomic) NSUInteger selectedCharity;
@property (nonatomic) NSInteger numberOfDiners;

//For coming from timeline
@property (strong, nonatomic) NSDictionary *voucherContent;
@property (strong, nonatomic) NSString *offerName;
@property (strong, nonatomic) NSString *restaurantName;

@end