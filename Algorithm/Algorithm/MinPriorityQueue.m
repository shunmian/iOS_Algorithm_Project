//
//  MiniPQ.m
//  Algorithm
//
//  Created by LAL on 17/3/26.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "MinPriorityQueue.h"


@interface HeapEnumerator: NSEnumerator
@property (nonatomic, strong) MinPriorityQueue *copyiedMinPQ;
@property (nonatomic, assign) NSInteger currentI;
@end

@implementation HeapEnumerator

- (instancetype)initWithMinPriorityQueue:(MinPriorityQueue *)minPQ
{
    if (self =[super init]) {
        if(minPQ.comparator == nil){
            _copyiedMinPQ= [[MinPriorityQueue alloc] initWithCapacity:[minPQ size]];
        }else {
            _copyiedMinPQ = [[MinPriorityQueue alloc] initWithCapacity:[minPQ size] andComparator:minPQ.comparator];
        }
    }
    
    for(int i = 1; i <= [minPQ size];i++){
        [_copyiedMinPQ insert: minPQ.pq[i]];
    }
    _currentI = 0;
    return self;
}

-(id)nextObject{
    if([self allObjects].count > 0){
        return [self.copyiedMinPQ deleteMin];
    }else{
        return nil;
    }
}

-(NSArray *)allObjects{
    return [self.copyiedMinPQ.pq subarrayWithRange: NSMakeRange(self.currentI+1, self.copyiedMinPQ.size-self.currentI)];
}
@end

@interface MinPriorityQueue()

@end

@implementation MinPriorityQueue

-(id)initWithCapacity:(NSInteger)capacity{
    if(self = [super init]){
        _pq = [[NSMutableArray alloc] initWithCapacity:capacity+1];
        _n = 0;
    }
    [_pq addObject:@"DummyObjectForIndex0"];
    _comparator = nil;
    return self;
}

-(id)initWithCapacity:(NSInteger)capacity
        andComparator:(NSComparator)comparator{
    if(self = [self initWithCapacity:capacity]){
        _comparator = comparator;
    }
    return self;
}

-(instancetype)init{
    if(self = [super init]){
        self =[self initWithCapacity:1];
    }
    return self;
}

-(BOOL)isEmpty{
    return self.n == 0;
}

-(NSInteger)size{
    return self.n;
}

-(id)min{
    if([self isEmpty]) [NSException raise:@"Priority queue underflow" format:@"PQ's number of items(%ld) is invalid", (long)self.n];
    return self.pq[1];
}

-(void) resize:(NSInteger) capacity{
    // no needed here since NSMutableArray can expand by calling addObject method.
}

-(void)insert:(id)x{
    [self.pq addObject:x];
    self.n += 1;
    [self swim:self.n];
    NSAssert([self isMinHeap],@"Heap is not min");
}

-(id)deleteMin{
    if([self isEmpty]) [NSException raise:@"Priority queue underflow" format:@"number of item(%ld) <= 0",(long)self.n];
    [self exchange:1 with:self.n];
    id min = self.pq[self.n--];
    [self.pq removeLastObject];
    [self sink:1];
    NSAssert([self isMinHeap],@"not a MinHeap");
    return min;
}

-(NSEnumerator *)enumerator{
    return [[HeapEnumerator alloc] initWithMinPriorityQueue:self];
}

-(NSString *)description{
    int level = 1;
    NSMutableString *result = [NSMutableString string];
    [result appendString:[NSString stringWithFormat:@"\n"]];
    for(int i =1; i <= self.n;i++){
        [result appendString:[NSString stringWithFormat:@"%@ ",self.pq[i]]];
        if(i == 2*level-1){
            level *= 2;
            [result appendString:[NSString stringWithFormat:@"\n"]];
        }
    }
    return [NSString stringWithString:result];
}

#pragma mark - helper

-(void)swim:(NSInteger)k{
    while(k > 1 && [self is:k/2 greaterThan:k]){
        [self exchange:k with:k/2];
        k = k/2;
    }
}

-(void) sink:(NSInteger)k{
    while(2*k <= self.n){
        NSInteger j = 2*k;
        if(j < self.n && [self is:j greaterThan:j+1]) j++;
        if(![self is:k greaterThan:j]) break;
        [self exchange:k with:j];
        k = j;
    }
}

-(BOOL)is:(NSInteger)k1 greaterThan:(NSInteger)k2{
    if (self.comparator == nil){
        return (NSOrderedDescending == [self.pq[k1] compare:self.pq[k2]]);
    }else {
        return (NSOrderedDescending == self.comparator(self.pq[k1],self.pq[k2]));
    }
}

-(void)exchange:(NSInteger)k1 with:(NSInteger)k2{
    id temp = self.pq[k1];
    self.pq[k1] = self.pq[k2];
    self.pq[k2] = temp;
}

-(BOOL)isMinHeap{
    return [self isMinHeap:1];
}

-(BOOL)isMinHeap:(NSInteger)k{
    if(k > self.n) return true;
    NSInteger left = 2*k;
    NSInteger right = 2*k +1;
    if(left  <= self.n && [self is:k greaterThan:left]) return false;
    if(right <= self.n && [self is:k greaterThan:right]) return false;
    return [self isMinHeap:left] && [self isMinHeap:right];
}



@end



