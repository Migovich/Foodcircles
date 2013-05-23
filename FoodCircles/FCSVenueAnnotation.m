//
//  FCSVenueAnnotation.m
//  FoodCircles
//
//  Created by David Groulx on 5/22/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSVenueAnnotation.h"

@implementation FCSVenueAnnotation

@synthesize venue;
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

-(id)initWithVenue:(FCSVenue *)theVenue {
  self = [super init];
  if (self) {
    venue = theVenue;
    coordinate = CLLocationCoordinate2DMake([venue.lat doubleValue], [venue.lon doubleValue]);
    title = @"RestaurantName";
    subtitle = @"";
  }

  return self;
}

@end
