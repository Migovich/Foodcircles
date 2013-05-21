//
//  FCSHeaderLabel.m
//  FoodCircles
//
//  Created by David Groulx on 5/9/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSHeaderLabel.h"
#import "FCSStyles.h"

@implementation FCSHeaderLabel

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.textColor = [FCSStyles primaryTextColor];
    self.font = [UIFont systemFontOfSize:22];
  }
  return self;
}

@end
