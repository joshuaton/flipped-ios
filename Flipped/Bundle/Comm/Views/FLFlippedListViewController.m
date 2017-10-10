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
#import "MJRefresh.h"
#import "Masonry.h"
#import "FLFlippedDetailViewController.h"
#import "FLUserInfoManager.h"
#import "FLToast.h"

@interface FLFlippedListViewController() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *emptyLabel;

@property (nonatomic, strong) NSMutableArray *flippedWords;

@end

@implementation FLFlippedListViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePostSuccess:) name:NOTIFICATION_POST_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLoginSuccess:) name:NOTIFICATION_LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDeleteSuccess:) name:NOTIFICATION_DELETE_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLocationSuccess:) name:NOTIFICATION_LOCATION_SUCCESS object:nil];

    [self makeConstraints];

    //如果没有登录不加载数据
    if(![[FLUserInfoManager sharedInstance] isLogin] && self.listType != FLFlippedListTypeSquare){
        [self showEmptyLabel:@"请登录后查看"];
        return;
    }
    
    [self loadData];
    //设置之后会自动执行一次
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.flippedWords removeAllObjects];
        [self loadData];
    }];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - private

-(void)makeConstraints{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.superview);
        make.left.equalTo(self.tableView.superview);
        make.bottom.equalTo(self.tableView.superview);
        make.right.equalTo(self.tableView.superview);
    }];
    
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
    }];
}

-(void)loadData{
    
    switch (self.listType) {
        case FLFlippedListTypeSquare:
        {
            
            [FLFlippedWordsService getNearbyFlippedWordsWithSuccessBlock:^(NSMutableArray *flippedWords) {
                self.flippedWords = flippedWords;
                
                [self showData];
            } failBlock:^(NSError *error) {
                NSLog(@"error %@", error);
                
                [self showData];
            }];

            break;
        }
        case FLFlippedListTypeSend:
        {
            [FLFlippedWordsService getSendFlippedWordsWithSuccessBlock:^(NSMutableArray *flippedWords) {
                self.flippedWords = flippedWords;
                
                [self showData];
            } failBlock:^(NSError *error) {
                NSLog(@"error %@", error);
                
                [self showData];
            }];
            
            break;
        }
        case FLFlippedListTypeReceive:
        {
            [FLFlippedWordsService getReceiveFlippedWordsWithSuccessBlock:^(NSMutableArray *flippedWords) {
                self.flippedWords = flippedWords;
                
                [self showData];
            } failBlock:^(NSError *error) {
                NSLog(@"error %@", error);
                
                [self showData];
            }];
            
            break;
        }
        default:
            break;
    }
}

-(void)showData{
    if(self.flippedWords.count == 0){
        [self showEmptyLabel:@"暂无数据"];
    }else{
        self.emptyLabel.hidden = YES;
        [self hideEmptyLabel];
        [self.tableView reloadData];
    }
    
    [self.tableView reloadData];
    
    [self endRefresh];

}

-(void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void)showEmptyLabel:(NSString *)text{
    self.emptyLabel.hidden = NO;
    self.emptyLabel.text = text;
}

-(void)hideEmptyLabel{
    self.emptyLabel.hidden = YES;
}

#pragma mark - notification

-(void)receivePostSuccess:(NSNotification *)notification{
    [self.tableView.mj_header beginRefreshing];
}

-(void)receiveLoginSuccess:(NSNotification *)notification{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.flippedWords removeAllObjects];
        [self loadData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

-(void)receiveDeleteSuccess:(NSNotification *)notification{
    NSString *id = [[notification userInfo] valueForKey:@"id"];
    
    for(int i=0; i<self.flippedWords.count; i++){
        FLFlippedWord *data = self.flippedWords[i];
        if([data.id isEqualToString:id]){
            [self.flippedWords removeObject:data];
            
            [self.tableView reloadData];
            break;
        }
    }
}
-(void)receiveLocationSuccess:(NSNotification *)notification{
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.flippedWords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FLFlippedWordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FLFlippedWordCell class]) forIndexPath:indexPath];
    cell.type = self.listType;
    [cell refreshWithData:self.flippedWords[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FLFlippedWordCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = COLOR_W;
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    FLFlippedDetailViewController *vc = [[FLFlippedDetailViewController alloc] init];
    FLFlippedWord *data = self.flippedWords[indexPath.row];
    vc.flippedId = data.id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
       
        

        
//        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            
//        }];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(UILabel *)emptyLabel{
    if(!_emptyLabel){
        _emptyLabel = [[UILabel alloc] init];
        _emptyLabel.text = @"暂无内容";
        _emptyLabel.font = FONT_L;
        _emptyLabel.textColor = COLOR_H1;
        _emptyLabel.hidden = YES;
        [self.view addSubview:_emptyLabel];
    }
    return _emptyLabel;
}


@end
