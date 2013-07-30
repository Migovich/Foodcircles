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
@property (strong, nonatomic) NSString *cuisine;
@property (strong, nonatomic) NSString *open_times;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSNumber *lat;
@property (strong, nonatomic) NSNumber *lon;
@property (strong, nonatomic) NSString *phone_number;
@property (strong, nonatomic) NSString *website_url;
@property (strong, nonatomic) NSString *facebook_url;
@property (strong, nonatomic) NSString *twitter_url;
@property (strong, nonatomic) NSString *yelp_url;
@property (strong, nonatomic) NSMutableArray *specials;
@property (strong, nonatomic) NSString *offer_picture_url;
@property (strong, nonatomic) NSString *venue_picture_url;

-(FCSVenue*) initFromJson: (NSString*) json;

@end