//
//  LiveFiltersViewController.m
//  VideoPlayer
//
//  Created by Student Student on 13.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LiveFiltersViewController.h"

@interface LiveFiltersViewController ()

@end

@implementation LiveFiltersViewController

@synthesize startButton;
@synthesize slider;
@synthesize filterType;

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
    [super viewDidLoad];
    type = 0;
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    if ([self.filterType isEqualToString:@"SepiaFilter"]) {
        filter = [[GPUImageSepiaFilter alloc] init];
    }
    else if ([self.filterType isEqualToString:@"PixellateFilter"]) {
        filter = [[GPUImagePixellateFilter alloc] init];
        self.slider.maximumValue = 0.1f;
    }
    else if ([self.filterType isEqualToString:@"GaussianBlurFilter"]){
        filter = [[GPUImageGaussianBlurFilter alloc] init];
    }
    else if ([self.filterType isEqualToString:@"PosterizeFilter"]){
        filter = [[GPUImagePosterizeFilter alloc] init];
        self.slider.maximumValue = 30.0f;
        self.slider.minimumValue = 1.0f;
    }
    else if ([self.filterType isEqualToString:@"SketchFilter"]){
        filter = [[GPUImageSketchFilter alloc] init];
        self.slider.hidden = YES;
    }
    else if ([self.filterType isEqualToString:@"GrayScaleFilter"]){
        filter = [[GPUImageGrayscaleFilter alloc] init];
        self.slider.hidden = YES;
    }
    else if ([self.filterType isEqualToString:@"ColorInvertFilter"]) {
        filter = [[GPUImageColorInvertFilter alloc] init];
        self.slider.hidden = YES;
    }
    else if ([self.filterType isEqualToString:@"SharpenFilter"]) {
        filter = [[GPUImageSharpenFilter alloc] init];
        self.slider.minimumValue = -4.0f;
        self.slider.maximumValue = 4.0f;
    }
    else if ([self.filterType isEqualToString:@"SaturationFilter"]) {
        filter = [[GPUImageSaturationFilter alloc] init];
        self.slider.maximumValue = 2.0f;
    }
    else if ([self.filterType isEqualToString:@"MonochromeFilter"]) {
        filter = [[GPUImageMonochromeFilter alloc] init];
    }
    else if ([self.filterType isEqualToString:@"LuminanceThresholdFilter"]) {
        filter = [[GPUImageLuminanceThresholdFilter alloc] init];
    }
    [videoCamera addTarget:filter];
    GPUImageView *filterView = (GPUImageView *)self.view;
    [filter addTarget:filterView];
    NSDate *today=[NSDate date];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
	[dateFormat setDateFormat:@"MM_dd_yyyy_HH_mm_ss"];
	NSString *dateString = [dateFormat stringFromDate:today];
    NSString *endPath = [NSString stringWithFormat:@"Documents/Movie%@.m4v", dateString];
    pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:endPath];
    unlink([pathToMovie UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0)];
    [filter addTarget:movieWriter];
    [videoCamera startCameraCapture];
	// Do any additional setup after loading the view.
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

- (IBAction)updateSliderValue:(id)sender
{
    if ([self.filterType isEqualToString:@"SepiaFilter"]) {
        [(GPUImageSepiaFilter *)filter setIntensity:[(UISlider *)sender value]];
    }
    else if ([self.filterType isEqualToString:@"PixellateFilter"]){
        [(GPUImagePixellateFilter *)filter setFractionalWidthOfAPixel:[(UISlider *)sender value]];
    }
    else if ([self.filterType isEqualToString:@"GaussianBlurFilter"]){
        [(GPUImageGaussianBlurFilter *)filter setBlurSize:[(UISlider *)sender value]];
    }
    else if ([self.filterType isEqualToString:@"PosterizeFilter"]) {
        [(GPUImagePosterizeFilter *)filter setColorLevels:(int)[(UISlider *)sender value]];
        NSLog(@"%d",(int)[(UISlider *)sender value]);
    }
    else if ([self.filterType isEqualToString:@"SketchFilter"]){
        [(GPUImageSketchFilter *)filter setTexelHeight:[(UISlider *)sender value]];
        [(GPUImageSketchFilter *)filter setTexelWidth:[(UISlider *)sender value]];
    }
    else if ([self.filterType isEqualToString:@"SharpenFilter"]) {
        [(GPUImageSharpenFilter *)filter setSharpness:[(UISlider *)sender value]];
    }
    else if ([self.filterType isEqualToString:@"SaturationFilter"]) {
        [(GPUImageSaturationFilter *)filter setSaturation:[(UISlider *)sender value]];
    }
    else if ([self.filterType isEqualToString:@"MonochromeFilter"]) {
        [(GPUImageMonochromeFilter *)filter setIntensity:[(UISlider *)sender value]];
    }
    else if ([self.filterType isEqualToString:@"LuminanceThresholdFilter"]) {
        [(GPUImageLuminanceThresholdFilter *)filter setThreshold:[(UISlider *)sender value]];
    }
}

-(void)pushStartButton:(id)sender{
    if (type == 0) {
        videoCamera.audioEncodingTarget = movieWriter;
        [movieWriter startRecording];
        type = 1;
    }
    else {
        [filter removeTarget:movieWriter];
        videoCamera.audioEncodingTarget = nil;
        [movieWriter finishRecording];
        NSLog(@"Movie completed");
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:[NSURL fileURLWithPath:pathToMovie]])
        {
            [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:pathToMovie] completionBlock:^(NSURL *assetURL, NSError *error){}];
        }
        [videoCamera stopCameraCapture];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)pushBackButton:(id)sender{
    [videoCamera stopCameraCapture];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
