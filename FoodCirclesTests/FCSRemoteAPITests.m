//
//  FCSRemoteAPITests.m
//  FoodCircles
//
//  Created by David Groulx on 5/1/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSRemoteAPITests.h"
#import "FCSRemoteAPI.h"

@implementation FCSRemoteAPITests

- (void)testSingletonBehavior {
  FCSRemoteAPI *remote = [FCSRemoteAPI sharedInstance];
  STAssertEqualObjects(remote, [FCSRemoteAPI sharedInstance], @"+sharedIntance should always return the same object");
}

@end
