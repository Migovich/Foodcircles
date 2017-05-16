//
//  FCSNewsImage.m
//  FoodCircles
//
//  Created by Simon Gislen on 06/09/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSNewsImage.h"

@implementation FCSNewsImage

- (id)initWithImage: (NSString*)imageUrl url: (NSString*)url {
    self = [super init];
    if (self) {
        _imageUrl = imageUrl;
        _url = url;
    }
    return self;
}

+ (FCSNewsImage*)newsImageWithImage: (NSString*)imageUrl url: (NSString*)url {
    return [[self alloc] initWithImage:imageUrl url:url];
}
@end
