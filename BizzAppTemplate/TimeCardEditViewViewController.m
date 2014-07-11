//
//  TimeCardEditViewViewController.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/10/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "TimeCardEditViewViewController.h"
#import "AddTaskViewController.h"

@interface TimeCardEditViewViewController ()<AddTaskDelegate>

@end

@implementation TimeCardEditViewViewController


- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
  
}
-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationItem.title  = @"Time Card";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.notes = [[NSMutableArray alloc] init];
    self.countTaskNoteLabel.text = [NSString stringWithFormat:@" %lu entries",(unsigned long)[self.notes count]];
    

    
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"taskNotes"]){
        
        AddTaskViewController  *add = (AddTaskViewController *) segue.destinationViewController;
        add.delegate =  self;
     
        
    }
    
}

-(void)updateTaskNoteList:(NSDate *)date andNote:(NSString *)note{
    
    NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
    [row setObject:date forKey:@"date"];
    [row setObject:note forKey:@"note"];
    [self.notes addObject:row];
    
    
    self.countTaskNoteLabel.text = [NSString stringWithFormat:@" %lu entries",(unsigned long)[self.notes count]];
    
}

- (IBAction)checkOutAction:(id)sender {
    
}
@end
