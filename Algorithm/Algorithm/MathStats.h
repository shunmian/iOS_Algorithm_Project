//
//  MathStats.h
//  Algorithm
//
//  Created by LAL on 17/3/20.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MathStats : NSObject
+(int)getRandomNumberBetween:(int)from to:(int)to;
+(double)getRandomDoubleNumberBetween:(double)from to:(double)to;
+(double)meanOf:(double *)array withLength:(int)N;
+(double)standardDeviationOf:(double *)array withLength:(int)N;
@end
