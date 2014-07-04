//
//  SecurityHomeViewController.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/2/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "SecurityHomeViewController.h"
#import <Parse/Parse.h>
#import "HomeViewController.h"
#import "MenuNavigationController.h"
#import "UIViewController+REFrostedViewController.h"
#import "REFrostedViewController.h"


@interface SecurityHomeViewController ()

@end

@implementation SecurityHomeViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
   
    
    
    /*
    PFACL *roleACL = [PFACL ACL];
    [roleACL setPublicReadAccess:YES];
    [roleACL setPublicWriteAccess:YES];
    PFRole *role = [PFRole roleWithName:@"Administrator" acl:roleACL];
    [role saveInBackground];
    
    
    role = [PFRole roleWithName:@"General" acl:roleACL];
    [role saveInBackground];
    */
    
    
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

- (IBAction)loginGuestAction:(id)sender {
    
    [PFUser logOut];
    [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (error) {
            
            NSLog(@"Anonymous login failed.");
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                                message:@"For now, the administration does not allow anonymous entries guests, please register to continue."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
            
            
            
        } else {
            
         //   [self performSegueWithIdentifier:@"homeView" sender:nil];
             [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
    }];
    
}
@end
