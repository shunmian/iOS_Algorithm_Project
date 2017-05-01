//
//  PercolationStats.h
//  Algorithm
//
//  Created by LAL on 17/3/19.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PercolationStats : NSObject

-(id)initWithCount:(int)N andRepeat:(int)T;
-(double)mean;
-(double)standardDeviation;
-(double)confidenceLo;
-(double)confidenceHi;
-(void)printResult;

@end
