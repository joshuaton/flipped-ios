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

@interface FLSquareViewController() 

@property (nonatomic, strong) FLFlippedListViewController *listView;

@property (nonatomic, strong) NSMutableArray *flippedWords;

@end

@implementation FLSquareViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"广场";
    [self configRightNavigationItemWithTitle:@"发布" image:nil action:@selector(postBtnDidClick)];
    
    
    [FLFlippedWordsService getNearbyFlippedWordsWithSuccessBlock:^(NSMutableArray *flippedWords) {
        self.flippedWords = flippedWords;
        [self.listView refreshWithFlippedWords:self.flippedWords];
    } failBlock:^(NSError *error) {
        NSLog(@"error %@", error);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.listView.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-48-64);
}

-(void)postBtnDidClick{
    FLPostViewController *vc = [[FLPostViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter & setter

-(FLFlippedListViewController *)listView{
    if(!_listView){
        _listView = [[FLFlippedListViewController alloc] init];
        [self addChildViewController:_listView];
        [self.view addSubview:_listView.view];
    }
    return _listView;
}

@end
