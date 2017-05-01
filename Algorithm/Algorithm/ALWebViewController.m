//
//  DescriptionViewController.m
//  Algorithm
//
//  Created by LAL on 17/3/19.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "ALWebViewController.h"

@interface ALWebViewController ()

@end

@implementation ALWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.project.shortName;
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.webView];
    self.webView.backgroundColor = [UIColor clearColor];
    [self.webView setScalesPageToFit:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIView *superView = self.webView.superview;
        make.left.equalTo(superView.mas_left).with.offset(0);
        make.right.equalTo(superView.mas_right).with.offset(0);
        make.top.equalTo(superView.mas_top).with.offset([self offsetHeightFromStatusBarAndNavigationBar]);
        make.bottom.equalTo(superView.mas_bottom).with.offset(0);
    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)loadPDFinWebviewWithPDF:(NSString *)pdfName{
    NSString *path = [[NSBundle mainBundle] pathForResource:pdfName ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [self.webView loadRequest:request];

}

@end
