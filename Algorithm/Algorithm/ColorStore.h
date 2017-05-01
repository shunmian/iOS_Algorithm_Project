//
//  ColorStore.h
//  Algorithm
//
//  Created by LAL on 17/3/24.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ColorStore : NSObject

+(UIColor *)basicThemeColor;
+(UIColor *)basicThemeColorWithAlpha:(CGFloat)alpha;
+(UIColor *)percolationHoleColorWithAlpha:(CGFloat)alpha;
+(UIColor *)percolationHoleColor;
+(UIColor *)redColor;
+(UIColor *)redColorWithAlpha:(CGFloat)alpha;

+(UIColor *)animationViewColor;
+(UIColor *)resultDisplayViewColor;
+(UIColor *)controlViewColor;


@end
