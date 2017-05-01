//
//  ALPairNumber.h
//  Algorithm
//
//  Created by LAL on 17/3/28.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALPairNumber : NSObject
@property(nonatomic, strong) NSNumber *row;
@property(nonatomic, strong) NSNumber *col;

-(id) initWithRow:(NSNumber*)row andCol:(NSNumber *)col;
@end
