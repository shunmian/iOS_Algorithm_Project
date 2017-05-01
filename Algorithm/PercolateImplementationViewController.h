//
//  PercolateImplementationViewController.h
//  Algorithm
//
//  Created by LAL on 17/3/19.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "Percolation.h"
#import "PercolationAnimationView.h"
#import "ALBasicViewController.h"

@interface PercolateImplementationViewController : ALBasicViewController <PercolationAnimationViewDelegate>

@property (nonatomic, strong) Project *project;
@property (weak, nonatomic) IBOutlet PercolationAnimationView *animationView;
@property (weak, nonatomic) IBOutlet UIView *resultDisplayView;
@property (weak, nonatomic) IBOutlet UIView *controlView;


@end
