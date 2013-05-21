//
//  FCSWebsiteButton.m
//  FoodCircles
//
//  Created by David Groulx on 5/21/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSWebsiteButton.h"

@implementation FCSWebsiteButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage *baseImage = [UIImage imageNamed:@"contact_button.png"];
    UIImage *resizeableImage = [baseImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self setBackgroundImage:resizeableImage forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
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
