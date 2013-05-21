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
    [self setThumbImage:[UIImage imageNamed:@"Slider_Knob.png"] forState:UIControlStateNormal];
//    [self setMinimumTrackTintColor:[FCSStyles darkRed]];
    [self setMinimumTrackImage:[UIImage imageNamed:@"Slider_fill.png"] forState:UIControlStateNormal];
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
