//
//  ALView.m
//  Algorithm
//
//  Created by LAL on 17/3/29.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "ALView.h"



@interface ALView()
@end

@implementation ALView

static NSMutableArray* animationBlocks;
static getNextAnimationBlock getNextAnimation;

+(void)animationWithSideEffectInSeriesBegins{
    animationBlocks = [NSMutableArray new];
    getNextAnimation = ^(){
        if ([animationBlocks count] > 0){
            animationBlock block = (animationBlock)[animationBlocks objectAtIndex:0];
            [animationBlocks removeObjectAtIndex:0];
            return block;
        } else {
            return ^(BOOL finished){
                animationBlocks = nil;
            };
        }
    };
}

+(void)addAnimationBlock:(animatingBlock)animation
                duration:(NSTimeInterval)interval
                   delay:(NSTimeInterval)delay
     withSideEffectBlock:(sideEffectBlock)sideEffect{

    [animationBlocks addObject:^(BOOL finished){
        [UIView animateWithDuration:interval delay:delay options:UIViewAnimationOptionCurveLinear animations:animation
                         completion: ^(BOOL finish){
            if(finish){
                sideEffect();
                getNextAnimation()(finish);
            };
        }];
    }];
}

+(void)animationWithSideEffectInSeriesExcutes{
    getNextAnimation()(YES);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
