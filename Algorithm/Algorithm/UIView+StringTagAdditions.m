//
//  UIView+StringTagAdditions.m
//  Algorithm
//
//  Created by LAL on 17/3/25.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "UIView+StringTagAdditions.h"
#import <objc/message.h>

@implementation UIView (StringTagAdditions)

static NSString *kStringTagKey = @"StringTag";

-(NSString *)stringTag{
    return objc_getAssociatedObject(self,CFBridgingRetain(kStringTagKey));
}

-(void)setStringTag:(NSString *)stringTag{
    objc_setAssociatedObject(self, CFBridgingRetain(kStringTagKey), stringTag, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

