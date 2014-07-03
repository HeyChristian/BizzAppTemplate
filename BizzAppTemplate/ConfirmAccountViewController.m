//
//  ConfirmAccountViewController.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/2/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "ConfirmAccountViewController.h"
#import <Parse/Parse.h>

@interface ConfirmAccountViewController ()<UIAlertViewDelegate>

@end

@implementation ConfirmAccountViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)reSendEmailVerification:(id)sender {
      NSLog(@"Not implemented yet.");
}

- (IBAction)refresh:(id)sender {
    
    PFUser *currentUser = [PFUser currentUser];
    
    if([[currentUser objectForKey:@"emailVerified"] boolValue]){
        
       //  [self.navigationController popToRootViewControllerAnimated:YES];
        [self performSegueWithIdentifier:@"homeView" sender:nil];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                            message:@"The account has not been confirmed yet. confirmed in the junk mail, to be sure."
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }


}

- (IBAction)enterByGuest:(id)sender {
    [PFUser logOut];
    [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (error) {
            
            NSLog(@"Anonymous login failed.");
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                                message:@"For now, the administration does not allow anonymous entries guests, please register to continue."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
            
            
        
        } else {
        
            [self performSegueWithIdentifier:@"homeView" sender:nil];
         //  [self.navigationController popToRootViewControllerAnimated:YES];
        
        }
    }];
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            [self performSegueWithIdentifier:@"loginView" sender:nil];
            break;
            
        default:
            break;
    }
}
@end
