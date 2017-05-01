//
//  PuzzleSolver.m
//  Algorithm
//
//  Created by LAL on 17/3/27.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "PuzzleSolver.h"

#import "MinPriorityQueue.h"

@interface Node: NSObject
@property(nonatomic, strong) PuzzleBoard* board;
@property(nonatomic, assign) int moves;
@property(nonatomic, assign) int manhattan;
@property(nonatomic, assign) int priority;
@property(nonatomic, strong) Node *pre;
@end

@implementation Node

-(instancetype)initWithBoard:(PuzzleBoard *)board Moves:(int)moves Node:(Node*)node{
    if(self = [super init]){
        _board = board;
        _moves = moves;
        _manhattan = [board manhattan];
        _priority = _moves + _manhattan;
        _pre = node;
    }
    return self;
}


- (NSComparisonResult)compare:(Node *)other{
    if (self.priority < other.priority) return NSOrderedAscending;
    else if(self.priority > other.priority) return NSOrderedDescending;
    else return NSOrderedSame;
}

-(NSString *)description {
    NSMutableString *result = [NSMutableString string];
    [result appendString:@"\n"];
    [result appendString:[NSString stringWithFormat:@"priority : %d\n",self.priority]];
    [result appendString:[NSString stringWithFormat:@"moves    : %d\n",self.moves]];
    [result appendString:[NSString stringWithFormat:@"manhattan: %d\n",self.manhattan]];
    [result appendString:[NSString stringWithFormat:@"%@\n",self.board.description]];
    return [NSString stringWithString:result];
}

@end



@interface PuzzleSolver()
@property(nonatomic, strong) Node* A;
@property(nonatomic, strong) Node* B;
@end

@implementation PuzzleSolver

-(instancetype)initWithBoard:(PuzzleBoard*)initialBoard{
    if (self = [super init]) {
        [self twinSolutionWithBoard:initialBoard];
    }
    return self;
}

-(BOOL) twinSolutionWithBoard:(PuzzleBoard*)initialBoard{
    Node *firstA = [[Node alloc] initWithBoard:initialBoard Moves:0 Node:nil];
    Node *currentA = firstA;
    MinPriorityQueue *nodePQA = [[MinPriorityQueue alloc] initWithCapacity:1];
    
    Node *firstB = [[Node alloc] initWithBoard:[initialBoard twin] Moves:0 Node:nil];
    Node *currentB = firstB;
    MinPriorityQueue *nodePQB = [[MinPriorityQueue alloc] initWithCapacity:1];

    while([currentA manhattan] != 0 && [currentB manhattan] != 0){
        currentA = [self alternateAB:currentA withPriorityQueue:nodePQA];
        currentB = [self alternateAB:currentB withPriorityQueue:nodePQB];
    }
    
    if ([currentA manhattan]==0){
        self.A = currentA;
        return TRUE;
    }else{
        self.B = currentB;
        return FALSE;
    }
    
}

-(Node *)alternateAB:(Node *)node withPriorityQueue:(MinPriorityQueue *)nodePQ{
    for (PuzzleBoard *b in [node.board neighbours]){
        Node *nextLevelNode = [[Node alloc] initWithBoard:b Moves:node.moves+1 Node:node];
        if(node.pre == nil || ![nextLevelNode.board equalsTo:node.pre.board]){
            [nodePQ insert:nextLevelNode];
        }
    }
    return [nodePQ deleteMin];
}

-(BOOL)isSolvable{
    return self.A == nil? FALSE: TRUE;
}

-(NSNumber *)moves{
    if(![self isSolvable]) return @(self.B.moves);
    else return @(self.A.moves);
}

-(NSEnumerator *)solution{
    if(![self isSolvable]) {
        NSMutableArray *result = [NSMutableArray array];
        for (Node *n = self.B; n!=nil;  n= n.pre){
            [result addObject:n.board];
        }
        return [[NSArray arrayWithArray:result] reverseObjectEnumerator];
    }else{
        NSMutableArray *result = [NSMutableArray array];
        for (Node *n = self.A; n!=nil;  n= n.pre){
            [result addObject:n.board];
        }
        return [[NSArray arrayWithArray:result] reverseObjectEnumerator];
    }
}


@end






