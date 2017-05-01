//
//  ColorStore.m
//  Algorithm
//
//  Created by LAL on 17/3/24.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "ColorStore.h"

@implementation ColorStore

+(UIColor *)basicThemeColor{
    return  [UIColor colorWithRed:29.0f/255.0f green:28.0f/255.0f blue:42.0f/255.0f alpha:1.0f];
}

+(UIColor *)basicThemeColorWithAlpha:(CGFloat)alpha{
    return [[self basicThemeColor] colorWithAlphaComponent:alpha];
}

+(UIColor *)percolationHoleColor{
    return [self percolationHoleColorWithAlpha:0.1f];
}

+(UIColor *)percolationHoleColorWithAlpha:(CGFloat)alpha{
    //return [UIColor colorWithRed:183.0/255.0 green:17.0/255.0 blue:31.0/255.0 alpha:alpha];
    return [UIColor colorWithRed:35.0/255.0 green:215.0/255.0 blue:255.0/255.0 alpha:alpha];
}

+(UIColor *)redColor{
    return [UIColor colorWithRed:189.0f/255.0f green:8.0f/255.0f blue:28.0f/255.0f alpha:1.0f];
}

+(UIColor *)redColorWithAlpha:(CGFloat)alpha{
    return [[self redColor] colorWithAlphaComponent:alpha];
}


+(UIColor *)animationViewColor{
    return [[UIColor whiteColor] colorWithAlphaComponent:0.05f];
}

+(UIColor *)resultDisplayViewColor{
    return [[UIColor whiteColor] colorWithAlphaComponent:0.0f];
}

+(UIColor *)controlViewColor{
    return [[UIColor whiteColor] colorWithAlphaComponent:0.0f];
}


@end
