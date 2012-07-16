//
//  VideoConverter.m
//  VideoPlayer
//
//  Created by Student Student on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VideoConverter.h"


@implementation VideoConverter


+(NSMutableArray *)convertVideoToImageArray:(NSURL *)path{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSError *err = NULL;
    NSMutableArray *times = [[NSMutableArray alloc] init];
    Float64 durationSeconds = CMTimeGetSeconds([asset duration]);
    int i = 0;
    while (i < durationSeconds) {
        CMTime time = CMTimeMakeWithSeconds(i, 1);
        CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
        UIImage *currentImg = [self scaleAndRotateImage:[[UIImage alloc] initWithCGImage:imgRef]];
        [times addObject:currentImg];
        i = i + 1;
    }
    /*for (int i = 0; i < durationSeconds; i++) {
        CMTime time = CMTimeMakeWithSeconds(i, 1);
        CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
        UIImage *currentImg = [self scaleAndRotateImage:[[UIImage alloc] initWithCGImage:imgRef]];
        [times addObject:currentImg];
    }*/
    return times;
}

+(UIImage *)scaleAndRotateImage:(UIImage *)image  { 

    CGImageRef imgRef = image.CGImage;

    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat boundHeight;
    boundHeight = bounds.size.height;  
    bounds.size.height = bounds.size.width; 
    bounds.size.width = boundHeight;
    transform = CGAffineTransformMakeScale(-1.0, 1.0);
    transform = CGAffineTransformRotate(transform, M_PI / 2.0);
    UIGraphicsBeginImageContext(bounds.size);   
    CGContextRef context = UIGraphicsGetCurrentContext();   
    CGContextConcatCTM(context, transform); 
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

+(CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:NO], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:NO], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width,
                                          size.height,  kCVPixelFormatType_32ARGB, (__bridge_retained CFDictionaryRef) options, 
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
	
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width,
                                                 size.height, 8, 4*size.width, rgbColorSpace, 
												 kCGImageAlphaPremultipliedFirst);
	
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), 
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
	remove(pxdata);
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    return pxbuffer;
}

+(void)writeImageAsMovie:(NSMutableArray *)array size:(CGSize)size duration:(int)duration{
    NSDate *today=[NSDate date];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
	[dateFormat setDateFormat:@"MM_dd_yyyy_HH_mm_ss"];
	NSString *dateString = [dateFormat stringFromDate:today];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedVideoPath = [NSString stringWithFormat:@"%@/video_%@.avi",documentsDirectory, dateString];
    printf(" \n\n\n-Video file == %s--\n\n\n",[savedVideoPath UTF8String]);
    
    NSError *error = nil;
    AVAssetWriter *videoWriter=[[AVAssetWriter alloc]initWithURL:[NSURL fileURLWithPath:savedVideoPath] fileType:AVFileTypeQuickTimeMovie error:&error];
	NSParameterAssert(videoWriter);
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                  [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                  [NSNumber numberWithInt:size.height], AVVideoHeightKey,
                                   nil];
    AVAssetWriterInput* writerInput = [AVAssetWriterInput
                                      assetWriterInputWithMediaType:AVMediaTypeVideo
                                      outputSettings:videoSettings];
    
    
    // NSDictionary *bufferAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
                                                     assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput
                                                     sourcePixelBufferAttributes:nil];
    
    writerInput.expectsMediaDataInRealTime=YES;
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    [videoWriter addInput:writerInput];    
    
    //Start a session:
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    
    CVPixelBufferRef buffer = NULL;
    
    
    //Write samples:
    for (int i=0; i<[array count]; i++)
    {
        while ( ![writerInput isReadyForMoreMediaData] )
        {
            [NSThread sleepForTimeInterval:0.5f];
        }
        buffer = NULL;
        int time = (int)i*(duration/[array count]);
        
        buffer = [self pixelBufferFromCGImage:[[array objectAtIndex:i] CGImage] size:size];
        //[adaptor appendPixelBuffer:buffer withPresentationTime:kCMTimeZero];
        [adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(time, 1)];  
    }
    //Finish the session:
    //[videoWriter endSessionAtSourceTime:CMTimeMake(duration, 1)];
    [writerInput markAsFinished];
    //[videoWriter finishWriting];
    int status = videoWriter.status;
    while (status == AVAssetWriterStatusUnknown) {
        NSLog(@"Waiting...");
        [NSThread sleepForTimeInterval:0.5f];
        status = videoWriter.status;
    }
    
    @synchronized(self) {
        BOOL success = [videoWriter finishWriting];
        if (!success) {
            NSLog(@"finishWriting returned NO");
        }
        NSLog(@"Completed recording, file is stored");
        /*ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:[NSURL fileURLWithPath:savedVideoPath]])
        {
            [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:savedVideoPath] completionBlock:^(NSURL *assetURL, NSError *error){}];
        }*/
        //UISaveVideoAtPathToSavedPhotosAlbum ( savedVideoPath, self, @selector(video:didFinishSavingWithError: contextInfo:), context);

    }
    
}

-(void)video:(NSString *)videoPath didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
NSLog(@"Finished saving video with error: %@", error);
}

@end
