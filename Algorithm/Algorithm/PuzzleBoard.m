//
//  8PuzzleBoard.m
//  Algorithm
//
//  Created by LAL on 17/3/27.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "PuzzleBoard.h"
#import "NSMutableArray+Shuffle.h"

@interface PuzzleBoard(){
    int** blocks;
    int N;
}
@property(nonatomic, strong) NSDictionary *neighboursDictionary;
@end

@implementation PuzzleBoard

-(instancetype)initWithBlocks:(int **)b andLength:(int)length{
    if(self = [self init]){
        blocks = [self copy2DArrayFromBlocks:b withLength:length];
        N = length;
    }
    return self;
}

-(id)initRandomlyWithLength:(int)length{
    if(self = [self init]){
        blocks = [self create2DArrayRandomlyForLength:length];
        N = length;
    }
    return self;
}

-(int)dimension{
    return N;
}

-(int)hamming{
    int sum = 0;
    for (int i = 0; i < N; i++){
        for(int j = 0; j < N; j++){
            if(blocks[i][j] !=0 && (blocks[i][j] != N*i+j+1)) sum++;
        }
    }
    return sum;
}

-(int) manhattan{
    int sum = 0;
    for (int i = 0; i < N; i++){
        for(int j = 0; j < N; j++){
            if(blocks[i][j] !=0){
                int n = blocks[i][j];
                int goalI = (n-1)/N;
                int goalJ = (n-1)%N;
                int delta = abs(goalI-i) + abs(goalJ - j);
                if(delta !=0) sum += delta;
            }
        }
    }
    return sum;
}

-(NSNumber*) isGoal{
    return [NSNumber numberWithBool:[self manhattan] == 0];
}

-(PuzzleBoard *)twin{
    int **twinBlock =[self copy2DArrayFromBlocks:blocks withLength:N];
    int count = 0;
    int **index = malloc(2*sizeof(int *));
    for(int i = 0; i < 2; i++){
        index[i] = malloc(2*sizeof(int));
    }
    
    BOOL outFlag = FALSE;
    for (int i = 0; i < N; i++){
        if(outFlag == TRUE) break;
        for(int j = 0; j < N; j++){
            if (count >=2){
                outFlag = true;
                break;
            }
            if(twinBlock[i][j] != 0){
                index[count][0] = i;
                index[count][1] = j;
                count++;
            };
        }
    }
    [self swapItemWithSourceArray:twinBlock sourceI:index[0][0] sourceJ:index[0][1] destinationI:index[1][0] destinationJ:index[1][1]];
    
    for (int i = 0; i < 2; i++){
        free(index[i]);
    }
    free(index);
    
    return [[PuzzleBoard alloc] initWithBlocks:twinBlock andLength:N];
}

-(BOOL)equalsTo:(PuzzleBoard *)other{
    if (other == nil) return FALSE;
    else{
        if([self dimension] != [other dimension]) return FALSE;
        return [[self description] isEqualToString:[other description]];
    }
}

-(NSDictionary *)neighboursDictionary{
    if(_neighboursDictionary == nil){
        int i0 = 0, j0 = 0;
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                if (blocks[i][j] == 0) {
                    i0 = i;
                    j0 = j;
                    break;
                }
            }
        }
        NSMutableDictionary *neighbourBoardsDictionary = [[NSMutableDictionary alloc] init];
        if (i0 - 1 >= 0) {
            int** upBlock = [self copy2DArrayFromBlocks:blocks withLength:N];
            [self swapItemWithSourceArray:upBlock sourceI:i0 sourceJ:j0 destinationI:i0-1 destinationJ:j0];
            PuzzleBoard *upBoard = [[PuzzleBoard alloc] initWithBlocks:upBlock andLength:N];
            [neighbourBoardsDictionary setObject:upBoard forKey:@(UISwipeGestureRecognizerDirectionDown)];
        }
        
        if (i0 + 1 < N) {
            int** belowBlock = [self copy2DArrayFromBlocks:blocks withLength:N];
            [self swapItemWithSourceArray:belowBlock sourceI:i0 sourceJ:j0 destinationI:i0+1 destinationJ:j0];
            PuzzleBoard *belowBoard = [[PuzzleBoard alloc] initWithBlocks:belowBlock andLength:N];
            [neighbourBoardsDictionary setObject:belowBoard forKey:@(UISwipeGestureRecognizerDirectionUp)];
        }
        
        if (j0 - 1 >= 0) {
            int** leftBlock = [self copy2DArrayFromBlocks:blocks withLength:N];
            [self swapItemWithSourceArray:leftBlock sourceI:i0 sourceJ:j0 destinationI:i0 destinationJ:j0-1];
            PuzzleBoard *leftBoard =[[PuzzleBoard alloc] initWithBlocks:leftBlock andLength:N];
            [neighbourBoardsDictionary setObject:leftBoard forKey:@(UISwipeGestureRecognizerDirectionRight)];
        }
        
        
        if (j0 + 1 < N) {
            int** rightBlock = [self copy2DArrayFromBlocks:blocks withLength:N];
            [self swapItemWithSourceArray:rightBlock sourceI:i0 sourceJ:j0 destinationI:i0 destinationJ:j0+1];
            PuzzleBoard *rightBoard = [[PuzzleBoard alloc] initWithBlocks:rightBlock andLength:N];
            [neighbourBoardsDictionary setObject:rightBoard forKey:@(UISwipeGestureRecognizerDirectionLeft)];
        }
        _neighboursDictionary = [NSDictionary dictionaryWithDictionary:neighbourBoardsDictionary];
    }
    return _neighboursDictionary;
}

-(NSArray *)neighbours{
    
    /*
     int i0 = 0, j0 = 0;
     for (int i = 0; i < N; i++) {
     for (int j = 0; j < N; j++) {
     if (blocks[i][j] == 0) {
     i0 = i;
     j0 = j;
     break;
     }
     }
     }
     NSMutableDictionary *neighbourBoardsDicionary = [[NSMutableDictionary alloc] init];
     NSMutableArray *neighbourBoards = [NSMutableArray array];
     if (i0 - 1 >= 0) {
     int** upBlock = [self copy2DArrayFromBlocks:blocks withLength:N];
     [self swapItemWithSourceArray:upBlock sourceI:i0 sourceJ:j0 destinationI:i0-1 destinationJ:j0];
     PuzzleBoard *upBoard = [[PuzzleBoard alloc] initWithBlocks:upBlock andLength:N];
     [neighbourBoards addObject:upBoard];
     [neighbourBoardsDicionary setObject:upBoard forKey:@(UISwipeGestureRecognizerDirectionUp)];
     }
     
     if (i0 + 1 < N) {
     int** belowBlock = [self copy2DArrayFromBlocks:blocks withLength:N];
     [self swapItemWithSourceArray:belowBlock sourceI:i0 sourceJ:j0 destinationI:i0+1 destinationJ:j0];
     PuzzleBoard *belowBoard = [[PuzzleBoard alloc] initWithBlocks:belowBlock andLength:N];
     [neighbourBoards addObject:belowBoard];
     [neighbourBoardsDicionary setObject:belowBoard forKey:@(UISwipeGestureRecognizerDirectionDown)];
     }
     
     if (j0 - 1 >= 0) {
     int** leftBlock = [self copy2DArrayFromBlocks:blocks withLength:N];
     [self swapItemWithSourceArray:leftBlock sourceI:i0 sourceJ:j0 destinationI:i0 destinationJ:j0-1];
     PuzzleBoard *leftBoard =[[PuzzleBoard alloc] initWithBlocks:leftBlock andLength:N];
     [neighbourBoards addObject:leftBoard];
     [neighbourBoardsDicionary setObject:leftBoard forKey:@(UISwipeGestureRecognizerDirectionLeft)];
     }
     
     
     if (j0 + 1 < N) {
     int** rightBlock = [self copy2DArrayFromBlocks:blocks withLength:N];
     [self swapItemWithSourceArray:rightBlock sourceI:i0 sourceJ:j0 destinationI:i0 destinationJ:j0+1];
     PuzzleBoard *rightBoard = [[PuzzleBoard alloc] initWithBlocks:rightBlock andLength:N];
     [neighbourBoards addObject:rightBoard];
     [neighbourBoardsDicionary setObject:rightBoard forKey:@(UISwipeGestureRecognizerDirectionRight)];
     }
     */
    return [[self neighboursDictionary] allValues];
}

-(NSString *)description{
    NSMutableString * result = [NSMutableString string];
    [result appendString:@"\n"];
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            [result appendString:[NSString stringWithFormat:@"%2d ", blocks[i][j]]];
        }
        [result appendString:@"\n"];
    }
    return [NSString stringWithString:result];
}

-(int)itemIn:(int)i and:(int)j{
    return blocks[i][j];
}

-(ALPairNumber*)indexForZero{
    NSInteger row = 0;
    CGFloat col = 0;
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            if (blocks[i][j] == 0) {
                row = i;
                col = j;
                break;
            }
        }
    }
    return [[ALPairNumber alloc] initWithRow:@(row) andCol:@(col)];
}

/*
-(PuzzleBoard *)targetBoardWithLength:(NSInteger)length{
    int **newBlock = malloc(length*sizeof(int *));
    for (int i = 0; i < length; i++){
        newBlock[i] = malloc(length*sizeof(int));
    }
    for (int i = 0; i < length; i++){
        for (int j = 0; j < length; j++){
            if(!(i == length-1 && j == length -1)){
                newBlock[i][j] = i*N+j+1;
            }else{
                newBlock[i][j] = 0;
            }
        }
    }
    return [[PuzzleBoard alloc] initWithBlocks:newBlock andLength:length];
}
*/
/*
-(BOOL)isWin{
    return [self.description isEqualToString:[self targetBoardWithLength:N].description];
}
*/
#pragma mark - helper

-(int **)copy2DArrayFromBlocks:(int **)b withLength:(int)length{
    int **newBlock = malloc(length*sizeof(int *));
    for (int i = 0; i < length; i++){
        newBlock[i] = malloc(length*sizeof(int));
    }
    for (int i = 0; i < length; i++){
        for (int j = 0; j < length; j++){
            newBlock[i][j] = b[i][j];
        }
    }
    return newBlock;
}

-(void)swapItemWithSourceArray:(int**)src
                       sourceI:(int)srcI
                       sourceJ:(int) srcJ
                  destinationI:(int) destI
                  destinationJ:(int) destJ{
    int temp = src[srcI][srcJ];
    src[srcI][srcJ] = src[destI][destJ];
    src[destI][destJ] = temp;
}

-(int**)create2DArrayRandomlyForLength:(int)length{
    int **b = malloc(length*sizeof(int *));
    for (int i = 0; i < length; i++){
        b[i] = malloc(length*sizeof(int));
    }
    
    NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:length*length];
    for(int i = 0; i < length*length;i++){
        indexArray[i] = @(i);
    }
    [indexArray shuffle];
    
    for(int i = 0; i < length*length;i++){
        int row = i / length;
        int col = i % length;
        b[row][col] = [(NSNumber *)indexArray[i] intValue];
    }
    return b;
}

-(void)dealloc{
    for (int i = 0; i < N; i++){
        free(blocks[i]);
    }
    free(blocks);
}

@end
