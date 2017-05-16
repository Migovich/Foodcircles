//
//  FCSDefaultSHKConfigurator.m
//  FoodCircles
//
//  Created by Simon Gislen on 07/09/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSDefaultSHKConfigurator.h"

@implementation FCSDefaultSHKConfigurator

- (NSString*)appName {
	return @"Food Circles";
}

- (NSString*)appURL {
	return @"http://foodcircles.net";
}

- (NSString*)twitterConsumerKey {
	return @"XmAxvWUI8aFgI7Q11iTfCw";
}

- (NSString*)twitterSecret {
	return @"ipOQjEZ876e0qWexIQLKOV99T11NPC9LBcMEzCZ4";
}
// You need to set this if using OAuth, see note above (xAuth users can skip it)
- (NSString*)twitterCallbackUrl {
	return @"http://foodcircles.net";
}

- (NSString*)facebookAppId {
	return @"526839707387980";
}
- (NSNumber*)forcePreIOS6FacebookPosting {
	return [NSNumber numberWithBool:true];
}
- (NSNumber*)forcePreIOS5TwitterAccess {
	return [NSNumber numberWithBool:true];
}

@end
