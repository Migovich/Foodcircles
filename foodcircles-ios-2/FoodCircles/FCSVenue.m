//
//  FCSVenue.m
//  FoodCircles
//
//  Created by David Groulx on 5/2/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSVenue.h"
#import "JSONKit.h"

@implementation FCSVenue

@synthesize id_number;
@synthesize name;
@synthesize cuisine;
@synthesize open_times;
@synthesize description;
@synthesize address;
@synthesize lat;
@synthesize lon;
@synthesize phone_number;
@synthesize website_url;
@synthesize facebook_url;
@synthesize twitter_url;
@synthesize yelp_url;
@synthesize specials;
@synthesize offer_picture_url;
@synthesize venue_picture_url;

+(NSArray *)parseVenuesFromJson:(NSString *)json{
    return [json objectFromJSONString];
}
@end
