//
//  LiveFiltersViewController.h
//  VideoPlayer
//
//  Created by Student Student on 13.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import "AssetsLibrary/AssetsLibrary.h"




@interface LiveFiltersViewController : UIViewController{
    GPUImageVideoCamera *videoCamera;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageMovieWriter *movieWriter;
    NSString *pathToMovie;
    int type;
    NSString *filterType;
}

@property (nonatomic, retain) IBOutlet UISlider *slider;
@property (nonatomic, retain) IBOutlet UIButton *startButton;
@property (nonatomic, retain) NSString *filterType;
- (IBAction)updateSliderValue:(id)sender;
-(IBAction)pushStartButton:(id)sender;
-(IBAction)pushBackButton:(id)sender;


@end
