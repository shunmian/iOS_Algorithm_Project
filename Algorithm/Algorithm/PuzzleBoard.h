//
//  8PuzzleBoard.h
//  Algorithm
//
//  Created by LAL on 17/3/27.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALPairNumber.h"

@interface PuzzleBoard : NSObject
@property(nonatomic, strong, readonly) NSDictionary *neighboursDictionary;
-(instancetype)initWithBlocks:(int **)b andLength:(int)length;
-(id)initRandomlyWithLength:(int)length;
-(int)dimension;
-(int)hamming;
-(int)manhattan;
-(NSNumber *)isGoal;
-(PuzzleBoard *)twin;
-(BOOL)equalsTo:(PuzzleBoard *)other;
-(NSArray *)neighbours;
-(int)itemIn:(int)i and:(int)j;
-(ALPairNumber *)indexForZero;
-(PuzzleBoard *)targetBoardWithLength:(NSInteger)length;
@end
