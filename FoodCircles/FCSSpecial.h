//
//  FCSSpecial.h
//  FoodCircles
//
//  Created by David Groulx on 5/2/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <CoreData/CoreData.h>

@class FCSVenue;

@interface FCSSpecial : NSManagedObject

@property (strong, nonatomic) NSNumber *id_number;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *details;
@property (strong, nonatomic) FCSVenue *venue;

@end
