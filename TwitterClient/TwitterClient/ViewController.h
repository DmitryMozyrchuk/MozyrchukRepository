//
//  ViewController.h
//  TwitterClient
//
//  Created by Student Student on 01.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterController.h"

@class SA_OAuthTwitterEngine; 

@interface ViewController : UIViewController<UITextFieldDelegate, SA_OAuthTwitterControllerDelegate>{
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *tweetButton;
    SA_OAuthTwitterEngine    *_engine;
}

@property(nonatomic, retain) IBOutlet UIButton *loginButton;
@property(nonatomic, retain) IBOutlet UIButton *tweetButton;


-(IBAction)updateTwitter:(id)sender;
-(IBAction)loginTwitter:(id)sender;

@end
