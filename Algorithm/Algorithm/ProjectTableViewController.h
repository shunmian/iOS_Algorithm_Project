//
//  ProjectTableViewController.h
//  Algorithm
//
//  Created by LAL on 17/3/19.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "ALBasicViewController.h"
@interface ProjectTableViewController : ALBasicViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) Project *project;
@property (strong, nonatomic) NSArray *entries;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
