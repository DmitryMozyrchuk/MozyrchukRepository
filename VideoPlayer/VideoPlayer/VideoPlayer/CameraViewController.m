//
//  CameraViewController.m
//  VideoPlayer
//
//  Created by Student Student on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Assetslibrary/AssetsLibrary.h>
#import <CoreImage/CoreImage.h>
#import "FilterViewController.h"

@interface CameraViewController ()
static UIImage *shrinkImage(UIImage *original, CGSize size);
-(void)updateDisplay;
-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType;

@end

@implementation CameraViewController

@synthesize imageView;
@synthesize img;
@synthesize takePictureButton;
@synthesize moviePlayerController;
@synthesize movieURL;
@synthesize lastChosenMediaType;
@synthesize filterButton;
@synthesize takePictureFromLibrary;

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
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        takePictureButton.hidden = YES;
    }
    imageFrame = imageView.frame;
    //imageView.image = self.img;
    filterButton.hidden = YES;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateDisplay];
}

-(void)viewWillAppear:(BOOL)animated{
    [self updateDisplay];
}

- (void)viewDidUnload
{
    self.imageView = nil;
    self.takePictureButton = nil;
    self.moviePlayerController = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



-(void)shootPictureOrVideo:(id)sender{
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
    type = 1;
    filterButton.hidden = NO;
    takePictureButton.hidden = YES;
    takePictureFromLibrary.hidden = YES;
    
}

-(void)selectExistingPictureOrVideo:(id)sender{
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
    type = 0;
    filterButton.hidden = NO;
    takePictureButton.hidden = YES;
    takePictureFromLibrary.hidden = YES;
}

-(void)acceptFilters:(id)sender{
    FilterViewController *controller = [FilterViewController new];
    controller.image = self.img;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark UIImagePickerController delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.lastChosenMediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
        UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImage *shrunkenImage = shrinkImage(chosenImage, imageFrame.size);
        self.img = shrunkenImage;
    }
    else if ([lastChosenMediaType isEqual:(NSString *)kUTTypeMovie]) {
        self.movieURL = [info objectForKey:UIImagePickerControllerMediaURL];
    }
    if (type == 1) {
        if ([lastChosenMediaType isEqual:(NSString *)kUTTypeMovie]) {
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:self.movieURL])
            {
                [library writeVideoAtPathToSavedPhotosAlbum:self.movieURL completionBlock:^(NSURL *assetURL, NSError *error){}];
            } 
            
        }
        else if ([lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
            UIImageWriteToSavedPhotosAlbum(self.img, nil, nil, nil);	
        }
    }
[picker dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark -

static UIImage *shrinkImage(UIImage *original, CGSize size){
    CGFloat scale = [UIScreen mainScreen].scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef contex = CGBitmapContextCreate(NULL, size.width * scale, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(contex, CGRectMake(0, 0, size.width * scale, size.height), original.CGImage);
    CGImageRef shrunken = CGBitmapContextCreateImage(contex);
    UIImage *final = [UIImage imageWithCGImage:shrunken];
    
    CGContextRelease(contex);
    CGImageRelease(shrunken);
    return final;
    
}

-(void)updateDisplay{
    if ([lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
        imageView.image = img;
        imageView.hidden = NO;
        moviePlayerController.view.hidden = YES;
    }
    else if ([lastChosenMediaType isEqual:(NSString *)kUTTypeMovie]) {
        [self.moviePlayerController.view removeFromSuperview];
        self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
        moviePlayerController.view.frame = imageFrame;
        moviePlayerController.view.clipsToBounds = YES;
        [self.view addSubview:moviePlayerController.view];
        imageView.hidden =YES;
    }
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
        /*if (sourceType == 1) {
            
        }*/
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
    if ([[segue identifier] isEqualToString:@"FilterSegue"]) {
        [[segue destinationViewController] setImage:self.img];
    }
}



@end
