//
//  ALDrawingView.m
//  Algorithm
//
//  Created by LAL on 17/4/5.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "ALDrawingView.h"



@interface ALDrawingView()
@property(nonatomic, strong) UIImageView *mainImageView;
@property(nonatomic, strong) UIImageView *tempImageView;

@end

@implementation ALDrawingView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setUp];
    }
    return self;
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self setUp];
    }
    return self;
}

-(void)setUp{
    self.mainImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.mainImageView];
    self.tempImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.tempImageView];
    self.penColor = [UIColor redColor];
    self.penRadius = 3.0f;
}

-(void)layoutSubviews{
    CGFloat top = self.frame.origin.y;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(top));
        make.left.equalTo(self.superview.mas_left).with.offset(0);
        make.right.equalTo(self.superview.mas_right).with.offset(0);
        make.height.equalTo(@(self.frame.size.width));
    }];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding);
    }];
    
    [self.tempImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding);
    }];
}

-(void)drawAbsolutePoint:(CGPoint)p
                 inBoard:(ALDrawingBoardEnum)board{
    [self drawingProcessInBoard:board WithTask:^(CGContextRef ctx){
        CGContextAddArc(ctx, p.x, p.y, self.penRadius/2, 0, M_PI*2, 0);
    }];
}

-(void)drawAbsoluteLineFromPoint:(CGPoint)fromP
                         toPoint:(CGPoint)toP
                         inBoard:(ALDrawingBoardEnum)board{
    [self drawingProcessInBoard:board WithTask:^(CGContextRef ctx) {
        CGContextMoveToPoint(ctx, fromP.x, fromP.y);
        CGContextAddLineToPoint(ctx, toP.x, toP.y);
    }];
}

-(void)drawAbsoluteRectWithOriginPoint:(CGPoint)originPoint
                           andEndPoint:(CGPoint)endPoint
                               inBoard:(ALDrawingBoardEnum)board{
    [self drawingProcessInBoard:board WithTask:^(CGContextRef ctx) {
        CGContextStrokeRect(ctx, CGRectMake(originPoint.x, originPoint.y, endPoint.x-originPoint.x, endPoint.y - originPoint.y));
    }];
}

-(void)drawPercentPoint:(CGPoint)p
                inBoard:(ALDrawingBoardEnum)board{
    CGPoint convertedP = [ALDrawingView convertToAbsoluteFromPercentPoint:p inView:self];
    [self drawAbsolutePoint:convertedP inBoard:board];
}

-(void)drawPercentLineFromPoint:(CGPoint)fromP
                        toPoint:(CGPoint)toP
                        inBoard:(ALDrawingBoardEnum)board{
    CGPoint convertedSourceP = [ALDrawingView convertToAbsoluteFromPercentPoint:fromP inView:self];
    CGPoint convertedDestP = [ALDrawingView convertToAbsoluteFromPercentPoint:toP inView:self];
    [self drawAbsoluteLineFromPoint:convertedSourceP toPoint:convertedDestP inBoard:board];
}

-(void)drawPercentRectWithOriginPoint:(CGPoint)originPoint
                          andEndPoint:(CGPoint)endPoint
                              inBoard:(ALDrawingBoardEnum)board{
    CGPoint convertedOriginPoint = [ALDrawingView convertToAbsoluteFromPercentPoint:originPoint inView:self];
    CGPoint convertedEndPoint = [ALDrawingView convertToAbsoluteFromPercentPoint:endPoint inView:self];
    [self drawAbsoluteRectWithOriginPoint:convertedOriginPoint
                              andEndPoint:convertedEndPoint
                                  inBoard:board];

}

-(void)clearBoard:(ALDrawingBoardEnum)board{
    UIImageView *view;
    switch (board) {
        case ALDrawingViewBackgroundBoard:
            view = self.mainImageView;
            break;
        case ALDrawingViewForegroundBoard:
            view = self.tempImageView;
        default:
            break;
    }
    UIGraphicsBeginImageContext(self.frame.size);
    view.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

#pragma mark - helper methods

-(void)setDrawingParametersForContext:(CGContextRef)ctx{
    CGContextSetStrokeColorWithColor(ctx, self.penColor.CGColor);
    CGContextSetLineWidth(ctx, self.penRadius);
}

-(void)drawingProcessInBoard:(ALDrawingBoardEnum)board
                   WithTask:(drawingTaskBlock)taskBlock{
    UIImageView *view;
    switch (board) {
        case ALDrawingViewBackgroundBoard:
            view = self.mainImageView;
            break;
        case ALDrawingViewForegroundBoard:
            view = self.tempImageView;
        default:
            break;
    }
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view drawRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self setDrawingParametersForContext:ctx];
    taskBlock(ctx);
    CGContextStrokePath(ctx);
    view.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



+(CGPoint)convertToAbsoluteFromPercentPoint:(CGPoint)perPoint
                                     inView:(UIView *)view{
    return CGPointMake(perPoint.x*view.frame.size.width, perPoint.y*view.frame.size.height);
}

+(CGPoint)convertToPercentFromAbsolutePoint:(CGPoint)perPoint
                                     inView:(UIView *)view{
    return CGPointMake(perPoint.x/view.frame.size.width, perPoint.y/view.frame.size.height);
}

@end
