//
//  FCSPurchaseViewController.m
//  FoodCircles
//
//  Created by David Groulx on 5/6/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

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
  //  self.priceLabel.text = [self.usdFormatter stringFromNumber:[NSNumber numberWithFloat:self.priceSlider.value]];
  [self updatePrice:self.priceSlider];
  
  // Start with the local charity selected, set text styles apppropiraetly
  self.charitySelectorSwitch.on = NO;
  [self donationChanged:self.charitySelectorSwitch];
  self.navigationItem.leftBarButtonItem.title = @"Acknowledge Briefings Read";
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)buy:(id)sender {
    // Create a PayPalPayment
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%0.2f", self.priceSlider.value]];
    payment.amount = [NSDecimalNumber decimalNumberWithString:@"10.0"];
    payment.currencyCode = @"USD";
    payment.shortDescription = @"desc";//self.special.name;
    
    // Check whether payment is processable.
    if (!payment.processable) {
        // If, for example, the amount was negative or the shortDescription was empty, then
        // this payment would not be processable. You would want to handle that here.
    }
    
    // Start out working with the test environment! When you are ready, remove this line to switch to live.
    [PayPalPaymentViewController setEnvironment:PayPalEnvironmentNoNetwork];
    
    // Provide a payerId that uniquely identifies a user within the scope of your system,
    // such as an email address or user ID.
    
#warning this should be the user's email
    NSString *aPayerId = @"someuser@somedomain.com";
    
    // Create a PayPalPaymentViewController with the credentials and payerId, the PayPalPayment
    // from the previous step, and a PayPalPaymentDelegate to handle the results.
    PayPalPaymentViewController *paymentViewController;
    paymentViewController = [[PayPalPaymentViewController alloc] initWithClientId:@"ATpY8BAwAkcjGxyOJ9IjArCzDNfrqdQV3FaADv-iWszrCOxpjQ_I2elLntHS"
                                                                    receiverEmail:@"jtkumario@gmail.com"
                                                                          payerId:aPayerId
                                                                          payment:payment
                                                                         delegate:self];
    
    // Present the PayPalPaymentViewController.
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

- (IBAction)updatePrice:(UISlider *)sender {
  self.priceLabel.text = [self.usdFormatter stringFromNumber:[NSNumber numberWithFloat:sender.value]];
  self.mealsProvidedLabel.text = [NSString stringWithFormat:@"%d meals provided", [self mealsProvided]];
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

- (NSString *)priceAsString {
  return [self.usdFormatter stringFromNumber:[NSNumber numberWithFloat:self.priceSlider.value]];
}

- (NSInteger)mealsProvided {
  return (int)self.priceSlider.value;
}

#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentDidComplete:(PayPalPayment *)completedPayment {
    // Payment was processed successfully; send to server for verification and fulfillment.
    //[self verifyCompletedPayment:completedPayment];
#warning need to verify payment!
    
    // Dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel {
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
