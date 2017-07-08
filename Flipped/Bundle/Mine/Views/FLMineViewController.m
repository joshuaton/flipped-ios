//
//  FLMineViewController.m
//  Flipped
//
//  Created by junshao on 2017/7/4.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLMineViewController.h"
#import "Masonry.h"

@interface FLMineViewController() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIButton *postButton;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FLMineViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self.postButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@30);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.postButton.mas_bottom).offset(10);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - getter & setter

-(UIButton *)postButton{
    if(!_postButton){
        _postButton = [[UIButton alloc] init];
        [_postButton setTitle:@"说句悄悄话" forState:UIControlStateNormal];
        [_postButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_postButton setBackgroundColor:[UIColor greenColor]];
        [self.view addSubview:_postButton];
    }
    return _postButton;
}

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
