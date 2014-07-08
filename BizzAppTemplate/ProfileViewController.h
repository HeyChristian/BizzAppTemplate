//
//  ProfileViewController.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/4/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InstructionsProfileViewController,ChangePasswordViewController;

@interface ProfileViewController : UITableViewController{
    
    InstructionsProfileViewController *instructionView;
    ChangePasswordViewController *changePasswordView;
    
}


@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *companyField;
@property (weak, nonatomic) IBOutlet UITextField *mobileField;
@property (weak, nonatomic) IBOutlet UITextField *workField;
@property (weak, nonatomic) IBOutlet UITextField *extensionField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;


@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;


- (IBAction)uploadProfile:(id)sender;
- (IBAction)changePasswordAction:(id)sender;


@end
