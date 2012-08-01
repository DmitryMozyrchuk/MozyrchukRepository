//
//  ViewController.m
//  TwitterClient
//
//  Created by Student Student on 01.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "SA_OAuthTwitterEngine.h"
#import "TwittViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize loginButton;
@synthesize tweetButton;

#define kOAuthConsumerKey        @"U0Sv1cxioIVQgEc2gVtNyw"         //REPLACE With Twitter App OAuth Key    
#define kOAuthConsumerSecret    @"YBEkDJWXHdvARGZfYPgNthR4iYbdjs1PwZmKERROU0"     //REPLACE With Twitter App OAuth Secret

- (void)viewDidLoad
{
    tweetButton.hidden = YES;
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



-(IBAction)updateTwitter:(id)sender  
{  
    TwittViewController *controller = [[TwittViewController alloc] initWithNibName:@"TwittViewController" bundle:[NSBundle mainBundle]];
    [self presentModalViewController:controller animated:YES];
    //Twitter Integration Code Goes Here  
    
}

-(void)loginTwitter:(id)sender{
    if (!_engine) {
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];  
        _engine.consumerKey    = kOAuthConsumerKey;  
        _engine.consumerSecret = kOAuthConsumerSecret;
    }
    
    if(![_engine isAuthorized]){  
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
        
        if (controller){  
            [self presentModalViewController: controller animated: YES];  
            loginButton.hidden = YES;
            tweetButton.hidden = NO;
        }  
    }
    else if (_engine && [_engine isAuthorized]) {
        loginButton.hidden = YES;
        tweetButton.hidden = NO;
    } 
}

#pragma mark SA_OAuthTwitterEngineDelegate  
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {  
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
    [defaults setObject: data forKey: @"authData"];  
    [defaults synchronize];  
}  

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {  
    return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];  
}

#pragma mark TwitterEngineDelegate  
- (void) requestSucceeded: (NSString *) requestIdentifier {  
    NSLog(@"Request %@ succeeded", requestIdentifier); 
    loginButton.hidden = YES;
    tweetButton.hidden = NO;
}  

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {  
    NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);  
} 

@end
