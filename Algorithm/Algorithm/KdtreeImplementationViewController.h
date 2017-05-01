//
//  KdtreeImplementationViewController.h
//  Algorithm
//
//  Created by LAL on 17/4/5.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "ALBasicViewController.h"
#import "Project.h"
#import "ALDrawingView.h"
@interface KdtreeImplementationViewController : ALBasicViewController
@property (nonatomic, strong) Project *project;
@property (weak, nonatomic) IBOutlet ALDrawingView *animationView;
@property (weak, nonatomic) IBOutlet UIView *resultDisplayView;
@property (weak, nonatomic) IBOutlet UIView *controlView;
@end
