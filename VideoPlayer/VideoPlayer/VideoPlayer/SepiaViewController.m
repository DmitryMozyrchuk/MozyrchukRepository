//
//  SepiaViewController.m
//  VideoPlayer
//
//  Created by Student Student on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SepiaViewController.h"
#import "Filter.h"
#import "CameraViewController.h"
#import "VideoConverter.h"

@interface SepiaViewController ()
static UIImage *shrinkImage(UIImage *original, CGSize size);

@end

@implementation SepiaViewController

@synthesize img;
@synthesize imageView;
@synthesize slider;
@synthesize returnButton;
@synthesize selfImage;
@synthesize typeOfMedia;
@synthesize array;
@synthesize movieURL;

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
    if (typeOfMedia == 0) {
        self.selfImage = shrinkImage(self.img, imageView.frame.size);
        self.imageView.image = [Filter makeSepiaWithImage:self.selfImage andIntencity:slider.value];
    }
    else {
        array = [VideoConverter convertVideoToImageArray:self.movieURL];
        self.selfImage = shrinkImage([array objectAtIndex:0], imageView.frame.size);
        self.imageView.image = [Filter makeSepiaWithImage:self.selfImage andIntencity:slider.value];
    }
    
    [super viewDidLoad];
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


-(void)changeIntensity:(id)sender{
    imageView.image = [Filter makeSepiaWithImage:self.selfImage andIntencity:slider.value];
}

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

-(void)applyResult:(id)sender{
    self.imageView.image = [Filter makeSepiaWithImage:self.selfImage andIntencity:slider.value];
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"ApplySepiaSegue"]) {
        if (typeOfMedia == 0) {
            self.img = [Filter makeSepiaWithImage:self.img andIntencity:slider.value];
            UIImageWriteToSavedPhotosAlbum(self.img, nil, nil, nil);
        }
        else {
            NSMutableArray *resultArray = [[NSMutableArray alloc] init];
            for (int i = 0; i< array.count; i++) {
                UIImage *filteredImage = [Filter makeSepiaWithImage:[array objectAtIndex:i] andIntencity:slider.value];
                [resultArray addObject:filteredImage];
            }
            [VideoConverter writeImageAsMovie:resultArray size:[self.view frame].size duration:array.count];
            
        }
    }
}

@end
