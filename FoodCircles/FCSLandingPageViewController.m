//
//  FCSLandingPageViewController.m
//  FoodCircles
//
//  Created by David Groulx on 5/12/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSLandingPageViewController.h"
#import "FCSShareProviders.h"
#import "OWActivityViewController.h"
#import "constants.h"

#import "UIImageView+WebCache.h"

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
@property (nonatomic) BOOL imageIsLoading;

@end


@implementation FCSLandingPageViewController {
    NSUInteger _currentImageIndex;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareButtonTapped)];
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
                _currentImageIndex = -1;
                self.newsImages = images;
                self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(changeImage:) userInfo:nil repeats:YES];
                [self.timer fire];
                
                UITapGestureRecognizer *imageTappedGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
                [self.newsImageView addGestureRecognizer:imageTappedGesture];
                
            }
        }
    }];
    /*SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    [imageCache cleanDisk];
     */
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [self.timer invalidate];
    self.timer = nil;
    
    [super viewDidDisappear:animated];
}
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
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
    /*
    FCSShareProviders *shareProviders = [[FCSShareProviders alloc] init];
    shareProviders.type = 1;
    NSURL *shareUrl = [NSURL URLWithString:@"http://joinfoodcircles.org/#app"];
    
    NSArray *itemsToShare = @[shareProviders,shareUrl];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePostToWeibo];
    
    [self presentViewController:activityVC animated:YES completion:nil];
     */
    FCSShareProviders *shareProviders = [[FCSShareProviders alloc] init];
    shareProviders.type = 1;
    
    OWFacebookActivity *facebookActivity = [[OWFacebookActivity alloc] init];
    facebookActivity.userInfo = @{ @"text": [shareProviders shareStringForActivityTime:UIActivityTypePostToFacebook]};
    OWTwitterActivity *twitterActivity = [[OWTwitterActivity alloc] init];
    twitterActivity.userInfo = @{ @"text": [shareProviders shareStringForActivityTime:UIActivityTypePostToTwitter]};
    OWActivityViewController *activityViewController = [[OWActivityViewController alloc] initWithViewController:self activities:@[facebookActivity, twitterActivity]];
    [activityViewController presentFromRootViewController];
}

- (void)imageTapped: (id)sender {
    FCSNewsImage *newsImage = self.newsImages[_currentImageIndex];
    NSLog(@"News Image %@\n %@", newsImage.imageUrl, newsImage.url);
    //Either open in safari, or go to restaurant page
    if ([newsImage.url isEqualToString:@"RestaurantList"]) {
        [self performSegueWithIdentifier:@"showVenueList" sender:nil];
    }
    else if (newsImage.url && ![newsImage.url isEqualToString:@""]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newsImage.url]];
    }
    else {
        [self performSegueWithIdentifier:@"showVenueList" sender:nil];
    }
        
}
#pragma mark - Helpers
- (void)changeImage: (id)sender {

    _currentImageIndex++;
    if (_currentImageIndex == self.newsImages.count) _currentImageIndex = 0;
    
    FCSNewsImage *newsImage = self.newsImages[_currentImageIndex];
    NSLog(@"News Image %@\n %@", newsImage.imageUrl, newsImage.url);
    [UIView transitionWithView:self.view duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    
        self.imageIsLoading = YES;
    
        [self.newsImageView setImageWithURL:[NSURL URLWithString:newsImage.imageUrl relativeToURL:[NSURL URLWithString:BASE_URL]] placeholderImage:nil options:-1 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            self.imageIsLoading = NO;
        }];
    } completion:nil];
}

- (void)setImageIsLoading:(BOOL)imageIsLoading {
    _imageIsLoading = imageIsLoading;
    if (imageIsLoading) {
        if ([self.timer isValid])
            [self.timer invalidate];
    }
    else {
        if (![self.timer isValid] && self.view.window)
            self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(changeImage:) userInfo:nil repeats:YES];
    }
}
@end
