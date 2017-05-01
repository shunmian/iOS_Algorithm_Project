//
//  ALPoint.h
//  Algorithm
//
//  Created by LAL on 17/4/11.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALPoint.h"




@interface ALPoint : NSObject
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
-(instancetype)initWithX:(CGFloat)x andY:(CGFloat)y;
-(NSComparisonResult)compare:(ALPoint *)other;  //why override is not visible, should delcare in .h
-(NSComparisonResult)compareSlopeWithPoint:(ALPoint *)p1
                                  andPoint:(ALPoint *)p2;
-(double)slopeToPoint:(ALPoint *)that;
-(CGPoint)CGPointValue;
@end
