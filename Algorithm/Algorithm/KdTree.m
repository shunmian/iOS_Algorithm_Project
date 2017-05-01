//
//  KdTree.m
//  Algorithm
//
//  Created by LAL on 17/3/31.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "KdTree.h"
#import "StdDraw.h"

@interface KdTreeNode:NSObject
@property (nonatomic, assign) CGPoint p;
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, strong) KdTreeNode *lb;
@property (nonatomic, strong) KdTreeNode *rt;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) BOOL isH;
@end

@implementation KdTreeNode

-(id)initWithPoint:(CGPoint) p{
    if(self = [self init]){
        _p = p;
        _rect = CGRectNull;
        _lb = nil;
        _rt = nil;
        _isH = FALSE;
    }
    return self;
}

-(id)initWithPoint:(CGPoint)p rect:(CGRect)rect isHorizontal:(BOOL)isH{
    if(self = [self init]){
        _p = p;
        _rect = rect;
        _lb = nil;
        _rt = nil;
        _isH = isH;
    }
    return self;
}

-(NSComparisonResult)compare:(KdTreeNode *)other{
    if(self.isH){
        CGFloat thisY = self.p.y;
        CGFloat thatY = other.p.y;
        if(thisY < thatY || (thisY == thatY && self.p.x != other.p.x)) return NSOrderedAscending;
        else if (thisY > thatY) return NSOrderedDescending;
        else return NSOrderedSame;
    }else{
        CGFloat thisX = self.p.x;
        CGFloat thatX = other.p.x;
        if(thisX < thatX ||(thisX == thatX && self.p.y != other.p.y)) return NSOrderedAscending;
        else if (thisX > thatX) return NSOrderedDescending;
        else return NSOrderedSame;
    }
}
@end


@interface MinPoint:NSObject
@property (nonatomic, assign) CGPoint p;
@property (nonatomic, assign) CGFloat distance;
@end

@implementation MinPoint

@end


@interface KdTree()
@property(nonatomic, strong) KdTreeNode *root;
@property(nonatomic, assign) NSInteger size;
@property(nonatomic, strong) NSMutableArray *toStringBFSQueue;
@end

@implementation KdTree

-(id)init{
    if(self = [super init]){
        _root = nil;
        _size = 0;
    }
    return self;
}

-(BOOL)isEmpty{
    return self.size <=0;
}

-(NSInteger)size{
    return _size;
}

-(void)insert:(CGPoint) p{
    //if(p == ) [NSException raise:@"null pointer exception" format:@"%@ is null",p];
    self.root = [self insertNode:self.root point:p rect:CGRectMake(0, 0, 1, 1) level:0];
}

-(KdTreeNode *)insertNode:(KdTreeNode *)x point:(CGPoint)p rect:(CGRect)rect level:(int)level{
    KdTreeNode *pNode = [[KdTreeNode alloc] initWithPoint:p];
    if(x==nil){
        self.size++;
        return [[KdTreeNode alloc] initWithPoint:p rect:rect isHorizontal:level%2 != 0];
    }
    int cmp = [x compare:pNode];
    
    if(cmp == NSOrderedDescending){
        CGRect lb = CGRectNull;
        if(x.isH){
            if(x.lb == nil) lb = CGRectMake(CGRectGetMinX(x.rect), CGRectGetMinY(x.rect), CGRectGetMaxX(x.rect), x.p.y);
            x.lb = [self insertNode:x.lb point:p rect:lb level:++level];
        }else{
            if(x.lb == nil) lb = CGRectMake(CGRectGetMinX(x.rect), CGRectGetMinY(x.rect), x.p.x, CGRectGetMaxY(x.rect));
            x.lb = [self insertNode:x.lb point:p rect:lb level:++level];
        }
    }else if (cmp == -1){
        CGRect rb = CGRectNull;
        if(x.isH){
            if(x.rt==nil) rb = CGRectMake(CGRectGetMinX(x.rect), x.p.y, CGRectGetMaxX(x.rect), CGRectGetMaxY(x.rect));
                x.rt = [self insertNode:x.rt point:p rect:rb level:++level];
        }else{
            if(x.rt==nil) rb = CGRectMake(x.p.x, CGRectGetMinY(x.rect), CGRectGetMaxX(x.rect), CGRectGetMaxY(x.rect));
            x.rt = [self insertNode:x.rt point:p rect:rb level:++level];
        }
    } else{
        return x;
    }
    return x;
}

-(BOOL)containsPoint:(CGPoint)p{
    KdTreeNode *x = self.root;
    KdTreeNode *pNode = [[KdTreeNode alloc] initWithPoint:p];
    while(x != nil){
        NSComparisonResult cmp = [x compare:pNode];
        if(cmp == NSOrderedDescending) x = x.lb;
        else if (cmp == NSOrderedAscending) x = x.rt;
        else{
            if(CGPointEqualToPoint(x.p,p)) return TRUE;
            else return FALSE;
        }
    }
    return FALSE;
}

-(NSArray *)IterableForPoints{
    NSMutableArray *queue = [NSMutableArray array];
    [self enqueue: queue withNode:self.root];
    return [NSArray arrayWithArray:queue];
}

-(void)enqueue:(NSMutableArray *)queue withNode:(KdTreeNode*)x{
    if(x==nil) return;
    else{
        [self enqueue:queue withNode:x.lb];
        [queue addObject:x];
        [self enqueue:queue withNode:x.rt];
    }
}

/*
-(void)draw{
    for (Node *x in [self IterableForPoints]){
        [StdDraw setPenColor:[UIColor blackColor]];
        [StdDraw setPenRadius:0.01];
        [StdDraw drawPoint:x.p];
        if(x.isH){
            [StdDraw setPenColor:[UIColor blueColor]];
            [StdDraw setPenRadius:0.05];
            [StdDraw drawLineFromPoint:CGPointMake(CGRectGetMinX(x.rect), x.p.y) toPoint:CGPointMake(CGRectGetMaxX(x.rect), x.p.y)];
        }else{
            [StdDraw setPenColor:[UIColor redColor]];
            [StdDraw setPenRadius:0.05];
            [StdDraw drawLineFromPoint:CGPointMake(x.p.x, CGRectGetMinY(x.rect)) toPoint:CGPointMake(x.p.x,CGRectGetMaxY(x.rect))];
        }
    }
}
*/

-(NSArray *)IterablePointsForRange:(CGRect)rect{
    if(CGRectIsNull(rect)) [NSException raise:@"null pointer exception" format:@"rect is null"];
    NSMutableArray *queue = [NSMutableArray array];
    [self enqueueRange:queue withNode:self.root withRect:rect];
    return [NSArray arrayWithArray:queue];
}


-(void)enqueueRange:(NSMutableArray *)queue withNode:(KdTreeNode*)x withRect:(CGRect)rect{
    if(x==nil) return;
    if(![self splittingLineIntersectsWithRect:rect withNode:x]){
        if([self leftBottomSubtreeIntersectsWithRect:rect withNode:x]) [self enqueueRange:queue withNode:x.lb withRect:rect];
        else [self enqueueRange:queue withNode:x.rt withRect:rect];
    }else{
        if([self CGRect:rect IsContain:x.p]) [queue addObject:[NSValue valueWithCGPoint:x.p]];
        [self enqueueRange:queue withNode:x.lb withRect:rect];
        [self enqueueRange:queue withNode:x.rt withRect:rect];
    }
}

-(BOOL)leftBottomSubtreeIntersectsWithRect:(CGRect)r withNode:(KdTreeNode *)x{
    if(x.isH){
        return CGRectGetMaxY(r) < x.p.y;
    }else{
        return CGRectGetMaxX(r) < x.p.x;
    }
}

-(BOOL)splittingLineIntersectsWithRect:(CGRect)r withNode:(KdTreeNode*)x{
    if(x.isH){
        return CGRectGetMinY(r) <= x.p.y && CGRectGetMaxY(r) >= x.p.y;
    }else{
        return CGRectGetMinX(r) <= x.p.x && CGRectGetMaxX(r) >= x.p.x;
    }
}

-(CGPoint)nearestToPoint:(CGPoint)p{
    MinPoint *minP = [[MinPoint alloc] init];
    minP.distance = 3.0f;
    [self findNearestPointWithNode:self.root withPoint:p withMinPoint:minP];
    return minP.p;
}


-(void)findNearestPointWithNode:(KdTreeNode *)x withPoint:(CGPoint)targetP withMinPoint:(MinPoint *)minP{
    if(x==nil)return;
    if([self distanceFromCGRect:x.rect toPoint:targetP] >= minP.distance) return;
    
    double distance = [self distanceFromCGPoint:x.p toPoint:targetP];
    if(distance < minP.distance){
        minP.distance = distance;
        minP.p = x.p;
    }

    if(x.lb != nil){
        NSComparisonResult cmp = [x compare:[[KdTreeNode alloc] initWithPoint:targetP]];
        if(cmp == NSOrderedDescending){
            [self findNearestPointWithNode:x.lb withPoint:targetP withMinPoint:minP];
            [self findNearestPointWithNode:x.rt withPoint:targetP withMinPoint:minP];
        }else{
            [self findNearestPointWithNode:x.rt withPoint:targetP withMinPoint:minP];
            [self findNearestPointWithNode:x.lb withPoint:targetP withMinPoint:minP];
        }
    }else if(x.rt !=nil){
        NSComparisonResult cmp = [x compare:[[KdTreeNode alloc] initWithPoint:targetP]];
        if(cmp == NSOrderedAscending){
            [self findNearestPointWithNode:x.rt withPoint:targetP withMinPoint:minP];
            [self findNearestPointWithNode:x.lb withPoint:targetP withMinPoint:minP];
        }else{
            [self findNearestPointWithNode:x.lb withPoint:targetP withMinPoint:minP];
            [self findNearestPointWithNode:x.rt withPoint:targetP withMinPoint:minP];
        }
    }else{
        return;
    }
}


-(CGFloat)distanceFromCGRect:(CGRect)rect toPoint:(CGPoint)p{
    CGFloat dx = 0.0, dy = 0.0;
    CGFloat xmin = CGRectGetMinX(rect);
    CGFloat xmax = CGRectGetMaxX(rect);
    CGFloat ymin = CGRectGetMinY(rect);
    CGFloat ymax = CGRectGetMaxY(rect);
    if      (p.x < xmin) dx = p.x - xmin;
    else if (p.x > xmax) dx = p.x - xmax;
    if      (p.y < ymin) dy = p.y - ymin;
    else if (p.y > ymax) dy = p.y - ymax;
    return dx*dx + dy*dy;
}

-(CGFloat)distanceFromCGPoint:(CGPoint)p1 toPoint:(CGPoint)p2{
    CGFloat dx = p1.x-p2.x, dy = p1.y - p2.y;
    return dx*dx+dy*dy;
}

-(NSString *)description{
    self.toStringBFSQueue = [NSMutableArray array];
    NSMutableString *string = [NSMutableString string];
    [self.toStringBFSQueue addObject:self.root];
    int level = -1;
    self.root.level = 0;
    BOOL levelFlag = FALSE;
    string = [self BFSToStringWithQueue:self.toStringBFSQueue mutablString:string flag:levelFlag level:level];
    return [NSString stringWithFormat:@"\n%@",[string substringFromIndex:1]];
}


-(NSMutableString *)BFSToStringWithQueue:(NSMutableArray *)queue mutablString:(NSMutableString *)string flag:(BOOL)levelFlag level:(int)level{
    if(queue.count == 0) return string;
    
    KdTreeNode *n = [queue objectAtIndex:0];
    [queue removeObject:n];
    if(levelFlag && n.level !=level){
        levelFlag = FALSE;
    }

    if(!levelFlag){
        level++;
        levelFlag = TRUE;
        [string appendString:[NSString stringWithFormat:@"\nlevel: %ld    ",(long)n.level]];
    }
    if(n.lb !=nil){
        n.lb.level = n.level+1;
        [queue addObject:n.lb];
        if(n.rt == nil){
            KdTreeNode *nullNode = [[KdTreeNode alloc] initWithPoint:CGPointMake(-1.0, -1.0)];
            nullNode.level = n.level + 1;
            [queue addObject:nullNode];
        }
    }
    
    if(n.rt !=nil){
        if(n.lb == nil){
            KdTreeNode *nullNode = [[KdTreeNode alloc] initWithPoint:CGPointMake(-1.0, -1.0)];
            nullNode.level = n.level + 1;
            [queue addObject:nullNode];
        }
        n.rt.level = n.level + 1;
        [queue addObject:n.rt];
    }
    [string appendString: [NSString stringWithFormat:@"(%.3f,%.3f)  ",n.p.x,n.p.y]];
    return [self BFSToStringWithQueue:queue mutablString:string flag:levelFlag level:level];
}

-(BOOL)CGRect:(CGRect)rect
    IsContain:(CGPoint)p{
    return  p.x >= CGRectGetMinX(rect) && p.x <= CGRectGetMaxX(rect) && p.y >= CGRectGetMinY(rect) && p.y <= CGRectGetMaxY(rect);
}

@end
