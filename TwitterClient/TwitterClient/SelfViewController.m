//
//  SelfViewController.m
//  TwitterClient
//
//  Created by Student Student on 02.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelfViewController.h"
#import "SA_OAuthTwitterEngine.h"

@interface SelfViewController ()

@end

@implementation SelfViewController

@synthesize backButton;
@synthesize navBar;
@synthesize _engine;
@synthesize image;
@synthesize imageView;
@synthesize BGimageView;
@synthesize nameLabel;
@synthesize tweetCountLabel;
@synthesize followersCountLabel;
@synthesize friendsCountLabel;
@synthesize locationLabel;
@synthesize descriptionLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/statuses/user_timeline.json?include_entities=true&include_rts=true&screen_name=%@&count=1", _engine.username]];
    [self doneUpdateQuerry:url];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)doneUpdateQuerry:(NSURL *)url{
    NSData* data = [NSData dataWithContentsOfURL: 
                    url];
    if ([data length] != 0) {
        [self performSelectorOnMainThread:@selector(fetchedData:) 
                               withObject:data waitUntilDone:YES];
    }
    else {
        //[indicator stopAnimating];
        NSLog(@"Sorry...");
    }
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData                          
                          options:kNilOptions 
                          error:&error];
    NSArray *array = (NSArray *) json;
        NSDictionary *temp = (NSDictionary *)[array objectAtIndex:0];
    NSDictionary *tempDictionary = [temp valueForKey:@"user"];
    nameLabel.text = [NSString stringWithFormat:@"%@", [tempDictionary valueForKey:@"name"]];
    tweetCountLabel.text = [NSString stringWithFormat:@"Number of statuses: %@", [tempDictionary valueForKey:@"statuses_count"]];
    followersCountLabel.text = [NSString stringWithFormat:@"Followers count: %@", [tempDictionary valueForKey:@"followers_count"]];
    friendsCountLabel.text = [NSString stringWithFormat:@"Friends count: %@", [tempDictionary valueForKey:@"friends_count"]];
    locationLabel.text = [NSString stringWithFormat:@"%@", [tempDictionary valueForKey:@"location"]];
    descriptionLabel.text = [NSString stringWithFormat:@"%@", [tempDictionary valueForKey:@"description"]];
    NSString *url = [tempDictionary valueForKey:@"profile_image_url_https"];
    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    imageView.image = image;
    url = [tempDictionary valueForKey:@"profile_background_image_url_https"];
    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    BGimageView.image = image;
    NSLog(@"%@",tempDictionary);
}

-(void)backButtonPressed:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}



@end
