//
//  MiniPQ.h
//  Algorithm
//
//  Created by LAL on 17/3/26.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface MinPriorityQueue : NSObject
@property (nonatomic, strong) NSMutableArray *pq;
@property (nonatomic, assign) NSInteger n;
@property (nonatomic, strong) NSComparator comparator;
-(id)init;
-(id)initWithCapacity:(NSInteger)capacity;
-(id)initWithCapacity:(NSInteger)capacity
        andComparator:(NSComparator)comparator;
-(BOOL) isEmpty;
-(NSInteger)size;
-(id)min;
-(void)insert:(id)x;
-(id)deleteMin;
-(NSEnumerator *)enumerator;

@end
