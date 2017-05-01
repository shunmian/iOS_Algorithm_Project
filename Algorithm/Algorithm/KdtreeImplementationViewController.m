//
//  KdtreeImplementationViewController.m
//  Algorithm
//
//  Created by LAL on 17/4/5.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "KdtreeImplementationViewController.h"
#import "KdTree.h"
#import "ALButton.h"

@interface KdtreeImplementationViewController ()
@property (nonatomic, assign) CGPoint p;
@property (nonatomic, strong) KdTree *kdTree;
@property (nonatomic, weak) IBOutlet UISwitch *switchBTN;
@property (nonatomic, assign) CGPoint rectStartPoint;
@property (nonatomic, assign) CGPoint rectEndPoint;
@property (nonatomic, weak) IBOutlet UILabel *swtichLabel;
@property (nonatomic, weak) IBOutlet UIView *switchView;
@property (nonatomic, assign) CGRect fingerRect;
@property (nonatomic, weak) IBOutlet UISlider *pointsSliderBTN;
@property (nonatomic, weak) IBOutlet UIView *sliderView;
@property (nonatomic, weak) IBOutlet UILabel *sliderMinLabel;
@property (nonatomic, weak) IBOutlet UILabel *sliderMaxLabel;

@property (nonatomic, weak) IBOutlet UIView *buttonView;
@property (nonatomic, weak) IBOutlet ALButton *nextBTN;
@property (nonatomic, weak) IBOutlet ALButton *restartBTN;
@property (nonatomic, weak) IBOutlet ALButton *playBTN;
@property (nonatomic, weak) IBOutlet ALButton *quickNextBTN;
@property (nonatomic, strong) UITapGestureRecognizer *tapGR;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipGR;
@end

@implementation KdtreeImplementationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        make.height.equalTo(@0);
        make.top.equalTo(self.animationView.mas_bottom).with.offset(0);
        make.left.equalTo(self.resultDisplayView.superview.mas_left).with.offset(0);
        make.right.equalTo(self.resultDisplayView.superview.mas_right).with.offset(0);
    }];
    
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resultDisplayView.mas_bottom).with.offset(0);
        make.bottom.equalTo(self.controlView.superview.mas_bottom).with.offset(0);
        make.left.equalTo(self.controlView.superview.mas_left).with.offset(0);
        make.right.equalTo(self.controlView.superview.mas_right).with.offset(0);
    }];
    
    
    //within controlView

    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.switchView.superview.mas_top).with.offset(0);
        make.height.equalTo(self.switchView.superview.mas_height).with.multipliedBy(0.25);
        make.width.equalTo(self.switchView.superview.mas_width).with.multipliedBy(1);
        make.left.equalTo(self.switchView.superview.mas_left).with.offset(0);
    }];
    
    [self.swtichLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.swtichLabel.superview.mas_centerY);
        make.height.equalTo(self.swtichLabel.superview.mas_height).with.multipliedBy(0.8);
        make.width.equalTo(self.swtichLabel.superview.mas_width).with.multipliedBy(0.2);
        make.left.equalTo(self.swtichLabel.superview.mas_centerX).with.multipliedBy(0.1);
    }];
    
    
    [self.switchBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.switchBTN.superview.mas_centerY);
        make.right.equalTo(self.switchBTN.superview.mas_centerX).with.multipliedBy(1.9);;
    }];
    
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.switchView.mas_bottom).with.offset(0);
        make.height.equalTo(self.sliderView.superview.mas_height).with.multipliedBy(0.25);
        make.width.equalTo(self.sliderView.superview.mas_width).with.multipliedBy(1);
        make.left.equalTo(self.switchView.superview.mas_left).with.offset(0);
    }];
    
    [self.pointsSliderBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.pointsSliderBTN.superview.mas_centerX).with.offset(0);
        make.centerY.equalTo(self.pointsSliderBTN.superview.mas_centerY).with.offset(0);
        make.left.equalTo(self.pointsSliderBTN.superview.mas_centerX).with.multipliedBy(0.4);
    }];
    
    [self.sliderMinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sliderMinLabel.superview.mas_centerY).with.offset(0);
        make.height.equalTo(self.sliderMinLabel.superview.mas_height).with.multipliedBy(0.8);
        make.width.equalTo(self.sliderMinLabel.superview.mas_width).with.multipliedBy(0.2);
        make.left.equalTo(self.sliderMinLabel.superview.mas_centerX).with.multipliedBy(0.1);
    }];
    
    [self.sliderMaxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sliderMaxLabel.superview.mas_centerY).with.offset(0);
        make.height.equalTo(self.sliderMaxLabel.superview.mas_height).with.multipliedBy(0.8);
        make.width.equalTo(self.sliderMaxLabel.superview.mas_width).with.multipliedBy(0.2);
        make.right.equalTo(self.sliderMaxLabel.superview.mas_centerX).with.multipliedBy(1.9);
    }];
    
    [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sliderView.mas_bottom).with.offset(0);
        make.height.equalTo(self.buttonView.superview.mas_height).with.multipliedBy(0.5);
        make.width.equalTo(self.buttonView.superview.mas_width).with.multipliedBy(1);
        make.left.equalTo(self.buttonView.superview.mas_left).with.offset(0);
    }];
    
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


-(void)initialize{
    self.animationView.backgroundColor = [ColorStore animationViewColor];
    self.controlView.backgroundColor = [ColorStore controlViewColor];
    
    self.animationView.penColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    self.animationView.penRadius = 2.0f;
    KdTree *kdtree = [[KdTree alloc] init];
    [kdtree  insert:CGPointMake(0.206107, 0.095492)];
    [kdtree  insert:CGPointMake(0.975528, 0.654508)];
    [kdtree  insert:CGPointMake(0.024472, 0.345492)];
    [kdtree  insert:CGPointMake(0.793893, 0.095492)];
    [kdtree  insert:CGPointMake(0.793893, 0.904508)];
    [kdtree  insert:CGPointMake(0.975528, 0.345492)];
    [kdtree  insert:CGPointMake(0.206107, 0.904508)];
    [kdtree  insert:CGPointMake(0.500000, 0.000000)];
    [kdtree  insert:CGPointMake(0.024472, 0.654508)];
    [kdtree  insert:CGPointMake(0.500000, 1.000000)];

    self.kdTree = kdtree;
    for (NSValue *pValue in [kdtree IterablePointsForRange:CGRectMake(0, 0, 1, 1)]){
        CGPoint p = [pValue CGPointValue];
        [self.animationView drawPercentPoint:p inBoard:ALDrawingViewBackgroundBoard];
    }
    
    [[self.switchBTN rac_newOnChannel] subscribeNext:^(id x) {
        [self.animationView clearBoard:ALDrawingViewForegroundBoard];
    }];
    
    self.swtichLabel.textAlignment = NSTextAlignmentLeft;
    self.switchView.backgroundColor = [UIColor clearColor];
    self.switchView.layer.borderWidth = 0.5;
    self.switchView.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.05f].CGColor;
    
    self.sliderView.backgroundColor = [UIColor clearColor];
    self.sliderView.layer.borderWidth = 0.5;
    self.sliderView.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.05f].CGColor;
    self.pointsSliderBTN.minimumValue = 10;
    self.pointsSliderBTN.maximumValue = 100;
    
    self.buttonView.backgroundColor = [UIColor clearColor];
    self.buttonView.layer.borderWidth = 0.5;
    self.buttonView.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.05f].CGColor;
    self.restartBTN.enabled = NO;
    self.playBTN.enabled = NO;
    self.quickNextBTN.enabled = NO;
    self.title =self.project.shortName;
    
    [[[[[self.pointsSliderBTN rac_newValueChannelWithNilValue:@0]
       throttle:0.05]
      doNext:^(NSNumber *x) {
        [self generateRandomKdtreeWithN:x];
    }] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        [self displayKdTree];
        [self.animationView setNeedsDisplay];
    }] ;
    
    [[[[self.nextBTN rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(id x) {
        [self generateRandomKdtreeWithN:[NSNumber numberWithFloat:self.pointsSliderBTN.value]];
    }] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        [self displayKdTree];
        [self.animationView setNeedsDisplay];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.switchBTN.on){
        [self updateAnimationViewForNearestPointStep1WithTouch:[touches anyObject]];
    }else{
        [self updateAnimationViewForRectContainingPointsStep1WithTouch:[touches anyObject]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.switchBTN.on){
        [self updateAnimationViewForNearestPointStep2WithTouch:[touches anyObject]];
    }else{
        [self updateAnimationViewForRectContainingPointsStep2WithTouch:[touches anyObject]];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.switchBTN.on){
        [self updateAnimationViewForNearestPointStep3WithTouch:[touches anyObject]];
    }else{
        [self updateAnimationViewForRectContainingPointsStep3WithTouch:[touches anyObject]];
    }
}

#pragma mark - helper

// for neartestPoints, 3 steps
-(void)updateAnimationViewForNearestPointStep1WithTouch:(UITouch *)touch{
    if([touch view] == self.animationView){
        CGPoint currentPercentPoint = [ALDrawingView convertToPercentFromAbsolutePoint:[touch locationInView:self.animationView] inView:self.animationView];
        [self.animationView clearBoard:ALDrawingViewForegroundBoard];
        self.animationView.penColor = self.animationView.penColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
        self.animationView.penRadius = 6.0f;
        CGPoint nearestPoint = [self.kdTree nearestToPoint:currentPercentPoint];
        [self.animationView drawPercentPoint:nearestPoint inBoard:ALDrawingViewForegroundBoard];
    }
}

-(void)updateAnimationViewForNearestPointStep2WithTouch:(UITouch *)touch{
    [self updateAnimationViewForNearestPointStep1WithTouch:touch];
}

-(void)updateAnimationViewForNearestPointStep3WithTouch:(UITouch *)touch{
    [self.animationView clearBoard:ALDrawingViewForegroundBoard];
}

// for rectContainingPoints, 3 steps
-(void)updateAnimationViewForRectContainingPointsStep1WithTouch:(UITouch *)touch{
    [self.animationView clearBoard:ALDrawingViewForegroundBoard];
    CGPoint currentPoint = [touch locationInView:self.animationView];
    self.rectStartPoint = [ALDrawingView convertToPercentFromAbsolutePoint:currentPoint inView:self.animationView];
    self.rectEndPoint = self.rectStartPoint;

}

-(void)updateAnimationViewForRectContainingPointsStep2WithTouch:(UITouch *)touch{
    [self.animationView clearBoard:ALDrawingViewForegroundBoard];
    CGPoint lastPoint = [touch locationInView:self.animationView];
    self.rectEndPoint = [ALDrawingView convertToPercentFromAbsolutePoint:lastPoint inView:self.animationView];
    if(self.rectEndPoint.y < 0){
        self.rectEndPoint = CGPointMake(self.rectEndPoint.x, 0);
    }else if(self.rectEndPoint.y > 1){
        self.rectEndPoint = CGPointMake(self.rectEndPoint.x, 1.0);
    }
    
    self.animationView.penColor = self.animationView.penColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    self.animationView.penRadius = 3.0f;
    [self.animationView drawPercentRectWithOriginPoint:self.rectStartPoint andEndPoint:self.rectEndPoint inBoard:ALDrawingViewForegroundBoard];
}

-(void)updateAnimationViewForRectContainingPointsStep3WithTouch:(UITouch *)touch{
    if(CGPointEqualToPoint(self.rectStartPoint, self.rectEndPoint)){
        [self.animationView clearBoard:ALDrawingViewForegroundBoard];
    }else{
        // execute in mainthread, since IterablePointsForRange is O(logN)
        self.fingerRect = CGRectMake(self.rectStartPoint.x, self.rectStartPoint.y, self.rectEndPoint.x-self.rectStartPoint.x, self.rectEndPoint.y-self.rectStartPoint.y);
        NSArray *containedPointsInRect = [self.kdTree IterablePointsForRange:self.fingerRect];
        
        self.animationView.penColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
        self.animationView.penRadius = 6.0f;
        for(NSValue *pValue in containedPointsInRect){
            CGPoint percentPoint = [pValue CGPointValue];
            [self.animationView drawPercentPoint:percentPoint inBoard:ALDrawingViewForegroundBoard];
            
        }
        
    }
}


-(void)generateRandomKdtreeWithN:(NSNumber *)n{
    int r = [MathStats getRandomNumberBetween:0 to:4];
    switch (r) {
        case 0:
            [self generateRandomCirlePoints:n];
            break;
        case 1:
            [self generateRandom45DegreeRectanglePoints:n];
            break;
        case 2:
            [self generateRandomTrianglePoints:n];
            break;
        case 3:
            [self generateRandomPoints:n];
            break;
        default:
            break;
    }
}

-(void)generateRandomTrianglePoints:(NSNumber *)n{
    self.kdTree = [[KdTree alloc] init];
    CGPoint randomPoint;
    for (int i = 0; i < n.integerValue; i++){
        if(i >= 0 && i < n.integerValue/3){
            randomPoint = [self generateRandomPointWithXFrom:0 to:0.5 andXYRelation:^CGFloat(CGFloat x) {
                return (-1.732*x +0.866);
            }];
        }else if ( i >= n.integerValue/3 && i < n.integerValue*2/3){
            randomPoint = [self generateRandomPointWithXFrom:0.5 to:1 andXYRelation:^CGFloat(CGFloat x) {
                return 1.732*x -0.866;
            }];
        }else{
            randomPoint = [self generateRandomPointWithXFrom:0 to:1 andXYRelation:^CGFloat(CGFloat x) {
                return 0.866;
            }];
        }
        [self.kdTree insert:randomPoint];
    }
}

-(void)generateRandomCirlePoints:(NSNumber *)n{
    self.kdTree = [[KdTree alloc] init];
    CGPoint randomPoint;
    for (int i = 0; i < n.integerValue; i++){
        randomPoint = [self generateRandomPointWithXFrom:0 to:1 andXYRelation:^CGFloat(CGFloat x) {
            int coin = [MathStats getRandomNumberBetween:0 to:2];
            return coin? 0.5+sqrt(0.25-(x-0.5)*(x-0.5)):0.5-sqrt(0.25-(x-0.5)*(x-0.5));
        }];
        [self.kdTree insert:randomPoint];
    }
}

-(void)generateRandomPoints:(NSNumber *)n{
    self.kdTree = [[KdTree alloc] init];
    CGPoint randomPoint;
    for (int i = 0; i < n.integerValue; i++){
        randomPoint = [self generateRandomPointWithXFrom:0 to:1 andXYRelation:^CGFloat(CGFloat x) {
            return [MathStats getRandomDoubleNumberBetween:0 to:1];
        }];
        [self.kdTree insert:randomPoint];
    }
}

-(void)generateRandom45DegreeRectanglePoints:(NSNumber *)n{
    self.kdTree = [[KdTree alloc] init];
    CGPoint randomPoint;
    for (int i = 0; i < n.integerValue; i++){
        if(i >= 0 && i < n.integerValue/4){
            randomPoint = [self generateRandomPointWithXFrom:0 to:0.5 andXYRelation:^CGFloat(CGFloat x) {
                return (-1*x +0.5);
            }];
        }else if ( i >= n.integerValue/4 && i < n.integerValue*2/4){
            randomPoint = [self generateRandomPointWithXFrom:0.5 to:1 andXYRelation:^CGFloat(CGFloat x) {
                return 1*x -0.5;
            }];
        }else if ( i >= n.integerValue*2/4 && i < n.integerValue*3/4){
            randomPoint = [self generateRandomPointWithXFrom:0.5 to:1 andXYRelation:^CGFloat(CGFloat x) {
                return -1*x +1.5;
            }];
        }else{
            randomPoint = [self generateRandomPointWithXFrom:0 to:0.5 andXYRelation:^CGFloat(CGFloat x) {
                return 1*x +0.5;
            }];
        }
        [self.kdTree insert:randomPoint];
    }
}

-(CGPoint)generateRandomPointWithXFrom:(double)fromX
                                 to:(double)toX
                      andXYRelation:(CGFloat(^)(CGFloat x))XYRelationBlock{
    CGFloat x = [MathStats getRandomDoubleNumberBetween:fromX to:toX];
    CGFloat y = XYRelationBlock(x);
    CGPoint randomPoint = CGPointMake(x, y);
    while([self.kdTree containsPoint:randomPoint]){
        y = XYRelationBlock([MathStats getRandomNumberBetween:fromX to:toX]);
        randomPoint = CGPointMake(x, y);
    }
    return randomPoint;
}

-(void)displayKdTree{
    [self.animationView clearBoard:ALDrawingViewBackgroundBoard];
    [self.animationView clearBoard:ALDrawingViewForegroundBoard];
    self.animationView.backgroundColor = [ColorStore animationViewColor];
    self.controlView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
    self.animationView.penColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    self.animationView.penRadius = 2.0f;
    for (NSValue *pValue in [self.kdTree IterablePointsForRange:CGRectMake(0, 0, 1, 1)]){
        CGPoint p = [pValue CGPointValue];
        [self.animationView drawPercentPoint:p inBoard:ALDrawingViewBackgroundBoard];
    }
}

@end
