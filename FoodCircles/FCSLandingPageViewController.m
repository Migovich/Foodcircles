//
//  FCSLandingPageViewController.m
//  FoodCircles
//
//  Created by David Groulx on 5/12/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSLandingPageViewController.h"
#import "FCSShareProviders.h"
#import "constants.h"

#import "FCSServerHelper.h"
#import "FCSNewsImage.h"

@interface FCSLandingPageViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareThisMissionLabelYConstraint;
@property (weak, nonatomic) IBOutlet UILabel *youCanFeedLabel;

@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic) NSArray *newsImages;
@property (nonatomic) NSTimer *timer;

@end


@implementation FCSLandingPageViewController {
    NSUInteger _currentImageIndex;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareButtonTapped)];
    tap.numberOfTapsRequired = 1;
    tap.enabled = YES;
    _shareButton.userInteractionEnabled = YES;
    [_shareButton addGestureRecognizer:tap];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"You can feed a child but your\nnetwork can feed a classrom" attributes:@{
                                                         NSForegroundColorAttributeName: [UIColor whiteColor]
                                       }];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:1];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    self.youCanFeedLabel.attributedText = text;
    
    [self.spinner startAnimating];
    [[FCSServerHelper sharedHelper] getNewsImages:^(NSArray *images, NSString *error) {
        
        [self.spinner stopAnimating];
        if (error) {
            NSLog(@"Error: %@", error);
            self.errorLabel.text = error;
        }
        else {
            if (images) {
                self.errorLabel.text = nil;
                _currentImageIndex = 0;
                self.newsImages = images;
                self.newsImageView.image = [images[0] image];
                self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(changeImage:) userInfo:nil repeats:YES];
                [self.timer fire];
            }
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@",segue.identifier);
    if ([segue.identifier isEqualToString:@"showVenueList"]) {
        NSLog(@"VenueList");
    } else {
        NSLog(@"Timeline");
    }
}

- (IBAction)swipeRecognized:(id)sender {
    NSLog(@"swipe is a go");
}

#pragma mark - Custom Methods
-(void)shareButtonTapped {
    FCSShareProviders *shareProviders = [[FCSShareProviders alloc] init];
    shareProviders.type = 1;
    NSURL *shareUrl = [NSURL URLWithString:@"http://joinfoodcircles.org/#app"];
    
    NSArray *itemsToShare = @[shareProviders,shareUrl];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePostToWeibo];
    
    [self presentViewController:activityVC animated:YES completion:nil];
}


#pragma mark - Helpers
- (void)changeImage: (id)sender {
    
    FCSNewsImage *newsImage = self.newsImages[_currentImageIndex];
    UIImage *image = newsImage.image;
    
    [UIView transitionWithView:self.view duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.newsImageView.image = image;
    } completion:nil];
    
    _currentImageIndex++;
    if (_currentImageIndex == self.newsImages.count) _currentImageIndex = 0;
}
@end
