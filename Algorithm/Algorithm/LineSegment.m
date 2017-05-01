//
//  LineSegment.m
//  Algorithm
//
//  Created by LAL on 17/4/11.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "LineSegment.h"

@implementation LineSegment

-(instancetype)initWithFromPoint:(ALPoint *)fromP toPoint:(ALPoint *)toP{
    if (fromP == nil || toP == nil)  [NSException raise:@"IllegalArgumentException" format:@"%@",[self class]];
    if(self = [self init]){
        _fromP = fromP;
        _toP = toP;
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@ -> %@", self.fromP,self.toP];
}

@end
