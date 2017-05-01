//
//  PercolateImplementationViewController.m
//  Algorithm
//
//  Created by LAL on 17/3/19.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "PercolateImplementationViewController.h"
#import "ALButton.h"

static const NSInteger MAXN = 100;
static const NSInteger MINN = 10;

@interface PercolateImplementationViewController ()

@property (nonatomic, weak) IBOutlet UISlider *countSlider;
@property (nonatomic, weak) IBOutlet UILabel *sliderMinLabel;
@property (nonatomic, weak) IBOutlet UILabel *sliderMaxLabel;
@property (nonatomic, strong) UILabel *sliderCurrentLabel;

@property (nonatomic, weak) IBOutlet ALButton *restartBTN;
@property (nonatomic, weak) IBOutlet ALButton *playBTN;
@property (nonatomic, weak) IBOutlet ALButton *quickNextBTN;

@property (nonatomic, weak) IBOutlet UILabel *isPercolatedLabel;
@property (nonatomic, weak) IBOutlet UILabel *ratioTextLabel;
@property (nonatomic, weak) IBOutlet UILabel *openSitesNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *NSquareLabel;
@property (nonatomic, weak) IBOutlet UILabel *ratioLabel;
@property (weak, nonatomic) IBOutlet UILabel *slashTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *equalSignTextLabel;

@property (nonatomic, strong) Percolation *mainPercolation;
@property (nonatomic, strong) NSNumber* N;


//decoration UIView
@property (weak, nonatomic) IBOutlet UIView *sliderView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet ALButton *nextBTN;
@property (weak, nonatomic) IBOutlet UILabel *percolatedTextLabel;

@end

@implementation PercolateImplementationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeViews];
    [self setUpRACSignals];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    for(UIView *subview in self.navigationController.navigationBar.subviews){
        if([subview.stringTag isEqualToString:@"separatorForNavigationBar"]){
            subview.backgroundColor = [UIColor clearColor];
            break;
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    for(UIView *subview in self.navigationController.navigationBar.subviews){
        if([subview.stringTag isEqualToString:@"separatorForNavigationBar"]){
            subview.backgroundColor = [ColorStore basicThemeColor];
        }else if ([subview.stringTag isEqualToString:@"percolationSourceView"]){
            [subview removeFromSuperview];
        }
    }
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
        make.height.equalTo(self.resultDisplayView.superview.mas_height).with.multipliedBy(0.125);
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
    //within resultDisplayView
    
    [self.percolatedTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.percolatedTextLabel.superview.mas_centerY).with.multipliedBy(0.5);
        make.height.equalTo(self.percolatedTextLabel.superview.mas_height).with.multipliedBy(0.4);
        make.width.equalTo(self.percolatedTextLabel.superview.mas_width).with.multipliedBy(0.5);
        make.left.equalTo(self.percolatedTextLabel.superview.mas_centerX).with.multipliedBy(0.1);
    }];
    
    [self.isPercolatedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.isPercolatedLabel.superview.mas_centerY).with.multipliedBy(0.5);
        make.height.equalTo(self.isPercolatedLabel.superview.mas_height).with.multipliedBy(0.4);
        make.width.equalTo(self.isPercolatedLabel.superview.mas_width).with.multipliedBy(0.5);
        make.right.equalTo(self.isPercolatedLabel.superview.mas_centerX).with.multipliedBy(1.9);
    }];
    
    
    [self.ratioTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ratioTextLabel.superview.mas_centerY).with.multipliedBy(1.5);
        make.height.equalTo(self.ratioTextLabel.superview.mas_height).with.multipliedBy(0.4);
        make.width.equalTo(self.ratioTextLabel.superview.mas_width).with.multipliedBy(0.4);
        make.left.equalTo(self.ratioTextLabel.superview.mas_centerX).with.multipliedBy(0.1);
    }];
    
    [self.ratioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ratioLabel.superview.mas_centerY).with.multipliedBy(1.5);
        make.height.equalTo(self.ratioLabel.superview.mas_height).with.multipliedBy(0.4);
//        make.width.equalTo(self.ratioLabel.superview.mas_width).with.multipliedBy(0.165);
        make.width.equalTo(@62);
        make.right.equalTo(self.ratioLabel.superview.mas_centerX).with.multipliedBy(1.9);
    }];
    
    
    [self.equalSignTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.equalSignTextLabel.superview.mas_centerY).with.multipliedBy(1.5);
        make.height.equalTo(self.equalSignTextLabel.superview.mas_height).with.multipliedBy(0.4);
        make.width.equalTo(self.equalSignTextLabel.superview.mas_width).with.multipliedBy(0.03);
        make.right.equalTo(self.ratioLabel.mas_left).with.offset(-3);
    }];
    
    [self.NSquareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.NSquareLabel.superview.mas_centerY).with.multipliedBy(1.5);
        make.height.equalTo(self.NSquareLabel.superview.mas_height).with.multipliedBy(0.4);
//        make.width.equalTo(self.NSquareLabel.superview.mas_width).with.multipliedBy(0.127);
        make.width.equalTo(@48);
        make.right.equalTo(self.equalSignTextLabel.mas_left).with.offset(-6);
    }];
    
    
    [self.slashTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.slashTextLabel.superview.mas_centerY).with.multipliedBy(1.5);
        make.height.equalTo(self.slashTextLabel.superview.mas_height).with.multipliedBy(0.4);
        make.width.equalTo(self.slashTextLabel.superview.mas_width).with.multipliedBy(0.03);
        make.right.equalTo(self.NSquareLabel.mas_left).with.offset(0);
    }];
    
    [self.openSitesNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.openSitesNumberLabel.superview.mas_centerY).with.multipliedBy(1.5);
        make.height.equalTo(self.openSitesNumberLabel.superview.mas_height).with.multipliedBy(0.4);
        make.width.equalTo(self.openSitesNumberLabel.superview.mas_width).with.multipliedBy(0.148);
        make.right.equalTo(self.slashTextLabel.mas_left).with.offset(-6);
    }];
    
    
    
    //within controlView
    
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sliderView.superview.mas_top).with.offset(0);
        make.height.equalTo(self.sliderView.superview.mas_height).with.multipliedBy(0.4);
        make.width.equalTo(self.sliderView.superview.mas_width).with.multipliedBy(1);
        make.left.equalTo(self.sliderView.superview.mas_left).with.offset(0);
    }];
    
    [self.countSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.countSlider.superview.mas_centerX).with.offset(0);
        make.centerY.equalTo(self.countSlider.superview.mas_centerY).with.offset(0);
        make.left.equalTo(self.countSlider.superview.mas_centerX).with.multipliedBy(0.4);
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
        make.height.equalTo(self.buttonView.superview.mas_height).with.multipliedBy(0.6);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Draw animationView
//貌似ReactiveCocoa只能替换返回值为void的delegate的方法，因此保留下面两个原始delegate实现的方法。
-(NSInteger)getCount{
    return self.N.intValue;
}

-(Percolation *)getPercolation{
    return self.mainPercolation;
}

#pragma mark - Helper

-(void)initializeViews{
    //0. title
    self.title = self.project.shortName;
    UIView *percolationSourceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [self offsetHeightFromStatusBarAndNavigationBar])];
    percolationSourceView.backgroundColor = [ColorStore percolationHoleColor];
    percolationSourceView.stringTag = @"percolationSourceView";
    [self.view addSubview:percolationSourceView];
    
    //1. AnimationView
    self.animationView.delegate = self;
    self.animationView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
    
    //2. resultsView
        //2.1 ResultLabels
    self.resultDisplayView.backgroundColor = [ColorStore resultDisplayViewColor];
    //self.isPercolatedLabel.font = [UIFont fontWithName:@"HelveticaNeue-light" size:16];
    self.percolatedTextLabel.text = @"Percolated";
    self.isPercolatedLabel.textColor = [UIColor whiteColor];
    self.isPercolatedLabel.textAlignment = NSTextAlignmentRight;
    self.isPercolatedLabel.backgroundColor = [UIColor clearColor];
    self.percolatedTextLabel.textColor = [UIColor whiteColor];
    self.percolatedTextLabel.textAlignment = NSTextAlignmentLeft;
    self.percolatedTextLabel.backgroundColor = [UIColor clearColor];
    self.resultDisplayView.layer.borderWidth = 0.5;
    self.resultDisplayView.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.05f].CGColor;
    self.NSquareLabel.textAlignment = NSTextAlignmentRight;
    
    //self.ratioTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-light" size:16];
    self.ratioTextLabel.textColor = [UIColor whiteColor];
    self.ratioTextLabel.text = @"Open Ratio";
    self.ratioTextLabel.backgroundColor = [UIColor clearColor];
    self.openSitesNumberLabel.backgroundColor = [UIColor clearColor];
    self.NSquareLabel.backgroundColor = [UIColor clearColor];
    self.ratioLabel.backgroundColor = [UIColor clearColor];
    
    //3. controlView
        //3.1 Slider and its labels
    self.countSlider.minimumValue = MINN;
    self.countSlider.maximumValue = MAXN;
    self.sliderView.backgroundColor = [UIColor clearColor];
    self.sliderView.layer.borderWidth = 0.5;
    self.sliderView.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.05f].CGColor;
    [self.countSlider setValue:10 animated:YES];
    self.sliderCurrentLabel.text = [NSString stringWithFormat:@"%d",(int)self.countSlider.value];
    self.sliderMinLabel.textAlignment = NSTextAlignmentLeft;
    self.sliderMaxLabel.textAlignment = NSTextAlignmentRight;
    self.controlView.backgroundColor = [ColorStore controlViewColor];
    self.buttonView.backgroundColor = [UIColor clearColor];
    self.buttonView.layer.borderWidth = 0.5;
    self.buttonView.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.05f].CGColor;
    self.nextBTN.enabled = NO;
}

-(void)setUpRACSignals{
    @weakify(self)
    [[[[self.countSlider rac_signalForControlEvents:UIControlEventValueChanged] map:^id(id value) {
        @strongify(self)
        return @((int)self.countSlider.value);
    }] startWith:@10] subscribeNext:^(id x) {
        @strongify(self)
        self.sliderCurrentLabel.text = [NSString stringWithFormat:@"%@",x];
        self.N = x;
        self.mainPercolation = [[Percolation alloc] initWithCount:self.N.intValue];
    }];
    
    [[[RACSignal combineLatest: @[RACObserve(self, mainPercolation.numberOfOpenSites), RACObserve(self, N)]
                        reduce:^id(NSNumber *openN,NSNumber *totalN){
                            return @[openN,totalN];
                        }]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSArray *numbers) {
         @strongify(self)
         NSNumber *openN = numbers[0];
         NSNumber *totalN = numbers[1];
         NSNumber *totalSquare = @(totalN.intValue * totalN.intValue);
         float ratio = openN.floatValue*100/totalSquare.floatValue;
         
         //[self.ratioTextLabel setText:[NSString stringWithFormat:@"Ratio: %*s%@/%@%*s = %*s%.02f%%",4-openN.description.length,"",openN,totalSquare,5-totalSquare.description.length,"",2-[self getCountsBeforeDecimal:ratio],"",ratio]];
         self.openSitesNumberLabel.text = [NSString stringWithFormat:@"%@",openN];
         self.NSquareLabel.text = [NSString stringWithFormat:@"%@",totalSquare];
         self.ratioLabel.text = [NSString stringWithFormat:@"%*s%.02f%%",2-[self getCountsBeforeDecimal:ratio],"",ratio];
         [self.animationView setNeedsDisplay];
     }];
    
    
    
    [[RACObserve(self, mainPercolation.percolates)
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSNumber *value) {
         BOOL isPercolated = value.boolValue;
         @strongify(self)
         if(isPercolated){
             self.isPercolatedLabel.text = @"Yes";
             self.resultDisplayView.backgroundColor = [ColorStore percolationHoleColor];
         } else{
             self.isPercolatedLabel.text = @"No";
             self.resultDisplayView.backgroundColor = [UIColor clearColor];
         }
     }];
    
    [[self.playBTN rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if([self.mainPercolation percolates].boolValue){
            return;
        }
        
        int randomI,randomJ;
        while(true){
            randomI = [MathStats getRandomNumberBetween:1 to:self.N.intValue+1];
            randomJ = [MathStats getRandomNumberBetween:1 to:self.N.intValue+1];
            if (![self.mainPercolation isOpenI:randomI andJ:randomJ]) break;
        }
        [self.mainPercolation openI:randomI andJ:randomJ];
    }];
    
    [[[[[[[self.quickNextBTN rac_signalForControlEvents:UIControlEventTouchUpInside]
       deliverOn:[RACScheduler mainThreadScheduler]]
       doNext:^(id x) {
        @strongify(self)
        self.quickNextBTN.selected = YES;
        self.restartBTN.enabled = NO;
        self.countSlider.enabled = NO;
    }] deliverOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityHigh]]
       doNext:^(id x) {
         @strongify(self)
         while(![self.mainPercolation percolates].boolValue){
             int randomI = [MathStats getRandomNumberBetween:1 to:self.N.intValue+1];
             int randomJ = [MathStats getRandomNumberBetween:1 to:self.N.intValue+1];
             if ([self.mainPercolation isOpenI:randomI andJ:randomJ]) continue;
             usleep(20000000/([self.N intValue]*[self.N intValue])); //平均 12s完成 a*N^2 = 12s。
             [self.mainPercolation openI:randomI andJ:randomJ];
             
         }
     }]deliverOn:[RACScheduler mainThreadScheduler]]
       subscribeNext:^(id x) {
        @strongify(self)
        [self.animationView setNeedsDisplay];
        self.quickNextBTN.selected = NO;
        self.restartBTN.enabled = YES;
        self.countSlider.enabled = YES;
    }];
    
    [[self.restartBTN rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self)
         [self.mainPercolation restart];
     }];
    

    RAC(self.playBTN,enabled) = [RACSignal combineLatest:@[RACObserve(self, mainPercolation.percolates),RACObserve(self,quickNextBTN.selected)] reduce:^id (NSNumber* percolates, NSNumber *selected){
        if([selected boolValue]){
            return @NO;
        }else if ([percolates boolValue]){
            return @NO;
        }else{
            return @YES;
        }
    }];
    
    RAC(self.quickNextBTN,enabled) = [[RACObserve(self, mainPercolation.percolates) not] deliverOn:[RACScheduler mainThreadScheduler]];
    
}

-(int)getCountsBeforeDecimal:(float)n{
    int nInt = (int)n;
    if(nInt == 0) return 1;
    int i = 0;
    while(nInt > 0){
        i++;
        nInt /= 10;
    }
    return i;
}

@end
