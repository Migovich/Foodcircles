//
//  FCSStyles.m
//  FoodCircles
//
//  Created by David Groulx on 5/10/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSStyles.h"

@implementation FCSStyles

+ (UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


+ (UIColor *)primaryTextColor {
  return [UIColor colorWithRed:0.3046 green:0.24218 blue:0.1328 alpha:1.0];
}

+ (UIColor *)backgroundColor {
  return [UIColor colorWithRed:0.9375 green:0.910156 blue:0.86718 alpha:1.0];
}

+ (UIColor *)greyBackgroundColor {
  return [UIColor colorWithRed:0.42745 green:0.431372 blue:0.443137 alpha:1.0];
}

+ (UIColor *)darkRed {
  return [UIColor colorWithRed:0.4375 green:0.1019 blue:0.1019 alpha:1.0];
}

+ (UIColor *)blueColor {
    return [UIColor colorWithRed:58.0/255.0 green:171.0/255.0 blue:239.0/255.0 alpha:1.0];
}

+ (UIColor *)brownColor {
    return [UIColor colorWithRed:78.0/255.0 green:62.0/255.0 blue:52.0/255.0 alpha:1.0];
}

+ (UIColor*)copyTextViewTextColor {
    return [self colorWithHexString:@"8a857f"];
}
+ (UIColor*)dateMonthTimelineTextColor {
    return [self colorWithHexString:@"bfbab4"];
}

@end
