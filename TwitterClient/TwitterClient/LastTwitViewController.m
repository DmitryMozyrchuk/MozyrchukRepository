//
//  LastTwitViewController.m
//  TwitterClient
//
//  Created by Student Student on 02.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LastTwitViewController.h"
#import "SA_OAuthTwitterEngine.h"


@interface LastTwitViewController ()

@end

@implementation LastTwitViewController

@synthesize backButton;
@synthesize tabView;
@synthesize updateButton;
@synthesize navBar;
@synthesize _engine;
@synthesize twitts;
@synthesize indicator;

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
    [indicator stopAnimating];
    twitts = [[NSMutableDictionary alloc] init];
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/statuses/user_timeline.json?include_entities=true&include_rts=true&screen_name=%@&count=20", _engine.username]];
    [self doneUpdateQuerry:url];
    //[self.tabView setEditing:!self.tabView.editing animated:YES];
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

-(void)updateButtonPressed:(id)sender{
    self.twitts = nil;
    twitts = [[NSMutableDictionary alloc] init];
    [indicator startAnimating];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/statuses/user_timeline.json?include_entities=true&include_rts=true&screen_name=%@&count=20", _engine.username]];
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
    NSLog(@"%@", self.twitts);
    self.tabView.reloadData;
    [indicator stopAnimating];
}

-(void)BackButtonPressed:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
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
    for (int i = 0; i < array.count; i++) {
        NSDictionary *temp = (NSDictionary *)[array objectAtIndex:i];
        NSLog(@"%@", temp);
        NSLog(@"%@", [[temp objectForKey:@"user"] class]);
        [self.twitts setValue:[temp valueForKey:@"text"] forKey:[temp valueForKey:@"id_str"]];
    }
}

#pragma mark tableView methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return twitts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = [twitts allKeys];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i++) {
        [tempArray addObject:[array objectAtIndex:array.count - (i + 1)]];
    }
    array = [NSArray arrayWithArray:tempArray];
    tempArray = nil;
    NSString *str = (NSString *)[twitts objectForKey:[array objectAtIndex:indexPath.row]];
    static NSString *CellIdentifier = @"EditFirstCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = str;
    return cell;

}




@end
