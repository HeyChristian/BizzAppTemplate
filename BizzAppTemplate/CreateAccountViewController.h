//
//  CreateAccountViewController.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/2/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALPValidator;

@interface CreateAccountViewController : UIViewController


//IBOutlets
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordField;

@property (weak, nonatomic) IBOutlet UIImageView *imgEmailValidator;
@property (weak, nonatomic) IBOutlet UIImageView *imgPassValidator;

@property (weak, nonatomic) IBOutlet UIImageView *imgRePassValidator;



//IBAction
- (IBAction)setValidatorRePassword:(id)sender;
- (IBAction)createAccountAction:(id)sender;
- (IBAction)cancelAction:(id)sender;





@end
