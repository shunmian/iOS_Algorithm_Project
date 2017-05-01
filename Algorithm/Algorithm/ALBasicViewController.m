//
//  ALBasicViewController.m
//  Algorithm
//
//  Created by LAL on 17/3/24.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "ALBasicViewController.h"

@interface ALBasicViewController ()

@end

@implementation ALBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //0. customize return button in NavigationBar
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    //1. setUp customized backgroundImageWithBlur
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"backgroundImageWithBlur"];
    [self.view insertSubview:imageView atIndex:0];
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

-(CGFloat)offsetHeightFromStatusBarAndNavigationBar{
    return self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height;
}

@end
