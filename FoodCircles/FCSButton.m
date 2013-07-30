//
//  FCSButton.m
//  FoodCircles
//
//  Created by David Groulx on 5/9/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSButton.h"

@implementation FCSButton

- (id)initWithCoder:(NSCoder *)decoder {
  self = [super initWithCoder:decoder];
  if (self) {
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    UIImage *baseImage = [UIImage imageNamed:@"button.png"];
    UIImage *resizeableImage = [baseImage resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
    [self setBackgroundImage:resizeableImage forState:UIControlStateNormal];
  }
  return self;
}

@end
