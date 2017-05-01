//
//  PercolationStats.m
//  Algorithm
//
//  Created by LAL on 17/3/19.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "PercolationStats.h"
#import "Percolation.h"

@interface PercolationStats () {
    int _N;
    int _T;
    double *_result;
}
@end

@implementation PercolationStats

-(id)initWithCount:(int)N andRepeat:(int)T{
    if(N<=0 || T<=0) [NSException raise:@"N and T not valid" format:@"N:%d and T:%d not valid",N,T];
    _N = N;
    _T = T;
    _result = malloc(T*sizeof(double));
    for(int i =0; i<T;++i){
        _result[i] = 0.0;
    }
    for (int i = 0; i<T; ++i){
        Percolation *percolation = [[Percolation alloc] initWithCount:N];
        _result[i] = [self percolationTaskWithPercolation:percolation];
    }
    return self;
}

-(double) percolationTaskWithPercolation:(Percolation*)percolation{
    while(![percolation percolates].boolValue){
        int randomI = [MathStats getRandomNumberBetween:1 to:_N+1];
        int randomJ = [MathStats getRandomNumberBetween:1 to:_N+1];
        if ([percolation isOpenI:randomI andJ:randomJ]) continue;
        [percolation openI:randomI andJ:randomJ];
    }
    return (double)[percolation numberOfOpenSites].intValue/(_N*_N);
}

-(double)mean{
    return [MathStats meanOf:_result withLength:_T];
}

-(double)standardDeviation{
    return [MathStats standardDeviationOf:_result withLength:_T];
}

-(double)confidenceLo{
    return [self mean]-1.96*[self standardDeviation]/sqrt(_T);
}

-(double)confidenceHi{
    return [self mean]+1.96*[self standardDeviation]/sqrt(_T);
}

-(void)dealloc{
    free(_result);
}

#pragma mark - helper


-(void)printResult{
    for(int i = 0; i < _T; ++i){
        DLog(@"%.3f",_result[i]);
    }
}


@end
