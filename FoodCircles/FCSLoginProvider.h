//
//  FCSLoginProvider.h
//  FoodCircles
//
//  Created by Bruno Guidolim on 8/19/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface FCSLoginProvider : NSObject {
    void (^_completionHandler)(BOOL success);
}

- (void) loginWithFacebook:(void(^)(BOOL))handler;
- (void) loginWithTwitter:(void(^)(BOOL))handler;
- (void) loginWithParams:(NSDictionary *)params :(void(^)(BOOL))handler;
- (void) savedLoginWithView:(UIViewController *)view segue:(NSString *)segue hud:(MBProgressHUD *)hud ;

@end
