//
//  FCSDrawUtilities.h
//  FoodCircles
//
//  Created by Simon Gislen on 06/09/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCSDrawUtilities : NSObject

@end

@interface UIBarButtonItem (CustomImage)
+ (UIBarButtonItem*)infoBarButtonItemWithTarget: (id)target selector: (SEL)selector;
+ (UIBarButtonItem*)settingsBarButtonItemWithTarget: (id)target selector: (SEL)selector;
@end
