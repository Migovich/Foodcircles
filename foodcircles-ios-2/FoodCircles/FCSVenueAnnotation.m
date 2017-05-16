//
//  FCSVenueAnnotation.m
//  FoodCircles
//
//  Created by David Groulx on 5/22/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSVenueAnnotation.h"
#import "FCSAppDelegate.h"

@implementation FCSVenueAnnotation

-(id)initWithVenueIndex:(NSInteger)venueIndex {
  self = [super init];
  if (self) {
      _coordinate = CLLocationCoordinate2DMake([[[UIAppDelegate.venues objectAtIndex:venueIndex] objectForKey:@"lat"] doubleValue], [[[UIAppDelegate.venues objectAtIndex:venueIndex] objectForKey:@"lon"] doubleValue]);
      _title = [[UIAppDelegate.venues objectAtIndex:venueIndex] objectForKey:@"name"];;
      _subtitle = @"";
  }

  return self;
}

@end
