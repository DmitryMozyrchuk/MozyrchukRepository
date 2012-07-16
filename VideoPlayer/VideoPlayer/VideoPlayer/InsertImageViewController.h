//
//  InsertImageViewController.h
//  VideoPlayer
//
//  Created by Student Student on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsertImageViewController : UIViewController<UIScrollViewDelegate, UIImagePickerControllerDelegate>{
    UIScrollView *scrollView;
    UIButton *deleteFrameButton;
    NSURL *videoPath;
    NSMutableArray *array;
    UIImageView *zoomedImageView;
    float width;
    int tag;
    NSString *lastChosenMediaType;
    UIImage *selfImage;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSURL *videoPath;
@property (nonatomic, retain) IBOutlet UIImageView *zoomedImageView;
@property (nonatomic, retain) IBOutlet UIButton *deleteFrameButton;
@property (nonatomic, retain) NSString *lastChosenMediaType;
@property (nonatomic, retain) UIImage *selfImage;

-(void)FillTheScrollView;
-(IBAction)deleteFrame:(id)sender;
-(IBAction)AddFrame:(id)sender;

@end
