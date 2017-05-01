//
//  PuzzleAnimationView.m
//  Algorithm
//
//  Created by LAL on 17/3/27.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "PuzzleAnimationView.h"
#import "PuzzleBoard.h"
#import "ALPairNumber.h"
#import "ALView.h"
#import "PuzzleGridView.h"


@interface PuzzleAnimationView(){
    int n;
    CGFloat unitWidth;
    CGFloat unitHeight;
}
@property(nonatomic, strong) NSMutableArray<PuzzleGridView*> *gridViews;
@property(nonatomic, strong) UISwipeGestureRecognizer *swipeUpGuestrueRecognizer;
@property(nonatomic, strong) UISwipeGestureRecognizer *swipeDownGuestrueRecognizer;
@property(nonatomic, strong) UISwipeGestureRecognizer *swipeLeftGuestrueRecognizer;
@property(nonatomic, strong) UISwipeGestureRecognizer *swipeRightGuestrueRecognizer;
@property(nonatomic, assign) BOOL isLayoutSubview;
@end


@implementation PuzzleAnimationView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setUp];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self setUp];
    }
    return self;
}

-(void)setUp{
    self.swipeUpGuestrueRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeInFourDirection:)];
    self.swipeUpGuestrueRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:self.swipeUpGuestrueRecognizer];
    
    self.swipeDownGuestrueRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeInFourDirection:)];
    self.swipeDownGuestrueRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:self.swipeDownGuestrueRecognizer];
    
    self.swipeLeftGuestrueRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeInFourDirection:)];
    self.swipeLeftGuestrueRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:self.swipeLeftGuestrueRecognizer];
    
    self.swipeRightGuestrueRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeInFourDirection:)];
    self.swipeRightGuestrueRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:self.swipeRightGuestrueRecognizer];
    self.isLayoutSubview = NO;
}

-(void)layoutSubviews{
    if(!self.isLayoutSubview){
        self.isLayoutSubview = YES;
        [super layoutSubviews];
        PuzzleBoard *currentPuzzleBoard = [self.dataSource getCurrentPuzzleBoardForAnimationView:self];
        n = 3;
        NSMutableArray *mutableGridViews = [NSMutableArray array];
        unitWidth = self.frame.size.width/n;
        unitHeight = self.frame.size.height/n;
        for(int row = 0; row < n; row++){
            for (int col = 0; col < n; col++){
                int number = [currentPuzzleBoard itemIn:row and:col];
                
                CGRect frame = CGRectMake(col*unitWidth, row*unitHeight, unitWidth, unitHeight);
                NSInteger tag = [self toOneDIndexWithRow:row andCol:col];
                PuzzleGridView *gridView = [[PuzzleGridView alloc] initViewWithFrame:frame
                                                                                 tag:tag
                                                                           andNumber:@(number)];
                [self addSubview:gridView];
                [mutableGridViews addObject:gridView];
                
            }
        }
        self.gridViews = mutableGridViews;
    }
}

-(PuzzleBoard *)currentBoard{
    return [self.dataSource getCurrentPuzzleBoardForAnimationView:self];
}

-(void)setCurrentBoard:(PuzzleBoard *)currentBoard{
    [self.dataSource setPuzzleBoardFromAnimationView:currentBoard];
}

-(void)swipeInFourDirection:(UISwipeGestureRecognizer *)recognizer{
    UISwipeGestureRecognizerDirection direction = recognizer.direction;
    NSDictionary *neighboursDictionary = [self.currentBoard neighboursDictionary];
    PuzzleBoard *destBoard;
    if(direction == UISwipeGestureRecognizerDirectionUp && [neighboursDictionary objectForKey:@(UISwipeGestureRecognizerDirectionUp)]){
        destBoard = [neighboursDictionary objectForKey:@(UISwipeGestureRecognizerDirectionUp)];
    }else if (direction == UISwipeGestureRecognizerDirectionDown && [neighboursDictionary objectForKey:@(UISwipeGestureRecognizerDirectionDown)]){
        destBoard = [neighboursDictionary objectForKey:@(UISwipeGestureRecognizerDirectionDown)];
    }else if (direction == UISwipeGestureRecognizerDirectionLeft && [neighboursDictionary objectForKey:@(UISwipeGestureRecognizerDirectionLeft)]){
        destBoard = [neighboursDictionary objectForKey:@(UISwipeGestureRecognizerDirectionLeft)];
        
    }else if (direction == UISwipeGestureRecognizerDirectionRight && [neighboursDictionary objectForKey:@(UISwipeGestureRecognizerDirectionRight)]){
        destBoard = [neighboursDictionary objectForKey:@(UISwipeGestureRecognizerDirectionRight)];
    }
    [self.dataSource setFromBeginningFlag:@NO];
    [self.dataSource setFromStartPosition:@NO];
    [self.dataSource setPlayerTouched:@YES];
    [self switchToDestBoard:destBoard];
}



-(void)updateConstraints{
    [super updateConstraints];
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.2f].CGColor;
    self.layer.borderWidth = 2.0f;
}


-(NSInteger)toOneDIndexWithRow:(int)row andCol:(int)col{
    return row*n+col+1;
}


- (void)drawRect:(CGRect)rect {
    PuzzleBoard *currentPuzzleBoard = [self.dataSource getCurrentPuzzleBoardForAnimationView:self];
    for (int i = 0; i < n; i++){
        for (int j = 0; j < n; j++){
            NSInteger tag = [self toOneDIndexWithRow:i andCol:j];
            PuzzleGridView *gridView = self.gridViews[tag-1];
            NSNumber *number = @([currentPuzzleBoard itemIn:i and:j]);
            [gridView setUpViewWithTag:tag andNumber:number];
        }
    }
}

#pragma mark - helper

-(void)enableSwipeGestureRecognizers:(BOOL)enabled{
    self.swipeUpGuestrueRecognizer.enabled = enabled;
    self.swipeDownGuestrueRecognizer.enabled = enabled;
    self.swipeLeftGuestrueRecognizer.enabled = enabled;
    self.swipeRightGuestrueRecognizer.enabled = enabled;
}

-(void)switchFromSourceBoard:(PuzzleBoard *) sourceBoard
                 toDestBoard:(PuzzleBoard *) destBoard
                  completion:(switchCompletionBlock) switchCompletion{
    
    [self enableSwipeGestureRecognizers:NO];
    ALPairNumber* sourceIndex = [sourceBoard indexForZero];
    NSInteger sourceRow = sourceIndex.row.integerValue;
    NSInteger sourceCol = sourceIndex.col.integerValue;
    CGPoint sourcePosition = CGPointMake(sourceCol*unitWidth,sourceRow*unitHeight);
    
    ALPairNumber* destIndex = [destBoard indexForZero];
    NSInteger destRow = destIndex.row.integerValue;
    NSInteger destCol = destIndex.col.integerValue;
    CGPoint destPosition = CGPointMake(destCol*unitWidth,destRow*unitHeight);
    
    NSInteger sourceIndexOneD = [self toOneDIndexWithRow:sourceRow andCol:sourceCol];
    NSInteger destIndexOneD = [self toOneDIndexWithRow:destRow andCol:destCol];
    PuzzleGridView *sourceView;
    PuzzleGridView *destView;
    
    for (PuzzleGridView *v in self.subviews){
        if([v isKindOfClass:[PuzzleGridView class]]){
            if(v.tag == sourceIndexOneD){
                sourceView = v;
            }else if(v.tag == destIndexOneD){
                destView = v;
            }
        }
    }
    PuzzleGridView *temp = self.gridViews[sourceIndexOneD-1];
    self.gridViews[sourceIndexOneD-1] = self.gridViews[destIndexOneD-1];
    self.gridViews[sourceIndexOneD-1].tag = sourceIndexOneD;
    self.gridViews[destIndexOneD-1] = temp;
    self.gridViews[destIndexOneD-1].tag = destIndexOneD;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = sourceView.frame;
        frame.origin = destPosition;
        sourceView.frame = frame;
        
        frame = destView.frame;
        frame.origin = sourcePosition;
        destView.frame = frame;
        
    } completion:^(BOOL finished) {
        self.currentBoard = destBoard;
        [self enableSwipeGestureRecognizers:YES];
        [self.dataSource setCurrentStep:@([self.dataSource currentStep].integerValue + 1)];
        if(switchCompletion) switchCompletion(finished);
    }];
}

-(void)switchToDestBoard:(PuzzleBoard*)destBoard{
    [self switchFromSourceBoard:self.currentBoard toDestBoard:destBoard completion:nil];
}

@end
