//
//  StdIn.h
//  Algorithm
//
//  Created by LAL on 17/4/11.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StdIn : NSObject

+(NSString *)readFile:(NSString *)filePath ofType:(NSString *)type;

@end
