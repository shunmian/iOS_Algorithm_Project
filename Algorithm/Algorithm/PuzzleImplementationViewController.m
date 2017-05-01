//
//  PuzzleImplementationViewController.m
//  Algorithm
//
//  Created by LAL on 17/3/27.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "PuzzleImplementationViewController.h"
#import "PuzzleBoard.h"
#import "ALButton.h"
#import "PuzzleSolver.h"
#import "ALView.h"
#import "ALProducerConsumer.h"

static const int kPOOL_CAPACITY = 10;

@interface PuzzleImplementationViewController (){
    int n;
}
@property (nonatomic, strong) ALProducerConsumer *producerConsumer;
@property (nonatomic, strong) NSNumber *currentStep;
@property (nonatomic, strong) NSNumber *playBTNFromBeginningFlag;
@property (nonatomic, strong) NSNumber *fromStartPosition;
@property (nonatomic, strong) NSNumber *playerTouched;
@property (nonatomic, strong) NSNumber *quickNextBTNExcuting;
@property (nonatomic, strong) NSEnumerator *solutions;
@property (nonatomic, assign) BOOL enableInteraction;

@property (nonatomic, strong) PuzzleBoard *currentPuzzleBoard;
@property (nonatomic, strong) PuzzleBoard *startPuzzleBoard;
@property (nonatomic, strong) PuzzleSolver *puzzleSolver;

@property (weak, nonatomic) IBOutlet ALButton *quickNextBTN;
@property (weak, nonatomic) IBOutlet ALButton *playBTN;
@property (weak, nonatomic) IBOutlet ALButton *restartBTN;
@property (weak, nonatomic) IBOutlet ALButton *nextBTN;

@property (weak, nonatomic) IBOutlet UILabel *isWinLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentStepLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalStepLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepSlashTextLabel;

@end

@implementation PuzzleImplementationViewController

-(void)awakeFromNib{
    [super awakeFromNib];
    [self awakeFromNibInitialization];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialization];
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
    
    //within resultDisplayView
    [self.resultTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.resultTextLabel.superview.mas_centerY).with.multipliedBy(0.5);
        make.height.equalTo(self.resultTextLabel.superview.mas_height).with.multipliedBy(0.4);
        make.width.equalTo(self.resultTextLabel.superview.mas_width).with.multipliedBy(0.5);
        make.left.equalTo(self.resultTextLabel.superview.mas_centerX).with.multipliedBy(0.1);
    }];
    
    [self.isWinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.isWinLabel.superview.mas_centerY).with.multipliedBy(0.5);
        make.height.equalTo(self.isWinLabel.superview.mas_height).with.multipliedBy(0.4);
        make.width.equalTo(self.isWinLabel.superview.mas_width).with.multipliedBy(0.5);
        make.right.equalTo(self.isWinLabel.superview.mas_centerX).with.multipliedBy(1.9);
    }];
    
    [self.stepTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stepTextLabel.superview.mas_centerY).with.multipliedBy(1.5);
        make.height.equalTo(self.stepTextLabel.superview.mas_height).with.multipliedBy(0.4);
        make.width.equalTo(self.stepTextLabel.superview.mas_width).with.multipliedBy(0.5);
        make.left.equalTo(self.stepTextLabel.superview.mas_centerX).with.multipliedBy(0.1);
    }];
    
    
    [self.totalStepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.totalStepLabel.superview.mas_centerY).with.multipliedBy(1.5);
        make.height.equalTo(self.totalStepLabel.superview.mas_height).with.multipliedBy(0.4);
        make.width.equalTo(self.totalStepLabel.superview.mas_width).with.multipliedBy(0.07);
        make.right.equalTo(self.totalStepLabel.superview.mas_centerX).with.multipliedBy(1.9);
    }];
    
    [self.stepSlashTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stepSlashTextLabel.superview.mas_centerY).with.multipliedBy(1.5);
        make.height.equalTo(self.stepSlashTextLabel.superview.mas_height).with.multipliedBy(0.4);
        make.width.equalTo(self.stepSlashTextLabel.superview.mas_width).with.multipliedBy(0.03);
        make.right.equalTo(self.totalStepLabel.mas_left).with.offset(-3);
    }];
    
    [self.currentStepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.currentStepLabel.superview.mas_centerY).with.multipliedBy(1.5);
        make.height.equalTo(self.currentStepLabel.superview.mas_height).with.multipliedBy(0.4);
        make.width.equalTo(self.currentStepLabel.superview.mas_width).with.multipliedBy(0.1);
        make.right.equalTo(self.stepSlashTextLabel.mas_left).with.offset(-3);
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


- (IBAction)playBTNPressed:(id)sender {
    if(![self.currentPuzzleBoard isGoal].boolValue && !self.playBTNFromBeginningFlag.boolValue){
        [self restartBTNPressed:sender];
        self.playBTNFromBeginningFlag = @(YES);
        return;
    }
    else if(![self.currentPuzzleBoard isGoal].boolValue){
        PuzzleBoard *next = [self.solutions nextObject];
        self.fromStartPosition = @NO;
        [self EnableControlsInteraction:NO];
        [self.animationView switchFromSourceBoard:self.currentPuzzleBoard toDestBoard:next completion:^(BOOL finisehd) {
            if(finisehd){
                [self EnableControlsInteraction:YES];
            }
        }];
    }
}

- (IBAction)quickNextBTNPressed:(id)sender {
    @weakify(self)
    if([self.currentPuzzleBoard isGoal].boolValue) {
        //self.playBTN.enabled = YES;
        if(self.producerConsumer.productsCount > 0)self.nextBTN.enabled = YES;
        else self.nextBTN.enabled = NO;
        [self.animationView enableSwipeGestureRecognizers:YES];
        self.quickNextBTN.selected = NO;
        self.playBTNFromBeginningFlag = @(NO);
        self.quickNextBTNExcuting = @NO;
        self.fromStartPosition = @NO;
        [self EnableControlsInteraction:YES];
        return;
    }
    else{
        self.quickNextBTNExcuting = @YES;
        //self.restartBTN.enabled = NO;
        //self.playBTN.enabled = NO;
        self.nextBTN.enabled = NO;
        [self.animationView enableSwipeGestureRecognizers:NO];
        self.quickNextBTN.selected = YES;
        [self EnableControlsInteraction:NO];
        PuzzleBoard *next = [self.solutions nextObject];
        [self.animationView switchFromSourceBoard:self.currentPuzzleBoard toDestBoard:next completion:^(BOOL finish) {
            @strongify(self)
            if(finish){
                [self quickNextBTNPressed:sender];
                
            }
        }];
    }
}

- (IBAction)restartBTNPressed:(id)sender {
    [self restartStartPuzzleBoard];
}

- (IBAction)randomBTNPressed:(id)sender {
    [self.producerConsumer consumingTask:^(PuzzleSolver *puzzleSolver) {
        self.puzzleSolver = puzzleSolver;
        [self restartStartPuzzleBoard];
    } onDispatchQueue:dispatch_get_main_queue()];
}

#pragma mark - DataSource for animationView

-(PuzzleBoard *)getCurrentPuzzleBoardForAnimationView:(PuzzleAnimationView *)animationView{
    return self.currentPuzzleBoard;
}

-(void)setPuzzleBoardFromAnimationView:(PuzzleBoard *)puzzleBoard{
    self.currentPuzzleBoard = puzzleBoard;
}

#pragma mark - Delegate for animationView

-(void)puzzleAnimationViewDidUpdateFromBoard:(PuzzleBoard *)sourceBoard toBoard:(PuzzleBoard *)destinationBoard{
    DLog(@"sourceBoard:%@",sourceBoard);
    DLog(@"destinationBoard:%@",destinationBoard);
}

-(void)setFromBeginningFlag:(NSNumber *)flag{
    _playBTNFromBeginningFlag = flag;
}

-(void)setFromStartPosition:(NSNumber *)flag{
    _fromStartPosition = flag;
}

-(void)setPlayerTouched:(NSNumber *)flag{
    _playerTouched = flag;
}


#pragma mark - helper

-(void)awakeFromNibInitialization{
    
    self.producerConsumer = [[ALProducerConsumer alloc] initWithCapacity:kPOOL_CAPACITY];
    self.enableInteraction = YES;
    n = 3;
    
    int **block;
    PuzzleBoard *board;
    PuzzleSolver *solver;
    
    //initial 1;
    block = malloc(n*sizeof(int*));
    for (int i = 0; i < 3; i++){
        block[i] = malloc(n*sizeof(int));
    }
    block[0][0] = 1; block[0][1] = 0; block[0][2] = 3;
    block[1][0] = 4; block[1][1] = 2; block[1][2] = 5;
    block[2][0] = 7; block[2][1] = 8; block[2][2] = 6;
    
    board = [[PuzzleBoard alloc] initWithBlocks:block andLength:n];
    solver = [[PuzzleSolver alloc] initWithBoard:board];
    [self.producerConsumer addProduct:solver];
    
    //initial 2;
    block = malloc(n*sizeof(int*));
    for (int i = 0; i < 3; i++){
        block[i] = malloc(n*sizeof(int));
    }
    block[0][0] = 4; block[0][1] = 1; block[0][2] = 2;
    block[1][0] = 6; block[1][1] = 0; block[1][2] = 3;
    block[2][0] = 7; block[2][1] = 5; block[2][2] = 8;
    
    board = [[PuzzleBoard alloc] initWithBlocks:block andLength:n];
    solver = [[PuzzleSolver alloc] initWithBoard:board];
    [self.producerConsumer addProduct:solver];
    //initial 3;
    
    block = malloc(n*sizeof(int*));
    for (int i = 0; i < 3; i++){
        block[i] = malloc(n*sizeof(int));
    }
    block[0][0] = 2; block[0][1] = 0; block[0][2] = 3;
    block[1][0] = 1; block[1][1] = 6; block[1][2] = 8;
    block[2][0] = 4; block[2][1] = 7; block[2][2] = 5;
    board = [[PuzzleBoard alloc] initWithBlocks:block andLength:n];
    solver = [[PuzzleSolver alloc] initWithBoard:board];
    [self.producerConsumer addProduct:solver];
    
    int randomI = [MathStats getRandomNumberBetween:0 to:[self.producerConsumer.productsCount integerValue]];
    self.puzzleSolver = [self.producerConsumer.products objectAtIndex:randomI];
    [self.producerConsumer.products removeObject:self.puzzleSolver];
    [self restartStartPuzzleBoard];
    
    self.playBTNFromBeginningFlag = @(YES);
    
    [self.producerConsumer producingTask:^id{
        PuzzleBoard *randomPuzzleBoard = [[PuzzleBoard alloc] initRandomlyWithLength:3];
        //DLog(@"r: %@",randomPuzzleBoard);
        PuzzleSolver *solver = [[PuzzleSolver alloc] initWithBoard:randomPuzzleBoard];
        return solver;
    }];
    self.fromStartPosition = @YES;
    self.playerTouched = @NO;
}

-(void)initialization{
    self.title = self.project.shortName;
    self.quickNextBTNExcuting = @NO;
    self.animationView.backgroundColor = [ColorStore animationViewColor];
    self.animationView.dataSource = self;
    self.animationView.delegate = self;
    [self.animationView setNeedsDisplay];
    
    self.resultDisplayView.backgroundColor = [ColorStore resultDisplayViewColor];
    self.resultDisplayView.layer.borderWidth = 0.5;
    self.resultDisplayView.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.05f].CGColor;
    self.isWinLabel.backgroundColor = [UIColor clearColor];
    self.isWinLabel.textAlignment = NSTextAlignmentRight;
    self.controlView.backgroundColor = [UIColor clearColor];
    self.currentStepLabel.backgroundColor = [UIColor clearColor];
    self.currentStepLabel.textAlignment = NSTextAlignmentRight;
    self.totalStepLabel.backgroundColor = [UIColor clearColor];
    self.totalStepLabel.textAlignment = NSTextAlignmentRight;
    self.stepSlashTextLabel.textAlignment = NSTextAlignmentRight;
    
    self.controlView.backgroundColor = [ColorStore resultDisplayViewColor];
    self.controlView.layer.borderWidth = 0.5;
    self.controlView.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.05f].CGColor;
    
    @weakify(self)
    [RACObserve(self, currentPuzzleBoard.isGoal) subscribeNext:^(NSNumber *x) {
        @strongify(self)
        BOOL win = x.boolValue;
        if(win){
            self.isWinLabel.text = @"Win";
        }else{
            self.isWinLabel.text = @"Lose";
        }
    }];
    
    [[self.restartBTN rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.currentPuzzleBoard = self.startPuzzleBoard;
        self.solutions = [self.puzzleSolver solution];
        [self.solutions nextObject];
        
    }];
    

    RAC(self.totalStepLabel, text) = [RACObserve(self,puzzleSolver.moves) map:^id(NSNumber* value) {
        return [NSString stringWithFormat:@"%d", value.integerValue];
    }];
    
    RAC(self.currentStepLabel, text) = [RACObserve(self, currentStep) map:^id(NSNumber* value) {
        return [NSString stringWithFormat:@"%@",value];
    }];
    
    RACSignal *quickNextExecutingSignal = [RACObserve(self, quickNextBTNExcuting) distinctUntilChanged];
    
    RAC(self, nextBTN.enabled) = [[RACSignal combineLatest:@[self.producerConsumer.consumingEnableSignal,quickNextExecutingSignal] reduce:^NSNumber *(NSNumber *consumingEnable, NSNumber *executing){
        return @([consumingEnable boolValue] && ![executing boolValue]);
    }] deliverOnMainThread];
    
    RAC(self, quickNextBTN.enabled) = RACObserve(self, fromStartPosition);
    
    
    RAC(self,restartBTN.enabled) = [RACSignal combineLatest:@[RACObserve(self, fromStartPosition),RACObserve(self, quickNextBTN.selected)] reduce:^id(NSNumber *fromBeginning, NSNumber *selected){
        if([selected boolValue]){
            return @NO;
        }else if([fromBeginning boolValue]){
            return @NO;
        }else{
            return @YES;
        }
    }];
    
    RAC(self,playBTN.enabled) = [RACSignal combineLatest:@[RACObserve(self, playerTouched),RACObserve(self, quickNextBTN.selected),RACObserve(self, currentPuzzleBoard.isGoal)] reduce:^id(NSNumber *playerTouched, NSNumber *selected, NSNumber *isGoal){
        if([selected boolValue] || [playerTouched boolValue] || [isGoal boolValue]){
            return @NO;
        }else{
            return @YES;
        }
    }];


}

-(void)restartStartPuzzleBoard{
    self.playBTNFromBeginningFlag = @YES;
    self.fromStartPosition = @YES;
    self.playerTouched = NO;
    self.currentStep = @(0);
    self.solutions = [self.puzzleSolver solution];
    self.startPuzzleBoard = [self.solutions nextObject];
    self.currentPuzzleBoard = self.startPuzzleBoard;
    [self.animationView setNeedsDisplay];
}


-(void)EnableControlsInteraction:(BOOL)enable{
    if(enable){
        if(!self.enableInteraction){
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            self.enableInteraction = YES;
        }
    }else{
        if(self.enableInteraction){
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            self.enableInteraction = NO;
        }
    }
}

@end
