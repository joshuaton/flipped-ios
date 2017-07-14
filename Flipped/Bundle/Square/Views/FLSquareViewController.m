//
//  FLSquareViewController.m
//  Flipped
//
//  Created by junshao on 2017/7/4.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLSquareViewController.h"
#import "FLFlippedWordsService.h"
#import "FLCommHeader.h"
#import "FLFlippedWordCell.h"
#import "FLPostViewController.h"

@interface FLSquareViewController() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *flippedWords;

@end

@implementation FLSquareViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"广场";
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btn addTarget:self action:@selector(postBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"post_add"] forState:UIControlStateNormal];
    UIBarButtonItem *publishItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = publishItem;
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.flippedWords = [[NSMutableArray alloc] init];
    
    [FLFlippedWordsService getNearbyFlippedWordsWithSuccessBlock:^(NSMutableArray *flippedWords) {
        self.flippedWords = flippedWords;
        NSLog(@"success %@", self.flippedWords);
        [self.tableView reloadData];
    } failBlock:^(NSError *error) {
        NSLog(@"error %@", error);
    }];
}

-(void)postBtnDidClick{
    FLPostViewController *vc = [[FLPostViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
