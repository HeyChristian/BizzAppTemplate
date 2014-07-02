//
//  LoginViewController.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/2/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController



@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;




- (IBAction)back:(id)sender;
- (IBAction)loginAction:(id)sender;
- (IBAction)forgotPasswordAction:(id)sender;



@end
