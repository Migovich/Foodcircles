#import "FCSAppDelegate.h"
#import "FCSPurchaseViewController.h"
#import "FCSVenueListViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "JSONKit.h"
#import "constants.h"
#import "FCSVoucherViewController.h"
#import "FCSStyles.h"
#import "FCSLoginProvider.h"

#import "RNBlurModalView.h"
#import "FPPopoverController.h"
#import "FCSPickerTableViewController.h"

#ifdef DEBUG
#ifndef SKIP_PAYMENT
#define SKIP_PAYMENT 0
#endif
#endif

#define kReceiverEmail @"jtkumario@gmail.com"

@interface FCSPurchaseViewController () <FCSPickerTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *payWhatYouWantLabel;
@property (weak, nonatomic) IBOutlet UILabel *bringingFriendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *donatedToLabel;

@property (strong, atomic) NSNumberFormatter *usdFormatter;
@property (strong, nonatomic) UIColor *selectedCharityColor;
@property (strong, nonatomic) UIColor *unselectedCharityColor;

@property (nonatomic) PayPalPayment *completedPayment;

@property (strong, nonatomic) UIColor *navigationBarBarTintColor;
@property (strong, nonatomic) UIColor *navigationBarTintColor;
@property (strong, nonatomic) UIColor *barButtonItemTintColor;

@property (nonatomic) FPPopoverController *popOverController;
@end

@implementation FCSPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    if (IS_OS_7_OR_LATER) self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.usdFormatter = [[NSNumberFormatter alloc] init];
    [self.usdFormatter setCurrencySymbol:@"$"];
    [self.usdFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    self.selectedCharityColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    self.unselectedCharityColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    
    _selectedOffer = 0;
    _selectedCharity = 0;
    
    [self setPriceRule];
    
    NSString *title = [[[[UIAppDelegate.venues objectAtIndex:_selectedVenueIndex] objectForKey:@"offers"] objectAtIndex:0] objectForKey:@"title"];
    [_offerButton setTitle:title forState:UIControlStateNormal];
    
    title = [[UIAppDelegate.charities objectAtIndex:0] objectForKey:@"name"];
    [_charityButton setTitle:title forState:UIControlStateNormal];
    
    [_priceSlider addTarget:self action:@selector(updatePrice:) forControlEvents:UIControlEventValueChanged];
    
    self.payWhatYouWantLabel.textColor = [FCSStyles brownColor];
    self.bringingFriendsLabel.textColor = [FCSStyles brownColor];
    self.donatedToLabel.textColor = [FCSStyles brownColor];
 
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.charitySelectorSwitch.on = NO;
    [self donationChanged:self.charitySelectorSwitch];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"VoucherSegue"]) {
        FCSVoucherViewController *destinationViewController = (FCSVoucherViewController *)segue.destinationViewController;
        destinationViewController.viewType = VoucherViewTypePayment;
        destinationViewController.selectedOffer = _selectedOffer;
        NSDictionary *offer = [[[UIAppDelegate.venues objectAtIndex:_selectedVenueIndex] objectForKey:@"offers"] objectAtIndex:_selectedOffer];
        destinationViewController.numberOfDiners = [[offer objectForKey:@"minimum_diners"] integerValue];
        destinationViewController.selectedVenueIndex = _selectedVenueIndex;
        destinationViewController.completedPayment = self.completedPayment;
        destinationViewController.selectedCharity = _selectedCharity;
     }
}

#pragma mark - IBActions
- (IBAction)buy:(id)sender {
    
#if SKIP_PAYMENT
    self.voucherContent = @{ @"code": @"123",
                             @"amout": @"2",
                             @"created_at": [[NSDate date] description]
                             };
    [self performSegueWithIdentifier:@"VoucherSegue" sender:nil];
    return;
#endif
    
    // Create a PayPalPayment
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.0f", trunc(self.priceSlider.value)]];
    payment.currencyCode = @"USD";
    payment.shortDescription = [[[[UIAppDelegate.venues objectAtIndex:_selectedVenueIndex] objectForKey:@"offers"] objectAtIndex:_selectedOffer] objectForKey:@"title"];
    
    if (!payment.processable) {
        
    }
    
    NSString *aPayerId = UIAppDelegate.user_uid;
    
#ifdef TESTING
    NSString *clientID = kTesterClientId;
#else
    NSString *clientID = kClientId;
#endif
    
    //PayPal style fix
    if (IS_OS_7_OR_LATER) {
        _navigationBarBarTintColor = [UINavigationBar appearance].barTintColor;
        _navigationBarTintColor = [UINavigationBar appearance].tintColor;
        _barButtonItemTintColor = [UIBarButtonItem appearance].tintColor;
        [[UINavigationBar appearance] setBarTintColor:nil];
        [[UINavigationBar appearance] setTintColor:nil];
        [[UIBarButtonItem appearance] setTintColor:nil];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
    
    //PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithClientId:clientID receiverEmail:kReceiverEmail payerId:aPayerId payment:payment delegate:self];
    PayPalConfiguration *paypalConfig = [[PayPalConfiguration alloc] init];
    paypalConfig.acceptCreditCards = YES;
    paypalConfig.rememberUser = YES;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:paypalConfig delegate:self];

    [self presentViewController:paymentViewController animated:YES completion:nil];
}

- (IBAction)updatePrice:(UISlider *)sender {
    [self update:sender.value];
}

- (IBAction)donationChanged:(UISwitch *)sender {
  if (sender.on) { // "on" points to the international charity
    self.localCharityLabel.textColor = self.unselectedCharityColor;
    self.internationalCharityLabel.textColor = self.selectedCharityColor;
  } else { // "off" points to the local charity
    self.localCharityLabel.textColor = self.selectedCharityColor;
    self.internationalCharityLabel.textColor = self.unselectedCharityColor;
  }
}

- (IBAction)selectOffer:(id)sender {
    NSMutableArray *offerNames = [[NSMutableArray alloc] init];
    for (NSDictionary *offer in [[UIAppDelegate.venues objectAtIndex:_selectedVenueIndex] objectForKey:@"offers"]) {
        [offerNames addObject:offer[@"title"]];
    }
    FCSPickerTableViewController *picker = [[FCSPickerTableViewController alloc] initWithStyle:UITableViewStylePlain];
    picker.titles = offerNames;
    picker.delegate = self;
    self.popOverController = [[FPPopoverController alloc] initWithViewController:picker];
    self.popOverController.contentSize = CGSizeMake(300, MIN(300, offerNames.count*44 + 38));
    self.popOverController.arrowDirection = FPPopoverArrowDirectionAny;
    self.popOverController.tint = FPPopoverRedTint;
    [self.popOverController presentPopoverFromView:sender];
    _pickerType = 1;
}

- (IBAction)selectCharity:(id)sender { 
    NSMutableArray *charityNames = [[NSMutableArray alloc] init];
    for (NSDictionary *charity in UIAppDelegate.charities) {
        [charityNames addObject:charity[@"name"]];
    }
    FCSPickerTableViewController *picker = [[FCSPickerTableViewController alloc] initWithStyle:UITableViewStylePlain];
    picker.titles = charityNames;
    picker.delegate = self;
    self.popOverController = [[FPPopoverController alloc] initWithViewController:picker];
    self.popOverController.contentSize = CGSizeMake(200, MIN(300, charityNames.count*44 + 38));
    self.popOverController.arrowDirection = FPPopoverArrowDirectionAny;
    self.popOverController.tint = FPPopoverRedTint;
    [self.popOverController presentPopoverFromView:sender];
    
    _pickerType = 2;
}

#pragma mark - Custom Methods
-(void)backDefaultStyle {
    if (IS_OS_7_OR_LATER) {
        [[UINavigationBar appearance] setBarTintColor:_navigationBarBarTintColor];
        [[UINavigationBar appearance] setTintColor:_navigationBarTintColor];
        [[UIBarButtonItem appearance] setTintColor:_barButtonItemTintColor];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
}

- (void)update:(NSInteger)value {
    [self.priceLabel setText:[NSString stringWithFormat:@"$%ld",(long)value]];
    
    if(value > 1)
        self.mealsProvidedLabel.text = [NSString stringWithFormat:@"%ld meals ", (long)value];
    else
        self.mealsProvidedLabel.text = [NSString stringWithFormat:@"%ld meal ", (long)value];
}

-(void)setPriceRule {
    [_priceSlider setMinimumValue:[[[[[UIAppDelegate.venues objectAtIndex:_selectedVenueIndex] objectForKey:@"offers"] objectAtIndex:_selectedOffer] objectForKey:@"price"] floatValue]];
    [_priceSlider setValue:_priceSlider.minimumValue];
    [self update:_priceSlider.value];
    [_priceSlider setMaximumValue:[[[[[UIAppDelegate.venues objectAtIndex:_selectedVenueIndex] objectForKey:@"offers"] objectAtIndex:_selectedOffer] objectForKey:@"original_price"] floatValue]*2];
    
    [_minPriceLabel setText:[NSString stringWithFormat:@"$%1.0f",_priceSlider.minimumValue]];
    [_medPriceLabel setText:[NSString stringWithFormat:@"$%1.0f",_priceSlider.maximumValue/2]];
    [_maxPriceLabel setText:[NSString stringWithFormat:@"$%1.0f",_priceSlider.maximumValue]];
}

- (NSString *)priceAsString {
  return [self.usdFormatter stringFromNumber:[NSNumber numberWithFloat:self.priceSlider.value]];
}

- (NSInteger)mealsProvided {
  return (NSInteger)self.priceSlider.value;
}

#pragma mark - PayPalPaymentDelegate methods
- (void)payPalPaymentDidComplete:(PayPalPayment *)completedPayment {
    self.completedPayment = completedPayment;
    //NSLog(@"Completed Payment: %@", completedPayment);
    
    if ([UIAppDelegate.user_token length] == 0) {
        FCSLoginProvider *login = [[FCSLoginProvider alloc] init];
        [self dismissViewControllerAnimated:YES completion:nil];
        [login savedLoginWithView:self segue:@"VoucherSegue" hud:HUD];
    } else {
        [self performSegueWithIdentifier:@"VoucherSegue" sender:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    [self backDefaultStyle];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self backDefaultStyle];
}

#pragma mark - Picker Delegate
- (void)picker: (FCSPickerTableViewController*)picker didSelectRowAtIndex: (NSUInteger)index {
    if (_pickerType == 1) {
        _selectedOffer = index;
        [_offerButton setTitle:[[[[UIAppDelegate.venues objectAtIndex:_selectedVenueIndex] objectForKey:@"offers"] objectAtIndex:_selectedOffer] objectForKey:@"title"] forState:UIControlStateNormal];
        [self setPriceRule];
    } else {
        _selectedCharity = index;
        [_charityButton setTitle:[[UIAppDelegate.charities objectAtIndex:_selectedCharity] objectForKey:@"name"]  forState:UIControlStateNormal];
    }
    [self.popOverController dismissPopoverAnimated:YES];
}
#pragma mark - Info Buttons

- (IBAction)bringingFriendsInfoPressed:(id)sender {
    RNBlurModalView *modalView = [[RNBlurModalView alloc] initWithParentView:self.view title:NSLocalizedString(@"Bringing Friends?", nil) message:NSLocalizedString(@"Grab an upgrade for bigger groups ($1 added per upgrade)", nil)];
    [modalView show];
}

- (IBAction)charityDescriptionInfoPressed:(id)sender {
    NSString *selectedCharityName = [[UIAppDelegate.charities objectAtIndex:_selectedCharity] objectForKey:@"name"];
    NSString *selectedCharityDescription = [[UIAppDelegate.charities objectAtIndex:_selectedCharity] objectForKey:@"description"];
    
    RNBlurModalView *modalView = [[RNBlurModalView alloc] initWithParentView:self.view title:selectedCharityName message:selectedCharityDescription];
    [modalView show];
}
@end
