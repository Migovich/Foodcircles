//
//  FCSAppDelegate.h
//  FoodCircles
//
//  Created by David Groulx on 5/1/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIAppDelegate ((FCSAppDelegate *)[UIApplication sharedApplication].delegate)

@interface FCSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *user_email;
@property (strong, nonatomic) NSString *user_token;
@property (strong, nonatomic) NSArray *venues;

@end