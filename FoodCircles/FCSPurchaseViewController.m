//
//  FCSPurchaseViewController.m
//  FoodCircles
//
//  Created by David Groulx on 5/6/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSPurchaseViewController.h"
#import "FCSRemoteAPI.h"


@interface FCSPurchaseViewController ()

@property (strong, atomic) PayPalPaymentViewController *paypalView;
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
  PayPalPayment *payment = [[PayPalPayment alloc] init];
  payment.amount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%0.2f", self.priceSlider.value]];
  payment.currencyCode = @"USD";
  payment.shortDescription = self.special.name;
  
  if (!payment.processable) {
    // Really should bail out here
  }
  
  // Start out working with the test environment! When you are ready, remove this line to switch to live.
  [PayPalPaymentViewController setEnvironment:PayPalEnvironmentNoNetwork];
  
  // Provide a payerId that uniquely identifies a user within the scope of your system,
  // such as an email address or user ID.
  NSString *aPayerId = [[FCSRemoteAPI sharedInstance] currentUser];
  
  // Create a PayPalPaymentViewController with the credentials and payerId, the PayPalPayment
  // from the previous step, and a PayPalPaymentDelegate to handle the results.
  self.paypalView = [[PayPalPaymentViewController alloc] initWithClientId:@"AevvhRDE-Ip2geQw3kMw5WS_e9t1oN09d_d70addhLxn2RXBCbFAytSNBX_T"
                                                            receiverEmail:@"david@sandbendersoftware.com"
                                                                  payerId:aPayerId
                                                                  payment:payment
                                                                 delegate:self];
  
  // Present the PayPalPaymentViewController.
  [self presentViewController:self.paypalView animated:YES completion:nil];
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

# pragma mark -
# pragma mark PayPalPaymentDelegate

- (void)payPalPaymentDidCancel {
  [self.paypalView dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidComplete:(PayPalPayment *)completedPayment {
  [self.paypalView dismissViewControllerAnimated:YES completion:nil];
}

@end
