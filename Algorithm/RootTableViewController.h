//
//  RootTableViewController.h
//  Algorithm
//
//  Created by LAL on 17/3/18.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "ALBasicViewController.h"

@interface RootTableViewController : ALBasicViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
