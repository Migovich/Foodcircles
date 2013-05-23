//
//  FCSVenue.h
//  FoodCircles
//
//  Created by David Groulx on 5/2/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <CoreData/CoreData.h>

@class FCSSpecial;

@interface FCSVenue : NSManagedObject

@property (strong, nonatomic) NSNumber *id_number;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *foodType;
@property (strong, nonatomic) UIImage *thumbnail;
@property (strong, nonatomic) FCSSpecial *special;
@property (strong, nonatomic) NSNumber *lat;
@property (strong, nonatomic) NSNumber *lon;

@end
