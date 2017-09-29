//
//  FLSquareViewController.m
//  Flipped
//
//  Created by junshao on 2017/7/4.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLSquareViewController.h"
#import "FLFlippedWordsService.h"
#import "FLFlippedWordCell.h"
#import "FLPostViewController.h"
#import "FLFlippedListViewController.h"
#import "Masonry.h"

@interface FLSquareViewController() 

@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) FLFlippedListViewController *squareListView;
@property (nonatomic, strong) FLFlippedListViewController *sendListView;
@property (nonatomic, strong) FLFlippedListViewController *receiveListView;

@property (nonatomic, strong) NSArray<NSString *> *segmentTitles;

@end

@implementation FLSquareViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"爱要说";
    [self configRightNavigationItemWithTitle:@"发布" image:nil action:@selector(postBtnDidClick)];
    
    self.segmentTitles = [NSArray arrayWithObjects:@"广场", @"我收到的", @"我发送的", nil];
    self.segmentControl.selectedSegmentIndex = 0;
    self.receiveListView.view.hidden = YES;
    self.sendListView.view.hidden = YES;

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self makeConstraints];
}

-(void)makeConstraints{
    
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentControl.superview).offset(STATUS_BAR_HEIGHT+44+10);
        make.centerX.equalTo(self.segmentControl.superview);
        make.left.equalTo(self.segmentControl.superview).offset(10);
        make.right.equalTo(self.segmentControl.superview).offset(-10);
        make.height.equalTo(@30);
    }];
    
    [self.squareListView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentControl.mas_bottom).offset(10);
        make.left.equalTo(self.squareListView.view.superview);
        make.bottom.equalTo(self.squareListView.view.superview);
        make.right.equalTo(self.squareListView.view.superview);
    }];

    [self.receiveListView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.squareListView.view);
        make.left.equalTo(self.squareListView.view);
        make.bottom.equalTo(self.squareListView.view);
        make.right.equalTo(self.squareListView.view);
    }];
    
    [self.sendListView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.squareListView.view);
        make.left.equalTo(self.squareListView.view);
        make.bottom.equalTo(self.squareListView.view);
        make.right.equalTo(self.squareListView.view);
    }];
}

#pragma mark - action

-(void)postBtnDidClick{
    
    [FLPostViewController present];
}

#pragma mark - action

- (void)segmentDidChange:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            self.squareListView.view.hidden = NO;
            self.receiveListView.view.hidden = YES;
            self.sendListView.view.hidden = YES;
            break;
        }
        case 1:
        {
            self.squareListView.view.hidden = YES;
            self.receiveListView.view.hidden = NO;
            self.sendListView.view.hidden = YES;
            break;
        }
        case 2:
        {
            self.squareListView.view.hidden = YES;
            self.receiveListView.view.hidden = YES;
            self.sendListView.view.hidden = NO;
        }
        default:
            break;
    }
}

#pragma mark - getter & setter

- (UISegmentedControl *)segmentControl {
    if(!_segmentControl){
        _segmentControl = [[UISegmentedControl alloc] initWithItems:self.segmentTitles];
        [_segmentControl addTarget:self action:@selector(segmentDidChange:) forControlEvents:UIControlEventValueChanged];
        _segmentControl.tintColor = COLOR_M;
        [self.view addSubview:_segmentControl];
    }
    return _segmentControl;
}

-(FLFlippedListViewController *)squareListView{
    if(!_squareListView){
        _squareListView = [[FLFlippedListViewController alloc] init];
        _squareListView.listType = FLFlippedListTypeSquare;
        [self addChildViewController:_squareListView];
        [self.view addSubview:_squareListView.view];
    }
    return _squareListView;
}

-(FLFlippedListViewController *)receiveListView{
    if(!_receiveListView){
        _receiveListView = [[FLFlippedListViewController alloc] init];
        _receiveListView.listType = FLFlippedListTypeReceive;
        [self addChildViewController:_receiveListView];
        [self.view addSubview:_receiveListView.view];
    }
    return _receiveListView;
}

-(FLFlippedListViewController *)sendListView{
    if(!_sendListView){
        _sendListView = [[FLFlippedListViewController alloc] init];
        _sendListView.listType = FLFlippedListTypeSend;
        [self addChildViewController:_sendListView];
        [self.view addSubview:_sendListView.view];
    }
    return _sendListView;
}

@end
