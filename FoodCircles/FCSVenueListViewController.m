//
//  FCSVenueListViewController.m
//  FoodCircles
//
//  Created by David Groulx on 5/1/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSVenueListViewController.h"

#import "FCSRemoteAPI.h"
#import "FCSAppDelegate.h"

@interface FCSVenueListViewController ()

@end

@implementation FCSVenueListViewController

@synthesize fetchedResultsController;


- (void)viewDidLoad
{
  NSLog(@"venue list view did load");
  [super viewDidLoad];
  [FCSRemoteAPI loadVenues];
  
  NSError *e;
  [self.fetchedResultsController performFetch:&e];
  NSLog(@"Fetched Objects: %@", self.fetchedResultsController.fetchedObjects);
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  NSLog(@"number of sections in table view");
  return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSLog(@"table view number of rows in section");
  NSArray *sections = [self.fetchedResultsController sections];
  id<NSFetchedResultsSectionInfo> sectionInfo = nil;
  sectionInfo = [sections objectAtIndex:section];
 return sectionInfo.numberOfObjects;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"tableview cellforrowatindexpath");
  
  UITableViewCell *cell = nil;
  NSManagedObject *venue = nil;
  venue = [[self fetchedResultsController] objectAtIndexPath:indexPath];
  cell = [tableView dequeueReusableCellWithIdentifier:@"VenueTableCell"];
  [[cell textLabel] setText:[venue valueForKey:@"name"]];
  return cell;
}


#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate

- (NSFetchedResultsController *)fetchedResultsController {
  // Set up the fetched results controller if needed.
  if (fetchedResultsController == nil) {
    NSManagedObjectContext *managedObjectContext = ( (FCSAppDelegate *)[UIApplication sharedApplication].delegate ).managedObjectContext;
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Venue"];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
  }
	
	return fetchedResultsController;
}

@end
