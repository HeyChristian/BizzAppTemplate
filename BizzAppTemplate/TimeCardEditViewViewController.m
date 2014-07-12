//
//  TimeCardEditViewViewController.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/10/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "TimeCardEditViewViewController.h"
#import "TaskNotesViewController.h"
#import "Tools.h"
#import <Parse/Parse.h>

@interface TimeCardEditViewViewController ()<TaskNoteDelegate>

@end

@implementation TimeCardEditViewViewController


- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self bindTimeCard];
  
}
-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationItem.title  = @"Time Card";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    
    [self bindNotes:[self.timeCard objectForKey:@"objectId"]];
    

    
}
-(void)bindTimeCard{
    
    
    
    self.clientNameLabel.text = [[self.timeCard objectForKey:@"client"] capitalizedString];
    self.locationLabel.text =[NSString stringWithFormat:@"%@ \n%@ \n%@",[self.timeCard objectForKey:@"line1"],[self.timeCard objectForKey:@"line2"],[self.timeCard objectForKey:@"line3"]];
    
    self.checkinLabel.text =[NSString stringWithFormat:@"%@ - %@",[self.timeCard objectForKey:@"time_in"],[self.timeCard objectForKey:@"date_in"]];
    
    if([[self.timeCard objectForKey:@"date_out"] length]>0){
    
        self.checkoutLabel.text =[NSString stringWithFormat:@"%@  %@",[self.timeCard objectForKey:@"time_out"],[self.timeCard objectForKey:@"date_out"]];
        self.checkoutLabel.textColor = [UIColor blackColor];
    }else{
        self.checkoutLabel.text  = @"In Progress";
        
        self.checkoutLabel.textColor = [UIColor redColor];
        
    }
    
    self.taskDescription.text = [[self.timeCard objectForKey:@"description"] capitalizedString];
    [self bindNotes:[self.timeCard objectForKey:@"objectId"]];
    
  
}
-(void)bindNotes:(NSString *)objectId{
    
    // __block NSMutableDictionary *row = nil;
    PFQuery *qrynotes = [PFQuery queryWithClassName:@"TaskNote"];
    [qrynotes whereKey:@"TimeCard"
               equalTo:[PFObject objectWithoutDataWithClassName:@"TimeCard" objectId:objectId]];
    self.notes =  [[NSMutableArray alloc] initWithArray:[qrynotes findObjects]];
    
    self.countTaskNoteLabel.text = [NSString stringWithFormat:@" %lu entries",(unsigned long)[self.notes count]];
    
    
    //[[NSMutableArray alloc] init];
    
    /*
    NSArray *objects = [qrynotes findObjects];
    for (PFObject *object in objects) {
    
    }*/
    
    
    
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"taskNotes"]){
        
        TaskNotesViewController  *tasks = (TaskNotesViewController *) segue.destinationViewController;
        tasks.delegate =  self;
        tasks.objectId = [self.timeCard objectForKey:@"objectId"];
     
    }
    
}

-(void)updateTaskNoteList:(NSDate *)date andNote:(NSString *)note{
    
    NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
    [row setObject:date forKey:@"date"];
    [row setObject:note forKey:@"note"];
    [self.notes addObject:row];
    
    NSString *parentId =[self.timeCard objectForKey:@"objectId"];
    
    PFQuery *timec = [PFQuery queryWithClassName:@"TimeCard"];
    [timec whereKey:@"objectId" equalTo:parentId];
    
    
    PFObject *tnote = [PFObject objectWithClassName:@"TaskNote"];
    tnote[@"TimeCard"] = [[timec findObjects] objectAtIndex:0];
    tnote[@"note"] = note;
    tnote[@"date"] = date;
    [tnote save];
    
    [self bindNotes:parentId];
    
    self.countTaskNoteLabel.text = [NSString stringWithFormat:@" %lu entries",(unsigned long)[self.notes count]];
    
}

- (IBAction)checkOutAction:(id)sender {
    
}
@end
