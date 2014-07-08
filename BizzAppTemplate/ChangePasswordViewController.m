//
//  ChangePasswordViewController.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/7/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ALPValidator.h"
#import "UIControl+ALPValidator.h"
#import "MRProgress.h"
#import <Parse/Parse.h>
#import "Tools.h"
#import "UIViewController+KNSemiModal.h"
#import "CSNotificationView.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate,ALPValidatorDelegate,UIAlertViewDelegate>{
    bool passValidation;
        MRProgressOverlayView *activityIndicatorView;
}

@property (nonatomic, strong) CSNotificationView* permanentNotification;


@end




@implementation ChangePasswordViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    passValidation=false;
    
    //img validators
    self.imgCurrentPassValidator.image =  nil;
    self.imgNewPassValidator.image = nil;
    self.imgRepPassValidator.image = nil;
    
    
    //Email
    self.currentPasswordField.delegate=self;
    // [self setValidator:self.emailField  andValidator:self.emailValidator andRule:[self emailRuleValidator]];
    [self.currentPasswordField attachValidator:[self passwordRuleValidator:self.imgCurrentPassValidator]];
    
    //Password
    self.passwordField.delegate=self;
    //[self setValidator:self.passwordField  andValidator:self.passValidator andRule:[self passwordRuleValidator]];
    [self.passwordField attachValidator:[self passwordRuleValidator:self.imgNewPassValidator ]];
    
    
    //Re Password
    self.repeatPasswordField.delegate=self;
    //[self setValidator:self.rePasswordField  andValidator:self.rePassValidator andRule:[self passwordEqualityRuleValidator:self.passwordField]];
    
 
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.currentPasswordField becomeFirstResponder];
}
- (IBAction)setValidatorRePassword:(id)sender {
    
    [sender attachValidator:[self passwordEqualityRuleValidator:self.passwordField]];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updatePasswordAction:(id)sender {
    
    
    if(passValidation){
    
        NSString *currentPassword = [Tools clearText:self.currentPasswordField];
        [PFUser logInWithUsernameInBackground:[PFUser currentUser].email password:currentPassword block:^(PFUser *user,NSError *error) {
            if(!error){
                
                [PFUser currentUser].password = [Tools clearText:self.passwordField];
                [[PFUser currentUser] saveInBackground];
                [self dismissSemiModalView];
                
                
                [self showMessage:@"Update Complete" andMessage:nil];
            }else{
                 [self showMessage:@"Sorry!" andMessage:@"Current Password is incorrect"];
            }
            
        }];
        
    }else{
        
        [self showMessage:@"Sorry!" andMessage:@"Validating passwords is incorrect"];
    }
    
    
}

- (ALPValidator *)passwordRuleValidator:(UIImageView *)imgView
{
    ALPValidator *validator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [validator addValidationToEnsurePresenceWithInvalidMessage:NSLocalizedString(@"This is required!", nil)];
    [validator addValidationToEnsureMinimumLength:6 invalidMessage:NSLocalizedString(@"Min length is 6 characters!", nil)];
    
    
    __typeof__(self) __weak weakSelf = self;
    
    passValidation=false;
    validator.validatorStateChangedHandler = ^(ALPValidatorState newState) {
        
        switch (newState) {
            case ALPValidatorValidationStateValid: {
                [weakSelf handleValid:imgView];
                passValidation=true;
                break;
            }
            case ALPValidatorValidationStateInvalid: {
                [weakSelf handleInvalid:imgView];
                break;
            }
            case ALPValidatorValidationStateWaitingForRemote: {
                [weakSelf handleWaiting];
                imgView.image = nil;
                break;
            }
        }
    };
    
    return validator;
}
- (ALPValidator *)passwordEqualityRuleValidator:(UITextField *)compareField
{
    ALPValidator *validator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [validator addValidationToEnsureInstanceIsTheSameAs:compareField.text invalidMessage:NSLocalizedString(@"Should be equal to 'password'", nil)];
    
    [validator addValidationToEnsurePresenceWithInvalidMessage:NSLocalizedString(@"This is required!", nil)];
    [validator addValidationToEnsureMinimumLength:6 invalidMessage:NSLocalizedString(@"Min length is 6 characters!", nil)];
    
    
    __typeof__(self) __weak weakSelf = self;
    
    
    passValidation=false;
    validator.validatorStateChangedHandler = ^(ALPValidatorState newState) {
        
        switch (newState) {
            case ALPValidatorValidationStateValid: {
                [weakSelf handleValid:self.imgRepPassValidator];
                passValidation=true;
                break;
            }
            case ALPValidatorValidationStateInvalid: {
                [weakSelf handleInvalid:self.imgRepPassValidator];
                break;
            }
            case ALPValidatorValidationStateWaitingForRemote: {
                [weakSelf handleWaiting];
                self.imgRepPassValidator.image = nil;
                break;
            }
        }
    };
    
    return validator;
}
#pragma mark States

- (void)handleValid:(UIImageView *)img
{
    
    img.image = [UIImage imageNamed:BZGood];
  
}

- (void)handleInvalid:(UIImageView *)img
{
    
    
    img.image = [UIImage imageNamed:BZBad];

    
}

- (void)handleWaiting
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)showMessage:(NSString *)title andMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}
@end
