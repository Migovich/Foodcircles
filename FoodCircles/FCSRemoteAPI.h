//
//  FCSRemoteAPI.h
//  FoodCircles
//
//  Created by David Groulx on 5/1/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FCSAuthorizer.h"
#import "FCSAPIAdapter.h"

@interface FCSRemoteAPI : NSObject

@property (strong, nonatomic) id<FCSAPIAdapter> apiAdapter;
@property (strong, nonatomic) FCSAuthorizer *authorizer;

+ (FCSRemoteAPI *)sharedInstance;

- (BOOL)authorizeEmail:(NSString *)email password:(NSString *)password;

- (BOOL)loadVenues;
+ (BOOL)loadVenues;

- (NSArray *)landingImages;
+ (NSArray *)landingImages;

- (NSString *)currentUser;
@end
