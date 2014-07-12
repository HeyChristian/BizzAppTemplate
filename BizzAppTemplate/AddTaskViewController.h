//
//  AddTaskViewController.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/10/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AddTaskDelegate <NSObject>
@optional
- (void) updateTaskNoteList:(NSDate *)date andNote:(NSString *)note;
@end

@interface AddTaskViewController : UIViewController{
    BOOL isNew;
}

@property (weak, nonatomic) IBOutlet UITextView *noteField;
@property (nonatomic, assign) id<AddTaskDelegate>delegate; //create a delegate

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property BOOL isNew;
@property (strong,nonatomic)NSString *note;

- (IBAction)AddAction:(id)sender;
- (IBAction)CancelAction:(id)sender;

@end
