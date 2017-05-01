//
//  CollinearImplementationViewController.m
//  Algorithm
//
//  Created by LAL on 17/4/12.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "CollinearImplementationViewController.h"
#import "FastCollinearPoints.h"
#import "ALButton.h"
#import "LineSegment.h"
#import "ALProducerConsumer.h"

static const int kPOOL_CAPACITY = 10;

@interface CollinearImplementationViewController ()
@property(nonatomic, strong) ALProducerConsumer *producerConsumer;
@property(nonatomic, strong) NSArray *fileNames;
@property(nonatomic, strong) FastCollinearPoints *fcp;
@property (weak, nonatomic) IBOutlet ALButton *playBTN;
@property (weak, nonatomic) IBOutlet ALButton *nextBTN;
@property (weak, nonatomic) IBOutlet UILabel *NoOfPointsTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *NoOfPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *NoOfCollinearLinesTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *NoOfCollinearLinesLabel;
@property (weak, nonatomic) IBOutlet ALButton *restartBTN;
@property (weak, nonatomic) IBOutlet ALButton *quickNextBTN;
@property (nonatomic, strong) NSNumber *lineDrawed;

@end


@implementation CollinearImplementationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    CGFloat topOffset = [self offsetHeightFromStatusBarAndNavigationBar];
    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topOffset));
        make.width.equalTo(@(self.view.frame.size.width));
        make.height.equalTo(@(self.view.frame.size.width));
        make.left.equalTo(self.animationView.superview.mas_left).with.offset(0);
    }];
    
    [self.resultDisplayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(80));
        make.top.equalTo(self.animationView.mas_bottom).with.offset(0);
        make.left.equalTo(self.resultDisplayView.superview.mas_left).with.offset(0);
        make.right.equalTo(self.resultDisplayView.superview.mas_right).with.offset(0);
    }];
    
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resultDisplayView.mas_bottom);
        make.bottom.equalTo(self.controlView.superview.mas_bottom).with.offset(0);
        make.left.equalTo(self.controlView.superview.mas_left).with.offset(0);
        make.right.equalTo(self.controlView.superview.mas_right).with.offset(0);
    }];
    
    //within reulstDisplayView
    [self.NoOfPointsTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.NoOfPointsTextLabel.superview.mas_centerY).with.multipliedBy(0.5);
        make.height.equalTo(self.NoOfPointsTextLabel.superview.mas_height).with.multipliedBy(0.4);
        make.width.equalTo(self.NoOfPointsTextLabel.superview.mas_width).with.multipliedBy(0.5);
        make.left.equalTo(self.NoOfPointsTextLabel.superview.mas_centerX).with.multipliedBy(0.1);
    }];
    
    [self.NoOfPointsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.NoOfPointsLabel.superview.mas_centerY).with.multipliedBy(0.5);
        make.height.equalTo(self.NoOfPointsLabel.superview.mas_height).with.multipliedBy(0.4);
        make.width.equalTo(self.NoOfPointsLabel.superview.mas_width).with.multipliedBy(0.5);
        make.right.equalTo(self.NoOfPointsLabel.superview.mas_centerX).with.multipliedBy(1.9);
    }];
    
    [self.NoOfCollinearLinesTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.NoOfCollinearLinesTextLabel.superview.mas_centerY).with.multipliedBy(1.5);
        make.height.equalTo(self.NoOfCollinearLinesTextLabel.superview.mas_height).with.multipliedBy(0.4);
        make.width.equalTo(self.NoOfCollinearLinesTextLabel.superview.mas_width).with.multipliedBy(0.5);
        make.left.equalTo(self.NoOfCollinearLinesTextLabel.superview.mas_centerX).with.multipliedBy(0.1);
    }];
    
    [self.NoOfCollinearLinesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.NoOfCollinearLinesLabel.superview.mas_centerY).with.multipliedBy(1.55);
        make.height.equalTo(self.NoOfCollinearLinesLabel.superview.mas_height).with.multipliedBy(0.4);
        make.width.equalTo(self.NoOfCollinearLinesLabel.superview.mas_width).with.multipliedBy(0.5);
        make.right.equalTo(self.NoOfCollinearLinesLabel.superview.mas_centerX).with.multipliedBy(1.9);
    }];
    
    //within controlView
    CGFloat buttonWidth = 40;
    CGFloat buttonHeight = 40;
    
    [self.restartBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.restartBTN.superview.mas_centerX).with.multipliedBy(0.25);
        make.centerY.equalTo(self.quickNextBTN.superview.mas_centerY).with.offset(0);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    
    [self.playBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.restartBTN.superview.mas_centerX).with.multipliedBy(0.75);
        make.centerY.equalTo(self.quickNextBTN.superview.mas_centerY).with.offset(0);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    
    [self.nextBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.restartBTN.superview.mas_centerX).with.multipliedBy(1.25);
        make.centerY.equalTo(self.quickNextBTN.superview.mas_centerY).with.offset(0);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    
    [self.quickNextBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.restartBTN.superview.mas_centerX).with.multipliedBy(1.75);
        make.centerY.equalTo(self.quickNextBTN.superview.mas_centerY).with.offset(0);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
}


#pragma mark - helper




-(void)initialize{
    self.title = self.project.shortName;
    self.lineDrawed = @NO;
    self.producerConsumer = [[ALProducerConsumer alloc] initWithCapacity: kPOOL_CAPACITY];
    //initialize views
    self.animationView.backgroundColor = [ColorStore animationViewColor];
    self.animationView.transform = CGAffineTransformMakeScale(1.0, -1.0);
    
    self.resultDisplayView.backgroundColor = [ColorStore resultDisplayViewColor];
    self.resultDisplayView.layer.borderWidth = 0.5;
    self.resultDisplayView.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.05f].CGColor;
    self.NoOfPointsTextLabel.textAlignment = NSTextAlignmentLeft;
    self.NoOfPointsLabel.textAlignment = NSTextAlignmentRight;
    self.NoOfCollinearLinesTextLabel.textAlignment = NSTextAlignmentLeft;
    self.NoOfCollinearLinesLabel.textAlignment = NSTextAlignmentRight;
    
    
    self.controlView.backgroundColor = [ColorStore resultDisplayViewColor];
    self.controlView.layer.borderWidth = 0.5;
    self.controlView.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.05f].CGColor;
    self.restartBTN.enabled = NO;
    self.quickNextBTN.enabled = NO;
    
    //initalize model
    self.fileNames = [self readFileNames];
    NSArray *results = [self readPointsFromFile:@"input8" ofType:@"txt"];
    NSArray *points = results[0];
    int maxWidthOrHeight = [(NSNumber *)results[1] integerValue];
    self.fcp = [[FastCollinearPoints alloc] initWithPoints: points andMaxWidthOrHeight:maxWidthOrHeight];
    [self drawBackgroundWithFcp:self.fcp];
    
    //Signal

    @weakify(self)
    [self.producerConsumer producingTask:^id{
        NSArray *results = [self generateRandomPoints];
        NSArray *points = (NSArray *)results[0];
        int maxWidthOrHeight = [(NSNumber *)results[1] integerValue];
        FastCollinearPoints *fcp = [[FastCollinearPoints alloc] initWithPoints:points andMaxWidthOrHeight: maxWidthOrHeight];
        return fcp;
    }];
    
    RAC(self,playBTN.enabled) = [RACObserve(self, lineDrawed) not];
    
    RAC(self.nextBTN,enabled) = [self.producerConsumer.consumingEnableSignal deliverOnMainThread];

    
    [[[[[[[self.nextBTN rac_signalForControlEvents:UIControlEventTouchUpInside]
          deliverOn:[RACScheduler mainThreadScheduler]]
         doNext:^(id x) {
             @strongify(self)
             self.nextBTN.enabled = NO;
             self.playBTN.enabled = NO;
         }]
        deliverOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityHigh]]
       doNext:^(id x) {
           @strongify(self)
           [self.producerConsumer consumingTask:^(FastCollinearPoints *fcp) {
               self.fcp = fcp;
           } onDispatchQueue: dispatch_get_main_queue()];
       }]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self)
         [self drawBackgroundWithFcp:self.fcp];
         if([self.producerConsumer.productsCount integerValue] > 0)self.nextBTN.enabled = YES;
         else self.nextBTN.enabled = NO;
         self.playBTN.enabled = YES;
         self.lineDrawed = @NO;
     }];
    
    
    [[self.playBTN rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if(![self.lineDrawed boolValue]){
            self.lineDrawed = @YES;
            self.animationView.penRadius = 2.0f;
            self.animationView.penColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
            for(LineSegment *line in [self.fcp getCollinearSegments]){
                NSInteger maxWidthOrHeight = self.fcp.maxWidthOrHeight;
                CGPoint startAbsoluteP = [line.fromP CGPointValue];
                CGPoint startPercentP = CGPointMake(startAbsoluteP.x/maxWidthOrHeight, startAbsoluteP.y/maxWidthOrHeight);
                CGPoint endAbsoluteP = [line.toP CGPointValue];
                CGPoint endPercentP = CGPointMake(endAbsoluteP.x/maxWidthOrHeight, endAbsoluteP.y/maxWidthOrHeight);
                [self.animationView drawPercentLineFromPoint:startPercentP toPoint:endPercentP inBoard:ALDrawingViewForegroundBoard];
            }
        }
    }];
    
    [[RACObserve(self, fcp.pointsCount)
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSNumber *count) {
         @strongify(self)
         self.NoOfPointsLabel.text = [NSString stringWithFormat:@"%@",count];
     }];
    
    [[RACObserve(self, fcp.lineSegmentsCount)
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSNumber *count) {
         @strongify(self)
         self.NoOfCollinearLinesLabel.text = [NSString stringWithFormat:@"%@",count];
     }];
}

-(NSArray *)readPointsFromFile:(NSString *)filePath ofType:(NSString *)type{
    int maxWidthOrHeight = 0;
    NSString *contents = [StdIn readFile:filePath ofType:type];
    NSArray *lines = [contents componentsSeparatedByString:@"\n"];
    int count = [((NSString *)lines[0]) intValue];
    NSMutableArray *points =[NSMutableArray arrayWithCapacity:count];
    for(int i = 1; i < count+1;i++){
        NSString *line = lines[i];
        NSMutableArray *pointComponents = (NSMutableArray *)[line componentsSeparatedByString:@" "];
        [pointComponents removeObject:@""];
        CGFloat x = [pointComponents[0] floatValue];
        CGFloat y = [pointComponents[1] floatValue];
        if(maxWidthOrHeight < x){
            maxWidthOrHeight = x;
        }
        if(maxWidthOrHeight < y){
            maxWidthOrHeight = y;
        }
        ALPoint *p = [[ALPoint alloc] initWithX:x andY:y];
        [points addObject:p];
    }
    return @[points,@(maxWidthOrHeight)];
}

-(NSArray *)generateRandomPoints{
    int randomI = [MathStats getRandomNumberBetween:0 to:self.fileNames.count];
    NSString *randomFileName = self.fileNames[randomI];
    NSArray *randomPoints = [self readPointsFromFile:randomFileName ofType:@"txt"];
    return randomPoints;
}

-(NSArray*)readFileNames{
    NSString *contents = [StdIn readFile:@"filename" ofType:@"txt"];
    NSMutableArray *lines = (NSMutableArray*)[contents componentsSeparatedByString:@"\n"];
    [lines removeObject:@""];
    return lines;
}

-(void)drawBackgroundWithFcp:(FastCollinearPoints *)fcp{
    [self.animationView clearBoard:ALDrawingViewBackgroundBoard];
    [self.animationView clearBoard:ALDrawingViewForegroundBoard];
    self.animationView.penRadius = 1.0f;
    self.animationView.penColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    NSInteger maxWidthOrHeight = self.fcp.maxWidthOrHeight;
    for(ALPoint *p in fcp.points){
        CGPoint absoluteP = [p CGPointValue];
        CGPoint percentP = CGPointMake(absoluteP.x/maxWidthOrHeight, absoluteP.y/maxWidthOrHeight);
        [self.animationView drawPercentPoint:percentP inBoard:ALDrawingViewBackgroundBoard];
    }
    [self.animationView setNeedsDisplay];
}

@end
