//
//  LoginViewController.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/2/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "RecoveryPasswordViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "MenuNavigationController.h"
#import "HomeViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "REFrostedViewController.h"


@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setHidden:YES];
    
    self.emailField.delegate = self;
    self.passwordField.delegate=self;
    
    recoveryView = [[RecoveryPasswordViewController alloc] initWithNibName:@"RecoveryPasswordViewController" bundle:nil];
    
    
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginAction:(id)sender {
    
    
    
    NSString *username = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password =[self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if( [username length] == 0 || [password length] ==0 ){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Make sure you enter a username and password!"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }else{
        
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user,NSError *error) {
            
            
            if(error){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                                    message:[error.userInfo objectForKey:@"error"]
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                
            }else{
                
                NSLog(@"validation: %d",[[user objectForKey:@"emailVerified"] boolValue]);
                
                if(![[user objectForKey:@"emailVerified"] boolValue]){
                    [self performSegueWithIdentifier:@"confirmAccount" sender:nil];
                }else{
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                    
                   // [self performSegueWithIdentifier:@"homeView" sender:nil];
                  // [self.navigationController popToRootViewControllerAnimated:YES];
                    
                    
                   // [self dismissViewControllerAnimated:YES completion:nil];
                    
                  //  while(self.presentedViewController)
                    //    [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                    // [self.navigationController popToRootViewControllerAnimated:YES];
                    
                   
                    //Go to Home View Controller Statement
                   // UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"iPhoneStoryboard" bundle:nil];
                    //HomeViewController *homeViewController = [mystoryboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                   // MenuNavigationController *navigationController=nil;
                   
                   // navigationController = [[MenuNavigationController alloc] initWithRootViewController:homeViewController];
                
                    
                    //[navigationController popToRootViewControllerAnimated:YES];
                
                    
                    //self.frostedViewController.contentViewController = navigationController;
                    //[self.frostedViewController hideMenuViewController];
                
                
                }
                
            }
            
            
            
        }];
        
        
    }
    
    
 
    
}

- (IBAction)forgotPasswordAction:(id)sender {
    
    [self presentSemiViewController:recoveryView withOptions:@{
                                                            KNSemiModalOptionKeys.pushParentBack    : @(YES),
                                                            KNSemiModalOptionKeys.animationDuration : @(0.5),
                                                            KNSemiModalOptionKeys.shadowOpacity     : @(0.9),
                                                            }];
    
}




- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
