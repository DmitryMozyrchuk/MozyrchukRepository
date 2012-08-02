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
    IBOutlet UIButton *recentTweetsButton;
    IBOutlet UIButton *selfInformationButton;
    SA_OAuthTwitterEngine    *_engine;
}

@property(nonatomic, retain) IBOutlet UIButton *loginButton;
@property(nonatomic, retain) IBOutlet UIButton *tweetButton;
@property(nonatomic, retain) IBOutlet UIButton *selfInformationButton;
@property(nonatomic, retain) IBOutlet UIButton *recentTweetsButton;


-(IBAction)updateTwitter:(id)sender;
-(IBAction)loginTwitter:(id)sender;
-(IBAction)recentTweets:(id)sender;
-(IBAction)infoButtonPressed:(id)sender;

@end
