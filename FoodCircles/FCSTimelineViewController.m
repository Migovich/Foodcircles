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
#import "OWActivityViewController.h"
#import "FCSVoucherViewController.h"

#import "FCSDrawUtilities.h"

@interface FCSTimelineViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

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
    [super viewWillAppear:animated];
    
    [HUD show:YES];
    
    NSURL *url = [NSURL URLWithString:TIMELINE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            UIAppDelegate.user_token, @"auth_token",
                            nil];
    TFLog(@"Calling TimeLine URL: %@ params: %@", url, params);
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [HUD hide:YES];
        
        TFLog(@"Timeline response: %@", [JSON JSONString]);
        
        FCSTimelineData *tl = [[FCSTimelineData alloc] init];
        _timelineData = [tl processJSON:[JSON objectForKey:@"content"]];
        if (!(_timelineData.count > 2)) {
            self.errorLabel.hidden = NO;
            self.errorLabel.textColor = [FCSStyles brownColor];
            self.errorLabel.text = NSLocalizedString(@"No purchases yet!", nil);
        }
        else {
            self.errorLabel.hidden = YES;
        }
        [_tableView reloadData];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        TFLog(@"Timeline failed: %@", [JSON JSONString]);
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IS_OS_7_OR_LATER) self.edgesForExtendedLayout = UIRectEdgeNone;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem settingsBarButtonItemWithTarget:self selector:@selector(settingsPressed:)];
    
    self.bottomLabel.text = NSLocalizedString(@"You can feed a child\nYour network can feed a classroom", nil);
}
- (void)settingsPressed: (id)sender {
    [self performSegueWithIdentifier:@"Settings" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"VoucherDetailSegue"]) {
        FCSVoucherViewController *destinationViewController = (FCSVoucherViewController *)segue.destinationViewController;
        destinationViewController.voucherContent = _voucherContent;
        destinationViewController.restaurantName = [_voucherContent objectForKey:@"restaurantName"];
        destinationViewController.offerName = [_voucherContent objectForKey:@"offerName"];
    }
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
            cell.backgroundColor = [UIColor clearColor];
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
    cell.dateLabel.textColor = [FCSStyles dateMonthTimelineTextColor];
    [cell.restaurantNameLabel setText:[timelineData.restaurantName uppercaseString]];
    
    if (timelineData.qtyFed > 1 )
        [cell.qtyChildrenLabel setText:[NSString stringWithFormat:@"%d children fed",timelineData.qtyFed]];
    else {
        [cell.qtyChildrenLabel setText:[NSString stringWithFormat:@"%d child fed",timelineData.qtyFed]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //Old logic
    /*NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
     NSDateComponents *comps = [cal components:NSDayCalendarUnit fromDate:timelineData.date toDate:[NSDate date] options:0];
     int numberOfDays = [comps day];
     
     if (numberOfDays <= 30) {
     [cell.voucherDetailButton addTarget:self action:@selector(acessoryButtonTapped:withEvent:) forControlEvents:UIControlEventTouchUpInside];
     [cell.voucherDetailButton setHidden:NO];
     } else {
     [cell.voucherDetailButton setHidden:YES];
     }
     */
    //if null or not used and not expired
    if (!timelineData.state || [timelineData.state isEqual:[NSNull null]]) {
        [cell.voucherDetailButton addTarget:self action:@selector(acessoryButtonTapped:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [cell.voucherDetailButton setHidden:NO];
    }
    else if ([timelineData.state isEqualToString:@"Expired"] || [timelineData.state isEqualToString:@"Expired"]) {
        [cell.voucherDetailButton setHidden:YES];
    }
    else {
        [cell.voucherDetailButton setHidden:YES];
    }
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[FCSTimelineTableViewCell class]]) {
        if (!((FCSTimelineTableViewCell*)cell).voucherDetailButton.hidden)
            [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    FCSTimelineData *timelineData = [_timelineData objectAtIndex:indexPath.row];
    
    _voucherContent = [NSDictionary dictionaryWithObjectsAndKeys:
                       timelineData.code,@"code",
                       [NSString stringWithFormat:@"%d",timelineData.qtyFed],@"amount",
                       [NSString stringWithFormat:@"%@",timelineData.date],@"created_at",
                       timelineData.restaurantName,@"restaurantName",
                       timelineData.offerName,@"offerName",
                       [NSString stringWithFormat:@"%d",timelineData.minumumDiners],@"num_diners",
                       nil];
    
    [self performSegueWithIdentifier:@"VoucherDetailSegue" sender:self];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - Curstom Methods
-(void)acessoryButtonTapped:(UIControl *)button withEvent:(UIEvent *)event {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:[[[event touchesForView: button] anyObject] locationInView: self.tableView]];
    
    if (indexPath == nil)
        return;
    
    [self.tableView.delegate tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
}

- (IBAction)inviteButtonTapped:(id)sender {
    FCSShareProviders *shareProviders = [[FCSShareProviders alloc] init];
    shareProviders.type = 1;
    
    OWFacebookActivity *facebookActivity = [[OWFacebookActivity alloc] init];
    facebookActivity.userInfo = @{ @"text": [shareProviders shareStringForActivityTime:UIActivityTypePostToFacebook]};
    OWTwitterActivity *twitterActivity = [[OWTwitterActivity alloc] init];
    twitterActivity.userInfo = @{ @"text": [shareProviders shareStringForActivityTime:UIActivityTypePostToTwitter]};
    OWActivityViewController *activityViewController = [[OWActivityViewController alloc] initWithViewController:self activities:@[facebookActivity, twitterActivity]];
    [activityViewController presentFromRootViewController];
}

@end
