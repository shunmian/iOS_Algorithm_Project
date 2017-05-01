//
//  ALPoint.m
//  Algorithm
//
//  Created by LAL on 17/4/11.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "ALPoint.h"

static const double DOUBLE_POSITIVE_INFINITY =  INFINITY;
static const double DOUBLE_NEGATIVE_INFINITY = -INFINITY;

@implementation ALPoint
-(instancetype)initWithX:(CGFloat)x andY:(CGFloat)y{
    if(self = [self init]){
        _x = x;
        _y = y;
    }
    return self;
}

-(CGPoint)CGPointValue{
    return CGPointMake(self.x, self.y);
}
-(NSComparisonResult)compare:(ALPoint *)other{
    if (self.y < other.y || (self.y == other.y && self.x < other.x)) return NSOrderedAscending;
    else if (self.y == other.y && self.x == other.x) return NSOrderedSame;
    else return NSOrderedDescending;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"(%.1f, %.1f)",self.x,self.y];
}

-(double)slopeToPoint:(ALPoint *)that{
    if(self.x == that.x && self.y == that.y) return DOUBLE_NEGATIVE_INFINITY;
    else if (self.x != that.x && self.y == that.y) return 0.0;
    else if (self.x == that.x && self.y != that.y) return DOUBLE_POSITIVE_INFINITY;
    else return (self.y - that.y)/(self.x - that.x);
}

-(NSComparisonResult)compareSlopeWithPoint:(ALPoint *)p1 andPoint:(ALPoint *)p2{
    if([self slopeToPoint:p1] > [self slopeToPoint:p2]) return NSOrderedDescending;
    else if([self slopeToPoint:p1] == [self slopeToPoint:p2]) return NSOrderedSame;
    else return NSOrderedAscending;
}


//for deep copying
-(id)copyWithZone:(NSZone *)zone{
    ALPoint *copy = [[ALPoint allocWithZone:zone] init];
    copy.x = self.x;
    copy.y = self.y;
    return copy;
}

@end
