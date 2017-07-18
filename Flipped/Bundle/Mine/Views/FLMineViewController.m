//
//  FLMineViewController.m
//  Flipped
//
//  Created by junshao on 2017/7/4.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLMineViewController.h"
#import "Masonry.h"
#import "FLFlippedListViewController.h"
#import "FLFlippedWordsService.h"
#import "FLPostViewController.h"

@interface FLMineViewController()

@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) FLFlippedListViewController *sendListView;
@property (nonatomic, strong) FLFlippedListViewController *receiveListView;

@property (nonatomic, strong) NSArray<NSString *> *segmentTitles;

@end

@implementation FLMineViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.title = @"我的";
    [self configRightNavigationItemWithTitle:@"发布" image:nil action:@selector(postBtnDidClick)];

    self.segmentTitles = [NSArray arrayWithObjects:@"我发送的", @"我收到的", nil];
    self.segmentControl.selectedSegmentIndex = 0;
    self.sendListView.view.hidden = NO;
    self.receiveListView.view.hidden = YES;
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self makeConstraints];
}

-(void)makeConstraints{
    
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentControl.superview).offset(64+10);
        make.centerX.equalTo(self.segmentControl.superview);
        make.left.equalTo(self.segmentControl.superview).offset(10);
        make.right.equalTo(self.segmentControl.superview).offset(-10);
        make.height.equalTo(@30);
    }];
    
    [self.sendListView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentControl.mas_bottom).offset(10);
        make.left.equalTo(self.sendListView.view.superview);
        make.bottom.equalTo(self.sendListView.view.superview);
        make.right.equalTo(self.sendListView.view.superview);
    }];
    
    [self.receiveListView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentControl.mas_bottom).offset(10);
        make.left.equalTo(self.receiveListView.view.superview);
        make.bottom.equalTo(self.sendListView.view.superview);
        make.right.equalTo(self.sendListView.view.superview);
    }];
}

#pragma mark - action

- (void)segmentDidChange:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            self.sendListView.view.hidden = NO;
            self.receiveListView.view.hidden = YES;
            break;
        }
        case 1:
        {
            self.sendListView.view.hidden = YES;
            self.receiveListView.view.hidden = NO;
            break;
        }
        default:
            break;
    }
}

-(void)postBtnDidClick{
    
    FLPostViewController *vc = [[FLPostViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:navi animated:YES completion:^{
        
    }];
    
}


#pragma mark - getter & setter

- (UISegmentedControl *)segmentControl {
    if(!_segmentControl){
        _segmentControl = [[UISegmentedControl alloc] initWithItems:self.segmentTitles];
        [_segmentControl addTarget:self action:@selector(segmentDidChange:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_segmentControl];
    }
    return _segmentControl;
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

-(FLFlippedListViewController *)receiveListView{
    if(!_receiveListView){
        _receiveListView = [[FLFlippedListViewController alloc] init];
        _receiveListView.listType = FLFlippedListTypeReceive;
        [self addChildViewController:_receiveListView];
        [self.view addSubview:_receiveListView.view];
    }
    return _receiveListView;
}

@end
