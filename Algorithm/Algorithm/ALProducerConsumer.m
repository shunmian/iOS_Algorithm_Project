//
//  ALProducerConsumer.m
//  Algorithm
//
//  Created by LAL on 17/4/19.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "ALProducerConsumer.h"

@interface ALProducerConsumer ()
@property(nonatomic, assign) int capacity;                      //maximum product capacity
@property(nonatomic, strong) id (^producingBlock)();
@property(nonatomic, strong) id (^consumingBlock)();
@property(nonatomic, strong) dispatch_queue_t concurrentQueue;
@property(nonatomic, strong) dispatch_group_t groupQueue;
@property(nonatomic, strong) NSNumber *isAdding;
@end

@implementation ALProducerConsumer

-(void)setProductsCount:(NSNumber *)productsCount{
    _productsCount = @(self.products.count);
}

-(instancetype)initWithCapacity:(int)capacity{
    if(self = [self init]){
        
        _producingEnableSignal = [RACSignal combineLatest:@[RACObserve(self,isAdding),RACObserve(self,productsCount)] reduce:^NSNumber* (NSNumber *isAddingFcps,NSNumber *fcpsCount){
            NSNumber *enable = [NSNumber numberWithBool:fcpsCount.integerValue < self.capacity && !isAddingFcps.boolValue];
            return enable;
        }];
        
        _consumingEnableSignal = [RACObserve(self, productsCount) map:^NSNumber *(NSNumber *count) {
            return @([count integerValue] > 0);
        }];
        
        _concurrentQueue = dispatch_queue_create("com.ALConsumerProducer.www", DISPATCH_QUEUE_CONCURRENT);
        _groupQueue = dispatch_group_create();
        _products = [NSMutableArray new];
        _productsCount = @(_products.count);
        _isAdding = @NO;
        _capacity = capacity;
    }
    return self;
}
/*
-(void)producingTask:(id (^)(void))producingBlock{
    self.producingBlock = producingBlock;
    @weakify(self)
    [self.producingEnableSignal
     subscribeNext:^(NSNumber *enable) {
         @strongify(self)
         dispatch_async(self.concurrentQueue, ^{
             if([enable boolValue]){
                 self.isAdding = @YES;
                 int begin = self.productsCount.integerValue;
                 dispatch_apply(self.capacity-begin, self.concurrentQueue, ^(size_t t) {
                     int index = begin + t;
                     id product = producingBlock();
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self.products addObject:product];
                         self.productsCount = @(RACDUMMY_SETTER);
                         DLog(@"after adding:%d, products count:%@",index,self.productsCount);
                     });
                 });

                 dispatch_group_notify(self.groupQueue, self.concurrentQueue, ^{
                     self.isAdding = @NO;
                     DLog(@"one group finish:%@",self.productsCount);
                 });
             }
         });
     }];
}
 */
-(void)producingTask:(id (^)(void))producingBlock{
    self.producingBlock = producingBlock;
    @weakify(self)
    [self.producingEnableSignal
     subscribeNext:^(NSNumber *enable) {
         @strongify(self)
             if([enable boolValue]){
                 self.isAdding = @YES;
                 int begin = self.productsCount.integerValue;
                 for(int i = begin; i < self.capacity;i++) {
                     dispatch_group_async(self.groupQueue, self.concurrentQueue, ^{
                         id product = producingBlock();
                         dispatch_sync(dispatch_get_main_queue(), ^{
                             [self addProduct:product];
                             DLog(@"after adding:%d, products count:%@",i,self.productsCount);
                         });
                     });
                 };
                 
                 dispatch_group_notify(self.groupQueue, self.concurrentQueue, ^{
                     self.isAdding = @NO;
                     DLog(@"one group finish:%@",self.productsCount);
                 });
             }
     }];
}


-(void)consumingTask:(void (^)(id))consumingBlock onDispatchQueue:(dispatch_queue_t)queue{
    int randomI = [MathStats getRandomNumberBetween:0 to:[self.productsCount integerValue]];
    id product = [self removeProductAtIndex:randomI];
    DLog(@"after removing, products count:%@",self.productsCount);
    dispatch_async(queue, ^{
        consumingBlock(product);
    });
}

-(void)addProduct:(id)product{
    [self.products addObject:product];
    self.productsCount = @(RACDUMMY_SETTER);
}

-(id)removeProductAtIndex:(int)index{
    if(index > [self.productsCount integerValue]) [NSException raise:@"arrayOutOfBounds" format:@"%@",self];
    id product = [self.products objectAtIndex:index];
    [self.products removeObject:product];
    self.productsCount = @(RACDUMMY_SETTER);
    return product;
}

@end
