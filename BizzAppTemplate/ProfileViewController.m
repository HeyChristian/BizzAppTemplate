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
#import "MRProgress.h"
#import "Tools.h"

@interface ProfileViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextFieldDelegate>{
    bool updateProfileImage;
     MRProgressOverlayView *activityIndicatorView;
}

@property (nonatomic,strong) PFFile *file;
@property (nonatomic,strong) UIImage *pickedImage;
@end

@implementation ProfileViewController



- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationItem.title  = @"Profile";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu48"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(MenuNavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];


    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                             style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(update)];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    updateProfileImage=false;
    
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
   
    
    activityIndicatorView = [MRProgressOverlayView new];
    activityIndicatorView.titleLabelText = @"";
    [self.tableView addSubview:activityIndicatorView];
    
    //activityIndicatorView.modeView = self.view;
   //[MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = 50.0;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.layer.borderWidth = 3.0f;
    self.profileImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.profileImageView.layer.shouldRasterize = YES;
    self.profileImageView.clipsToBounds = YES;
    
   
}

#pragma mark - IBActions
- (IBAction)uploadProfile:(id)sender {
    
    //if device have camera
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [self promptForSource];
        
    }else{
        [self promptForPhotoRoll];
    }
    
}

- (IBAction)changePasswordAction:(id)sender {
}
-(void) promptForSource{
    UIActionSheet *actionSheed = [[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Roll", nil];
    
    [actionSheed showInView:self.view];
    
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex != actionSheet.cancelButtonIndex){
        if(buttonIndex != actionSheet.firstOtherButtonIndex){
            
            [self promptForPhotoRoll];
            
        }else{
            
            [self promptForCamera];
        }
    }
}

-(void)promptForCamera{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    controller.allowsEditing = YES;
    [self presentViewController:controller animated:YES completion:nil];
    
}

-(void)promptForPhotoRoll{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.allowsEditing =  YES;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    
}

-(void) setPickedImage:(UIImage *)pickedImage{
    _pickedImage = pickedImage;
    if(pickedImage == nil){
        self.profileImageView.image  = [UIImage imageNamed:@"profile2"];
    }else{
        self.profileImageView.image = pickedImage;
    }
}
#pragma mark - Image Picker
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    UIImage *original =  info[UIImagePickerControllerOriginalImage];
  
    
    self.profileImageView.image = [Tools imageWithImage:original scaledToWidth:200];
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;

    
    updateProfileImage=true;
    [picker dismissViewControllerAnimated:YES completion:NO];

    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];

}


-(void)update{
   
   // [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    [activityIndicatorView show:YES];
    
    
    NSString *firstname = [nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lastname = [lastNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *company= [companyField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *mobile= [mobileField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *work= [mobileField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *ext= [mobileField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   // NSString *email= [mobileField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    
    PFUser *user = [PFUser currentUser];
    
    user[@"Firstname"]=firstname;
    user[@"LastName"]=lastname;
    user[@"Company"]=company;
    user[@"Mobile"]=mobile;
    user[@"Work"]=work;
    user[@"WorkExt"]=ext;
    
    
    
    if (updateProfileImage){
        

        NSData *imageData =UIImagePNGRepresentation(self.profileImageView.image);
        
        self.file = [PFFile fileWithName:@"Image.png" data:imageData];
        [self.file save];
        
        user[@"Image"]=self.file;
        
    }
    
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
       // [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
        [activityIndicatorView hide:YES];
        
        if(error){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
        }else{
            updateProfileImage=false;
        }
        
    }];
  
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
@end
