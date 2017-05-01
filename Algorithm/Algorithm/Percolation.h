//
//  Percolation.h
//  Algorithm
//
//  Created by LAL on 17/3/19.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Percolation : NSObject

@property(nonatomic, strong) NSNumber* numberOfOpenSites;
@property(nonatomic, strong) NSNumber* percolates;
-(id) initWithCount:(int) N;
-(void) openI:(int) i andJ:(int) j;
-(BOOL) isOpenI:(int)i andJ:(int)j;
-(BOOL) isFullWithI:(int)i andJ:(int)j;
-(BOOL **)state;
-(void)restart;

@end
