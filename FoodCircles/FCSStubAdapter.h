//
//  FCSStubAdapter.h
//  FoodCircles
//
//  Created by David Groulx on 5/1/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "FCSAPIAdapter.h"

@interface FCSStubAdapter : NSObject
<FCSAPIAdapter>

@property (strong, nonatomic) NSArray *venues;

- (void)defaults;

- (BOOL)loadVenues;

@end
