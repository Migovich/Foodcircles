//
//  FCSStubAdapter.m
//  FoodCircles
//
//  Created by David Groulx on 5/1/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSStubAdapter.h"
#import "FCSAppDelegate.h"
#import "FCSVenue.h"
#import "FCSSpecial.h"

@interface FCSStubAdapter ()

@property (strong) NSManagedObjectContext *moc;

@end

@implementation FCSStubAdapter

- (id)init {
  self = [super init];
  if (self) {
    self.moc = ((FCSAppDelegate *)[[UIApplication sharedApplication] delegate] ).managedObjectContext;
    [self defaults];
  }
  return self;
}

- (void)defaults {
  self.venues = @[
                  @{@"id" : @1, @"name" : @"Georgio's", @"foodType" : @"Pizza", @"image" : @"georgios",
                    @"offer" : @{@"id" : @1, @"title" : @"2 Free Desserts", @"details" : @"With purchase of at least 2 slices of pizza per person"} },
                  @{@"id" : @2, @"name" : @"Stella's", @"foodType" : @"So much whiskey", @"image" : @"stellas",
                    @"offer" : @{@"id" : @2, @"title" : @"1 free Chronic", @"details" : @"Perk does not apply on the burger special."} },
                  @{@"id" : @3, @"name" : @"HopCat", @"foodType" : @"So much beer", @"image" : @"hopcat",
                    @"offer" : @{@"id" : @3, @"title" : @"2 free appetizers", @"details" : @""} }
                  ];
}

- (BOOL)loadVenues {
  NSEntityDescription *venueEntity = [NSEntityDescription entityForName:@"Venue" inManagedObjectContext:self.moc];
  NSEntityDescription *specialEntity = [NSEntityDescription entityForName:@"Special" inManagedObjectContext:self.moc];
  
  for ( NSDictionary *venueDictionary in self.venues ) {
    FCSVenue *venue = (FCSVenue *)[[NSManagedObject alloc] initWithEntity:venueEntity insertIntoManagedObjectContext:self.moc];
    venue.id_number = [venueDictionary objectForKey:@"id"];
    venue.name = [venueDictionary objectForKey:@"name"];
    venue.foodType = [venueDictionary objectForKey:@"foodType"];
    NSString *imageFilename = [venueDictionary valueForKey:@"image"];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageFilename ofType:@"png" inDirectory:@"images"];
    venue.thumbnail = [UIImage imageWithContentsOfFile:imagePath];
    
    FCSSpecial *special = (FCSSpecial *)[[NSManagedObject alloc] initWithEntity:specialEntity insertIntoManagedObjectContext:self.moc];
    NSDictionary *offer = [venueDictionary objectForKey:@"offer"];
    special.id_number = [offer objectForKey:@"id"];
    special.title = [offer objectForKey:@"title"];
    special.details = [offer objectForKey:@"details"];
    
    venue.special = special;
  }
  
  return YES;
}

@end
