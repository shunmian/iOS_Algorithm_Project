//
//  UIColor+RGBAComponents.m
//  Algorithm
//
//  Created by LAL on 17/4/11.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "UIColor+RGBAComponents.h"

@implementation UIColor (RGBAComponents)

-(CGFloat)redComponent{
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    return components[0];
}

-(CGFloat)greenComponent{
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    return components[1];
}

-(CGFloat)blueComponent{
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    return components[2];
}

-(CGFloat)alphaComponent{
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    return components[3];
}
@end
