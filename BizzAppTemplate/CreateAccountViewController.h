//
//  CreateAccountViewController.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/2/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateAccountViewController : UIViewController



@property (weak, nonatomic) IBOutlet UITextField *firstNameField;

@property (weak, nonatomic) IBOutlet UITextField *lastNameField;


@property (weak, nonatomic) IBOutlet UITextField *companyNameField;

@property (weak, nonatomic) IBOutlet UITextField *emailField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;


- (IBAction)createAccountAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

@end
