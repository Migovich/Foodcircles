//
//  FCSSignUpViewControllerTests.m
//  FoodCircles
//
//  Created by David Groulx on 5/1/13.
//  Copyright (c) 2013 FoodCircles. All rights reserved.
//

#import "FCSSignUpViewControllerTests.h"
#import "FCSSignUpViewController.h"


@interface FCSSignUpViewControllerTests ()

@property FCSSignUpViewController *controller;

@end

@implementation FCSSignUpViewControllerTests

- (void)setUp
{
  [super setUp];
  
  UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
  _controller = [sb instantiateViewControllerWithIdentifier:@"SignUpViewController"];
  [_controller loadView];
}

- (void)tearDown
{
  [super tearDown];
}

- (void)testTextFieldShouldReturn {
  UITextField *tf = [[UITextField alloc] init];
  [tf becomeFirstResponder];
  [_controller textFieldShouldReturn:tf];
  STAssertFalse([tf isFirstResponder], @"UITextField did not relinquish first responder status");
}

- (void)testVerifyBindings {
  STAssertEqualObjects(_controller, [[_controller emailTextField] delegate], @"emailTextField delegate is not correct");
  STAssertEqualObjects(_controller, [[_controller passwordTextField] delegate], @"passwordTextField delegate is not correct");
  
  [self assertThat:_controller.signUpButton isWiredTo:@"signUp:"];
}

- (void)assertThat:(UIControl *)control isWiredTo:(NSString *)action {
  STAssertNotNil(control, @"Control should not be nil");
  
  NSArray *actionsForTarget = [control actionsForTarget:_controller forControlEvent:UIControlEventTouchUpInside];
  
  BOOL result = [actionsForTarget containsObject:action];
  STAssertTrue(result, @"Control was not wired to @selector(%@)", action);
}

@end
