//
//  FLNewMineViewController.m
//  Flipped
//
//  Created by ShaoJun on 2017/7/23.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLNewMineViewController.h"
#import "Masonry.h"
#import "UIColor+HexColor.h"
#import "FLHelpViewController.h"
#import "FLLoginViewController.h"
#import "FLFeedbackViewController.h"
#import "FLUserInfoManager.h"

@interface FLNewMineViewController() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FLNewMineViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"我的";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.superview);
        make.left.equalTo(self.tableView.superview);
        make.bottom.equalTo(self.tableView.superview);
        make.right.equalTo(self.tableView.superview);
    }];
}

#pragma mark - tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return 1;
            break;
        }
        case 1:
        {
            return 2;
            break;
        }
        case 2:
        {
            return 1;
            break;
        }
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"用户%@", [FLUserInfoManager sharedUserInfoManager].uid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case 1:
        {
            if(indexPath.row == 0){
                cell.textLabel.text = @"使用帮助";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else if(indexPath.row == 1){
                cell.textLabel.text = @"反馈问题";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            break;
        }
        case 2:
        {
            cell.textLabel.text = @"退出登录";
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            break;
        }
        default:
            break;
    }
    
    cell.textLabel.font = FONT_L;
    cell.textLabel.textColor = COLOR_H1;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.section) {

        case 1:
        {
            if(indexPath.row == 0){
                FLHelpViewController *vc = [[FLHelpViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if(indexPath.row == 1){
                
                if(![[FLUserInfoManager sharedUserInfoManager] checkLogin]){
                    return;
                }
                
                FLFeedbackViewController *vc = [[FLFeedbackViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }

            break;
        }
        case 2:
        {
            [self.navigationController.tabBarController setSelectedIndex:0];
            [FLLoginViewController present];
            break;
        }
        default:
            break;
    }
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
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];


        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
