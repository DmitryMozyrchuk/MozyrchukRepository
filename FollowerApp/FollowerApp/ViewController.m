//
//  ViewController.m
//  FollowerApp
//
//  Created by Student Student on 01.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize findFollowersButton, followersLabel, followersFollowersLabel, arrayOfFollowers, countOfFollowers, indicator, numberOfQueues, tField;

- (void)viewDidLoad
{
    arrayOfFollowers = [[NSMutableArray alloc] init];
    countOfFollowers = 0;
    numberOfQueues = 0;
    indicator.hidesWhenStopped = YES;
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

-(void)pushFollowersButton:(id)sender{
    [indicator startAnimating];
    NSURL *kLatestKivaLoansURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/followers/ids.json?cursor=-1&screen_name=fastake", tField.text]];
    [self doneFirstQuerry:kLatestKivaLoansURL];
}

-(void)doneFirstQuerry:(NSURL *)url{
    
    dispatch_async(firstQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: 
                        url];
        if ([data length] != 0) {
            [self performSelectorOnMainThread:@selector(fetchedData:) 
                                   withObject:data waitUntilDone:YES];
        }
        else {
            //[indicator stopAnimating];
            NSLog(@"Sorry...");
            [self doneFirstQuerry:url];
            followersLabel.text = [NSString stringWithFormat:@"Not enough queues..."];
        }
            });
}

-(void)doneSecondQuerry:(NSURL *)url{
    dispatch_async(firstQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: 
                        url];
        if ([data length] != 0) {
            [self performSelectorOnMainThread:@selector(fetchedAnotherData:) 
                                   withObject:data waitUntilDone:YES];
        }
        else {
            NSLog(@"Not enough queues");
            followersFollowersLabel.text = [NSString stringWithFormat:@"Followers of followers: %d", countOfFollowers];
            [indicator stopAnimating];
        }
        
    });
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    numberOfQueues++;
    NSLog(@"Queue number: %d", numberOfQueues);
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData                          
                          options:kNilOptions 
                          error:&error];
    NSLog(@"loans: %@", json);
    NSArray *array = [json objectForKey:@"ids"];
    [arrayOfFollowers addObjectsFromArray:array];
    
    
    if ([[json objectForKey:@"next_cursor"] intValue] != 0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/followers/ids.json?cursor=%@&screen_name=%@", [[json objectForKey:@"next_cursor"] stringValue], tField.text]];
        [self doneFirstQuerry:url];
    }
    else {
        followersLabel.text = [NSString stringWithFormat:@"Followers: %d", [arrayOfFollowers count]];
        NSString *str = @"";
        NSString *temp = @"";
        if ([arrayOfFollowers count] > 100) {
            for (int i = 0; i < 99; i++) {
                temp = [NSString stringWithFormat:@"%@,", [(NSNumber*)[arrayOfFollowers objectAtIndex:i]stringValue]];
                str =[str stringByAppendingString:temp];
            }
        }
        else {
            for (int i = 0; i < [arrayOfFollowers count]; i++) {
                temp = [NSString stringWithFormat:@"%@,", [(NSNumber*)[arrayOfFollowers objectAtIndex:i]stringValue]];
                str =[str stringByAppendingString:temp];
            }
        }
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/users/lookup.json?user_id=%@", str]];
        [self doneSecondQuerry:url];
    }
}

-(void)fetchedAnotherData:(NSData *)responseData{
    numberOfQueues++;
    NSLog(@"Queue number: %d", numberOfQueues);
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData                          
                          options:kNilOptions 
                          error:&error];
    NSLog(@"loans: %@", json);
    NSArray * array = (NSArray *)json;
    
    for (int i = 0; i < array.count; i++) {
        NSDictionary *temp = [array objectAtIndex:i];
        countOfFollowers += [(NSNumber *)[temp objectForKey:@"followers_count"] intValue];
    }
    
    NSLog(@"Count: %d", countOfFollowers);
    NSLog(@"%d", arrayOfFollowers.count);
    NSRange range;
    if ([arrayOfFollowers count] > 100) {
        range = NSMakeRange(0, 100);
    }
    else {
        range = NSMakeRange(0, [arrayOfFollowers count]);
    }
    [arrayOfFollowers removeObjectsInRange:range];
    
    NSLog(@"%d", arrayOfFollowers.count);
    
    if ([arrayOfFollowers count] != 0) {
        NSString *str = @"";
        NSString *temp = @"";
        if ([arrayOfFollowers count] > 100) {
            for (int i = 0; i < 99; i++) {
                temp = [NSString stringWithFormat:@"%@,", [(NSNumber*)[arrayOfFollowers objectAtIndex:i]stringValue]];
                str =[str stringByAppendingString:temp];
            }
        }
        else {
            for (int i = 0; i < [arrayOfFollowers count]; i++) {
                temp = [NSString stringWithFormat:@"%@,", [(NSNumber*)[arrayOfFollowers objectAtIndex:i]stringValue]];
                str =[str stringByAppendingString:temp];
            }
        }
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/users/lookup.json?user_id=%@", str]];
        [self doneSecondQuerry:url];
    }
    else {
        [indicator stopAnimating];
        followersFollowersLabel.text = [NSString stringWithFormat:@"Followers of followers: %d", countOfFollowers];
    }

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
