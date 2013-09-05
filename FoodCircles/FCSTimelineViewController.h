//
//  FCSTimelineViewController.h
//  FoodCircles
//
//  Created by David Groulx on 5/22/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FCSStyledViewController.h"
#import "MBProgressHUD.h"

@class MBProgressHUD;

@interface FCSTimelineViewController : FCSStyledViewController <UITableViewDelegate, UITableViewDataSource> {
    MBProgressHUD *HUD;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *timelineData;
@property (assign, nonatomic) int lastMonth;
@property (assign, nonatomic) int monthCount;
@property (strong, nonatomic) NSDictionary *voucherContent;

- (IBAction)inviteButtonTapped:(id)sender;

@end
