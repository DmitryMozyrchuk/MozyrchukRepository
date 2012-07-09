//
//  MonochromeViewController.h
//  VideoPlayer
//
//  Created by Student Student on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonochromeViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UISlider *sliderRed;
@property (nonatomic, retain) IBOutlet UISlider *sliderGreen;
@property (nonatomic, retain) IBOutlet UISlider *sliderBlue;
@property (nonatomic, retain) UIImage *img;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *returnButton;
@property (nonatomic, retain) UIImage *selfImage;

-(IBAction)IntensityChange:(id)sender;

@end
