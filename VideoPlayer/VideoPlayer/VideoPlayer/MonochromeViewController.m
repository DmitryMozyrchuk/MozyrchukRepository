//
//  MonochromeViewController.m
//  VideoPlayer
//
//  Created by Student Student on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MonochromeViewController.h"
#import "Filter.h"
#import "VideoConverter.h"

@interface MonochromeViewController ()
static UIImage *shrinkImage(UIImage *original, CGSize size);

@end

@implementation MonochromeViewController

@synthesize sliderBlue;
@synthesize sliderGreen;
@synthesize sliderRed;
@synthesize returnButton;
@synthesize imageView;
@synthesize img;
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

-(void)IntensityChange:(id)sender{
    imageView.image = [Filter makeMonochromeImage:self.selfImage withRedColor:sliderRed.value greenColor:sliderGreen.value blueColor:sliderBlue.value];
}

- (void)viewDidLoad
{
    if (typeOfMedia == 0) {
        self.selfImage = shrinkImage(self.img, imageView.frame.size);
        self.imageView.image = [Filter makeMonochromeImage:self.selfImage withRedColor:sliderRed.value greenColor:sliderGreen.value blueColor:sliderBlue.value];
    }
    else {
        array = [VideoConverter convertVideoToImageArray:self.movieURL];
        self.selfImage = shrinkImage([array objectAtIndex:0], imageView.frame.size);
        self.imageView.image = [Filter makeMonochromeImage:self.selfImage withRedColor:sliderRed.value greenColor:sliderGreen.value blueColor:sliderBlue.value];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"ApplyMonochromeSegue"]) {
        if (typeOfMedia == 0) {
            self.img = [Filter makeMonochromeImage:self.selfImage withRedColor:sliderRed.value greenColor:sliderGreen.value blueColor:sliderBlue.value];
            UIImageWriteToSavedPhotosAlbum(self.img, nil, nil, nil);
        }
        else {
            NSMutableArray *resultArray = [[NSMutableArray alloc] init];
            for (int i = 0; i< array.count; i++) {
                UIImage *filteredImage = [Filter makeMonochromeImage:self.selfImage withRedColor:sliderRed.value greenColor:sliderGreen.value blueColor:sliderBlue.value];
                [resultArray addObject:filteredImage];
            }
            [VideoConverter writeImageAsMovie:resultArray size:[self.view frame].size duration:array.count];
            
        }
        //[[segue destinationViewController] viewWillAppear:YES];
    }
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



@end
