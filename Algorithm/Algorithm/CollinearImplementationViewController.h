//
//  CollinearImplementationViewController.h
//  Algorithm
//
//  Created by LAL on 17/4/12.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "ALBasicViewController.h"
#import "ALDrawingView.h"
#import "Project.h"

@interface CollinearImplementationViewController : ALBasicViewController
@property (nonatomic, strong) Project *project;
@property (nonatomic, weak) IBOutlet ALDrawingView *animationView;
@property (nonatomic, weak) IBOutlet UIView *resultDisplayView;
@property (nonatomic, weak) IBOutlet UIView *controlView;

@end
