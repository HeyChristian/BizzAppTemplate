//
//  ProfileViewController.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/4/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UITableViewController{
    
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *lastNameField;
    __weak IBOutlet UITextField *companyField;
    __weak IBOutlet UITextField *mobileField;
    __weak IBOutlet UITextField *workField;
    __weak IBOutlet UITextField *extensionField;
    __weak IBOutlet UITextField *emailField;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;


- (IBAction)uploadProfile:(id)sender;
- (IBAction)changePasswordAction:(id)sender;


@end
