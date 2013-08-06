#import "FCSAppDelegate.h"
#import "FCSPurchaseViewController.h"


@interface FCSPurchaseViewController ()

@property (strong, atomic) NSNumberFormatter *usdFormatter;
@property (strong, nonatomic) UIColor *selectedCharityColor;
@property (strong, nonatomic) UIColor *unselectedCharityColor;

@end

@implementation FCSPurchaseViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.usdFormatter = [[NSNumberFormatter alloc] init];
  [self.usdFormatter setCurrencySymbol:@"$"];
  [self.usdFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
  self.selectedCharityColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
  self.unselectedCharityColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
}

- (void)viewWillAppear:(BOOL)animated {
  self.charitySelectorSwitch.on = NO;
  [self donationChanged:self.charitySelectorSwitch];
}


- (IBAction)buy:(id)sender {
    // Create a PayPalPayment
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%0.2f", self.priceSlider.value]];
    payment.amount = [NSDecimalNumber decimalNumberWithString:@"10.0"];
    payment.currencyCode = @"USD";
    payment.shortDescription = @"desc";
    
    if (!payment.processable) {}
    
    [PayPalPaymentViewController setEnvironment:PayPalEnvironmentNoNetwork];
    
    NSString *aPayerId = UIAppDelegate.user_email;
    
    PayPalPaymentViewController *paymentViewController;
    paymentViewController = [[PayPalPaymentViewController alloc] initWithClientId:@"ATpY8BAwAkcjGxyOJ9IjArCzDNfrqdQV3FaADv-iWszrCOxpjQ_I2elLntHS"
                                                                    receiverEmail:@"jtkumario@gmail.com"
                                                                          payerId:aPayerId
                                                                          payment:payment
                                                                         delegate:self];

    [self presentViewController:paymentViewController animated:YES completion:nil];
}

- (IBAction)updatePrice:(UISlider *)sender {
    [self update];
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
}

- (IBAction)selectCharity:(id)sender {
}

- (void) update {
    int fullPrice = 9;
    
    NSNumber *cost = [NSNumber numberWithShort:10];
    self.priceLabel.text = [self.usdFormatter stringFromNumber:cost];
    
    if(cost > [NSNumber numberWithShort:1])
        self.mealsProvidedLabel.text = [NSString stringWithFormat:@"%@ meals ", cost];
    else
        self.mealsProvidedLabel.text = [NSString stringWithFormat:@"%@ meal ", cost];
}

- (NSString *)priceAsString {
  return [self.usdFormatter stringFromNumber:[NSNumber numberWithFloat:self.priceSlider.value]];
}

- (NSInteger)mealsProvided {
  return (int)self.priceSlider.value;
}

#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentDidComplete:(PayPalPayment *)completedPayment {
    //[self verifyCompletedPayment:completedPayment];
#warning need to verify payment!
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
