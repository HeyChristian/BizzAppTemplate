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
#import "UIViewController+KNSemiModal.h"
#import "InstructionsProfileViewController.h"
#import "ChangePasswordViewController.h"

@interface ProfileViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextFieldDelegate>{
    
    bool updateProfileImage;
    MRProgressOverlayView *activityIndicatorView;
    bool firstLoad;
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
    [self loadUser];
    
    updateProfileImage=false;
    
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    activityIndicatorView = [MRProgressOverlayView new];
    activityIndicatorView.titleLabelText = @"updating...";
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
    
 
    
    self.nameField.delegate=self;
    self.lastNameField.delegate=self;
    self.companyField.delegate=self;
    self.mobileField.delegate=self;
    self.workField.delegate=self;
    self.extensionField.delegate=self;
    
    instructionView = [[InstructionsProfileViewController alloc] initWithNibName:@"InstructionsProfileViewController" bundle:nil];
    changePasswordView = [[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:nil];
    
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
    
    
   // ChangePasswordViewController *semiview = [[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:nil];
    
    
    [self presentSemiViewController:changePasswordView withOptions:@{
                                                               KNSemiModalOptionKeys.pushParentBack    : @(YES),
                                                               KNSemiModalOptionKeys.animationDuration : @(0.5),
                                                               KNSemiModalOptionKeys.shadowOpacity     : @(0.9),
                                                               }];
    
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
    
    
    UIImage *original = info[UIImagePickerControllerEditedImage]; //info[UIImagePickerControllerOriginalImage];
  
    
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
    
    
    NSString *firstname = [self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lastname = [self.lastNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *company= [self.companyField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *mobile= [self.mobileField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *work= [self.mobileField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *ext= [self.mobileField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   // NSString *email= [mobileField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
   /*
    PFUser *user = [PFUser currentUser];
    user[@"Firstname"]=firstname;
    user[@"LastName"]=lastname;
    user[@"Company"]=company;
    user[@"Mobile"]=mobile;
    user[@"Work"]=work;
    user[@"WorkExt"]=ext;
    */
    
    [[PFUser currentUser] setObject:firstname forKey:@"Firstname"];
    [[PFUser currentUser] setObject:lastname forKey:@"LastName"];
    [[PFUser currentUser] setObject:company forKey:@"Company"];
    [[PFUser currentUser] setObject:mobile forKey:@"Mobile"];
    [[PFUser currentUser] setObject:work forKey:@"Work"];
    [[PFUser currentUser] setObject:ext forKey:@"WorkExt"];
    
    
    if (updateProfileImage){
        

        NSData *imageData =UIImagePNGRepresentation(self.profileImageView.image);
        
        self.file = [PFFile fileWithName:@"Image.png" data:imageData];
        [self.file save];
   
        [[PFUser currentUser] setObject:self.file forKey:@"Image"];
        
       // user[@"Image"]=self.file;
        
    }
    
    
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
       
        [activityIndicatorView hide:YES];
        
        if(error){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
        }else{
            
            [[PFUser currentUser] refresh];
            updateProfileImage=false;
        }
        
    }];
  
}

- (void)loadUser {
    PFUser *user = [PFUser currentUser];
    
    PFFile *imageFile = [user objectForKey:@"Image"];
    NSLog(@"Image Data URL: %@",imageFile.url);
    
    
    NSLog(@"Object ID: %@",user.objectId);
    
    self.nameField.text = [user objectForKey:@"Firstname"];
    self.lastNameField.text = [user objectForKey:@"LastName"];
    self.companyField.text = [user objectForKey:@"Company"];
    self.mobileField.text = [user objectForKey:@"Mobile"];
    self.workField.text = [user objectForKey:@"Work"];
    self.extensionField.text = [user objectForKey:@"WorkExt"];
    self.emailField.text = [user objectForKey:@"email"];

    
    if([self.nameField.text length]==0 || [self.lastNameField.text length]==0 || [self.companyField.text length]==0){
        [self presentSemiViewController:instructionView withOptions:@{
                                                                   KNSemiModalOptionKeys.pushParentBack    : @(YES),
                                                                   KNSemiModalOptionKeys.animationDuration : @(0.5),
                                                                   KNSemiModalOptionKeys.shadowOpacity     : @(1.0),
                                                                   }];
    }
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:user.objectId];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            PFUser *u = objects[0];
            
            PFFile *imageFile = [u objectForKey:@"Image"];
            NSLog(@"Image Data URL: %@",imageFile.url);
            if(imageFile.url != nil){
                
                NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
                NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
                self.profileImageView.image = [UIImage imageWithData:imageData];
             
            }else{
                self.profileImageView.image=[UIImage imageNamed:@"profile2"];
            }
            
            
            self.nameField.text = [user objectForKey:@"Firstname"];
            self.lastNameField.text = [user objectForKey:@"LastName"];
            self.companyField.text = [user objectForKey:@"Company"];
            self.mobileField.text = [user objectForKey:@"Mobile"];
            self.workField.text = [user objectForKey:@"Work"];
            self.extensionField.text = [user objectForKey:@"WorkExt"];
            self.emailField.text = [user objectForKey:@"email"];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
   
    [self.view endEditing:YES];
}

@end
