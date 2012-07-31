//
//  ViewController.h
//  SimpleTwitterApp
//
//  Created by Student Student on 31.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterController.h"
#import <Twitter/Twitter.h>

@class SA_OAuthTwitterEngine; 

@interface ViewController : UIViewController<UITextFieldDelegate, SA_OAuthTwitterControllerDelegate>{
    
    IBOutlet UITextField     *tweetTextField; 
    UITextField *friendTextField;
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *tweetButton;
    IBOutlet UIButton *findFriendsButton;
    IBOutlet UILabel *friendsCountLabel;
    IBOutlet UILabel *friendsOfFriendsCountLabel;
    SA_OAuthTwitterEngine    *_engine; 
}

@property(nonatomic, retain) IBOutlet UITextField *tweetTextField;
@property(nonatomic, retain) IBOutlet UITextField *friendTextField;
@property(nonatomic, retain) IBOutlet UIButton *loginButton;
@property(nonatomic, retain) IBOutlet UIButton *tweetButton;
@property(nonatomic, retain) IBOutlet UIButton *findFriendsButton;
@property(nonatomic, retain) IBOutlet UILabel *friendsCountLabel;
@property(nonatomic, retain) IBOutlet UILabel *friendsOfFriendsCountLabel;

-(IBAction)updateTwitter:(id)sender;
-(IBAction)findFriends:(id)sender;
-(IBAction)loginTwitter:(id)sender;
-(void)checkFriends:(NSString *)userName;
-(void)checkFriendsOfFriends:(NSString *)friendsIds;

@end
