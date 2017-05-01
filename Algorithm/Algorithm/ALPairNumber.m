//
//  ALPairNumber.m
//  Algorithm
//
//  Created by LAL on 17/3/28.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "ALPairNumber.h"

@implementation ALPairNumber
-(id)initWithRow:(NSNumber *)row andCol:(NSNumber *)col{
    if(self = [self init]){
        _row = row;
        _col = col;
    }
    return self;
}
@end
