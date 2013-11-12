//
//  FCSServerHelper.h
//  FoodCircles
//
//  Created by Simon Gislen on 05/09/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "AFHTTPClient.h"
@class PayPalPayment;
@interface FCSServerHelper : AFHTTPClient
+ (id)sharedHelper;

//Use voucher
- (void)useVoucher: (NSDictionary *)voucherContent withCompletion:(void(^)(NSString *error))completion;
//Payment
- (void)processPayment: (PayPalPayment *)payment offerId: (NSString *)offerId charityId: (NSString *)charityId withCompletion: (void(^)(NSDictionary *voucherContent, NSString *error))completion;

//Images
- (void)getNewsImages: (void(^)(NSArray *images, NSString *error))completion;

//Logout
- (void)logoutWithCompletion: (void(^)())completion;
@end
