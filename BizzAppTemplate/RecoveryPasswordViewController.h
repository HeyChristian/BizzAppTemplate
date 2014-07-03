//
//  RecoveryPasswordViewController.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/2/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecoveryPasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgRecoveryValidator;
@property (weak, nonatomic) IBOutlet UITextField *recoveryEmail;

- (IBAction)sendRecoveryAction:(id)sender;

- (IBAction)cancelAction:(id)sender;

@end
