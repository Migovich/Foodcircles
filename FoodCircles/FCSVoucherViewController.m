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

@interface FCSVoucherViewController ()
@property (strong, nonatomic) NSDictionary *voucherContent;
@property (strong, nonatomic) NSString *offerName;
@property (strong, nonatomic) NSString *restaurantName;

@property (weak, nonatomic) IBOutlet FCSHeaderLabel *offerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *voucherNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *kidsFedLabel;
@property (weak, nonatomic) IBOutlet UILabel *minGroupDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *yourCodeLabel;

@property (weak, nonatomic) IBOutlet UIView *receiptView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *accountButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
- (IBAction)accountButtonClicked:(id)sender;
- (IBAction)shareButtonTapped:(id)sender;

@end

@implementation FCSVoucherViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
  
    self.receiptView.layer.shadowOpacity = 0.4f;
    self.receiptView.layer.shadowColor = [[UIColor colorWithRed:109.0/255.0 green:109.0/255.0 blue:109.0/255.0 alpha:1.0] CGColor];
    self.receiptView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    
    self.offerName = [[[[UIAppDelegate.venues objectAtIndex:_selectedVenueIndex] objectForKey:@"offers"] objectAtIndex:_selectedOffer] objectForKey:@"title"];
    self.restaurantName = [[UIAppDelegate.venues objectAtIndex:_selectedVenueIndex] objectForKey:@"name"];
    
    self.restaurantNameLabel.text = self.restaurantName;
    self.offerNameLabel.text = self.offerName;
    self.voucherNumberLabel.text = @"";
    self.minGroupDateLabel.text = @"";
    self.kidsFedLabel.text = @"";
    [self.spinner startAnimating];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *offerId = [[[[UIAppDelegate.venues objectAtIndex:_selectedVenueIndex] objectForKey:@"offers"] objectAtIndex:_selectedOffer] objectForKey:@"id"];
    
    [[FCSServerHelper sharedHelper] processPayment:self.completedPayment offerId:offerId withCompletion:^(NSDictionary *voucherContent, NSString *error) {
        
        if (error) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error!", nil) message:error delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self.spinner stopAnimating];
            self.voucherContent = voucherContent;
            
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
            
            [self.minGroupDateLabel setText:[NSString stringWithFormat:@"(min. group %d, use by %@)",amount*2,[formatter stringFromDate:date]]];
            
            [self.yourCodeLabel setTextColor:[FCSStyles brownColor]];
            [self.minGroupDateLabel setTextColor:[FCSStyles brownColor]];
            [self.restaurantNameLabel setTextColor:[FCSStyles brownColor]];
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)accountButtonClicked:(id)sender {
    //[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    [self performSegueWithIdentifier:@"TimelineSegue" sender:self];
}

- (IBAction)shareButtonTapped:(id)sender {
    FCSShareProviders *shareProviders = [[FCSShareProviders alloc] init];
    shareProviders.type = 2;
    shareProviders.kidsFed = [[self.voucherContent objectForKey:@"amount"] integerValue];
    shareProviders.restaurantName = self.restaurantName;
    
    NSURL *shareUrl = [NSURL URLWithString:@"http://joinfoodcircles.org/restaurant"];
    
    NSArray *itemsToShare = @[shareProviders,shareUrl];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePostToWeibo];
    
    [self presentViewController:activityVC animated:YES completion:nil];
}


@end
