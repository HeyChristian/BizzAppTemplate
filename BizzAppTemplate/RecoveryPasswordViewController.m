//
//  RecoveryPasswordViewController.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/2/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "RecoveryPasswordViewController.h"
#import "ALPValidator.h"
#import "UIControl+ALPValidator.h"
#import "UIViewController+KNSemiModal.h"
#import <Parse/Parse.h>

@interface RecoveryPasswordViewController ()<UITextFieldDelegate,ALPValidatorDelegate>{
    bool passValidation;
}


@property (strong, nonatomic) ALPValidator *emailValidator;
@end

@implementation RecoveryPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    [self.recoveryEmail becomeFirstResponder];
    
    passValidation=false;
    self.imgRecoveryValidator.image = nil;
    
    self.recoveryEmail.delegate=self;
    //[self setValidator:self.passwordField  andValidator:self.passValidator andRule:[self passwordRuleValidator]];
    [self.recoveryEmail attachValidator:[self passwordRuleValidator]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendRecoveryAction:(id)sender {
    
    if(passValidation){
        [PFUser requestPasswordResetForEmailInBackground:self.recoveryEmail.text];
        [self dismissSemiModalView];
    }
}

- (IBAction)cancelAction:(id)sender {
   [self dismissSemiModalView];
}

- (ALPValidator *)passwordRuleValidator
{
    ALPValidator *validator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [validator addValidationToEnsureValidEmailWithInvalidMessage:@"Must be a valid email address!"];
    
    
    __typeof__(self) __weak weakSelf = self;
    
    passValidation=false;
    validator.validatorStateChangedHandler = ^(ALPValidatorState newState) {
        
        switch (newState) {
            case ALPValidatorValidationStateValid: {
                [weakSelf handleValid:self.imgRecoveryValidator];
                passValidation=true;
                break;
            }
            case ALPValidatorValidationStateInvalid: {
                [weakSelf handleInvalid:self.imgRecoveryValidator];
                break;
            }
            case ALPValidatorValidationStateWaitingForRemote: {
               // [weakSelf handleWaiting];
                self.imgRecoveryValidator.image = nil;
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
#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
@end
