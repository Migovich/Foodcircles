//
//  FCSNewsImage.m
//  FoodCircles
//
//  Created by Simon Gislen on 06/09/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSNewsImage.h"

@implementation FCSNewsImage

- (id)initWithImage: (UIImage*)image url: (NSURL*)url {
    self = [super init];
    if (self) {
        _image = image;
        _url = url;
    }
    return self;
}

+ (FCSNewsImage*)newsImageWithImage: (UIImage*)image url: (NSURL*)url {
    return [[self alloc] initWithImage:image url:url];
}
@end
