//
//  FLFlippedListViewController.m
//  Flipped
//
//  Created by ShaoJun on 2017/7/15.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLFlippedListViewController.h"
#import "FLFlippedWordCell.h"
#import "FLFlippedWordsService.h"

@interface FLFlippedListViewController() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *flippedWords;

@end

@implementation FLFlippedListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

-(void)refreshWithFlippedWords:(NSMutableArray *)filppedWords{
    self.flippedWords = filppedWords;
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.flippedWords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FLFlippedWordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FLFlippedWordCell class]) forIndexPath:indexPath];
    [cell refreshWithData:self.flippedWords[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma mark - getter & setter

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[FLFlippedWordCell class] forCellReuseIdentifier:NSStringFromClass([FLFlippedWordCell class])];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


@end
