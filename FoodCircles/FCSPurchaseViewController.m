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
@property (strong, atomic) NSNumberFormatter *usdFormatter; @end

@implementation FCSPurchaseViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
    if (self) {
      self.usdFormatter = [[NSNumberFormatter alloc] init];
      [self.usdFormatter setCurrencySymbol:@"$"];
      [self.usdFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
  self.priceLabel.text = [self.usdFormatter stringFromNumber:[NSNumber numberWithFloat:self.priceSlider.value]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buy:(id)sender {
  PayPalPayment *payment = [[PayPalPayment alloc] init];
  payment.amount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%0.2f", self.priceSlider.value]];
  payment.currencyCode = @"USD";
  payment.shortDescription = self.description;
  
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
}

- (NSString *)priceAsString {
  return [self.usdFormatter stringFromNumber:[NSNumber numberWithFloat:self.priceSlider.value]];
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
