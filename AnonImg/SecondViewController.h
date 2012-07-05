//
//  SecondViewController.h
//  AnonImg
//
//  Created by iD Student on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
    UIImage *camImg;
    NSString *tagStr;
    NSString *titleStr;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgPreview;
@property (strong, nonatomic) UIAlertView *tagAlert;
@property (strong, nonatomic) UIAlertView *titleAlert;

- (IBAction)editTags:(id)sender;
- (IBAction)editTitle:(id)sender;
- (IBAction)takePicture:(id)sender;
- (IBAction)shareImg:(id)sender;


@end
