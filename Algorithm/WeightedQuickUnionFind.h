//
//  WeightedQuickUnionFind.h
//  Algorithm
//
//  Created by LAL on 17/3/19.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeightedQuickUnionFind : NSObject

-(int)count;  //return the number of components
-(int)findSetWithID:(int)ID;
-(void)unionID:(int)pID
        withID:(int)qID;
-(BOOL)connectedID:(int)pID
            withID:(int)qID;
-(instancetype)initWithCount:(int)count;
@end
