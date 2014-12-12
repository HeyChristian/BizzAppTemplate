//
//  InstructionsProfileViewController.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/7/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "InstructionsProfileViewController.h"
#import "UIViewController+KNSemiModal.h"
@interface InstructionsProfileViewController ()

@end

@implementation InstructionsProfileViewController
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)DismissAction:(id)sender {
    [self dismissSemiModalView];
}


- (IBAction)closeAction:(id)sender {
}
@end
