//
//  Filter.h
//  VideoPlayer
//
//  Created by Student Student on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Filter : NSObject

+(UIImage *)makeSepiaWithImage:(UIImage *)inputImage andIntencity:(float)intencity;
+(UIImage *)makeMonochromeImage:(UIImage *)inputImage withRedColor:(float)red greenColor:(float)green blueColor:(float)blue; 
@end
