//
//  FCSStubAdapter.m
//  FoodCircles
//
//  Created by David Groulx on 5/1/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSStubAdapter.h"
#import "FCSAppDelegate.h"

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
                  @{@"id" : @1, @"name" : @"Bartertown"},
                  @{@"id" : @2, @"name" : @"Stella's"},
                  @{@"id" : @3, @"name" : @"HopCat"}
                  ];
}

- (BOOL)loadVenues {
  NSEntityDescription *venueEntity = [NSEntityDescription entityForName:@"Venue" inManagedObjectContext:self.moc];
  for ( NSDictionary *venue in self.venues ) {
    NSManagedObject *mo = [[NSManagedObject alloc] initWithEntity:venueEntity insertIntoManagedObjectContext:self.moc];
    [mo setValue:[venue objectForKey:@"id"] forKey:@"id"];
    [mo setValue:[venue objectForKey:@"name"] forKey:@"name"];
  }
  return YES;
}

@end
