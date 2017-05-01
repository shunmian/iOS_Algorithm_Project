//
//  PuzzleSolver.h
//  Algorithm
//
//  Created by LAL on 17/3/27.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PuzzleBoard.h"

@interface PuzzleSolver : NSObject
@property (nonatomic, strong) NSNumber *moves;

-(instancetype)initWithBoard:(PuzzleBoard*)initialBoard;
-(BOOL)isSolvable;
-(NSEnumerator *)solution;

@end
