//
//  AlgorithmTests.m
//  AlgorithmTests
//
//  Created by LAL on 17/3/18.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WeightedQuickUnionFind.h"
#import "MinPriorityQueue.h"
#import "PercolationStats.h"
#import "MathStats.h"
#import "PuzzleBoard.h"
#import "PuzzleSolver.h"
#import "KdTree.h"
#import "ALPoint.h"
#import "FastCollinearPoints.h"
#import "StdIn.h"

@interface AlgorithmTests : XCTestCase
@property(nonatomic,strong) WeightedQuickUnionFind *wqUF;
@property(nonatomic,strong) PercolationStats *pStats;
@end

@implementation AlgorithmTests

- (void)setUp {
    [super setUp];
    
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
//    [self testWeightedQuickUnionFind];
//    [self testMinPriorityQueue];
    //[self testPuzzleBoard];

    //[self testPuzzleSolver];
    //[self testMathStats];
    //[self testALPoint];
    [self testFastCollinearPoints];
    //[self testKdtree];
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        [self testPuzzleSolver];
    }];
}

#pragma mark - Helper


-(void)testWeightedQuickUnionFind{
    DLog(@"count:%d",self.wqUF.count);
    [self.wqUF unionID:3 withID:8];
    XCTAssertEqual([self.wqUF count],9,@"wquf错误！");
    [self.wqUF unionID:7 withID:9];
    XCTAssertEqual([self.wqUF count],8,@"wquf错误！");
    [self.wqUF unionID:2 withID:5];
    XCTAssertEqual([self.wqUF count],7,@"wquf错误！");
    [self.wqUF unionID:3 withID:7];
    XCTAssertEqual([self.wqUF count],6,@"wquf错误！");
    [self.wqUF unionID:4 withID:6];
    XCTAssertEqual([self.wqUF count],5,@"wquf错误！");
    [self.wqUF unionID:0 withID:1];
    [self.wqUF unionID:0 withID:3];
    XCTAssertEqual([self.wqUF count],3,@"wquf错误！");
    XCTAssertEqual([self.wqUF findSetWithID:5],2,@"wquf错误!");
    XCTAssertEqual([self.wqUF findSetWithID:2],2,@"wquf错误!");
    XCTAssertEqual([self.wqUF findSetWithID:0],3,@"wquf错误!");
    XCTAssertEqual([self.wqUF findSetWithID:1],3,@"wquf错误!");
    XCTAssertEqual([self.wqUF findSetWithID:7],3,@"wquf错误!");
    XCTAssertEqual([self.wqUF findSetWithID:8],3,@"wquf错误!");
    XCTAssertEqual([self.wqUF findSetWithID:9],3,@"wquf错误!");
    XCTAssertEqual([self.wqUF findSetWithID:6],4,@"wquf错误!");
    XCTAssertEqual([self.wqUF findSetWithID:4],4,@"wquf错误!");
    [self.wqUF unionID:0 withID:1];
    [self.wqUF unionID:2 withID:3];
    [self.wqUF unionID:4 withID:3];
    XCTAssertEqual([self.wqUF count],1,@"wquf错误！");
    for(int i = 0; i<10;++i){
        XCTAssertEqual([self.wqUF findSetWithID:i],3,@"wquf错误!");
    }
}


-(void)testPercolationStats{
    self.pStats = [[PercolationStats alloc] initWithCount:100 andRepeat:100];
    [self.pStats printResult];
    DLog(@"mean:%.3f",self.pStats.mean);
    DLog(@"stddev: %.3f",self.pStats.standardDeviation);
    DLog(@"confidenceLo:%.3f",self.pStats.confidenceLo);
    DLog(@"confidenceHi:%.3f",self.pStats.confidenceHi);
}

-(void)testMinPriorityQueue{
    MinPriorityQueue *minPQ = [[MinPriorityQueue alloc] initWithCapacity:1];

    for (int i = 0; i < 18; i++){
        int random = [MathStats getRandomNumberBetween:0 to:100];
        [minPQ insert:[NSNumber numberWithInt:random]];
    }
    DLog(@"%@",minPQ);
    XCTAssertEqual([minPQ size],18,@"minPQ size错误！");
    NSNumber *min1 = [minPQ deleteMin];
    DLog(@"min1: %@",min1);
    XCTAssertEqual([minPQ size],17,@"minPQ size错误！");
    DLog(@"%@",minPQ);
    [minPQ insert:@50];
    DLog(@"%@",minPQ);
    DLog(@"test enumerator--------------:");
    for(id item in [minPQ enumerator]){
        DLog(@"%@",item);
    }
    
    
    minPQ = [[MinPriorityQueue alloc] initWithCapacity:1];
    
    for (int i = 0; i < 2; i++){
        int random = [MathStats getRandomNumberBetween:0 to:100];
        [minPQ insert:[NSNumber numberWithInt:random]];
    }
    [minPQ deleteMin];
    [minPQ deleteMin];
//    [minPQ deleteMin];
    DLog(@"%ld",(long)[minPQ size]);

}

-(void)testPuzzleBoard{
    int n = 3;
    int **block = malloc(n*sizeof(int*));
    for (int i = 0; i < 3; i++){
        block[i] = malloc(n*sizeof(int));
    }
    block[0][0] = 1; block[0][1] = 2; block[0][2] = 3;
    block[1][0] = 4; block[1][1] = 0; block[1][2] = 5;
    block[2][0] = 7; block[2][1] = 8; block[2][2] = 6;
    
    
    PuzzleBoard *puzzleBoard = [[PuzzleBoard alloc] initWithBlocks:block andLength:n];
    
    DLog(@"board description: %@",puzzleBoard);
    DLog(@"hamming: %d",[puzzleBoard hamming]);
    DLog(@"manhattan: %d",[puzzleBoard manhattan]);
    for (PuzzleBoard *pb in [puzzleBoard neighbours]){
        DLog(@"board neighbours: %@",pb);
    }

    DLog(@"board twin: %@",[puzzleBoard twin]);
    XCTAssertEqual([puzzleBoard manhattan],2,@"manhattan错误！");
    
    for (int i = 0; i < n; i++){
        free(block[i]);
    }
    free(block);
}

-(void)testPuzzleSolver{
    
    int n = 3;
    int **block = malloc(n*sizeof(int*));
    for (int i = 0; i < 3; i++){
        block[i] = malloc(n*sizeof(int));
    }
    block[0][0] = 3; block[0][1] = 5; block[0][2] = 8;
    block[1][0] = 6; block[1][1] = 4; block[1][2] = 1;
    block[2][0] = 7; block[2][1] = 2; block[2][2] = 0;
    
    /*
    PuzzleBoard *puzzleBoard = [[PuzzleBoard alloc] initRandomlyWithLength:3];
    DLog(@"%@",puzzleBoard);
     */
    PuzzleBoard *puzzleBoard = [[PuzzleBoard alloc] initWithBlocks:block andLength:3];
    PuzzleSolver *solver = [[PuzzleSolver alloc] initWithBoard:puzzleBoard];
    DLog(@"%@",puzzleBoard);
    if(![solver isSolvable]){
        DLog(@"No solution possible");
        DLog(@"Minimum number of moves = %d",solver.moves);
        for (PuzzleBoard *b in [solver solution]){
            DLog(@"%@",b);
        }
    }else{
        DLog(@"Minimum number of moves = %d",solver.moves);
        for (PuzzleBoard *b in [solver solution]){
            DLog(@"%@",b);
        }
    }
    
    
    /*
    for (int i = 0; i < n; i++){
        free(block[i]);
    }
    free(block);
     */
}

-(void)testKdtree{
    KdTree *kdtree = [[KdTree alloc] init];
    [kdtree  insert:CGPointMake(0.206107, 0.095492)];
    [kdtree  insert:CGPointMake(0.975528, 0.654508)];
    [kdtree  insert:CGPointMake(0.024472, 0.345492)];
    [kdtree  insert:CGPointMake(0.793893, 0.095492)];
    [kdtree  insert:CGPointMake(0.793893, 0.904508)];
    [kdtree  insert:CGPointMake(0.975528, 0.345492)];
    [kdtree  insert:CGPointMake(0.206107, 0.904508)];
    [kdtree  insert:CGPointMake(0.500000, 0.000000)];
    [kdtree  insert:CGPointMake(0.024472, 0.654508)];
    [kdtree  insert:CGPointMake(0.500000, 1.000000)];
    
    DLog(@"%@",kdtree);
    
    CGPoint targetP = CGPointMake(0.5, 0.89);
    CGPoint nearestP = [kdtree nearestToPoint:targetP];
    DLog(@"nearest Points to (%f,%f):(%f,%f)",targetP.x,targetP.y, nearestP.x,nearestP.y);
    
    
    targetP = CGPointMake(0.206107, 0.904508);
    nearestP = [kdtree nearestToPoint:targetP];
    DLog(@"kdtree contains (%f,%f):%d",targetP.x,targetP.y, [kdtree containsPoint:targetP]);
    for(NSValue *pValue in [kdtree IterablePointsForRange:CGRectMake(0, 0, 1, 1)]){
        CGPoint p = [pValue CGPointValue];
        DLog(@"rect: contains (%f,%f):",p.x,p.y);
    }
}

-(void)testMathStats{
    for (int i = 0; i < 10; i++){
        DLog(@"%f",[MathStats getRandomDoubleNumberBetween:0 to:1]);
    }
}

-(void)testALPoint{
    DLog(@"infinity:%.2f",INFINITY);
    DLog(@"-inifity:%.2f",-INFINITY);
    ALPoint *p1 = [[ALPoint alloc] initWithX:1 andY:2];
    DLog(@"p1:%@",p1);
    ALPoint *p2 = [[ALPoint alloc] initWithX:3 andY:4];
    DLog(@"p2:%@",p2);
    ALPoint *p3 = [[ALPoint alloc] initWithX:5 andY:6];
    DLog(@"p3:%@",p3);
    
    ALPoint *p4 = [[ALPoint alloc] initWithX:1 andY:2];
    DLog(@"p4: itself slope -infinity:%.2f",[p1 slopeToPoint:p4]);
    
    ALPoint *p5 = [[ALPoint alloc] initWithX:2 andY:2];
    DLog(@"p5: horizontal slope 0.0: %.2f",[p1 slopeToPoint:p5]);
    
    ALPoint *p6 = [[ALPoint alloc] initWithX:1 andY:1];
    DLog(@"p6: vertical slope +infinity: %.2f",[p1 slopeToPoint:p6]);
    
    DLog(@"%@ compare to %@:%ld\n",p1,p2,(long)[p1 compare:p2]);
    DLog(@"%@ compare to %@:%ld\n",p1,p4,(long)[p1 compare:p4]);
    DLog(@"%@ compare to %@:%ld\n",p1,p5,(long)[p1 compare:p5]);
    DLog(@"%@ compare to %@:%ld\n",p1,p6,(long)[p1 compare:p6]);
    
    NSArray *points = @[p2,p3,p5,p6];
    DLog(@"before sort:%@",points);
    
    points = [points sortedArrayUsingComparator:^NSComparisonResult(ALPoint *point1, ALPoint *point2) {
        return [point1 compare:point2];
    }];
    DLog(@"after sort:%@",points);
    
    points = [points sortedArrayUsingComparator:^NSComparisonResult(ALPoint *point1, ALPoint *point2) {
        return [p1 compareSlopeWithPoint:point1 andPoint:point2];
    }];
    DLog(@"after sort by slope:%@",points);
}

-(void)testFastCollinearPoints{
    NSString *contents = [StdIn readFile:@"input8" ofType:@"txt"];
    NSArray *lines = [contents componentsSeparatedByString:@"\n"];
    DLog(@"%@",lines);
    int count = [((NSString *)lines[0]) intValue];
    NSMutableArray *points =[NSMutableArray arrayWithCapacity:count];
    for(int i = 1; i < count+1;i++){
        NSString *line = lines[i];
        NSMutableArray *pointComponents = (NSMutableArray *)[line componentsSeparatedByString:@" "];
        [pointComponents removeObject:@""];
        CGFloat x = [pointComponents[0] floatValue];
        CGFloat y = [pointComponents[1] floatValue];
        ALPoint *p = [[ALPoint alloc] initWithX:x andY:y];
        [points addObject:p];
    }
    DLog(@"%@",points);

    FastCollinearPoints *fcp = [[FastCollinearPoints alloc] initWithPoints:[NSArray arrayWithArray:points]];
    DLog(@"fcp segments: %@",[fcp getCollinearSegments]);
}

@end
