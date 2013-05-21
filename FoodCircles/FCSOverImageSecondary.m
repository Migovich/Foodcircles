//
//  FCSOverImageSecondary.m
//  FoodCircles
//
//  Created by David Groulx on 5/21/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSOverImageSecondary.h"

@implementation FCSOverImageSecondary

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
      self.font = [UIFont fontWithName:@"Neutraface Slab Text" size:16];
      self.textColor = [UIColor whiteColor];
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
