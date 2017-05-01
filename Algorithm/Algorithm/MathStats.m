//
//  MathStats.m
//  Algorithm
//
//  Created by LAL on 17/3/20.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "MathStats.h"
#define ARC4RANDOM_MAX      0x100000000
@implementation MathStats

+(int)getRandomNumberBetween:(int)from to:(int)to {
    return (int)from + arc4random() % (to-from);
}


+(double)getRandomDoubleNumberBetween:(double)from to:(double)to{
    double randomDistribution = ((double)arc4random() / ARC4RANDOM_MAX);
    return from + randomDistribution * (to-from);
}

+(double)meanOf:(double *)array withLength:(int)N{
    double sum = 0.0;
    for(int i = 0; i < N; i++){
        sum += array[i];
    }
    return sum/N;
}

+(double)standardDeviationOf:(double *)array withLength:(int)N{
    if(N <= 0) return 0.0;
    
    double mean = [self meanOf:array withLength:N];
    double sumOfSquaredDifferences = 0.0;
    
    for(int i = 0; i < N; i++){
        double difference = array[i]-mean;
        sumOfSquaredDifferences += difference*difference;
    }
    return sqrt(sumOfSquaredDifferences/N);
}


@end
