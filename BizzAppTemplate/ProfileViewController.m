//
//  ProfileViewController.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/4/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "ProfileViewController.h"
#import "MenuNavigationController.h"
#import <Parse/Parse.h>

@interface ProfileViewController ()

@end

@implementation ProfileViewController



- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationItem.title  = @"Profile";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
   
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu48"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(MenuNavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    
    
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
  //  self.tableView.opaque = NO;
   // self.tableView.backgroundColor = [UIColor clearColor];
    
    
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = 50.0;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.layer.borderWidth = 3.0f;
    self.profileImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.profileImageView.layer.shouldRasterize = YES;
    self.profileImageView.clipsToBounds = YES;
    
    /*
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        self.profileImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        self.profileImageView.image = [UIImage imageNamed:@"profile2"];
        self.profileImageView.layer.masksToBounds = YES;
        self.profileImageView.layer.cornerRadius = 50.0;
       self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.profileImageView.layer.borderWidth = 3.0f;
        self.profileImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.profileImageView.layer.shouldRasterize = YES;
        self.profileImageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        
        PFUser *user  = [PFUser currentUser];
        
        NSString *name = user[@"name"];
        NSString *last = user[@"lastn"];
        
        NSString *displayName;
        
        if([name length]>0)
            displayName = [NSString stringWithFormat:@"%@ %@",name,last];
        else
            displayName = user[@"email"];
        
        
        label.text = displayName;
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });*/
}

@end
