//
//  VideoConverter.h
//  VideoPlayer
//
//  Created by Student Student on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <Assetslibrary/AssetsLibrary.h>
#import <CoreImage/CoreImage.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>


@interface VideoConverter : NSObject


+(NSMutableArray *)convertVideoToImageArray:(NSURL *)path;

+(UIImage *)scaleAndRotateImage:(UIImage *)image;

+ (CVPixelBufferRef) pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size;

+(void)writeImageAsMovie:(NSMutableArray *)array size:(CGSize)size duration:(int)duration;

@end
