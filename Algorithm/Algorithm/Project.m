//
//  Project.m
//  Algorithms
//
//  Created by LAL on 17/3/18.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "Project.h"

@implementation Project


-(id)initWithIcon:(UIImage *)icon
      chapterName:(NSString *)chapterName
             name:(NSString *)name
 shortDescription:(NSString *)shortDescription
  fullDescription:(NSString *)fullDescription
         fullHint:(NSString *)fullHint
  otherDetailInfo:(NSArray *)info{
    if(self = [self init]){
        _icon = icon;
        _chapterName = chapterName;
        _name = name;
        _shortDescription = shortDescription;
        _fullDescription = fullDescription;
        _otherDetailInfo = info;
        _fullHint = fullHint;
        NSRange range = [self.name rangeOfString:@":"];
        if(range.location != NSNotFound){
            _shortName = [_name substringFromIndex:range.location+2];
        }
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"name: %@\nshortDescription:%@\n",self.name,self.shortDescription];
}

@end
