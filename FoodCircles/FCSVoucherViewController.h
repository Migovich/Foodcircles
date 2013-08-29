//
//  FCSVoucherViewController.h
//  FoodCircles
//
//  Created by David Groulx on 5/10/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCSStyledViewController.h"
#import "FCSHeaderLabel.h"

@interface FCSVoucherViewController : FCSStyledViewController

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
- (IBAction)accountButtonClicked:(id)sender;
- (IBAction)shareButtonTapped:(id)sender;

@end