//
//  PuzzleImplementationViewController.h
//  Algorithm
//
//  Created by LAL on 17/3/27.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleAnimationView.h"
#import "Project.h"
#import "ALBasicViewController.h"

@interface PuzzleImplementationViewController : ALBasicViewController<PuzzleAnimationViewDataSource,PuzzleAnimationViewDelegate>
@property (nonatomic, strong) Project *project;
@property (weak, nonatomic) IBOutlet PuzzleAnimationView *animationView;
@property (weak, nonatomic) IBOutlet UIView *resultDisplayView;
@property (weak, nonatomic) IBOutlet UIView *controlView;

@end
