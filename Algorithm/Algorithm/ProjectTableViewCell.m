//
//  ProjectTableViewCell.m
//  Algorithm
//
//  Created by LAL on 17/3/18.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "ProjectTableViewCell.h"

@implementation ProjectTableViewCell


-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setUp];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self setUp];
    }
    return self;
}

-(void)setUp{

}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.superview.mas_centerY).with.multipliedBy(1.0);
        make.left.equalTo(self.iconImageView.superview.mas_left).with.offset(5.0);
        make.height.equalTo(self.iconImageView.superview.mas_height).with.multipliedBy(0.7);
        make.width.equalTo(self.iconImageView.mas_height).with.multipliedBy(1.5);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top).with.offset(0);
        make.left.equalTo(self.iconImageView.mas_right).with.offset(10);
        make.right.equalTo(self.titleLabel.superview.mas_right).with.offset(-10);
        make.height.equalTo(self.iconImageView.superview.mas_height).with.multipliedBy(0.2);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(-4);
        make.left.equalTo(self.iconImageView.mas_right).with.offset(10);
        make.right.equalTo(self.detailLabel.superview.mas_right).with.offset(-10);
        make.height.equalTo(self.detailLabel.superview.mas_height).with.multipliedBy(0.6);
    }];
}



- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    UIColor *myBlue = [UIColor colorWithRed:92.0f/255.0f green:148.0f/255.0f blue:233.0f/255.0f alpha:0.00f];
    self.titleLabel.layer.borderColor = myBlue.CGColor;
    self.titleLabel.layer.borderWidth = 1;
    self.titleLabel.layer.cornerRadius = 2;
    self.detailLabel.layer.borderColor = myBlue.CGColor;
    self.detailLabel.layer.borderWidth = 1;
    self.detailLabel.layer.cornerRadius = 2;
    self.detailLabel.textAlignment = NSTextAlignmentLeft;

    self.iconImageView.layer.cornerRadius = 2;
    self.iconImageView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
