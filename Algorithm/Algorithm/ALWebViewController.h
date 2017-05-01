//
//  DescriptionViewController.h
//  Algorithm
//
//  Created by LAL on 17/3/19.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "ALBasicViewController.h"

@interface ALWebViewController : ALBasicViewController

@property (nonatomic, strong) Project *project;
@property (nonatomic, strong) UIWebView *webView;
-(void)loadPDFinWebviewWithPDF:(NSString *)pdfName;
@end
