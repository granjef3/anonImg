//
//  SecondViewController.m
//  AnonImg
//
//  Created by iD Student on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController
@synthesize imgPreview = _imgPreview;
@synthesize tagAlert = _tagAlert;
@synthesize titleAlert = _titleAlert;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self uploadImg:[NSArray arrayWithObjects:@"file", @"json",nil]];
}

- (void)viewDidUnload
{;
    [self setImgPreview:nil];
    [self setTagAlert:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main   .
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    camImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.imgPreview setImage:camImg];
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)takePicture:(id) sender 
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else 
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    
    [self presentModalViewController:imagePicker animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (UIInterfaceOrientationIsPortrait(UIInterfaceOrientationPortrait));
}

//fun stuff to upload things to internet!
- (void)uploadImg:(NSArray *)tags
{
    NSString *urlString = @"http://b0ss.me/iServ/pushData.php";
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tags options:kNilOptions error:nil];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    //Add content-type to Header. Need to use a string boundary for data uploading.
    NSString *boundary = [NSString stringWithString:@"0xKhTmLbOuNdArY"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //create the post body
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    
    [body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"json\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@", [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding]] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSData *imageData = UIImageJPEGRepresentation(camImg, 0.7);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@.jpeg\"\r\n", titleStr] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(returnString);
}


- (IBAction)editTags:(id)sender 
{
    self.tagAlert = [[UIAlertView alloc] initWithTitle:@"Tags" message:@"Separate tags with commas." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [self.tagAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[self.tagAlert textFieldAtIndex:0] setDelegate:self];
    [self tagAlert].tag = 0;
    [self.tagAlert show];  
}

- (IBAction)editTitle:(id)sender 
{
    self.titleAlert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"Enter the title of your image." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [self.titleAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[self.titleAlert textFieldAtIndex:0] setDelegate:self];
    [self titleAlert].tag = 1;
    [self.titleAlert show];  
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView.tag == 0)
    {
        NSString *inputText = [[alertView textFieldAtIndex:0] text];
        NSRange rangeValue = [inputText rangeOfString:@"," options:NSCaseInsensitiveSearch];
        if (rangeValue.length > 0)
        {
            return YES;
        } 
        else 
        {
            return NO;
        }
    }
    else
    {
        return YES;
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 0)
    {
        if(buttonIndex == 1)
        {
            tagStr = [alertView textFieldAtIndex:0].text;
        }
    }
    else if(alertView.tag == 1)
    {
        if(buttonIndex == 1)
        {
            titleStr = [alertView textFieldAtIndex:0].text;
        }
    }
}


- (IBAction)shareImg:(id)sender 
{
    NSArray *array = [tagStr componentsSeparatedByString: @","];
    [self uploadImg:array];
}
@end
