//
//  InsertImageViewController.m
//  VideoPlayer
//
//  Created by Student Student on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InsertImageViewController.h"
#import "VideoConverter.h"

@interface InsertImageViewController ()
-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType;

@end

@implementation InsertImageViewController

@synthesize scrollView;
@synthesize videoPath;
@synthesize zoomedImageView;
@synthesize deleteFrameButton;
@synthesize lastChosenMediaType;
@synthesize selfImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{ 
    width = self.scrollView.frame.size.width / 3;
    array = [VideoConverter convertVideoToImageArray:self.videoPath];
    [self FillTheScrollView];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)showTapMenu:(UITapGestureRecognizer *)sender{
    self.zoomedImageView.image = [array objectAtIndex:[sender.view tag]];
    tag = [sender.view tag];
    [self FillTheScrollView];
    
}

-(void)FillTheScrollView{
    NSArray* subviews = [NSArray arrayWithArray:self.scrollView.subviews];
    for (UIView* view in subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    float x = 0;
    UITapGestureRecognizer *taprecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showTapMenu:)];
    CGSize contentSize = CGSizeMake(width * [array count] + [array count]*10, 138);
    [self.scrollView setContentSize:contentSize];
    CGRect frame = CGRectMake(0, 0, width, self.scrollView.frame.size.height);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setUserInteractionEnabled:YES];
    [imageView addGestureRecognizer:taprecognizer];
    [imageView setTag:0];
    imageView.image = [array objectAtIndex:0];
    [self.scrollView addSubview:imageView];
    for (int i =1; i < array.count; i++) {
        UITapGestureRecognizer *_taprecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showTapMenu:)]; 
        CGRect frame = CGRectMake(x + width + 10, 0, width, self.scrollView.frame.size.height);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView setUserInteractionEnabled:YES];
        [imageView setTag:i];
        [imageView addGestureRecognizer:_taprecognizer];
        imageView.image = [array objectAtIndex:i];
        [self.scrollView addSubview:imageView];
        x = x + width + 10;
    }
}

-(void)deleteFrame:(id)sender{
    if (self.zoomedImageView.image != NULL) {
        [array removeObjectAtIndex:tag];
    }
    [self FillTheScrollView];
    self.zoomedImageView.image = NULL;
}

-(void)AddFrame:(id)sender{
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UIIMagePickerController delegate methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.lastChosenMediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
        self.selfImage = [info objectForKey:UIImagePickerControllerEditedImage];
        [array insertObject:self.selfImage atIndex:tag+1];
        [self FillTheScrollView];
    }
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType{
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediaTypes count] > 0) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES]; 
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error accessing media" 
                                                        message:@"Device doesn't support this media source" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"Cancel" 
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqual:@"ApplyEditingSegue"]) {
        [VideoConverter writeImageAsMovie:array size:[self.view frame].size duration:array.count];
    }
}
@end
