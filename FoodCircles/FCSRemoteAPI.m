//
//  FCSRemoteAPI.m
//  FoodCircles
//
//  Created by David Groulx on 5/1/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSRemoteAPI.h"
#import "FCSFixtureAdapter.h"
#import "FCSStubAdapter.h"

static FCSRemoteAPI *sharedFCSRemoteAPI;

@implementation FCSRemoteAPI

+ (FCSRemoteAPI *)sharedInstance {
  if (nil != sharedFCSRemoteAPI) {
    return sharedFCSRemoteAPI;
  }
  
  static dispatch_once_t pred;        // Lock
  dispatch_once(&pred, ^{             // This code is called at most once per app
    sharedFCSRemoteAPI = [[FCSRemoteAPI alloc] init];
  });
  
  return sharedFCSRemoteAPI;
}

- (id)init
{
  self = [super init];
  
  if (self) {
    self.authorizer = [[FCSAuthorizer alloc] init];
    self.apiAdapter = [[FCSStubAdapter alloc] init];
  }
  
  return self;
}

- (BOOL)authorizeEmail:(NSString *)email password:(NSString *)password {
  return [self.authorizer authorizeEmail:email password:password];
}

- (BOOL)loadVenues {
  return [self.apiAdapter loadVenues];
}

+ (BOOL)loadVenues {
  return [[FCSRemoteAPI sharedInstance] loadVenues];
}

- (NSArray *)landingImages {
  return [self.apiAdapter landingImages];
}

+ (NSArray *)landingImages {
  return [[FCSRemoteAPI sharedInstance] landingImages];
}

- (NSString *)currentUser {
  return self.authorizer.userEmail;
}

@end
