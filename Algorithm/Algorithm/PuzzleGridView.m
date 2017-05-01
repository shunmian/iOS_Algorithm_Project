//
//  PuzzleGridView.m
//  Algorithm
//
//  Created by LAL on 17/3/30.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "PuzzleGridView.h"

@implementation PuzzleGridView


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

-(id)initViewWithFrame:(CGRect)frame
                           tag:(NSInteger)tag
                     andNumber:(NSNumber *)number{
    if(self = [self initWithFrame:frame]){
        [self setUpViewWithTag: tag andNumber: number];
    }
    return self;
}


-(void)setUp{
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.bounds)-10, CGRectGetMidY(self.bounds)-10, 20, 20)];
    [self addSubview:self.numberLabel];
   
}
-(void)setUpViewWithTag:(NSInteger)tag andNumber:(NSNumber *)number{
    self.tag = tag;
    if(number.intValue != 0){
        self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.05f];
        self.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.2f].CGColor;
        self.layer.borderWidth = 1.0f;
    
        self.numberLabel.backgroundColor = [UIColor clearColor];
        self.numberLabel.text = [NSString stringWithFormat:@"%@",number];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        self.numberLabel.textColor = [UIColor whiteColor];
    }else{
        self.tag = tag;
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.borderWidth = 0.0f;
        self.numberLabel.text = nil;
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
