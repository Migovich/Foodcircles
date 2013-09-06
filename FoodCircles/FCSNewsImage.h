//
//  FCSNewsImage.h
//  FoodCircles
//
//  Created by Simon Gislen on 06/09/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCSNewsImage : NSObject
@property (nonatomic) UIImage *image;
@property (nonatomic) NSURL *url;

//for later...
@property (nonatomic) NSString *venueId;

+ (FCSNewsImage*)newsImageWithImage: (UIImage*)image url: (NSURL*)url;

@end
