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
#import <QuartzCore/QuartzCore.h>

NSString *kVenueId = @"venueListViewID";

@interface FCSVenueListViewController ()

@end

@implementation FCSVenueListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Restaurants";
    
    self.collectionView.backgroundColor = [FCSStyles backgroundColor];
    
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flow.sectionInset = UIEdgeInsetsMake(10, 5, 0, 5);
    flow.minimumInteritemSpacing = 1;
    
    [self reloadOffers];

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
    [venueCell.productImage setClipsToBounds:YES];
    
    NSArray *tags = [NSArray arrayWithArray:[[UIAppDelegate.venues objectAtIndex:indexPath.row] objectForKey:@"tags"]];
    
    if (tags.count > 0) {
        venueCell.detailTextLabel.text = [[tags objectAtIndex:0] objectForKey:@"name"];
    } else {
        venueCell.detailTextLabel.text = @"";
    }
    
    NSString *miles = [[UIAppDelegate.venues objectAtIndex:indexPath.row] objectForKey:@"distance"];
    [venueCell.milesLabel setText:miles];
    
    int leftTag = [[[UIAppDelegate.venues objectAtIndex:[indexPath row]] objectForKey:@"vouchers_available"] integerValue];
    [venueCell.qtyLeftLabel setText:[NSString stringWithFormat:@"%d",leftTag]];
    
    if (leftTag == 0) {
        [venueCell.tagImageView setImage:[UIImage imageNamed:@"tag-grey.png"]];
        [venueCell setUserInteractionEnabled:NO];
        [venueCell.soldOutLabel setHidden:NO];
    } else {
        [venueCell.tagImageView setImage:[UIImage imageNamed:@"tag-blue.png"]];
        [venueCell setUserInteractionEnabled:YES];
        [venueCell.soldOutLabel setHidden:YES];
    }
    
    venueCell.contentView.layer.shadowOpacity = 0.1f;
    venueCell.contentView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    venueCell.contentView.layer.masksToBounds = NO;
    
    //Set LocalNotifications
    CLLocationCoordinate2D coords;
    coords.latitude = [[[UIAppDelegate.venues objectAtIndex:indexPath.row] objectForKey:@"lat"] floatValue];
    coords.longitude= [[[UIAppDelegate.venues objectAtIndex:indexPath.row] objectForKey:@"lon"] floatValue];
    
    NSString *restaurantName = [[UIAppDelegate.venues objectAtIndex:[indexPath row]] objectForKey:@"name"];
    NSDictionary *venue = [UIAppDelegate.venues objectAtIndex:indexPath.row];
    NSString *offerName = [[[venue objectForKey:@"offers"] objectAtIndex:0] objectForKey:@"title"];
    
    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:coords radius:5.0 identifier:[NSString stringWithFormat:@"%@|%@",restaurantName,offerName]];
    
    [UIAppDelegate.locationManager stopMonitoringForRegion:region];
    [UIAppDelegate.locationManager startMonitoringForRegion:region];
    
    return venueCell;
}

- (void)reloadOffers {
    
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
    }
    [HUD show:YES];
    
    FCSCharity *charities = [[FCSCharity alloc] init];
    [charities getCharities];
#ifdef DEBUG
    double latitude = 42.963316;
    double longitude = -85.669563;
#else
    double latitude = UIAppDelegate.locationManager.location.coordinate.latitude;
    double longitude = UIAppDelegate.locationManager.location.coordinate.longitude;
#endif
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:VENUES_URL,latitude,longitude]];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"" parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [HUD hide:YES];
        
        NSLog(@"%@",[JSON JSONString]);
        
        UIAppDelegate.venues = [JSON objectForKey:@"content"];
        UIAppDelegate.venues = [UIAppDelegate.venues sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSDictionary *d1 = obj1;
            NSDictionary *d2 = obj2;
            //TODO: This crashes if mi is used a unit... Added exception handling for now..
            @try {
                NSString *dString1 = [d1 objectForKey:@"distance"];
                //dString1 = [dString1 substringWithRange:NSMakeRange(0, [dString1 length]-6)];
                double dDouble1 = [dString1 doubleValue];
                
                NSString *dString2 = [d2 objectForKey:@"distance"];
                //dString2 = [dString2 substringWithRange:NSMakeRange(0, [dString2 length]-6)];
                double dDouble2 = [dString2 doubleValue];
                
                if (dDouble1 > dDouble2) {
                    return (NSComparisonResult)NSOrderedDescending;
                } else if (dDouble1 < dDouble2) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
            }
            @catch (NSException *e) {
                
            }
            
            return (NSComparisonResult)NSOrderedSame;
            
        }];
        
        if ([UIAppDelegate.venues count] == 0) {
            HUD.labelText = NSLocalizedString(@"No Venues found.", nil);
            HUD.mode = MBProgressHUDModeText;
            [HUD hide:YES afterDelay:3];
        } else {
            [self.collectionView reloadData];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [HUD hide:YES];
        
        TFLog(@"Error: %@", error.localizedDescription);
        NSString *errorMessage = [error localizedDescription];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }];
    
    [operation start];
}

@end
