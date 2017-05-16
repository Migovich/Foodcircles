//
//  FCSRestaurantInfoName.m
//  FoodCircles
//
//  Created by David Groulx on 5/21/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSRestaurantInfoName.h"

#import "FCSStyles.h"

@implementation FCSRestaurantInfoName

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.textColor = [FCSStyles primaryTextColor];
    self.font = [UIFont fontWithName:@"Neutraface Slab Text" size:22];
  }
  return self;
}

@end
