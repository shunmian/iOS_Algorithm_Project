//
//  KdTree.h
//  Algorithm
//
//  Created by LAL on 17/3/31.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
@interface Node : NSObject

-(id)initWithPoint:(CGPoint)p;
-(id)initWithPoint:(CGPoint)p rect:(CGRect)rect isHorizontal:(BOOL)isH;

@end
 */

@interface KdTree : NSObject
-(BOOL)isEmpty;
-(NSInteger)size;
-(void)insert:(CGPoint)p;
-(BOOL)containsPoint:(CGPoint)p;
-(NSArray *)IterablePointsForRange:(CGRect)rect;
-(CGPoint)nearestToPoint:(CGPoint)p;
@end
