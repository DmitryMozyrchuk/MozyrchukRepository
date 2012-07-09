//
//  Filter.m
//  VideoPlayer
//
//  Created by Student Student on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Filter.h"

@implementation Filter

+(UIImage *)makeSepiaWithImage:(UIImage *)inputImage andIntencity:(float)intencity{
    CIImage *img = [[CIImage alloc] initWithImage:inputImage];
    CIFilter *sepiaFilter = [CIFilter filterWithName:@"CISepiaTone"];
    [sepiaFilter setDefaults];
    [sepiaFilter setValue:img forKey:@"inputImage"];
    [sepiaFilter setValue:[NSNumber numberWithFloat:intencity] forKey:@"inputIntensity"];
    img = [sepiaFilter outputImage];
    CIContext *context = [CIContext contextWithOptions: nil];
    CGImageRef cgImage = [context createCGImage:img fromRect:img.extent];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    return resultImage;

}

+(UIImage *)makeMonochromeImage:(UIImage *)inputImage withRedColor:(float)red greenColor:(float)green blueColor:(float)blue{
    CIImage *img = [[CIImage alloc] initWithImage:inputImage];
    CIFilter *monochromeFilter = [CIFilter filterWithName:@"CIColorMonochrome"];
    [monochromeFilter setValue:img forKey:@"inputImage"];             
    [monochromeFilter setValue:[CIColor colorWithRed:red green:green blue:blue] forKey:@"inputColor"];
    [monochromeFilter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputIntensity"];
    img = [monochromeFilter outputImage];
    CIContext *context = [CIContext contextWithOptions: nil];
    CGImageRef cgImage = [context createCGImage:img fromRect:img.extent];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    return resultImage;
}

@end
