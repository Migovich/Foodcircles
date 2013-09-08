//
//  FCSShareProviders.h
//  FoodCircles
//
//  Created by Bruno Guidolim on 8/29/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCSShareProviders : UIActivityItemProvider

@property (assign, nonatomic) int type;
@property (assign, nonatomic) int kidsFed;
@property (strong, nonatomic) NSString *restaurantName;

- (NSString*)shareStringForActivityTime: (NSString*)activityType;

@end
