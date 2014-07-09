//
//  Tools.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/5/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "Tools.h"
#import <Parse/Parse.h>

@implementation Tools


+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+(NSString *)clearText:(UITextField *)field{
  
    return [field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
+(id) getSessionObject:(NSString *)key{
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];

}
+(void)setSessionObject:(NSString *)key andValue:(id)value{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setValue:value forKey:key];
    
}
+(void)setCurrentUserImageData{
    
    PFFile *imageFile = [[PFUser currentUser] objectForKey:@"Image"];
    NSLog(@"Image Data URL: %@",imageFile.url);
    if(imageFile.url != nil){
        
        NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
        NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
        
        [Tools setSessionObject:@"ProfileImage" andValue:imageData]; //[UIImage imageWithData:imageData]];
        
    }else{
        UIImage *img = [UIImage imageNamed:@"profile2"];
        [Tools setSessionObject:@"ProfileImage" andValue:UIImagePNGRepresentation(img)];

    }
}
+(UIImage *)getProfileImage{
    
    UIImage *img = [UIImage imageWithData:[Tools getSessionObject:@"ProfileImage"]];
    
    return img;
}
+(NSString *) formatDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d, yyyy"];
    
    return [dateFormatter stringFromDate:date];
    
}
@end
