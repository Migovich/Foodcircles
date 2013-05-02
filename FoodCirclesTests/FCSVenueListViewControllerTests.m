//
//  FCSVenueListViewControllerTests.m
//  FoodCircles
//
//  Created by David Groulx on 5/2/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSVenueListViewControllerTests.h"
#import "FCSVenueListViewController.h"
#import "FCSRemoteAPI.h"
#import "FCSStubAdapter.h"

@interface FCSVenueListViewControllerTests ()

@property FCSVenueListViewController *controller;
@property NSArray *venues;

@end

@implementation FCSVenueListViewControllerTests

- (void)setUp {
  [super setUp];
  
  UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
  _controller = [sb instantiateViewControllerWithIdentifier:@"VenueListViewController"];
  [_controller loadView];

  FCSStubAdapter *stubAdapter = [[FCSStubAdapter alloc] init];
  [[FCSRemoteAPI sharedInstance] setApiAdapter:stubAdapter];
  self.venues = stubAdapter.venues;
}

- (void)testFetchedResultsController {
  STAssertNotNil([_controller fetchedResultsController], @"Unable to create NSFetchedResultsController for the Venue list table");
}


#pragma mark -
#pragma mark - UITableViewDataSource

- (void)testNumberOfSectionsInTableView {
  UITableView *tv = [_controller tableView];
  STAssertEquals(0, [_controller numberOfSectionsInTableView:tv], @"Wrong number of sections in the table view");
}

- (void)testTableView_numberOfRowsInSection {
  UITableView *tv = [_controller tableView];
  STAssertEquals([_controller tableView:tv numberOfRowsInSection:0], (NSInteger)[self.venues count], @"Number of rows should be the same as number of records");
}

@end
