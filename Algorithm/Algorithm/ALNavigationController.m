//
//  ALNavigationController.m
//  Algorithm
//
//  Created by LAL on 17/3/25.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "ALNavigationController.h"

@interface ALNavigationController ()

@end

@implementation ALNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
    self.navigationBar.barStyle = UIBarStyleBlack;
    
    //add separatorView for NavigationBar once.
    UIView *separator = ({UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBar.frame.size.height-1.5, self.view.frame.size.width, 1.5)];
        line.backgroundColor = [ColorStore basicThemeColorWithAlpha:0.1f];
        line.stringTag = @"separatorForNavigationBar";
        line;
    });
    [self.navigationBar addSubview:separator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
