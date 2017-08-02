//
//  FLFlippedDetailViewController.m
//  Flipped
//
//  Created by junshao on 2017/7/19.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLFlippedDetailViewController.h"
#import "Masonry.h"
#import "FLFlippedWordsService.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FLToast.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "FLCommHeader.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "FLStringUtils.h"
#import "FLCopyLabel.h"
#import "QQPopMenuView.h"
#import "FLCommService.h"
#import "FLCommentCell.h"
#import "FLUserInfoManager.h"


@interface FLFlippedDetailViewController() <MWPhotoBrowserDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) FLCopyLabel *contentLabel;
@property (nonatomic, strong) UILabel *sendLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *commentView;
@property (nonatomic, strong) UIView *commentLineView;
@property (nonatomic, strong) UIView *commentTextBorderView;
@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, strong) UIButton *commentButton;

@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) FLFlippedWord *data;
@property (nonatomic, strong) NSMutableArray *comments;

@end

@implementation FLFlippedDetailViewController

-(void)viewDidLoad{
    [super viewDidLoad];
        
    self.title = @"详情";
    [self configRightNavigationItemWithTitle:nil image:[UIImage imageNamed:@"flipped_detail_more"] action:@selector(moreBtnClick)];
    
    [FLFlippedWordsService getFlippedWordsDetailWithId:self.flippedId successBlock:^(FLFlippedWord *data) {
        
        self.data = data;
        [self showData:data];
        

    } failBlock:^(NSError *error) {
        NSLog(@"get detail error");

    }];
    
    [self loadComment:NO];
    
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self makeConstraints];

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - private

-(void)makeConstraints{
        
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.bottom.equalTo(self.commentView.mas_top);
        make.right.equalTo(@0);
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
    }];
    
    [self.sendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentLabel);
        make.right.equalTo(self.contentLabel);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sendLabel.mas_bottom).offset(10);
        make.left.equalTo(self.sendLabel);
        make.right.equalTo(self.sendLabel);
        make.height.equalTo(self.imageView.mas_width);
        make.bottom.equalTo(self.headerView).offset(-10);
    }];
    
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.bottom.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@45);
    }];
    
    [self.commentLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@1);
    }];
    
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentLineView.mas_bottom).offset(5);
        make.bottom.equalTo(@-5);
        make.right.equalTo(@-10);
        make.width.equalTo(@65);
    }];
    
    [self.commentTextBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentButton);
        make.left.equalTo(@10);
        make.bottom.equalTo(self.commentButton);
        make.right.equalTo(self.commentButton.mas_left).offset(-10);
    }];
    
    [self.commentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentTextBorderView);
        make.left.equalTo(self.commentTextBorderView).offset(10);
        make.bottom.equalTo(self.commentTextBorderView);
        make.right.equalTo(self.commentTextBorderView).offset(-10);
    }];
    
    

}

-(void)showData:(FLFlippedWord *)data{
    
    NSArray<FLContent> *contents = data.contents;
    
    BOOL hasImage = NO;
    
    for(int i=0; i<contents.count; i++){
        FLContent *content = contents[i];
        
        if([content.type isEqualToString:@"text"]){
            self.contentLabel.text = content.text;
        }else if([content.type isEqualToString:@"picture"]){
            
            content.text = [FLStringUtils convertToHttpsWithUrl:content.text];
            
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:content.text] placeholderImage:[UIImage imageNamed:@"flipped_pic_default"]];
            hasImage = YES;
            
            self.photos = [NSMutableArray array];
            [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:content.text]]];
        }
    }
    
    [UILabel changeLineSpaceForLabel:self.contentLabel WithSpace:4.0];
    
    self.sendLabel.text = [NSString stringWithFormat:@"发送给：%@", data.sendto];

    if(hasImage){
        self.imageView.hidden = NO;
    }else{
        self.imageView.hidden = YES;
    }
    
    if(self.imageView.hidden){
        
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sendLabel.mas_bottom).offset(10);
            make.left.equalTo(self.sendLabel);
            make.bottom.equalTo(self.headerView).offset(-10);
            make.width.equalTo(@0);
            make.height.equalTo(@0);
        }];
    }
    
    CGFloat height = [self.headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = self.headerView.frame;
    frame.size.height = height;
    self.headerView.frame =frame;
    self.tableView.tableHeaderView = self.headerView;
}

-(void)loadComment:(BOOL)gotoEnd{
    
    [FLFlippedWordsService getCommentsWithId:self.flippedId successBlock:^(NSArray *comments) {
        
        self.comments = [comments mutableCopy];
        [self.tableView reloadData];
        
        if(gotoEnd){
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.comments.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    } failBlock:^(NSError *error) {
        
    }];
}

#pragma mark - notification

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWillShown:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    [self.commentView layoutIfNeeded];
    
    [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-keyboardSize.height));
    }];
    [UIView animateWithDuration:duration animations:^{
        [self.commentView layoutIfNeeded];
        [self.tableView layoutIfNeeded];
        [self.headerView layoutIfNeeded];
    }];
    
    
}
//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)notification{
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [self.commentView layoutIfNeeded];
    
    [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
    }];
    [UIView animateWithDuration:duration animations:^{
        [self.commentView layoutIfNeeded];
        [self.tableView layoutIfNeeded];
        [self.headerView layoutIfNeeded];
    }];

}

#pragma mark - action

-(void)moreBtnClick{
    
    if(![[FLUserInfoManager sharedUserInfoManager] checkLogin]){
        return;
    }
    
    NSArray<FLLink> *links = self.data.links;
    
    NSMutableArray *menuData = [[NSMutableArray alloc] init];
    for(int i=0; i<links.count; i++){
        FLLink *link = links[i];
        NSDictionary *dict;
        if([link.rel isEqualToString:@"report"]){
            dict = @{@"title" : @"举报"};
        }else if([link.rel isEqualToString:@"delete"]){
            dict = @{@"title" : @"删除"};
        }
        [menuData addObject:dict];
    }
    
    
    [QQPopMenuView showWithItems:menuData
                           width:130
    triangleLocation:CGPointMake([UIScreen mainScreen].bounds.size.width-30, 64+5)
      action:^(NSInteger index) {
          FLLink *link = links[index];
          
          if([link.rel isEqualToString:@"report"]){
              
              [FLCommService requestWithURI:link.uri method:link.method params:nil successBlock:^{
                  [FLToast showToast:@"举报成功，我们会尽快处理"];
              } failBlock:^(NSError *error) {
                  
              }];
              
          }else if([link.rel isEqualToString:@"delete"]){
              
              UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认删除" message:@"您将删除此心动话，删除后不能恢复" preferredStyle:UIAlertControllerStyleAlert];
              
              UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
              cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                  [alertController dismissViewControllerAnimated:YES completion:nil];
              }];
              [alertController addAction:cancelAction];
              
              UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                  [FLCommService requestWithURI:link.uri method:link.method params:nil successBlock:^{
                      
                      NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.data.id forKey:@"id"];
                      [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DELETE_SUCCESS object:self userInfo:userInfo];
                      [self.navigationController popViewControllerAnimated:YES];
                      
                  } failBlock:^(NSError *error) {
                      
                  }];                                  }];
              [alertController addAction:OKAction];
              
              [self presentViewController:alertController animated:YES completion:nil];
              
              
          }
      }];
    
    
}

-(void)imageViewClick{
    
    [self.commentTextField resignFirstResponder];
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    
    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:0];
    
    // Present
    [self.navigationController pushViewController:browser animated:YES];
}

-(void)commentBtnClick{
    NSString *contentStr = self.commentTextField.text;
    contentStr = [contentStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(contentStr.length == 0){
        [FLToast showToast:@"评论内容不能为空~"];
        return;
    }
    
    if(contentStr.length > 140){
        [FLToast showToast:@"评论不能超过140个字~"];
        return;
    }
    
    [FLFlippedWordsService commentFlippedWordWithId:self.data.id content:contentStr successBlock:^{
        
        [self loadComment:YES];
        [self.commentTextField resignFirstResponder];
        self.commentTextField.text = @"";
    } failBlock:^(NSError *error) {
        
    }];
}

-(void)clickOther{
    [self.commentTextField resignFirstResponder];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count) {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}

#pragma mark - tableview delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FLCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FLCommentCell class]) forIndexPath:indexPath];
    [cell refreshWithData:self.comments[indexPath.row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self.commentTextField resignFirstResponder];
    
    FLComment *comment = self.comments[indexPath.row];
    NSArray *links = comment.links;
    if(!links || links.count == 0){
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action;
    
    for(int i=0; i<links.count; i++){
        FLLink *link = links[i];
        
        if([link.rel isEqualToString:@"delete"]){
            action = [UIAlertAction actionWithTitle:@"删除评论" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                UIAlertController *deleteController = [UIAlertController alertControllerWithTitle:@"确认删除" message:@"您将删除此评论，删除后不能恢复" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [alertController dismissViewControllerAnimated:YES completion:nil];
                }];
                [deleteController addAction:cancelAction];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [FLCommService requestWithURI:link.uri method:link.method params:nil successBlock:^{
                        
                        [self.comments removeObjectAtIndex:indexPath.row];
                        [self.tableView reloadData];
                        
                    } failBlock:^(NSError *error) {
                        
                    }];                                  }];
                [deleteController addAction:OKAction];
                
                [self presentViewController:deleteController animated:YES completion:nil];
                
                
            }];
            [alertController addAction:action];

        }
    }
    
    action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = COLOR_H1;
    label.font = FONT_M;
    label.text = @"全部评论";
    [label sizeToFit];
    label.frame = CGRectMake(10, (30-label.frame.size.height)/2, label.frame.size.width, label.frame.size.height);

    headerView.backgroundColor = COLOR_H5;
    [headerView addSubview:label];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOther)];
    headerView.userInteractionEnabled = YES;
    [headerView addGestureRecognizer:tap];
    
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(self.comments.count > 0){
        return 30.0;
    }
    return 0;
}

#pragma mark - getter & setter

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[FLCommentCell class] forCellReuseIdentifier:NSStringFromClass([FLCommentCell class])];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableHeaderView = self.headerView;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(UIView *)headerView{
    if(!_headerView){
        _headerView = [[UIView alloc] init];
        _headerView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOther)];
        _headerView.userInteractionEnabled = YES;
        [_headerView addGestureRecognizer:tap];

    }
    return _headerView;
}


-(FLCopyLabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[FLCopyLabel alloc] init];
        _contentLabel.font = FONT_L;
        _contentLabel.textColor = COLOR_H1;
        _contentLabel.numberOfLines = 0;
        
        [self.headerView addSubview:_contentLabel];
    }
    return _contentLabel;
}

-(UILabel *)sendLabel{
    if(!_sendLabel){
        _sendLabel = [[UILabel alloc] init];
        _sendLabel.font = FONT_M;
        _sendLabel.textColor = COLOR_H2;
        [self.headerView addSubview:_sendLabel];
    }
    return _sendLabel;
}

-(UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick)];
        [_imageView addGestureRecognizer:tap];
        [self.headerView addSubview:_imageView];
    }
    return _imageView;
}

-(UIView *)commentView{
    if(!_commentView){
        _commentView = [[UIView alloc] init];
        _commentView.backgroundColor = COLOR_H5;
        [self.view addSubview:_commentView];
    }
    return _commentView;
}

-(UIView *)commentLineView{
    if(!_commentLineView){
        _commentLineView = [[UIView alloc] init];
        _commentLineView.backgroundColor = COLOR_H4;
        [self.commentView addSubview:_commentLineView];
    }
    return _commentLineView;
}

-(UIView *)commentTextBorderView{
    if(!_commentTextBorderView){
        _commentTextBorderView = [[UIView alloc] init];
        _commentTextBorderView.backgroundColor = COLOR_W;
        _commentTextBorderView.layer.cornerRadius = 4;
        _commentTextBorderView.layer.borderColor = COLOR_H4.CGColor;
        _commentTextBorderView.layer.borderWidth = 1;
        [self.commentView addSubview:_commentTextBorderView];
    }
    return _commentTextBorderView;
}

-(UITextField *)commentTextField{
    if(!_commentTextField){
        _commentTextField = [[UITextField alloc] init];
        _commentTextField.placeholder = @"说点什么吧...";
        _commentTextField.font = FONT_L;
        _commentTextField.layer.cornerRadius = 4;
        _commentTextField.layer.borderColor = COLOR_H4.CGColor;
        [self.commentTextBorderView addSubview:_commentTextField];

    }
    return _commentTextField;
}

-(UIButton *)commentButton{
    if(!_commentButton){
        _commentButton = [[UIButton alloc] init];
        [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
        [_commentButton setBackgroundColor:COLOR_M];
        _commentButton.titleLabel.font = FONT_L;
        [_commentButton setTitleColor:COLOR_W forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _commentButton.layer.cornerRadius = 4;
        _commentButton.clipsToBounds = YES;
        [self.commentView addSubview:_commentButton];
    }
    return _commentButton;
}

@end
