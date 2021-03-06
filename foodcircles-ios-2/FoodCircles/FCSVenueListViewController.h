//
//  FCSVenueListViewController.h
//  FoodCircles
//
//  Created by David Groulx on 5/1/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <MessageUI/MessageUI.h>

@class MBProgressHUD;

@interface FCSVenueListViewController : UICollectionViewController
<UICollectionViewDelegate, UICollectionViewDataSource, MFMailComposeViewControllerDelegate> {
    MBProgressHUD *HUD;
}

- (void)reloadOffers;
@end
