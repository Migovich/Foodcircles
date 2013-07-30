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
/*
-(FCSVenue *)initFromJson:(NSString *)json{
    self = [super init];
    
    self.id_number = [json valueForKeyPath:@"id"];
    self.name = [json valueForKeyPath:@"name"];
//    self.cuisine = [json valueForKeyPath:@"id"];
//    self.open_times = [json valueForKeyPath:@"id"];
    self.description = [json valueForKeyPath:@"description"];
    self.address = [json valueForKeyPath:@"address"];
//    self.lat = [json valueForKeyPath:@"id"];
//    self.lon = [json valueForKeyPath:@"id"];
//    self.phone_number = [json valueForKeyPath:@"id"];
    self.website_url = [json valueForKeyPath:@"web"];
//    self.facebook_url = [json valueForKeyPath:@"id"];
//    self.twitter_url = [json valueForKeyPath:@"id"];
//    self.yelp_url = [json valueForKeyPath:@"id"];
    self.specials = [json valueForKeyPath:@"id"];
//    self.offer_picture_url = [json valueForKeyPath:@"image"];
    self.venue_picture_url = [json valueForKeyPath:@"image"];
    
    return self;
}
*/
@end
