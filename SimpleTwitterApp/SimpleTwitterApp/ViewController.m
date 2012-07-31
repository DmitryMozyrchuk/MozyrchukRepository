//
//  ViewController.m
//  SimpleTwitterApp
//
//  Created by Student Student on 31.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "SA_OAuthTwitterEngine.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize tweetButton, tweetTextField, loginButton, friendsCountLabel, friendsOfFriendsCountLabel, findFriendsButton, friendTextField;

#define kOAuthConsumerKey        @"D3JVAPhLVFOa9iLJH5dTg"         //REPLACE With Twitter App OAuth Key    
#define kOAuthConsumerSecret    @"vpxzcJ00s5zP3DJWILhMSvKMCb8kFHgRAxxYFcA6qo"     //REPLACE With Twitter App OAuth Secret

- (void)viewDidLoad
{
    [super viewDidLoad];
    tweetButton.hidden = YES;
    tweetTextField.hidden = YES;
    friendsCountLabel.hidden = YES;
    friendsOfFriendsCountLabel.hidden = YES;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _engine = nil;
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(IBAction)updateTwitter:(id)sender  
{  
    
    //Twitter Integration Code Goes Here  
    [_engine sendUpdate:tweetTextField.text];   
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
        }  
    }
    else if (_engine && [_engine isAuthorized]) {
        loginButton.hidden = YES;
        tweetTextField.hidden = NO;
        tweetButton.hidden = NO;
    } 
}

-(void)findFriends:(id)sender{
    [self checkFriends:friendTextField.text];
}

-(void)checkFriends:(NSString *)userName{
   
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userName forKey:@"screen_name"];
    [params setObject:@"-1" forKey:@"cursor"];
    
    NSURL *url = 
    [NSURL URLWithString:@"http://api.twitter.com/1/friends/ids.json"];
    
    //  Now we can create our request.  Note that we are performing a GET request.
    TWRequest *request = [[TWRequest alloc] initWithURL:url 
                                             parameters:params 
                                          requestMethod:TWRequestMethodGET];
    
    //  Perform our request
    [request performRequestWithHandler:
     ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
         
         if (responseData) {
             //  Use the NSJSONSerialization class to parse the returned JSON
             NSError *jsonError;
             NSDictionary *timeline = 
             [NSJSONSerialization JSONObjectWithData:responseData 
                                             options:NSJSONReadingMutableLeaves 
                                               error:&jsonError];
             
             if (timeline) {
                 // We have an object that we can parse
                 NSArray *friends = [timeline objectForKey:@"ids"];
                 NSString *result = @"";
                 NSString *temp;
                 int k = 0;
                 if (friends.count>100) {
                     k = 100;
                 }
                 else {
                     k = friends.count;
                 }
                 for (int i = 0; i < k; i++) {
                     NSLog(@"%@", [friends objectAtIndex:i]);
                     temp = [NSString stringWithFormat:@"%@,", [(NSNumber*)[friends objectAtIndex:i]stringValue]];
                     result = [result stringByAppendingString:temp];

                 }
                 friendsCountLabel.hidden = NO;
                 friendsCountLabel.text = [NSString stringWithFormat:@"Количество друзей: %d", friends.count];
                 [self checkFriendsOfFriends:result];
                 
                 
             } 
             else { 
                 // Inspect the contents of jsonError
                 NSLog(@"%@", jsonError);
             }
         }
     }];
}


-(void)checkFriendsOfFriends:(NSString *)friendsIds{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:friendsIds forKey:@"user_id"];
    
    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/users/lookup.json"];
    
    TWRequest *request = [[TWRequest alloc] initWithURL:url 
                                             parameters:params 
                                          requestMethod:TWRequestMethodGET];
    
    //  Perform our request
    [request performRequestWithHandler:
     ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
         
         if (responseData) {
             //  Use the NSJSONSerialization class to parse the returned JSON
             NSError *jsonError;
             NSArray *timeline = 
             [NSJSONSerialization JSONObjectWithData:responseData 
                                             options:NSJSONReadingMutableLeaves 
                                               error:&jsonError];
             
             if (timeline) {
                 // We have an object that we can parse
                 int count = 0;
                 for (int i = 0; i < timeline.count; i++) {
                     NSDictionary * temp = [timeline objectAtIndex:i];
                     count += [(NSNumber*)[temp objectForKey:@"friends_count"] intValue];
                 }

                 friendsOfFriendsCountLabel.hidden = NO;
                 friendsOfFriendsCountLabel.text = [NSString stringWithFormat:@"Количество друзей друзей: %d", count];
                 
             } 
             else { 
                 // Inspect the contents of jsonError
                 NSLog(@"%@", jsonError);
             }
         }
     }];
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
    tweetTextField.hidden = NO;
    tweetButton.hidden = NO;
}  

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {  
    NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);  
}  

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
