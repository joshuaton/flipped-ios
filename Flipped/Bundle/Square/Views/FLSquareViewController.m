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
#import "FLFlippedListViewController.h"
#import "Masonry.h"

@interface FLSquareViewController() 

@property (nonatomic, strong) FLFlippedListViewController *listView;

@property (nonatomic, strong) NSMutableArray *flippedWords;

@end

@implementation FLSquareViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"广场";
    [self configRightNavigationItemWithTitle:@"发布" image:nil action:@selector(postBtnDidClick)];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self makeConstraints];
}

-(void)makeConstraints{
    [self.listView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.listView.view.superview);
        make.left.equalTo(self.listView.view.superview);
        make.bottom.equalTo(self.listView.view.superview);
        make.right.equalTo(self.listView.view.superview);
    }];
}

#pragma mark - action

-(void)postBtnDidClick{
    
    [FLPostViewController present];
}

#pragma mark - getter & setter

-(FLFlippedListViewController *)listView{
    if(!_listView){
        _listView = [[FLFlippedListViewController alloc] init];
        _listView.listType = FLFlippedListTypeSquare;
        [self addChildViewController:_listView];
        [self.view addSubview:_listView.view];
    }
    return _listView;
}

@end
