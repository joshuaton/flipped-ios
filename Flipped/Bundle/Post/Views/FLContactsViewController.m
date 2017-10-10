//
//  FLContactsViewController.m
//  Flipped
//
//  Created by junshao on 2017/10/10.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLContactsViewController.h"

@interface FLContactsViewController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FLContactsViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"从通讯录导入";
}

#pragma mark - tableview delegate

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.flippedWords.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    FLFlippedWordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FLFlippedWordCell class]) forIndexPath:indexPath];
//    cell.type = self.listType;
//    [cell refreshWithData:self.flippedWords[indexPath.row]];
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    FLFlippedWordCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.backgroundColor = COLOR_W;
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    
//    FLFlippedDetailViewController *vc = [[FLFlippedDetailViewController alloc] init];
//    FLFlippedWord *data = self.flippedWords[indexPath.row];
//    vc.flippedId = data.id;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 44;
//}

#pragma mark - getter & setter

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        [_tableView registerClass:[FLFlippedWordCell class] forCellReuseIdentifier:NSStringFromClass([FLFlippedWordCell class])];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end

