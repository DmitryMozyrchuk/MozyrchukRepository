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

@interface SepiaViewController ()
static UIImage *shrinkImage(UIImage *original, CGSize size);

@end

@implementation SepiaViewController

@synthesize img;
@synthesize imageView;
@synthesize slider;
@synthesize returnButton;
@synthesize selfImage;

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
    self.selfImage = shrinkImage(self.img, imageView.frame.size);
    self.imageView.image = [Filter makeSepiaWithImage:self.selfImage andIntencity:slider.value];
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
    self.img = [Filter makeSepiaWithImage:self.img andIntencity:slider.value];
    /*[[self.storyboard instantiateViewControllerWithIdentifier:@"23"] setImg:self.img];
    [self.navigationController popToRootViewControllerAnimated:YES];*/
    UIImageWriteToSavedPhotosAlbum(self.img, nil, nil, nil);
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"ApplySepiaSegue"]) {
        self.img = [Filter makeSepiaWithImage:self.img andIntencity:slider.value];
        UIImageWriteToSavedPhotosAlbum(self.img, nil, nil, nil);
        //[[segue destinationViewController] viewWillAppear:YES];
    }
}

@end
