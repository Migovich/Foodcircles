//
//  FCSAuthorizer.m
//  FoodCircles
//
//  Created by David Groulx on 5/1/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSAuthorizer.h"

@implementation FCSAuthorizer

@synthesize userEmail;

- (id)init {
  self = [super init];
  
  if (self) {
    self.userEmail = nil;
  }
  
  return self;
}

- (BOOL)authorizeEmail:(NSString *)email password:(NSString *)password {
  self.userEmail = email;
  return YES;
}

@end
