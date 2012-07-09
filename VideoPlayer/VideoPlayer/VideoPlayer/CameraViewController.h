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
    UIButton *filterButton;
    UIButton *takePictureFromLibrary;
    MPMoviePlayerController *moviePlayerController;
    UIImage *img;
    NSURL *movieURL;
    NSString *lastChosenMediaType;
    CGRect imageFrame;
    int type;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *takePictureButton;
@property (nonatomic, retain) IBOutlet UIButton *filterButton;
@property (nonatomic, retain) IBOutlet UIButton *takePictureFromLibrary;
@property (nonatomic, retain) IBOutlet MPMoviePlayerController *moviePlayerController;
@property (nonatomic, retain) UIImage *img;
@property (nonatomic, retain) NSURL *movieURL;
@property (nonatomic, retain) NSString *lastChosenMediaType;

-(IBAction)shootPictureOrVideo:(id)sender;
-(IBAction)selectExistingPictureOrVideo:(id)sender;
-(IBAction)acceptFilters:(id)sender;

@end
