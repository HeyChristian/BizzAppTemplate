//
//  ChangePasswordViewController.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/7/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController{

}



@property (weak, nonatomic) IBOutlet UIImageView *imgCurrentPassValidator;

@property (weak, nonatomic) IBOutlet UIImageView *imgNewPassValidator;

@property (weak, nonatomic) IBOutlet UIImageView *imgRepPassValidator;


@property (weak, nonatomic) IBOutlet UITextField *currentPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordField;


- (IBAction)updatePasswordAction:(id)sender;


@end
