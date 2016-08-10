//
//  SecondViewController.m
//  PhotoApp
//
//  Created by Jo Tu on 7/30/16.
//  Copyright © 2016 Turn To Tech. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
- (IBAction)takePhoto:(id)sender;
- (IBAction)selectPhoto:(id)sender;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dao = [DAO sharedManager];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhoto:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSLog(@"picked library bc camera aint avail");
        
    }
    else{
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)selectPhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:NULL];

    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 1); //got help on this method ~THEKAUSH
    
    [self.dao uploadImagetoStorageUsingNSData:imageData fileName:[self uuidString]];
    self.tabBarController.selectedIndex = 0;

    
}
     

- (NSString *)uuidString {
         // Returns a UUID
         
         CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
         NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
         CFRelease(uuid);
         
         return uuidString;
     }



@end
