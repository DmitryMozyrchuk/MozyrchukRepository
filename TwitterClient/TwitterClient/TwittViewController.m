//
//  TwittViewController.m
//  TwitterClient
//
//  Created by Student Student on 01.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwittViewController.h"
#import "SA_OAuthTwitterEngine.h"

@interface TwittViewController ()

@end

@implementation TwittViewController

@synthesize saveButton;
@synthesize navBar;
@synthesize tView;
@synthesize _engine;

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
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self
                                                                       action:@selector(backButtonAction)];
    self.navBar.topItem.leftBarButtonItem = backButton;
    // Do any additional setup after loading the view from its nib.
}

-(void)backButtonAction{
    [self dismissModalViewControllerAnimated:YES];
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

-(void)save:(id)sender{
    if (_engine && [_engine isAuthorized]){
        [_engine sendUpdate:tView.text];
    }
    else {
        NSLog(@"Error");
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

#pragma mark TwitterEngineDelegate  
- (void) requestSucceeded: (NSString *) requestIdentifier {  
    NSLog(@"Request %@ succeeded", requestIdentifier); 

}  

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {  
    NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);  
} 

@end
