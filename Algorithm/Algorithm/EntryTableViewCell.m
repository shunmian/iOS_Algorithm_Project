//
//  EntryTableViewCell.m
//  Algorithm
//
//  Created by LAL on 17/3/24.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "EntryTableViewCell.h"

@implementation EntryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.superview.mas_centerY).with.multipliedBy(1.0);
        make.left.equalTo(self.iconImageView.superview.mas_left).with.offset(20.0);
        make.height.equalTo(self.iconImageView.superview.mas_height).with.multipliedBy(0.7);
        make.width.equalTo(self.iconImageView.mas_height).with.multipliedBy(1.0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.superview.mas_centerY).with.multipliedBy(0.4);
        make.left.equalTo(self.iconImageView.mas_right).with.offset(20);
        make.right.equalTo(self.titleLabel.superview.mas_right).with.offset(-10);
        make.height.equalTo(self.iconImageView.superview.mas_height).with.multipliedBy(0.2);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.detailLabel.superview.mas_centerY).with.multipliedBy(1.2);
        make.left.equalTo(self.iconImageView.mas_right).with.offset(20);
        make.right.equalTo(self.detailLabel.superview.mas_right).with.offset(-20);
        make.height.equalTo(self.detailLabel.superview.mas_height).with.multipliedBy(0.6);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
