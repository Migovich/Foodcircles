//
//  FCSRestaurantListTitle.m
//  FoodCircles
//
//  Created by David Groulx on 5/21/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSRestaurantListTitle.h"

@implementation FCSRestaurantListTitle

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.textColor = [UIColor blackColor];
    self.font = [UIFont fontWithName:@"Neutraface Slab Text" size:17];
  }
  return self;
}

@end
