//
//  SepiaViewController.h
//  VideoPlayer
//
//  Created by Student Student on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SepiaViewController : UIViewController{
    UIImage *img;
    int typeOfMedia;
    NSMutableArray *array;
    NSURL *movieURL;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UISlider *slider;
@property (nonatomic, retain) UIImage *img;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *returnButton;
@property (nonatomic, retain) UIImage *selfImage;
@property (nonatomic, assign) int typeOfMedia;
@property (nonatomic, retain) NSMutableArray *array;
@property (nonatomic, retain) NSURL *movieURL;

-(IBAction)changeIntensity:(id)sender;
-(IBAction)applyResult:(id)sender;

@end
