//
//  FCSTwitterButton.m
//  FoodCircles
//
//  Created by David Groulx on 5/21/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSTwitterButton.h"

const int TWITTER_BUTTON_HEIGHT = 44;

@implementation FCSTwitterButton

- (id)initWithCoder:(NSCoder *)decoder {
  self = [super initWithCoder:decoder];
  if (self) {
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:24];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleEdgeInsets = UIEdgeInsetsMake(0,-10,0,0);

    UIImage *baseImage = [UIImage imageNamed:@"Twitter_button.png"];
    UIImage *resizeableImage = [baseImage resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
    [self setBackgroundImage:resizeableImage forState:UIControlStateNormal];
    
    UIImage *icon = [UIImage imageNamed:@"twitter-icon.png"];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
    iconView.frame = CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width, (TWITTER_BUTTON_HEIGHT - icon.size.height) / 2, icon.size.width, icon.size.height);
    [self addSubview:iconView];
  }
  return self;
}

@end
