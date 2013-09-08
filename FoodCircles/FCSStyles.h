//
//  FCSStyles.h
//  FoodCircles
//
//  Created by David Groulx on 5/10/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCSStyles : NSObject

+ (UIColor *)primaryTextColor;
+ (UIColor *)backgroundColor;
+ (UIColor *)greyBackgroundColor;
+ (UIColor *)darkRed;
+ (UIColor *)blueColor;
+ (UIColor *)brownColor; //#4e3e34

+ (UIColor*)colorWithHexString:(NSString*)hex;
+ (UIColor*)copyTextViewTextColor;
+ (UIColor*)dateMonthTimelineTextColor;
@end
