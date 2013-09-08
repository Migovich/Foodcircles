//
//  FCSAppDelegate.m
//  FoodCircles
//
//  Created by David Groulx on 5/1/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSAppDelegate.h"
#import <Parse/Parse.h>
#import "TestFlight.h"

#import "SHKConfiguration.h"
#import "FCSDefaultSHKConfigurator.h"
#import "SHKFacebook.h"

#define kLastNotificationDateKey @"kLastNotificationDate"

@implementation FCSAppDelegate

@synthesize user_email;
@synthesize user_token;
@synthesize venues;
@synthesize charities;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [TestFlight takeOff:@"f70b7a5b-4c79-4d6b-841c-a4b6a61a3ba6"];
    
    [Parse setApplicationId:@"kOy6fgxIymc6fp3Z6FaYdkTaMy6F41hYX3SgAltZ"
                  clientKey:@"dq206qPaYrhf2WnFOeuA4n1gTDvKIa3PFLQ7qt3i"];
    
    [PFTwitterUtils initializeWithConsumerKey:@"XmAxvWUI8aFgI7QlliTfCw"
                               consumerSecret:@"ipOQjEZ876e0qWexIOLKOV99TllNPC9LBcMEzCZ4"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    DefaultSHKConfigurator *configurator = [[FCSDefaultSHKConfigurator alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
    //Set the last notified date to a week back, the first the time app starts...
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [NSDate date];
    NSDateComponents *comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    NSDate *today = [calendar dateFromComponents:comps];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-8];
    NSDate *lastWeek = [calendar dateByAddingComponents:components toDate:today options:0];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{kLastNotificationDateKey: lastWeek}];
    
    //UI Defaults
    UIImage *backButton = [[UIImage imageNamed:@"back-arrow"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 10)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage *barButton = [[UIImage imageNamed:@"square_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
    [[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    [self setNotification];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSString* scheme = [url scheme];
    
    if ([scheme hasPrefix:[NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)]]) {
        [SHKFacebook handleOpenURL:url];
    }
    
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [SHKFacebook handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Saves changes in the application's managed object context before the application terminates.
    [SHKFacebook handleWillTerminate];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    NSLog(@"%@",region.identifier);
    
    NSDate *lastNotifiedDate = [[NSUserDefaults standardUserDefaults] objectForKey:kLastNotificationDateKey];
    NSDate *currentDate = [NSDate date];
    
    if ([currentDate timeIntervalSinceDate:lastNotifiedDate] >= 60*60*24*7) {
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        
        NSArray *strings = [region.identifier componentsSeparatedByString: @"|"];
        
        if ([strings count] > 1) {
            notification.alertBody = [NSString stringWithFormat:@"You're near %@! \rGrab %@ for a buck!",[strings objectAtIndex:0],[strings objectAtIndex:1]];
            notification.alertAction = @"View details";
            notification.soundName = UILocalNotificationDefaultSoundName;
            notification.applicationIconBadgeNumber = 1;
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastNotificationDateKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

-(void)setNotification {
    NSArray *messages = [[NSArray alloc] initWithObjects:
                         @"Dinner plans in 60secs. \rBuy a meal, feed a child in need.",
                         @"Your hunger can feed a child in need. \rGrab food w/ our app to provide food to local kids in need.",
                         @"You're hungry. They're hungry. You both can eat. \rBuy One, Feed One tonight.",
                         @"Hungry? Your appetizer, drink or dessert is on us. \rFeed a child in need through our app, and get specials all around town.",
                         @"Share a warm meal with friends! \rEnjoy free appetizers for $1 and provide food to a local child in need.",
                         @"Solve the hunger of others just by solving your own. \rBuy One, Feed One specials tonight.",
                         @"'I don't know, what do you want to eat?' \rKnow what to say. Check the latest 'Buy One, Feed One' specials.",
                         @"Need something to do w/ friends? \rStart a conversation over a 'Buy One, Feed One' special tonight.",
                         @"Solve dinner plans & help a local child eat. \rDecide through our app to provide a free meal to a child in need.",
                         nil];
    
    NSDate *date = [NSDate date];
    date = [date dateByAddingTimeInterval:60*60*24*7];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertAction = @"View details";
    int i = arc4random() % [messages count];
    localNotification.alertBody = [NSString stringWithFormat:@"%@",[messages objectAtIndex:i]];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = -1;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    [comps setHour:16];
    [comps setMinute:0];
    date = [calendar dateFromComponents:comps];
    localNotification.fireDate = date;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
