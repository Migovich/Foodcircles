//
//  FCSRestaurantListTitle.m
//  FoodCircles
//
//  Created by David Groulx on 5/21/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSRestaurantListTitle.h"
#import "FCSStyles.h"

@implementation FCSRestaurantListTitle

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
      self.textColor = [FCSStyles brownColor];
      self.font = [UIFont fontWithName:@"NeutrafaceSlabText-Bold" size:15];
  }
  return self;
}

@end
