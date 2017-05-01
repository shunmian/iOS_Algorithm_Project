//
//  FastCollinearPoints.m
//  Algorithm
//
//  Created by LAL on 17/4/11.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "FastCollinearPoints.h"


@interface FastCollinearPoints()
@property(nonatomic, strong) NSArray<ALPoint *> *sortedSlope;
@property(nonatomic, strong) NSMutableArray<LineSegment *> *segments;
@end

@implementation FastCollinearPoints

-(instancetype)initWithPoints:(NSArray *)points{
    if (points == nil)  [NSException raise:@"IllegalArgumentException" format:@"%@",self];
    for(int i = 0; i < points.count; i++){
        if(points[i] == nil) [NSException raise:@"IllegalArgumentException" format:@"%@",self];
    }
    
    if(self = [self init]){
        // do a deep copying
        _points = [[NSArray alloc] initWithArray:points copyItems:YES];
        _points = [_points sortedArrayUsingComparator:^NSComparisonResult(ALPoint* p1, ALPoint* p2) {
            return [p1 compare:p2];
        }];
        
        
        ALPoint *pre = (ALPoint *)_points[0];
        
        for(int i = 1; i < _points.count; i++){
            if(_points[i] == nil) [NSException raise:@"IllegalArgumentException" format:@"%@",self];
            if([pre compare:_points[i]] == NSOrderedSame) [NSException raise:@"IllegalArgumentException" format:@"%@",self];
            pre = _points[i];
        }
        
        _segments = [NSMutableArray new];
        
        for(int i = 0; i < _points.count; i++){
            _sortedSlope = [self deepCopyArrayFrom:_points withOrigin:i andLength:(int)_points.count-i];
            ALPoint *p0 = _points[i];
            _sortedSlope = [_sortedSlope sortedArrayUsingComparator:^NSComparisonResult(ALPoint *p1, ALPoint *p2) {
                return [p0 compareSlopeWithPoint:p1 andPoint:p2];
            }];
            
            for(int start = 1; start < (int)_sortedSlope.count-2;){
                //count is unsigned, underflow when become < 0, so must be cast to signed int first
                ALPoint *p1 = _sortedSlope[start];
                ALPoint *p2 = _sortedSlope[start+1];
                ALPoint *p3 = _sortedSlope[start+2];
                if([p0 slopeToPoint:p1] == [p0 slopeToPoint:p2] && [p0 slopeToPoint:p1] == [p0 slopeToPoint:p3]){
                    int end = 0;
                    for(end = start+3; end < _sortedSlope.count; end++){
                        ALPoint *p_end = _sortedSlope[end];
                        if([p0 slopeToPoint:p1] != [p0 slopeToPoint:p_end]) break;
                    }
                    int length = end - start + 1;
                    NSMutableArray<ALPoint *> *collinearPoints = [NSMutableArray arrayWithCapacity:length];
                    collinearPoints[0] = _sortedSlope[0];
                    for(int delta = 1; delta < length; delta++){
                        collinearPoints[delta] = _sortedSlope[start+delta-1];
                    }
                    [collinearPoints sortUsingComparator:^NSComparisonResult(ALPoint *p1, ALPoint *p2) {
                        return [p1 compare:p2];
                    }];
                    ALPoint *max = collinearPoints[length-1];
                    ALPoint *min = collinearPoints[0];
                    BOOL addedFlag = FALSE;
                    for (int j = 0; j < i; j++){
                        if([_points[j] slopeToPoint:max] == [max slopeToPoint:min]){
                            addedFlag = TRUE;
                            break;
                        }
                    }
                    if(!addedFlag){
                        [_segments addObject:[[LineSegment alloc] initWithFromPoint:min toPoint:max]];
                    }
                    start = end;
                }else{
                    start++;
                    continue;
                }
            
            }
            
        }
        _pointsCount = @(_points.count);
        _lineSegmentsCount = @(_segments.count);
    }
    return self;
}

-(instancetype)initWithPoints:(NSArray *)points andMaxWidthOrHeight:(NSInteger)n{
    if(self = [self initWithPoints:points]){
        _maxWidthOrHeight = n;
    }
    return self;
}



-(NSArray<LineSegment *> *)getCollinearSegments{
    return [NSArray arrayWithArray:self.segments];
}


-(NSComparisonResult)pointsComparatorFromPoint:(NSValue *)obj1 toPoint:(NSValue *)obj2{
    CGPoint p1 = [(NSValue *)obj1 CGPointValue];
    CGPoint p2 = [(NSValue *)obj2 CGPointValue];
    if (p1.y < p2.y || (p1.y == p2.y && p1.x < p2.x)) return NSOrderedAscending;
    else if (p1.y == p2.y && p1.x == p2.x) return NSOrderedSame;
    else return NSOrderedDescending;
}

/*

-(NSComparisonResult)pointsSlopeComparatorMainPoint:(NSValue *)obj0
                                          FromPoint:(NSValue *)obj1
                                            toPoint:(NSValue *)obj2{
    CGPoint p0 = [(NSValue *)obj0 CGPointValue];
    CGPoint p1 = [(NSValue *)obj1 CGPointValue];
    CGPoint p2 = [(NSValue *)obj2 CGPointValue];
    
}
*/

-(NSArray *)deepCopyArrayFrom:(NSArray *)sourceArray withOrigin:(int)origin andLength:(int)length{
    NSMutableArray *destArray = [NSMutableArray arrayWithCapacity:length];
    for (int i = 0; i < length; i++){
        destArray[i] = sourceArray[i+origin];
    }
    return [[NSArray alloc] initWithArray:destArray copyItems:YES];
}


@end
