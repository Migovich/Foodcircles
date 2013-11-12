//
//  FCSVoucherViewController.m
//  FoodCircles
//
//  Created by David Groulx on 5/10/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSVoucherViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FCSStyles.h"
#import "FCSShareProviders.h"

#import "FCSServerHelper.h"
#import "FCSAppDelegate.h"

#import "OWActivityViewController.h"
#import "MBProgressHUD.h"

@interface FCSVoucherViewController () <UIActionSheetDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet FCSHeaderLabel *offerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *voucherNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *kidsFedLabel;
@property (weak, nonatomic) IBOutlet UILabel *minGroupDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *yourCodeLabel;

@property (weak, nonatomic) IBOutlet UIView *receiptView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *accountButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic) MBProgressHUD *hud;

- (void)updateViewWithVoucherContent;
@end

@implementation FCSVoucherViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.receiptView.layer.shadowOpacity = 0.4f;
    self.receiptView.layer.shadowColor = [[UIColor colorWithRed:109.0/255.0 green:109.0/255.0 blue:109.0/255.0 alpha:1.0] CGColor];
    self.receiptView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    
    if (self.viewType == VoucherViewTypePayment) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Timeline", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(accountButtonClicked:)];
        self.offerName = [[[[UIAppDelegate.venues objectAtIndex:_selectedVenueIndex] objectForKey:@"offers"] objectAtIndex:_selectedOffer] objectForKey:@"title"];
        self.restaurantName = [[UIAppDelegate.venues objectAtIndex:_selectedVenueIndex] objectForKey:@"name"];
        self.voucherNumberLabel.text = @"";
        self.minGroupDateLabel.text = @"";
        self.kidsFedLabel.text = @"";
        [self.spinner startAnimating];
    }
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [self.hud hide:NO];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    
    self.restaurantNameLabel.text = self.restaurantName;
    self.offerNameLabel.text = self.offerName;
    
    if (self.viewType == VoucherViewTypeTimeline) {
        [self updateViewWithVoucherContent];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
     NSString *offerId = [[[[UIAppDelegate.venues objectAtIndex:_selectedVenueIndex] objectForKey:@"offers"] objectAtIndex:_selectedOffer] objectForKey:@"id"];
    NSString *charityId = [UIAppDelegate.charities objectAtIndex:self.selectedCharity][@"id"];
    
    if (self.viewType == VoucherViewTypePayment) {
        [[FCSServerHelper sharedHelper] processPayment:self.completedPayment offerId:offerId charityId:charityId withCompletion:^(NSDictionary *voucherContent, NSString *error) {
            
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error!", nil) message:error delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [self.spinner stopAnimating];
                self.voucherContent = voucherContent;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateViewWithVoucherContent];
                });
            }
            
        }];
    }
}

- (void)updateViewWithVoucherContent {
    NSLog(@"Voucher Content %@", self.voucherContent);
    self.voucherNumberLabel.text = [self.voucherContent objectForKey:@"code"];
    
    int amount = [[self.voucherContent objectForKey:@"amount"] integerValue];
    NSString *donatedText = [NSString stringWithFormat:@"$%d donated",amount];
    NSString *kidsfedText = [NSString stringWithFormat:(amount > 1?@"(%d kids fed)":@"(%d kid fed)"),amount];
    
    NSString *text = [NSString stringWithFormat:@"%@ %@",donatedText,kidsfedText];
    
    NSDictionary *attribs = @{NSForegroundColorAttributeName: self.kidsFedLabel.textColor,
                              NSFontAttributeName: self.kidsFedLabel.font,
                              };
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
    NSRange donatedTextRange = [text rangeOfString:donatedText];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:self.kidsFedLabel.font.pointSize];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:78.0/255.0 green:62.0/255.0 blue:52.0/255.0 alpha:1.0],NSFontAttributeName:boldFont} range:donatedTextRange];
    
    NSRange kidsfedTextRange = [text rangeOfString:kidsfedText];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.539 green:0.5195 blue:0.496 alpha:1.0]} range:kidsfedTextRange];
    
    self.kidsFedLabel.attributedText = attributedText;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [[self.voucherContent objectForKey:@"created_at"] substringToIndex:10];
    NSDate *date = [formatter dateFromString:dateStr];
    date = [date dateByAddingTimeInterval:60*60*24*30];
    [formatter setDateFormat:@"MM/dd/yy"];
    
    //Use server's value if available, else use local value.
    NSString *minimumDiners = self.voucherContent[@"num_diners"];
    if (!minimumDiners || [minimumDiners isEqual:[NSNull null]]) {
        minimumDiners = [NSString stringWithFormat:@"%d", self.numberOfDiners];
    }
    NSString *minimumText = nil;
    if ([minimumDiners intValue] > 2) {
        minimumText = [NSString stringWithFormat:@"(min. group %@, use by %@)",minimumDiners,[formatter stringFromDate:date]];
    }
    else {
        minimumText = [NSString stringWithFormat:@"(Use by %@)", [formatter stringFromDate:date]];
    }
    
    [self.minGroupDateLabel setText:minimumText];
    
    [self.yourCodeLabel setTextColor:[FCSStyles brownColor]];
    [self.minGroupDateLabel setTextColor:[FCSStyles brownColor]];
    [self.restaurantNameLabel setTextColor:[FCSStyles brownColor]];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - User events
- (void)accountButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"TimelineSegue" sender:self];
}

- (IBAction)shareButtonTapped:(id)sender {
    
    /*
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Share", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Facebook", nil), NSLocalizedString(@"Twitter", nil), nil];
    [sheet showInView:self.view];
    */
    
    FCSShareProviders *shareProviders = [[FCSShareProviders alloc] init];
    shareProviders.type = 2;
    shareProviders.kidsFed = [[self.voucherContent objectForKey:@"amount"] integerValue];
    shareProviders.restaurantName = self.restaurantName;
    
    OWFacebookActivity *facebookActivity = [[OWFacebookActivity alloc] init];
    facebookActivity.userInfo = @{ @"text": [shareProviders shareStringForActivityTime:UIActivityTypePostToFacebook]};
    OWTwitterActivity *twitterActivity = [[OWTwitterActivity alloc] init];
    twitterActivity.userInfo = @{ @"text": [shareProviders shareStringForActivityTime:UIActivityTypePostToTwitter]};
    OWActivityViewController *activityViewController = [[OWActivityViewController alloc] initWithViewController:self activities:@[facebookActivity, twitterActivity]];
    [activityViewController presentFromRootViewController];
    
    /*NSURL *shareUrl = [NSURL URLWithString:@"http://joinfoodcircles.org/restaurant"];
    
    NSArray *itemsToShare = @[shareProviders,shareUrl];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePostToWeibo];
    
    [self presentViewController:activityVC animated:YES completion:nil];
     */
     
}

- (IBAction)markAsUsedPressed:(id)sender {
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Are you sure?", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Yes", nil), nil] show];
}


#pragma mark - Actionsheet
/*
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    FCSShareProviders *shareProviders = [[FCSShareProviders alloc] init];
    shareProviders.type = 2;
    shareProviders.kidsFed = [[self.voucherContent objectForKey:@"amount"] integerValue];
    shareProviders.restaurantName = self.restaurantName;
    
    if (buttonIndex == 0) {
        SHKItem *item = [SHKItem text:[shareProviders shareStringForActivityTime:UIActivityTypePostToFacebook]];
        
        // Share the item on Facebook
        [SHKFacebook shareItem:item];
    }
    else if (buttonIndex == 1) {
        SHKItem *item = [SHKItem text:[shareProviders shareStringForActivityTime:UIActivityTypePostToTwitter]];
        
        // Share the item on Facebook
        [SHKTwitter shareItem:item];
    }
}
 */

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self.hud show:YES];
        [[FCSServerHelper sharedHelper] useVoucher:self.voucherContent withCompletion:^(NSString *error) {
            if (error) {
                self.hud.labelText = NSLocalizedString(@"Error!", nil);
                self.hud.detailsLabelText = error;
                [self.hud hide:YES afterDelay:3];
            }
            else {
                [self.hud hide:YES];
                if (self.viewType == VoucherViewTypePayment) {
                    [self accountButtonClicked:nil];
                }
                else if (self.viewType == VoucherViewTypeTimeline) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    }
}

@end
