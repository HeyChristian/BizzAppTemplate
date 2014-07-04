//
//  CreateAccountViewController.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/2/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "CreateAccountViewController.h"
#import <Parse/Parse.h>
#import "ALPValidator.h"
#import "UIControl+ALPValidator.h"
#import "ConfirmAccountViewController.h"

@interface CreateAccountViewController ()<UITextFieldDelegate,ALPValidatorDelegate,UIAlertViewDelegate>{
    bool passValidation;
}

@property (strong, nonatomic) ALPValidator *emailValidator;
@property (strong, nonatomic) ALPValidator *passValidator;
@property (strong, nonatomic) ALPValidator *rePassValidator;



@end

@implementation CreateAccountViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationItem.title  = @"Create Account";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
   
    passValidation=false;
    
    //img validators
    self.imgEmailValidator.image =  nil;
    self.imgPassValidator.image = nil;
    self.imgRePassValidator.image = nil;
    
    
    //Email
    self.emailField.delegate=self;
   // [self setValidator:self.emailField  andValidator:self.emailValidator andRule:[self emailRuleValidator]];
    [self.emailField attachValidator:[self emailRuleValidator]];
    
    //Password
    self.passwordField.delegate=self;
    //[self setValidator:self.passwordField  andValidator:self.passValidator andRule:[self passwordRuleValidator]];
    [self.passwordField attachValidator:[self passwordRuleValidator]];
    
    
    //Re Password
    self.rePasswordField.delegate=self;
    //[self setValidator:self.rePasswordField  andValidator:self.rePassValidator andRule:[self passwordEqualityRuleValidator:self.passwordField]];
    
    
    
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.emailField becomeFirstResponder];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    //[self.emailValidator validate:self.emailField.text];
   
    
    //[self.passValidator validate:self.passwordField.text];
    //[self.rePassValidator validate:self.rePasswordField.text];
}




- (IBAction)setValidatorRePassword:(id)sender {
    
    [sender attachValidator:[self passwordEqualityRuleValidator:self.passwordField]];
    
}

- (IBAction)createAccountAction:(id)sender {
    
    
    
    NSString *username = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password =[self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *repassword = [self.rePasswordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if( passValidation == false || ( [username length] == 0 || [password length] ==0 || [repassword length] ==0 ) || (![password isEqualToString:repassword]) ){
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Make sure you enter a email and password!"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        
        
        
    }else {
        
     
            
            
            
            
            PFUser *newUser = [PFUser user];
            newUser.username=username;
            newUser.password=password;
            newUser.email=username;
            newUser[@"role"] = @"General";
        
        
            [newUser signUpInBackgroundWithBlock:^(BOOL succeeded,NSError *error){
                
                
                if(error){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                                        message:[error.userInfo objectForKey:@"error"]
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                    
                }else{
                    
                 
                 
               
                    
                
                    
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Congrats, the account was created"
                                                                        message:@"Now go to the email to confirm your account."
                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alertView show];
                    
                    
                }
                
                
            }];
        }
        
    
    
    
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch (buttonIndex) {
        case 0:
            [self performSegueWithIdentifier:@"confirmAccount" sender:nil];
            break;
  
        default:
            break;
    }
}
- (IBAction)cancelAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
  //  [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark Accessors

- (void)setValidator:(UIImageView *)img andValidator:(ALPValidator *)_validator andRule:(ALPValidator *)validator
{
    _validator = validator;
    _validator.delegate = self;
    
    __typeof__(self) __weak weakSelf = self;
    
    _validator.validatorStateChangedHandler = ^(ALPValidatorState newState) {
        
        switch (newState) {
            case ALPValidatorValidationStateValid: {
                [weakSelf handleValid:img];
                break;
            }
            case ALPValidatorValidationStateInvalid: {
                [weakSelf handleInvalid:img];
                break;
            }
            case ALPValidatorValidationStateWaitingForRemote: {
                [weakSelf handleWaiting];
                break;
            }
        }
    };
}
#pragma mark States

- (void)handleValid:(UIImageView *)img
{
    
    img.image = [UIImage imageNamed:BZGood];
   // UIColor *validGreen = [UIColor colorWithRed:0.27 green:0.63 blue:0.27 alpha:1];
    //textField.backgroundColor = [validGreen colorWithAlphaComponent:0.3];
    //self.errorsTextView.text = NSLocalizedString(@"No errors 😃", nil);
    //self.errorsTextView.textColor = validGreen;
}

- (void)handleInvalid:(UIImageView *)img
{
    
    
    img.image = [UIImage imageNamed:BZBad];
    //UIColor *invalidRed = [UIColor colorWithRed:0.89 green:0.18 blue:0.16 alpha:1];
    //textField.backgroundColor = [invalidRed colorWithAlphaComponent:0.3];
    //self.errorsTextView.text = [self.validator.errorMessages componentsJoinedByString:@" 💣\n"];
    //self.errorsTextView.textColor = invalidRed;

}

- (void)handleWaiting
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
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

#pragma mark ALPValidatorDelegate

- (void)validator:(ALPValidator *)validator remoteValidationAtURL:(NSURL *)url receivedResult:(BOOL)remoteConditionValid
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)validator:(ALPValidator *)validator remoteValidationAtURL:(NSURL *)url failedWithError:(NSError *)error
{
    
    NSLog(@"Remote service could not be contacted: %@. Have you started the sinatra server?", error);
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *errorMessage = [NSString stringWithFormat:@"The remote service could not be contacted: %@. Have you started the Sinatra server bundled with the demo?", error];
        UIAlertView *alertOnce = [[UIAlertView alloc] initWithTitle:@"Remote service error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertOnce show];
    });
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
#pragma mark APLValidator Rules
- (ALPValidator *)emailRuleValidator
{
    ALPValidator *validator = [ALPValidator validatorWithType:ALPValidatorTypeString];
   // [validator addValidationToEnsurePresenceWithInvalidMessage:NSLocalizedString(@"This is required!", nil)];
    [validator addValidationToEnsureValidEmailWithInvalidMessage:@"Must be a valid email address!"];
   
    __typeof__(self) __weak weakSelf = self;
    
    passValidation=false;
    validator.validatorStateChangedHandler = ^(ALPValidatorState newState) {
        
        switch (newState) {
            case ALPValidatorValidationStateValid: {
                [weakSelf handleValid:self.imgEmailValidator];
                passValidation=true;
                break;
            }
            case ALPValidatorValidationStateInvalid: {
                [weakSelf handleInvalid:self.imgEmailValidator];
               
                break;
            }
            case ALPValidatorValidationStateWaitingForRemote: {
                [weakSelf handleWaiting];
                break;
                self.imgEmailValidator.image = nil;
            }
        }
    };
    
    
    return validator;
}
- (ALPValidator *)passwordRuleValidator
{
    ALPValidator *validator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [validator addValidationToEnsurePresenceWithInvalidMessage:NSLocalizedString(@"This is required!", nil)];
    [validator addValidationToEnsureMinimumLength:6 invalidMessage:NSLocalizedString(@"Min length is 6 characters!", nil)];
   
    
    __typeof__(self) __weak weakSelf = self;
    
    passValidation=false;
    validator.validatorStateChangedHandler = ^(ALPValidatorState newState) {
        
        switch (newState) {
            case ALPValidatorValidationStateValid: {
                [weakSelf handleValid:self.imgPassValidator];
                passValidation=true;
                break;
            }
            case ALPValidatorValidationStateInvalid: {
                [weakSelf handleInvalid:self.imgPassValidator];
                break;
            }
            case ALPValidatorValidationStateWaitingForRemote: {
                [weakSelf handleWaiting];
                self.imgPassValidator.image = nil;
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
                [weakSelf handleValid:self.imgRePassValidator];
                passValidation=true;
                break;
            }
            case ALPValidatorValidationStateInvalid: {
                [weakSelf handleInvalid:self.imgRePassValidator];
                break;
            }
            case ALPValidatorValidationStateWaitingForRemote: {
                [weakSelf handleWaiting];
                self.imgRePassValidator.image = nil;
                break;
            }
        }
    };
    
    return validator;
}
@end
