//
//  FCSServerHelper.m
//  FoodCircles
//
//  Created by Simon Gislen on 05/09/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSServerHelper.h"

#import "FCSAppDelegate.h"

#import "AFNetworking.h"
#import "PayPalMobile.h"
#import "constants.h"

#import "FCSNewsImage.h"

@implementation FCSServerHelper

+ (id)sharedHelper {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    return self;
}

- (void)processPayment: (PayPalPayment*)payment offerId:(NSString *)offerId withCompletion:(void (^)(NSDictionary *voucherContent, NSString *error))completion {
    
    NSDictionary *paymentDetails;
    
    //[[[[UIAppDelegate.venues objectAtIndex:_selectedVenueIndex] objectForKey:@"offers"] objectAtIndex:_selectedOffer] objectForKey:@"id"]
    
    
    if ([[[payment.confirmation objectForKey:@"proof_of_payment"] objectForKey:@"adaptive_payment"] count] > 0) {
        paymentDetails = [NSDictionary dictionaryWithObjectsAndKeys:
                          [[[payment.confirmation objectForKey:@"proof_of_payment"] objectForKey:@"adaptive_payment"] objectForKey:@"pay_key"], @"paypal_charge_token",
                          offerId, @"offer_id",
                          [[payment.confirmation objectForKey:@"payment"] objectForKey:@"amount"], @"amount",
                          nil];
    } else {
        paymentDetails = [NSDictionary dictionaryWithObjectsAndKeys:
                          [[[payment.confirmation objectForKey:@"proof_of_payment"] objectForKey:@"rest_api"] objectForKey:@"payment_id"], @"paypal_charge_token",
                          offerId, @"offer_id",
                          [[payment.confirmation objectForKey:@"payment"] objectForKey:@"amount"], @"amount",
                          nil];
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            UIAppDelegate.user_token, @"auth_token",
                            paymentDetails, @"payment",
                            nil];
    
    TFLog(@"Calling Payment URL: %@ params: %@", PAYMENT_URL_SHORT, params);
    
    [self postPath:PAYMENT_URL_SHORT parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        TFLog(@"Voucher confirmed: %@", JSON);
        completion([JSON objectForKey:@"content"], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        TFLog(@"Voucher not confirmed: %@", error);
        completion(nil, error.localizedDescription);
    }];
}

- (void)getNewsImages: (void(^)(NSArray *images, NSString *error))completion {
    
    NSDictionary *params = @{
                             UIAppDelegate.user_token: @"auth_token"
                            };
    
    [self getPath:NEWS_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //TODO: PARSE JSON
        
        NSMutableArray *images = [[NSMutableArray alloc] init];
        
        FCSNewsImage *newsImage = [FCSNewsImage newsImageWithImage:[UIImage imageNamed:@"Kids-crowd.jpg"] url:[NSURL URLWithString:@""]];
        FCSNewsImage *newsImage2 = [FCSNewsImage newsImageWithImage:[UIImage imageNamed:@"US_Navy_050106.jpg"] url:[NSURL URLWithString:@""]];
        
        
        if (completion) completion(@[newsImage, newsImage2], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) completion(nil, error.localizedDescription);
    }];
}

@end
