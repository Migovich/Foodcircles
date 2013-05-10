//
//  FCSSecondaryCopyLabel.m
//  FoodCircles
//
//  Created by David Groulx on 5/9/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSSecondaryCopyLabel.h"

@implementation FCSSecondaryCopyLabel

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.textColor = [UIColor colorWithRed:0.539 green:0.5195 blue:0.496 alpha:1.0];
    self.font = [UIFont systemFontOfSize:12];
  }
  return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
