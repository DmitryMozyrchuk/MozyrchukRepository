//
//  FilterViewController.m
//  VideoPlayer
//
//  Created by Student Student on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterCell.h"
#import "Filter.h"
#import "SepiaViewController.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

@synthesize tableView;
@synthesize image;
@synthesize filters;
@synthesize type;
@synthesize movieURL;

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
    filters = [NSArray arrayWithObjects:@"CISepiaTone", @"Monochrome", nil];
	// Do any additional setup after loading the view.
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark tableView methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return filters.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSString *cellIdentidier = @"FilterCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentidier];
        cell.textLabel.text = [filters objectAtIndex:indexPath.row];
        return cell;
    }
    else {
        NSString *cellIdentidier = @"Filter1Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentidier];
        cell.textLabel.text = [filters objectAtIndex:indexPath.row];
        return cell;
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([self.type isEqualToString:@"Photo"]) {
        [[segue destinationViewController] setImg:self.image];
        [[segue destinationViewController] setTypeOfMedia:0];
    }
    else {
        [[segue destinationViewController] setMovieURL:self.movieURL];
        [[segue destinationViewController] setTypeOfMedia:1];
    }
}
@end



