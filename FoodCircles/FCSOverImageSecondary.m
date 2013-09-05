//
//  FCSOverImageSecondary.m
//  FoodCircles
//
//  Created by David Groulx on 5/21/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSOverImageSecondary.h"

@implementation FCSOverImageSecondary

- (void)awakeFromNib {
    UIFont *font = [UIFont fontWithName:@"NeutrafaceSlabText-BoldItalic" size:14];
    self.font = font;
    self.textColor = [UIColor whiteColor];
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
