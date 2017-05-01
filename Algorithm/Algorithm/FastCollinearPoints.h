//
//  FastCollinearPoints.h
//  Algorithm
//
//  Created by LAL on 17/4/11.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALPoint.h"
#import "LineSegment.h"

@interface FastCollinearPoints : NSObject
@property(nonatomic, strong) NSArray<ALPoint *> *points;
@property(nonatomic, assign) NSUInteger maxWidthOrHeight;
@property(nonatomic, strong) NSNumber *pointsCount;
@property(nonatomic, strong) NSNumber *lineSegmentsCount;
-(instancetype)initWithPoints:(NSArray *)points;
-(NSArray<LineSegment *> *)getCollinearSegments;
-(instancetype)initWithPoints:(NSArray *)points andMaxWidthOrHeight:(NSInteger)n;
@end
