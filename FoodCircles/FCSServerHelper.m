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


//Use voucher
- (void)useVoucher: (NSDictionary*)voucherContent withCompletion:(void(^)(NSString *error))completion {
    NSDictionary *params = @{
                             @"auth_token": UIAppDelegate.user_token,
                             @"code": voucherContent[@"code"]
                             };
    [self getPath:DELETE_VOUCHER_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) completion(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) completion(error.localizedDescription);
    }];
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
                              @"auth_token": UIAppDelegate.user_token
                            };
    
    [self getPath:NEWS_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *images = [[NSMutableArray alloc] init];
        
        NSArray *news = [[responseObject objectForKey:@"content"] objectForKey:@"news"];
        for (NSDictionary *newsObject in news) {
            FCSNewsImage *newsImage = [FCSNewsImage newsImageWithImage:newsObject[@"mobile_image_url"] url:newsObject[@"mobile_url"]];
            //Test images
            /*if (arc4random() % 4 == 0)
                newsImage.imageUrl = @"http://blog.gettyimages.com/wp-content/uploads/2013/01/Siberian-Tiger-Running-Through-Snow-Tom-Brakefield-Getty-Images-200353826-001.jpg";
            else if (arc4random() % 4 == 1) {
                newsImage.imageUrl = @"http://l.yimg.com/bt/api/res/1.2/o1sg_vgaIuYxC_8LOiWPMw--/YXBwaWQ9eW5ld3M7Zmk9aW5zZXQ7aD02MjQ7cT04NTt3PTk1MA--/http://l.yimg.com/os/156/2012/10/23/000-Del412742-jpg_073522.jpg";
            }
            else if (arc4random() % 4 == 4) {
                newsImage.imageUrl = @"http://forbesindia.com/media/photogallery/2012/Dec/horse_flame_20121228105002_930x584.jpg";
            }
            else {
                newsImage.imageUrl = @"http://blog.gettyimages.com/wp-content/uploads/2013/01/Siberian-Tiger-Running-Through-Snow-Tom-Brakefield-Getty-Images-200353826-001.jpg";
            }
             */
            
            [images addObject:newsImage];
            
        }
        
        
        
        if (completion) completion(images, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) completion(nil, error.localizedDescription);
    }];
}

- (void)logoutWithCompletion: (void(^)())completion {
    NSDictionary *params = @{
                             @"auth_token": UIAppDelegate.user_token
                             };
    [self deletePath:LOGOUT_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) completion();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //Should there be an error if the user tries to logout?
        if (completion) completion();
    }];
}

@end
