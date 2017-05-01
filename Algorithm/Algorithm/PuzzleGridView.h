//
//  PuzzleGridView.h
//  Algorithm
//
//  Created by LAL on 17/3/30.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PuzzleGridView : UIView
@property(nonatomic, strong) UILabel *numberLabel;

-(id)initViewWithFrame:(CGRect)frame
                   tag:(NSInteger)tag
             andNumber:(NSNumber *)number;

-(void)setUpViewWithTag:(NSInteger)tag andNumber:(NSNumber *)number;

@end
