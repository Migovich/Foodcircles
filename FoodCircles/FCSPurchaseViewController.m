#import "FCSAppDelegate.h"
#import "FCSPurchaseViewController.h"
#import "FCSVenueListViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "JSONKit.h"
#import "constants.h"
#import "FCSVoucherViewController.h"

#import "RNBlurModalView.h"

#ifdef DEBUG
#ifndef SKIP_PAYMENT
#define SKIP_PAYMENT 0
#endif
#endif

@interface FCSPurchaseViewController ()

@property (strong, atomic) NSNumberFormatter *usdFormatter;
@property (strong, nonatomic) UIColor *selectedCharityColor;
@property (strong, nonatomic) UIColor *unselectedCharityColor;

@property (nonatomic) PayPalPayment *completedPayment;

@end

@implementation FCSPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usdFormatter = [[NSNumberFormatter alloc] init];
    [self.usdFormatter setCurrencySymbol:@"$"];
    [self.usdFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    self.selectedCharityColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    self.unselectedCharityColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    
    BOOL iphone4inch = [UIScreen mainScreen].bounds.size.height == 568;
    _pickerView = [[UIPickerView alloc] initWithFrame:iphone4inch?CGRectMake(0, 290, 320, 300):CGRectMake(0, 200, 320, 300)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.showsSelectionIndicator = YES;
    [self.view addSubview:_pickerView];
    _pickerView.hidden = YES;
    
    _selectedOffer = 0;
    _selectedCharity = 0;
    
    [self setPriceRule];
    
    [_pickerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerTapped:)]];
    
    NSString *title = [[[[UIAppDelegate.venues objectAtIndex:_selectedVenueIndex] objectForKey:@"offers"] objectAtIndex:0] objectForKey:@"title"];
    [_offerButton setTitle:title forState:UIControlStateNormal];
    
    title = [[UIAppDelegate.charities objectAtIndex:0] objectForKey:@"name"];
    [_charityButton setTitle:title forState:UIControlStateNormal];
    
    [_priceSlider addTarget:self action:@selector(updatePrice:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    self.charitySelectorSwitch.on = NO;
    [self donationChanged:self.charitySelectorSwitch];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"VoucherSegue"]) {
        FCSVoucherViewController *destinationViewController = (FCSVoucherViewController *)segue.destinationViewController;
        destinationViewController.viewType = VoucherViewTypePayment;
        destinationViewController.selectedOffer = _selectedOffer;
        destinationViewController.selectedVenueIndex = _selectedVenueIndex;
        destinationViewController.completedPayment = self.completedPayment;
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
    payment.shortDescription = [[[[UIAppDelegate.venues objectAtIndex:_selectedVenueIndex] objectForKey:@"offers"] objectAtIndex:0] objectForKey:@"title"];
    
    if (!payment.processable) {}
    
    [PayPalPaymentViewController setEnvironment:PayPalEnvironmentNoNetwork];
    
    NSString *aPayerId = UIAppDelegate.user_email;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithClientId:@"ATpY8BAwAkcjGxyOJ9IjArCzDNfrqdQV3FaADv-iWszrCOxpjQ_I2elLntHS" receiverEmail:@"jtkumario@gmail.com" payerId:aPayerId payment:payment delegate:self];

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
    _pickerView.hidden = NO;
    _pickerType = 1;
    [_pickerView reloadAllComponents];
}

- (IBAction)selectCharity:(id)sender {
    _pickerView.hidden = NO;
    _pickerType = 2;
    [_pickerView reloadAllComponents];
}

#pragma mark - Custom Methods
- (void)update:(int)value {
    [self.priceLabel setText:[NSString stringWithFormat:@"$%d",value]];
    
    if(value > 1)
        self.mealsProvidedLabel.text = [NSString stringWithFormat:@"%d meals ", value];
    else
        self.mealsProvidedLabel.text = [NSString stringWithFormat:@"%d meal ", value];
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
  return (int)self.priceSlider.value;
}

#pragma mark - PayPalPaymentDelegate methods
- (void)payPalPaymentDidComplete:(PayPalPayment *)completedPayment {
    self.completedPayment = completedPayment;
    [self performSegueWithIdentifier:@"VoucherSegue" sender:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIPickerViewDelegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_pickerType == 1) {
        _selectedOffer = row;
    } else {
        _selectedCharity = row;
    }
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_pickerType == 1) {
        return [[[UIAppDelegate.venues objectAtIndex:_selectedVenueIndex] objectForKey:@"offers"] count];
    } else {
        return [UIAppDelegate.charities count];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    if (_pickerType == 1) {
        title = [[[[UIAppDelegate.venues objectAtIndex:_selectedVenueIndex] objectForKey:@"offers"] objectAtIndex:row] objectForKey:@"title"];
    } else {
        title = [[UIAppDelegate.charities objectAtIndex:row] objectForKey:@"name"];
    }
    
    return title;
}

-(void)pickerTapped:(UIGestureRecognizer *)gestureRecognizer {
    if (_pickerType == 1) {
        [_offerButton setTitle:[[[[UIAppDelegate.venues objectAtIndex:_selectedVenueIndex] objectForKey:@"offers"] objectAtIndex:_selectedOffer] objectForKey:@"title"] forState:UIControlStateNormal];
        
        [self setPriceRule];
    } else {
        [_charityButton setTitle:[[UIAppDelegate.charities objectAtIndex:_selectedCharity] objectForKey:@"name"]  forState:UIControlStateNormal];
    }
    _pickerView.hidden = YES;
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
