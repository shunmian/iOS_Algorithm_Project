//
//  Percolation.m
//  Algorithm
//
//  Created by LAL on 17/3/19.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "Percolation.h"
#import "WeightedQuickUnionFind.h"

@interface Percolation (){
    int _N;
    bool **_opened;
}
@property (nonatomic,strong) WeightedQuickUnionFind *ufTopBottom;
@property (nonatomic,strong) WeightedQuickUnionFind *ufTop;
@end


@implementation Percolation

@synthesize percolates = _percolates;

-(id)initWithCount:(int) N{
    if(self = [self init]){
        if (N <= 0) [NSException raise:@"Invalid ID value" format:@"foo of %d is invalid", N];
        _N = N;
        _opened = malloc(N*sizeof(bool*));
        for(int i = 0; i < N;++i){
            _opened[i] = malloc(N*sizeof(bool));
        }
        [self restart];
    }
    return self;
}

-(void)openI:(int) i andJ:(int) j{
    [self validateI:i andJ:j];
    if([self isOpenI:i andJ:j]) return;
    _opened[i-1][j-1] = true;
    
    int n = self.numberOfOpenSites.intValue;
    self.numberOfOpenSites = [NSNumber numberWithInt:++n];

    
    // for _N==1, i==1 && j==1 special case
    int k =[self xyTo1DwithI:i andJ:j]; //ij 1D
    if(_N==1 && i==1 && j==1){
        [self unionI:k andJ:0];
        [self.ufTopBottom unionID:k withID:_N*_N+1];
        return;
    }
    
    // for other general case
    if (i == 1){
        [self unionI:k andJ:0];
        if ([self isOpenI:i+1 andJ:j]) [self unionI:k andJ:[self xyTo1DwithI:i+1 andJ:j]];
    } else if (i == _N){
        [self.ufTopBottom unionID:k withID:_N*_N+1];
        if ([self isOpenI:i-1 andJ:j]) [self unionI:k andJ:[self xyTo1DwithI:i-1 andJ:j]];
    } else {
        if ([self isOpenI:i+1 andJ:j]) [self unionI:k andJ:[self xyTo1DwithI:i+1 andJ:j]];
        if ([self isOpenI:i-1 andJ:j]) [self unionI:k andJ:[self xyTo1DwithI:i-1 andJ:j]];
    }
    
    if (j == 1){
        if ([self isOpenI:i andJ:j+1]) [self unionI:k andJ:[self xyTo1DwithI:i andJ:j+1]];
    } else if (j == _N){
        if ([self isOpenI:i andJ:j-1]) [self unionI:k andJ:[self xyTo1DwithI:i andJ:j-1]];
    } else {
        if ([self isOpenI:i andJ:j+1]) [self unionI:k andJ:[self xyTo1DwithI:i andJ:j+1]];
        if ([self isOpenI:i andJ:j-1]) [self unionI:k andJ:[self xyTo1DwithI:i andJ:j-1]];
    }
    
    NSNumber *dummyNumber = @(100);
    [self setPercolates:dummyNumber];
}



-(BOOL) isOpenI:(int)i andJ:(int)j{
    [self validateI:i andJ:j];
    return _opened[i-1][j-1];
}

-(BOOL) isFullWithI:(int)i andJ:(int)j{
    [self validateI:i andJ:j];
    int k = [self xyTo1DwithI:i andJ:j];
    return [self.ufTop connectedID:0 withID:k];
}

-(NSNumber *) percolates{
    return @([self.ufTopBottom connectedID:0 withID:_N*_N+1]);
}

-(void)setPercolates:(NSNumber *)percolates{
    _percolates = @([self.ufTopBottom connectedID:0 withID:_N*_N+1]);
}

-(BOOL **)state{
    return (BOOL **)_opened;
}

-(void)restart{
    self.ufTopBottom = [[WeightedQuickUnionFind alloc] initWithCount:_N*_N+2];
    self.ufTop =[[WeightedQuickUnionFind alloc] initWithCount:_N*_N+1];
    for(int i = 0; i < _N; ++i){
        for(int j = 0; j < _N; ++j){
            _opened[i][j] = false;
        }
    }
    NSNumber *dummyNumber = @(100);
    
    //change self.percolates immediately for RACSignal to send its changing event
    [self setPercolates:dummyNumber];
    self.numberOfOpenSites = @0;
}

#pragma mark - Helper

-(int)xyTo1DwithI:(int)i andJ:(int)j{
    [self validateI:i andJ:j];
    return (i-1)*_N+j;
}

-(void)unionI:(int)i andJ:(int)j{
    [self.ufTopBottom unionID:i withID:j];
    [self.ufTop unionID:i withID:j];
}

-(void)validateI:(int)i andJ:(int) j{
    if(i < 1 ||i >_N || j < 1 || j > _N) [NSException raise: @"Invalid i,j value" format:@"i:%d or j:%d is invalid", i,j];
}

-(void)dealloc{
    for(int i = 0; i<_N;i++){
        free(_opened[i]);
    }
    free(_opened);
}


@end
