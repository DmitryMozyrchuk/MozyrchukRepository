//
//  FilterViewController.h
//  VideoPlayer
//
//  Created by Student Student on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    UIImage *image;
}

@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSArray *filters;

@end
