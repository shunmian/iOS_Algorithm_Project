//
//  Project.h
//  Algorithms
//
//  Created by LAL on 17/3/18.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Project : NSObject
@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) NSString *chapterName;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *shortName;
@property (strong, nonatomic) NSString *shortDescription;
@property (strong, nonatomic) NSString *fullDescription;
@property (strong, nonatomic) NSString *fullHint;
@property (strong, nonatomic) NSArray *otherDetailInfo;

-(id)initWithIcon:(UIImage *)icon
      chapterName:(NSString *)chapterName
             name:(NSString *)name
 shortDescription:(NSString *)shortDescription
  fullDescription:(NSString *)fullDescription
         fullHint:(NSString *)fullHint
  otherDetailInfo:(NSArray *)info;

@end
