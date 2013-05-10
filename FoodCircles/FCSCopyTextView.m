//
//  FCSCopyTextField.m
//  FoodCircles
//
//  Created by David Groulx on 5/9/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSCopyTextView.h"
#import "FCSStyles.h"

@implementation FCSCopyTextView

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.textColor = [FCSStyles primaryTextColor];
  }
  return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
