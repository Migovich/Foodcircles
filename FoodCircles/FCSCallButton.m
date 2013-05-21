//
//  FCSCallButton.m
//  FoodCircles
//
//  Created by David Groulx on 5/21/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSCallButton.h"

@implementation FCSCallButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage *baseImage = [UIImage imageNamed:@"contact_button.png"];
    UIImage *resizeableImage = [baseImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self setBackgroundImage:resizeableImage forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
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
