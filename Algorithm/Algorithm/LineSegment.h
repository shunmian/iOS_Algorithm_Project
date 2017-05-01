//
//  LineSegment.h
//  Algorithm
//
//  Created by LAL on 17/4/11.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALPoint.h"

@interface LineSegment : NSObject
@property (nonatomic, strong) ALPoint *fromP;
@property (nonatomic, strong) ALPoint *toP;

-(instancetype)initWithFromPoint:(ALPoint *)fromP toPoint:(ALPoint *)toP;

@end
