//
//  LastTwitViewController.h
//  TwitterClient
//
//  Created by Student Student on 02.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define firstQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import <UIKit/UIKit.h>

#import "SA_OAuthTwitterController.h"


@class SA_OAuthTwitterEngine;

@interface LastTwitViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    SA_OAuthTwitterEngine    *_engine;
    IBOutlet UITableView *tabView;
    IBOutlet UIBarButtonItem *backButton;
    IBOutlet UIBarButtonItem *updateButton;
    IBOutlet UINavigationBar *navBar;
    NSMutableDictionary *twitts;
    IBOutlet UIActivityIndicatorView *indicator;
}

@property (nonatomic, retain) SA_OAuthTwitterEngine *_engine;
@property (nonatomic, retain) IBOutlet UITableView *tabView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *updateButton;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) NSMutableDictionary *twitts;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;

-(void)doneUpdateQuerry:(NSURL *)url;
-(IBAction)updateButtonPressed:(id)sender;
-(IBAction)BackButtonPressed:(id)sender;


@end
