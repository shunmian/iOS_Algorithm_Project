//
//  PercolationAnimationView.m
//  Algorithm
//
//  Created by LAL on 17/3/20.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "PercolationAnimationView.h"
#import "ColorStore.h"

@interface PercolationAnimationView ()

@property (nonatomic,strong) CAShapeLayer *shapeLayer;

@end

@implementation PercolationAnimationView
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setUp];
    }
    return self;
}

+(Class)layerClass{
    return [CAShapeLayer class];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self setUp];
    }
    return self;
}

-(void)setUp{
    UIImage *wall = [UIImage imageNamed:@"Project 1.1_wall"];
    self.backgroundColor = [UIColor colorWithPatternImage:wall];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    NSInteger N = [self.delegate getCount];
    CGFloat width   = self.bounds.size.width;
    CGFloat height  = self.bounds.size.height;
    CGFloat left    = self.bounds.origin.x;
    CGFloat bottom  = self.bounds.origin.y;
    CGFloat deltaX  = width/N;
    CGFloat deltaY  = height/N;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
    
    /*
    for(int i = 1; i < N; i++){
        CGContextMoveToPoint(ctx, left, bottom+i*deltaY);
        CGContextAddLineToPoint(ctx, right, bottom+i*deltaY);
    }
    for(int i = 1; i < N; i++){
        CGContextMoveToPoint(ctx, left+i*deltaX, bottom);
        CGContextAddLineToPoint(ctx, left+i*deltaX, up);
    }
     */
    //CGContextMoveToPoint(ctx, left, bottom);
    //CGContextAddLineToPoint(ctx, left, up);
    //CGContextAddLineToPoint(ctx, left+width, bottom+height);
    //CGContextAddLineToPoint(ctx, left+width, bottom);
    
    
    CGContextSetLineWidth(ctx, 1);
    CGContextStrokePath(ctx);
    
    UIColor *hole = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f];
    //UIColor *water = [UIColor colorWithRed:189.0/255.0 green:8.0/255.0 blue:28.0/255.0 alpha:1.0f];
    UIColor *water = [ColorStore percolationHoleColor];
    
    Percolation *percolation = [self.delegate getPercolation];
    CGContextSetBlendMode(ctx, kCGBlendModeNormal);
    BOOL **_state = [percolation state];
    for(int i = 1; i <= N;++i){
        for(int j = 1; j <= N;++j){
            if (_state[i-1][j-1]) {
                if([percolation isFullWithI:i andJ:j]){
                    CGContextSetFillColorWithColor(ctx, water.CGColor);
                    CGContextClearRect(ctx, CGRectMake(left +(j-1)*deltaX,bottom+(i-1)*deltaY, deltaX, deltaY));
                    CGContextFillRect(ctx, CGRectMake(left +(j-1)*deltaX,bottom+(i-1)*deltaY, deltaX, deltaY));
                    
                }else{
                    CGContextSetFillColorWithColor(ctx, hole.CGColor);
                    CGContextClearRect(ctx, CGRectMake(left +(j-1)*deltaX,bottom+(i-1)*deltaY, deltaX, deltaY));
                }
            }
        }
    }
}




@end
