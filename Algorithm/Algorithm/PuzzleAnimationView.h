//
//  PuzzleAnimationView.h
//  Algorithm
//
//  Created by LAL on 17/3/27.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleBoard.h"

@class PuzzleAnimationView;
typedef void(^switchCompletionBlock)(BOOL);

@protocol PuzzleAnimationViewDataSource <NSObject>
-(PuzzleBoard *)getCurrentPuzzleBoardForAnimationView:(PuzzleAnimationView*)animationView;
-(void)setPuzzleBoardFromAnimationView:(PuzzleBoard*)puzzleBoard;
-(void)setFromBeginningFlag:(NSNumber *)flag;
-(void)setFromStartPosition:(NSNumber *)flag;
-(void)setPlayerTouched:(NSNumber *)flag;
-(void)setCurrentStep:(NSNumber *)number;
-(NSNumber *)currentStep;
@end

@protocol PuzzleAnimationViewDelegate <NSObject>

-(void)puzzleAnimationViewDidUpdateFromBoard:(PuzzleBoard *)sourceBoard toBoard:(PuzzleBoard*)destinationBoard;

@end

@interface PuzzleAnimationView : UIView
@property(nonatomic, weak) id<PuzzleAnimationViewDataSource> dataSource;
@property(nonatomic, weak) id<PuzzleAnimationViewDelegate> delegate;
@property(nonatomic, strong) PuzzleBoard *currentBoard;

-(void)switchFromSourceBoard:(PuzzleBoard *) sourceBoard
                 toDestBoard:(PuzzleBoard *) destBoard
                  completion:(switchCompletionBlock) switchCompletion;

-(void)enableSwipeGestureRecognizers:(BOOL)enabled;
@end
