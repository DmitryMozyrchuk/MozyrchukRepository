//
//  CameraViewController.h
//  VideoPlayer
//
//  Created by Student Student on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface CameraViewController : UIViewController
<UIImagePickerControllerDelegate, UINavigationBarDelegate>{
    UIImageView *imageView;
    UIButton *takePictureButton;
    MPMoviePlayerController *moviePlayerController;
    UIImage *image;
    NSURL *movieURL;
    NSString *lastChosenMediaType;
    CGRect imageFrame;
    int type;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *takePictureButton;
@property (nonatomic, retain) IBOutlet MPMoviePlayerController *moviePlayerController;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSURL *movieURL;
@property (nonatomic, retain) NSString *lastChosenMediaType;

-(IBAction)shootPictureOrVideo:(id)sender;
-(IBAction)selectExistingPictureOrVideo:(id)sender;

@end
