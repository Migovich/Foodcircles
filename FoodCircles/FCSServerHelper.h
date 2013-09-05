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
- (void)processPayment: (PayPalPayment*)payment offerId: (NSString*)offerId withCompletion: (void(^)(NSDictionary *voucherContent, NSString *error))completion;
@end
