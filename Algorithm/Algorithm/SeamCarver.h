//
//  SeamCarver.h
//  Algorithm
//
//  Created by LAL on 17/4/11.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeamCarver : NSObject
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, assign) int width;
@property(nonatomic, assign) int height;

-(instancetype)initWithImage:(UIImage *)image;
-(double)energyWithRow:(int)row andCol:(int)Col;
-(NSArray *)findHorizontalSeam;
-(NSArray *)findVerticalSeam;
-(void)removeHorizontalSeamWithSeam:(NSArray *)seam;
-(void)removeVerticalSeamWithSeam:(NSArray *)seam;
@end
