//
//  FCSInfoButton.m
//  FoodCircles
//
//  Created by Simon Gislen on 05/09/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSInfoButton.h"

@implementation FCSInfoButton
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect relativeFrame = self.bounds;
    UIEdgeInsets hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets);
    return CGRectContainsPoint(hitFrame, point);
}
@end
