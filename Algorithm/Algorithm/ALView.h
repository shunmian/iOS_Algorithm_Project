//
//  ALView.h
//  Algorithm
//
//  Created by LAL on 17/3/29.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sideEffectBlock)(void);
typedef void(^animationBlock)(BOOL);
typedef void(^animatingBlock)(void);
typedef animationBlock (^getNextAnimationBlock)();

@interface ALView : UIView

+(void)animationWithSideEffectInSeriesBegins;
+(void)addAnimationBlock:(animatingBlock)animation
                duration:(NSTimeInterval)interval
                   delay:(NSTimeInterval)delay
     withSideEffectBlock:(sideEffectBlock)sideEffect;
+(void)animationWithSideEffectInSeriesExcutes;
@end
