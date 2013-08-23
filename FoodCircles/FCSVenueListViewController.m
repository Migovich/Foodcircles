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
#import "AFJSONRequestOperation.h"
#import "FCSCharity.h"

NSString *kVenueId = @"venueListViewID";

@interface FCSVenueListViewController ()

@end

@implementation FCSVenueListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
    
    #warning set a better place
    FCSCharity *charities = [[FCSCharity alloc] init];
    [charities getCharities];
    
    #warning Mock data
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:VENUES_URL,@"42.962924",@"-85.669713"]];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"" parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [HUD hide:YES];
                                                                                            
                                                                                            NSLog(@"%@",[JSON JSONString]);
                                                                                            
                                                                                            UIAppDelegate.venues = [JSON objectForKey:@"content"];
                                                            
                                                                                            [self.collectionView reloadData];
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [HUD hide:YES];
                                                                                            
                                                                                            #warning message if venues dont load
                                                                                            NSLog(@"Error: %@", error);
                                                                                            
                                                                                        }];
    
    [operation start];
    
    self.collectionView.backgroundColor = [FCSStyles backgroundColor];
    
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flow.sectionInset = UIEdgeInsetsMake(10, 5, 0, 5);
    flow.minimumInteritemSpacing = 1;
    
    self.title = @"Restaurants";
    
    /*
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
     */
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
    [venueCell.productImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,[[UIAppDelegate.venues objectAtIndex:indexPath.row] objectForKey:@"timeline_image"]]] placeholderImage:[UIImage imageNamed:@"transparent_box.png"]];

    NSArray *tags = [NSArray arrayWithArray:[[UIAppDelegate.venues objectAtIndex:indexPath.row] objectForKey:@"tags"]];
    
    if (tags.count > 0) {
        venueCell.detailTextLabel.text = [[tags objectAtIndex:0] objectForKey:@"name"];
    } else {
        venueCell.detailTextLabel.text = @"";
    }
    
  return venueCell;
}

@end
