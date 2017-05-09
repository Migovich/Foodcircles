//
//  FCSAppDelegate.h
//  FoodCircles
//
//  Created by David Groulx on 5/1/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>

#define UIAppDelegate ((FCSAppDelegate *)[UIApplication sharedApplication].delegate)

@interface FCSAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *user_email;
@property (strong, nonatomic) NSString *user_token;
@property (strong, nonatomic) NSString *user_uid;
@property (strong, nonatomic) NSArray *venues;
@property (strong, nonatomic) NSArray *charities;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) UNMutableNotificationContent *localNotification;

-(void)setNotification;

@end

@interface UINavigationController (StatusBarStyle)

@end
