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
//    self.layer.shadowRadius = 20.0f;
    self.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    self.layer.masksToBounds = NO;
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
