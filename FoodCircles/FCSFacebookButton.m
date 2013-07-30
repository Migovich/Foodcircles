//
//  FCSFacebookButton.m
//  FoodCircles
//
//  Created by David Groulx on 5/21/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSFacebookButton.h"

const int FACEBOOK_BUTTON_HEIGHT = 44;
const int PADDING_BETWEEN_TEXT_AND_FACEBOOK_ICON = 5;

@implementation FCSFacebookButton

- (id)initWithCoder:(NSCoder *)decoder {
  self = [super initWithCoder:decoder];
  
    if (self) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleEdgeInsets = UIEdgeInsetsMake(0,-10,0,0);
        
        UIImage *baseImage = [UIImage imageNamed:@"Facebook_button.png"];
        UIImage *resizeableImage = [baseImage resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
        [self setBackgroundImage:resizeableImage forState:UIControlStateNormal];
        
        UIImage *icon = [UIImage imageNamed:@"facebook-icon.png"];
        UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
        iconView.frame = CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + PADDING_BETWEEN_TEXT_AND_FACEBOOK_ICON, (FACEBOOK_BUTTON_HEIGHT - icon.size.height) / 2, icon.size.width, icon.size.height);
        [self addSubview:iconView];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView *view in self.subviews) {   // Go through all subviews
        if ([view isKindOfClass:NSClassFromString(@"UIImageView")] && view.frame.size.width < self.frame.size.width) {
            CGRect frame = view.frame;
            frame.origin.x = self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + PADDING_BETWEEN_TEXT_AND_FACEBOOK_ICON;
            view.frame = frame;
        }
    }
}

@end