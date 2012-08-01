//
//  ViewController.h
//  FollowerApp
//
//  Created by Student Student on 01.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#define firstQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define secondQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>

@interface ViewController : UIViewController <UITextFieldDelegate>{
    IBOutlet UIButton *findFollowersButton;
    IBOutlet UILabel *followersLabel;
    IBOutlet UILabel *followersFollowersLabel;
    NSMutableArray *arrayOfFollowers;
    int countOfFollowers;
    int numberOfQueues;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UITextField *tField;
    
}

@property (nonatomic, retain) IBOutlet UIButton *findFollowersButton;
@property (nonatomic, retain) IBOutlet UILabel *followersLabel;
@property (nonatomic, retain) IBOutlet UILabel *followersFollowersLabel;
@property (nonatomic, retain) IBOutlet UITextField *tField;
@property (nonatomic, retain) NSMutableArray *arrayOfFollowers;
@property (nonatomic, assign) int countOfFollowers;
@property (nonatomic, assign) int numberOfQueues;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;



-(IBAction)pushFollowersButton:(id)sender;
-(void)doneFirstQuerry:(NSURL *)url;
-(void)doneSecondQuerry:(NSURL *)url;

@end
