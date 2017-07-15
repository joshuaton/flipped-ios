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
    self.segmentTitles = [NSArray arrayWithObjects:@"我发送的", @"我收到的", nil];
    self.segmentControl.selectedSegmentIndex = 0;
    
    [self makeConstraints];
    
    [FLFlippedWordsService getSendFlippedWordsWithSuccessBlock:^(NSMutableArray *flippedWords) {
        [self.sendListView refreshWithFlippedWords:flippedWords];
    } failBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(void)makeConstraints{
    
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentControl.superview).offset(64+10);
        make.centerX.equalTo(self.segmentControl.superview);
        make.width.equalTo(self.segmentControl.superview);
        make.height.equalTo(@30);
    }];
    
    [self.sendListView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentControl).offset(10);
        make.left.equalTo(self.sendListView.view.superview);
        make.bottom.equalTo(self.sendListView.view);
        make.right.equalTo(self.sendListView.view);
    }];
    
    [self.receiveListView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentControl).offset(10);
        make.left.equalTo(self.receiveListView.view.superview);
        make.bottom.equalTo(self.sendListView.view);
        make.right.equalTo(self.sendListView.view);
    }];
}

#pragma mark - action

- (void)segmentDidChange:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            [FLFlippedWordsService getSendFlippedWordsWithSuccessBlock:^(NSMutableArray *flippedWords) {
                [self.sendListView refreshWithFlippedWords:flippedWords];
            } failBlock:^(NSError *error) {
                NSLog(@"%@", error);
            }];
            break;
        }
        case 1:
        {
            [FLFlippedWordsService getReceiveFlippedWordsWithSuccessBlock:^(NSMutableArray *flippedWords) {
                [self.sendListView refreshWithFlippedWords:flippedWords];
            } failBlock:^(NSError *error) {
                NSLog(@"%@", error);
            }];
            break;
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
        [self.view addSubview:_segmentControl];
    }
    return _segmentControl;
}

-(FLFlippedListViewController *)sendListView{
    if(!_sendListView){
        _sendListView = [[FLFlippedListViewController alloc] init];
        [self addChildViewController:_sendListView];
        [self.view addSubview:_sendListView.view];
        _sendListView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    return _sendListView;
}

-(FLFlippedListViewController *)receiveListView{
    if(!_receiveListView){
        _receiveListView = [[FLFlippedListViewController alloc] init];
        [self addChildViewController:_receiveListView];
        [self.view addSubview:_receiveListView.view];
        _receiveListView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    return _receiveListView;
}

@end
