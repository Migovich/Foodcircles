//
//  FCSHeaderLabel.m
//  FoodCircles
//
//  Created by David Groulx on 5/9/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSHeaderLabel.h"

@implementation FCSHeaderLabel

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
    if (self) {
      self.textColor = [UIColor colorWithRed:0.3046 green:0.24218 blue:0.1328 alpha:1.0];
      self.font = [UIFont systemFontOfSize:22];
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
