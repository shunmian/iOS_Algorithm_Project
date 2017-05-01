//
//  ALButton.m
//  Algorithm
//
//  Created by LAL on 17/3/26.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "ALButton.h"

@implementation ALButton


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
    [self setShadowForEnabled:YES];
}

-(void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    [self setShadowForEnabled:enabled];
}


-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        self.layer.shadowOpacity = 0.8f;
    }
    else self.layer.shadowOpacity = 0.4f;
}




-(void)setShadowForEnabled:(BOOL)enabled{
    if(enabled){
        self.imageView.layer.cornerRadius = 7.0f;
        self.layer.shadowRadius = 4.0f;
        self.layer.shadowColor = [UIColor colorWithWhite:0.8f alpha:1].CGColor;
        self.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
        self.layer.shadowOpacity = 0.4f;
        self.layer.masksToBounds = NO;
    }else{
        //self.layer.shadowOpacity = 0.1f;

    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
