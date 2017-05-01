//
//  ALProducerConsumer.h
//  Algorithm
//
//  Created by LAL on 17/4/19.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALProducerConsumer : NSObject

@property(nonatomic, strong) RACSignal *producingEnableSignal; //enabling producing when n < capacity
@property(nonatomic, strong) RACSignal *consumingEnableSignal; //enanling consuming when n > 0;
@property(nonatomic, strong) NSNumber *productsCount;          //the products.count wrapper. Since Reactive Cocoa cannot observer array.count directly, custum its setter and each time the products.count change, called setter explicitly to sent RACEvent
@property(nonatomic, strong) NSMutableArray *products;


-(instancetype)initWithCapacity:(int)capacity;

-(void)producingTask:(id(^)(void))producingBlock;

-(void)consumingTask:(void (^)(id))consumingBlock
     onDispatchQueue:(dispatch_queue_t)queue;

-(void)addProduct:(id)product; //the wrapper for products -add methods, with self.productsCount = @"RACDummy_SETTER" included;

-(id)removeProductAtIndex:(int)index; //the wrapper for randomly removing an product from self. products, with self.productsCount = @"RACDummy_SETTER" included;

@end
