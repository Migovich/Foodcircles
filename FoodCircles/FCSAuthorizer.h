//
//  FCSAuthorizer.h
//  FoodCircles
//
//  Created by David Groulx on 5/1/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCSAuthorizer : NSObject

@property (strong, nonatomic) NSString *userEmail;

- (BOOL)authorizeEmail:(NSString *)email password:(NSString *)password;

@end
