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

//Payment
- (void)processPayment: (PayPalPayment*)payment offerId: (NSString*)offerId withCompletion: (void(^)(NSDictionary *voucherContent, NSString *error))completion;

//Images
- (void)getNewsImages: (void(^)(NSArray *images, NSString *error))completion;

@end
