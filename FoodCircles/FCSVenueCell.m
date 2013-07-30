//
//  FCSVenueCell.m
//  FoodCircles
//
//  Created by David Groulx on 5/10/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSVenueCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation FCSVenueCell

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    self.layer.masksToBounds = NO;
  }
  return self;
}

@end
