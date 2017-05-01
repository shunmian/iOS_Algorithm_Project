//
//  EntryTableViewCell.h
//  Algorithm
//
//  Created by LAL on 17/3/24.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectTableViewCell.h"
@interface EntryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@end
