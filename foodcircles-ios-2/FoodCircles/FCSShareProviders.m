//
//  FCSShareProviders.m
//  FoodCircles
//
//  Created by Bruno Guidolim on 8/29/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSShareProviders.h"

@implementation FCSShareProviders

- (id)init {
    return [super init];
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    NSLog(@"%@", activityType);
    
    NSString *shareString = @"";
    
    if (_type == 1) {
        if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
            shareString = @"Local restaurants, $1 appetizers, 100% donated to feed hungry children.  Grab the free app. http://joinfoodcircles.org";
        } else if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
            shareString = @"Local restaurants, $1 appetizers, 100% donated to feed hungry children. Buy one, feed one. Get the @foodcircles app http://joinfoodcircles.org";
        }
    }
    
    if (_type == 2) {
        if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
            shareString = [NSString stringWithFormat:@"Fed %ld child(ren) simply by eating out. Picked out %@ via FoodCircles. http://joinfoodcircles.org",(long)_kidsFed,_restaurantName];
        } else if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
            shareString = [NSString stringWithFormat:@"Fed %ld child(ren) in need simply by eating out. Picked out %@ via @foodcircles. #bofo http://joinfoodcircles.org",(long)_kidsFed,_restaurantName];
        }
    }
    
    if (_type == 3) {
        if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
            shareString = @"Dinner plans in 60 seconds. Local restaurants, $1 appetizers, 100% donated to feed children in need. http://joinfoodcircles.org";
        } else if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
            shareString = @"Dinner plans in 60 secs. Local restaurants, $1 appetizers, 100% donated to feed children in need. #bofo @foodcircles http://joinfoodcircles.org";
        }
    }
    
    return shareString;
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return @"";
}

- (NSString*)shareStringForActivityTime:(NSString *)activityType {
    return [self activityViewController:nil itemForActivityType:activityType];
}

@end
