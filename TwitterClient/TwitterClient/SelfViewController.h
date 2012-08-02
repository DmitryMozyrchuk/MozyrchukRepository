//
//  SelfViewController.h
//  TwitterClient
//
//  Created by Student Student on 02.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterController.h"


@class SA_OAuthTwitterEngine;


@interface SelfViewController : UIViewController{
    SA_OAuthTwitterEngine    *_engine;
    IBOutlet UIBarButtonItem *backButton;
    IBOutlet UINavigationBar *navBar;
    NSMutableDictionary *twitts;
    UIImage *image;
    IBOutlet UIImageView *imageView;
    IBOutlet UIImageView *BGimageView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *tweetCountLabel;
    IBOutlet UILabel *friendsCountLabel;
    IBOutlet UILabel *followersCountLabel;
    IBOutlet UILabel *descriptionLabel;
    IBOutlet UILabel *locationLabel;

}

@property (nonatomic, retain) SA_OAuthTwitterEngine *_engine;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIImageView *BGimageView;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *tweetCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *friendsCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *followersCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;

-(void)doneUpdateQuerry:(NSURL *)url;
-(IBAction)backButtonPressed:(id)sender;

@end
