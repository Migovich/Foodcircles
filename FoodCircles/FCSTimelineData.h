//
//  FCSTimelineData.h
//  FoodCircles
//
//  Created by Bruno Guidolim on 8/22/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"

@interface FCSTimelineData : NSObject

@property (assign, nonatomic) int type;
@property (assign, nonatomic) int total;
@property (assign, nonatomic) int dataType;
@property (strong, nonatomic) NSString *year;
@property (strong, nonatomic) NSString *month;
@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) int qtyFed;
@property (strong, nonatomic) NSString *restaurantName;

-(NSArray *)processJSON:(id)JSON;

@end
