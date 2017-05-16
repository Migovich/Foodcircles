//
//  FCSBoldShowServerLabel.m
//  FoodCircles
//
//  Created by Bruno Guidolim on 8/27/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSBoldShowServerLabel.h"

@implementation FCSBoldShowServerLabel

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont fontWithName:@"Neutraface Slab Text" size:24];
    }
    return self;
}

@end
