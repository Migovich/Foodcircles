//
//  FCSHeaderLabel.m
//  FoodCircles
//
//  Created by David Groulx on 5/9/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSBoldHeaderLabel.h"
#import "FCSStyles.h"

@implementation FCSBoldHeaderLabel

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.textColor = [FCSStyles primaryTextColor];
        self.font = [UIFont fontWithName:@"NeutrafaceSlabText-Bold" size:22];

    }
    return self;
}

@end
