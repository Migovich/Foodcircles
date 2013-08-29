//
//  FCSTimelineViewController.m
//  FoodCircles
//
//  Created by David Groulx on 5/22/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSTimelineViewController.h"
#import "FCSTimelineTableViewCell.h"
#import "FCSTimelineMonthCell.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "JSONKit.h"
#import "constants.h"
#import "FCSStyles.h"
#import "FCSTimelineData.h"
#import "FCSAppDelegate.h"
#import "FCSShareProviders.h"

@interface FCSTimelineViewController ()

@end

@implementation FCSTimelineViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    // Custom initialization
      _tableView.delegate = self;
      _tableView.dataSource = self;
  }
  return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [HUD show:YES];
    NSURL *url = [NSURL URLWithString:TIMELINE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            UIAppDelegate.user_token, @"auth_token",
                            nil];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [HUD hide:YES];
                                                                                            
                                                                                            NSLog(@"%@",[JSON JSONString]);
                                                                                            
                                                                                            FCSTimelineData *tl = [[FCSTimelineData alloc] init];
                                                                                            _timelineData = [tl processJSON:[JSON objectForKey:@"content"]];
                                                                                            
                                                                                            [_tableView reloadData];
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [HUD hide:YES];
                                                                                            
                                                                                            #warning message if timeline dont load
                                                                                            NSLog(@"Error: %@", error);
                                                                                            
                                                                                        }];
    
    [operation start];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_timelineData count];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    FCSTimelineData *timelineData = [_timelineData objectAtIndex:indexPath.row];
    
    if (timelineData.type == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TotalCell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TotalCell"];
        }
        
        [cell.textLabel setTextAlignment:NSTextAlignmentRight];
        [cell.textLabel setTextColor:[FCSStyles primaryTextColor]];
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Kids Fed %d",timelineData.total]];
        [text addAttribute:NSForegroundColorAttributeName value:[FCSStyles blueColor] range:NSMakeRange(9, [text length]-9)];
        [cell.textLabel setAttributedText: text];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
        return cell;
    }
    
    if (timelineData.type == 1) {
        FCSTimelineMonthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonthCell"];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FCSTimelineMonthCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        [cell.yearLabel setText:timelineData.year];
        [cell.monthLabel setText:timelineData.month];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    FCSTimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimelineCell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FCSTimelineTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell.qtyChildrenLabel setTextColor:[FCSStyles blueColor]];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd"];

    [cell.dateLabel setText:[formatter stringFromDate:timelineData.date]];
    [cell.restaurantNameLabel setText:timelineData.restaurantName];
    
    if (timelineData.qtyFed > 1 )
        [cell.qtyChildrenLabel setText:[NSString stringWithFormat:@"%d children fed",timelineData.qtyFed]];
    else {
        [cell.qtyChildrenLabel setText:[NSString stringWithFormat:@"%d child fed",timelineData.qtyFed]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


- (IBAction)inviteButtonTapped:(id)sender {
    FCSShareProviders *shareProviders = [[FCSShareProviders alloc] init];
    shareProviders.type = 3;
    NSURL *shareUrl = [NSURL URLWithString:@"http://joinfoodcircles.org/"];
    
    NSArray *itemsToShare = @[shareProviders,shareUrl];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePostToWeibo];
    
    [self presentViewController:activityVC animated:YES completion:nil];
}
@end
