//
//  CameraViewController.h
//  VideoPlayer
//
//  Created by Student Student on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <Assetslibrary/AssetsLibrary.h>
#import <CoreImage/CoreImage.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreMedia/CoreMedia.h>

@interface CameraViewController : UIViewController
<UIImagePickerControllerDelegate, UINavigationBarDelegate>{
    UIImageView *imageView;
    UIButton *takePictureButton;
    UIButton *filterButton;
    UIButton *takePictureFromLibrary;
    UIButton *insertImageToVideoButton;
    UIButton *liveFiltersButton;
    MPMoviePlayerController *moviePlayerController;
    UIImage *img;
    NSURL *movieURL;
    NSString *lastChosenMediaType;
    CGRect imageFrame;
    int typeOfMedia;
    
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *takePictureButton;
@property (nonatomic, retain) IBOutlet UIButton *filterButton;
@property (nonatomic, retain) IBOutlet UIButton *takePictureFromLibrary;
@property (nonatomic, retain) IBOutlet UIButton *insertImageToVideoButton;
@property (nonatomic, retain) IBOutlet UIButton *liveFiltersButton;
@property (nonatomic, retain) IBOutlet MPMoviePlayerController *moviePlayerController;
@property (nonatomic, retain) UIImage *img;
@property (nonatomic, retain) NSURL *movieURL;
@property (nonatomic, retain) NSString *lastChosenMediaType;

-(IBAction)shootPictureOrVideo:(id)sender;
-(IBAction)selectExistingPictureOrVideo:(id)sender;
-(IBAction)canceled:(id)sender;

@end
