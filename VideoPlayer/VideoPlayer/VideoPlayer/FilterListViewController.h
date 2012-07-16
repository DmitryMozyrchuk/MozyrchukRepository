//
//  FilterListViewController.h
//  VideoPlayer
//
//  Created by Student Student on 16.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tabView;
@property (nonatomic, retain) NSMutableArray *array;

@end
