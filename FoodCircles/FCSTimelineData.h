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
@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) NSString *year;
@property (strong, nonatomic) NSString *month;

-(NSArray *)processJSON:(id)JSON;

@end
