//
//  PercolationAnimationView.h
//  Algorithm
//
//  Created by LAL on 17/3/20.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Percolation.h"

@protocol PercolationAnimationViewDelegate <NSObject>
-(Percolation *)getPercolation;
-(NSInteger)getCount;
@end


@interface PercolationAnimationView : UIView

@property (nonatomic,strong) id<PercolationAnimationViewDelegate> delegate;

@end
