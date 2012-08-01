//
//  TwittViewController.h
//  TwitterClient
//
//  Created by Student Student on 01.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterController.h"

@class SA_OAuthTwitterEngine;

@interface TwittViewController : UIViewController<SA_OAuthTwitterControllerDelegate, UITextViewDelegate>{
    SA_OAuthTwitterEngine    *_engine;
    IBOutlet UINavigationBar *navBar;
    IBOutlet UIBarButtonItem *saveButton;
    IBOutlet UITextView *tView;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, retain) IBOutlet UITextView *tView;

-(IBAction)save:(id)sender;

@end
