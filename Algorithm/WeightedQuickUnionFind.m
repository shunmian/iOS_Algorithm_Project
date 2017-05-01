//
//  WeightedQuickUnionFind.m
//  Algorithm
//
//  Created by LAL on 17/3/19.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "WeightedQuickUnionFind.h"

@interface WeightedQuickUnionFind (){
    int *_parent;   //parent[i] = parent of i
    int *_size;     //size[i] = number of sites in subtree rooted at i
    int _count;     //number of components
    int _N;
}
@end

@implementation WeightedQuickUnionFind

-(instancetype)initWithCount:(int)count{
    if (self = [self init]) {
        _count = count;
        _N = count;
        _parent = malloc(sizeof(int)*_N);
        _size = malloc(sizeof(int)*_N);

        for (int i = 0; i < _N; ++i){
            _parent[i]= i;
            _size[i] = 1;
        }
    }
    return self;
}

-(int)count{
    return _count;
}

-(int)findSetWithID:(int)ID{
    [self validateID:ID];
    while(ID != _parent[ID]){
        ID = _parent[ID];
    }
    return ID;
}

-(void)validateID:(int)ID{
    if(ID<0 || ID>=_N){
        [NSException raise:@"Invalid ID value" format:@"foo of %d is invalid", ID];
    }
}

-(BOOL)connectedID:(int)pID
            withID:(int)qID{
    return [self findSetWithID:pID] == [self findSetWithID:qID];
}

//Merge the component containing site (pID) with the component containing site (qID)

-(void)unionID:(int)pID
        withID:(int)qID{
    int rootP = [self findSetWithID:pID];
    int rootQ = [self findSetWithID:qID];
    if(rootP == rootQ) return;
    
    if(_size[rootP] < _size[rootQ]){
        _parent[rootP] = rootQ;
        _size[rootQ] += _size[rootP];
    }else{
        _parent[rootQ] = rootP;
        _size[rootP] += _size[rootQ];
    }
    _count--;
}

-(void)dealloc{
    free(_parent);
    free(_size);
}


@end
