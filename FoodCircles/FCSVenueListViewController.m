//
//  FCSVenueListViewController.m
//  FoodCircles
//
//  Created by David Groulx on 5/1/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSVenueListViewController.h"
#import "FCSAppDelegate.h"
#import "FCSVenueViewController.h"
#import "FCSVenue.h"
#import "FCSSpecial.h"
#import "FCSVenueCell.h"
#import "FCSStyles.h"
#import "ILHTTPClient.h"
#import "constants.h"
#import "JSONKit.h"
#import "UIImageView+AFNetworking.h"

NSString *kVenueId = @"venueListViewID";

@interface FCSVenueListViewController ()

@end

@implementation FCSVenueListViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
    ILHTTPClient *client = [ILHTTPClient clientWithBaseURL:@"http://foodcircles.net"
                                          showingHUDInView:self.view];

    [client getPath:@"/api/venues.json"
         parameters:nil
        loadingText:@"Loading"
        successText:nil
            success:^(AFHTTPRequestOperation *operation, NSString *response)
    {
        UIAppDelegate.venues = [response objectFromJSONString];
        [self.collectionView reloadData];
    }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
#warning message if venues dont load
        NSLog(@"Error: %@", error);
    }];
    
  
  self.collectionView.backgroundColor = [FCSStyles backgroundColor];
  
  UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
  flow.sectionInset = UIEdgeInsetsMake(10, 5, 0, 5);
  flow.minimumInteritemSpacing = 1;
  
  self.title = @"Restaurants";
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"showVenue"]) {
    NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
    FCSVenueViewController *destinationViewController = (FCSVenueViewController *)segue.destinationViewController;
    destinationViewController.selectedVenueIndex = [indexPath row];
  }
}


#pragma mark -
#pragma mark UICollectionViewDataSoure

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [UIAppDelegate.venues count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  FCSVenueCell *venueCell = [collectionView dequeueReusableCellWithReuseIdentifier:kVenueId forIndexPath:indexPath];
    venueCell.productName.text = [[[UIAppDelegate.venues objectAtIndex:[indexPath row]] objectForKey:@"name"] uppercaseString];
    
    [venueCell.productImage setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[@"http://foodcircles.net" stringByAppendingString:[[UIAppDelegate.venues objectAtIndex:[indexPath row]] objectForKey:@"image"]]]]
                          placeholderImage:[UIImage imageNamed:@"transparent_box.png"]
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                       venueCell.productImage.image = image;
                                       [venueCell setNeedsLayout];
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                       
                                   }];
    
  return venueCell;
}

@end
