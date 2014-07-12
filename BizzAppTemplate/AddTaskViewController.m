//
//  AddTaskViewController.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/10/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "AddTaskViewController.h"
#import "UIViewController+KNSemiModal.h"
#import <Parse/Parse.h>

@interface AddTaskViewController () <UITextFieldDelegate>

@end

@implementation AddTaskViewController

@synthesize isNew;


- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Status View: %id", isNew);
    if(isNew){
        [self.noteField becomeFirstResponder];
        [self.noteField setEditable:YES];
        [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    }else{
        [self.noteField setEditable:NO];
        [self.titleLabel setText:@"Task note:"];
        [self.addButton setHidden:YES];
        [self.noteField setText:self.note];
        [self.cancelButton setTitle:@"Close" forState:UIControlStateNormal];
    }
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
}
- (IBAction)AddAction:(id)sender {

    if([self.noteField.text length]>0){
    
    [self.delegate updateTaskNoteList:[NSDate date] andNote:self.noteField.text];
    [self dismissSemiModalView];
    }else{
        [self showMessage:@"Oops!" andMessage:@"Task note is empty"];
    }
}
- (IBAction)CancelAction:(id)sender {
    [self dismissSemiModalView];
}

-(void)showMessage:(NSString *)title andMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}
@end
