//
//  FCSSlider.m
//  FoodCircles
//
//  Created by David Groulx on 5/20/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSSlider.h"

#import "FCSStyles.h"

@implementation FCSSlider

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self setThumbImage:[UIImage imageNamed:@"slider_knob.png"] forState:UIControlStateNormal];
    [self setMinimumTrackImage:[[UIImage imageNamed:@"Track-Min.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 0)] forState:UIControlStateNormal];
    [self setMaximumTrackImage:[[UIImage imageNamed:@"Track-Max.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,15)] forState:UIControlStateNormal];
  }
  return self;
}

@end
