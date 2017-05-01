//
//  IndexMinPriorityQueue.h
//  Algorithm
//
//  Created by LAL on 17/4/11.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexMinPriorityQueue : NSObject

-(instancetype)initWithCapacity:(int)capacity;
-(void)insertIndex:(int)index WithValue:(NSNumber *)value;
-(NSNumber *)minIndex;

@end
