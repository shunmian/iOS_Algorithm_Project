//
//  ALDrawingView.h
//  Algorithm
//
//  Created by LAL on 17/4/5.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^drawingTaskBlock)(CGContextRef);

typedef NS_ENUM(NSInteger, ALDrawingBoardEnum)
{
    ALDrawingViewBackgroundBoard = 1,
    ALDrawingViewForegroundBoard
};

@interface ALDrawingView : UIView
@property(nonatomic, strong) UIColor* penColor;
@property(nonatomic, assign) CGFloat penRadius;

//in absolute CGPoint
-(void)drawAbsolutePoint:(CGPoint)p inBoard:(ALDrawingBoardEnum)board;
-(void)drawAbsoluteLineFromPoint:(CGPoint)fromP toPoint:(CGPoint)toP inBoard:(ALDrawingBoardEnum)board;
-(void)drawAbsoluteRectWithOriginPoint:(CGPoint)originPoint andEndPoint:(CGPoint)endPoint inBoard:(ALDrawingBoardEnum)board;

-(void)clearBoard:(ALDrawingBoardEnum)board;

//in percentage CGPoint relative to self.frame.size
-(void)drawPercentPoint:(CGPoint)p inBoard:(ALDrawingBoardEnum)board;
-(void)drawPercentLineFromPoint:(CGPoint)fromP toPoint:(CGPoint)toP inBoard:(ALDrawingBoardEnum)board;
-(void)drawPercentRectWithOriginPoint:(CGPoint)originPoint andEndPoint:(CGPoint)endPoint inBoard:(ALDrawingBoardEnum)board;

+(CGPoint)convertToPercentFromAbsolutePoint:(CGPoint)absPoint inView:(UIView *)view;
+(CGPoint)convertToAbsoluteFromPercentPoint:(CGPoint)perPoint inView:(UIView *)view;
@end
