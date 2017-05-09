//
//  FCSDrawUtilities.m
//  FoodCircles
//
//  Created by Simon Gislen on 06/09/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSDrawUtilities.h"
#import "constants.h"

@implementation FCSDrawUtilities

@end

@implementation UIBarButtonItem (CustomImage)
+ (UIBarButtonItem*)infoBarButtonItemWithTarget: (id)target selector: (SEL)selector {
    if (IS_OS_7_OR_LATER) {
        UIImage *infoImage = [UIImage imageNamed:@"info_button_ios7"];
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:infoImage style:UIBarButtonItemStylePlain target:target action:selector];
        return buttonItem;
    } else {
        UIImage *infoImage = [UIImage imageNamed:@"info_button"];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, infoImage.size.width, infoImage.size.height)];
        [button setBackgroundImage:infoImage forState:UIControlStateNormal];
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        
        return [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}
+ (UIBarButtonItem*)settingsBarButtonItemWithTarget: (id)target selector: (SEL)selector {
    if (IS_OS_7_OR_LATER) {
        UIImage *infoImage = [UIImage imageNamed:@"gear_button_ios7"];
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:infoImage style:UIBarButtonItemStylePlain target:target action:selector];
        return buttonItem;
    } else {
        UIImage *infoImage = [UIImage imageNamed:@"gear_button"];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, infoImage.size.width, infoImage.size.height)];
        [button setBackgroundImage:infoImage forState:UIControlStateNormal];
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        return [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}
@end
