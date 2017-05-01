//
//  StdDraw.h
//  Algorithm
//
//  Created by LAL on 17/3/31.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StdDraw : NSObject

@property(nonatomic, strong) UIView *view;
-(void)setPenColor:(UIColor *)color;
-(void)setPenRadius:(CGFloat)radius;
-(void)drawPoint:(CGPoint)p;
-(void)drawLineFromPoint:(CGPoint)fromP toPoint:(CGPoint)toP;
@end
