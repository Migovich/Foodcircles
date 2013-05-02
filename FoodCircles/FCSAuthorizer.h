//
//  FCSAuthorizer.h
//  FoodCircles
//
//  Created by David Groulx on 5/1/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCSAuthorizer : NSObject

- (BOOL)authorizeEmail:(NSString *)email password:(NSString *)password;

@end
