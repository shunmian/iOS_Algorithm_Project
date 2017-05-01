//
//  StdIn.m
//  Algorithm
//
//  Created by LAL on 17/4/11.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "StdIn.h"

@implementation StdIn

+(NSString *)readFile:(NSString *)filePath ofType:(NSString *)type{
    NSString *filepath = [[NSBundle mainBundle] pathForResource:filePath ofType:type];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    
    if (error)
        DLog(@"Error reading file: %@", error.localizedDescription);
    
    return fileContents;
}

@end
