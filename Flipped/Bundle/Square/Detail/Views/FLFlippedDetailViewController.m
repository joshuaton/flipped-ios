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
@property (nonatomic, strong) NSArray *comments;

@end

@implementation FLFlippedDetailViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"详情";
    [self configRightNavigationItemWithTitle:nil image:[UIImage imageNamed:@"flipped_detail_more"] action:@selector(moreBtnClick)];

    [self makeConstraints];
    
    [FLFlippedWordsService getFlippedWordsDetailWithId:self.flippedId successBlock:^(FLFlippedWord *data) {
        
        self.data = data;
        [self showData:data];
    } failBlock:^(NSError *error) {
        NSLog(@"get detail error");

    }];
    
    [FLFlippedWordsService getCommentsWithId:self.flippedId successBlock:^(NSArray *comments) {
        
        self.comments = comments;
    } failBlock:^(NSError *error) {
        
    }];
}

-(void)makeConstraints{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.superview);
        make.left.equalTo(self.tableView.superview);
        make.bottom.equalTo(self.tableView.superview);
        make.right.equalTo(self.tableView.superview);
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    
    
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.superview).offset(64+10);
        make.left.equalTo(self.contentLabel.superview).offset(10);
        make.right.equalTo(self.contentLabel.superview).offset(-10);
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
    }];
    
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentView.superview);
        make.bottom.equalTo(self.commentView.superview);
        make.right.equalTo(self.commentView.superview);
        make.height.equalTo(@45);
    }];
    
    [self.commentLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentLineView.superview);
        make.left.equalTo(self.commentLineView.superview);
        make.right.equalTo(self.commentLineView.superview);
        make.height.equalTo(@1);
    }];
    
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentLineView.mas_bottom).offset(5);
        make.bottom.equalTo(self.commentButton.superview).offset(-5);
        make.right.equalTo(self.commentButton.superview).offset(-10);
        make.width.equalTo(@65);
    }];
    
    [self.commentTextBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentButton);
        make.left.equalTo(self.commentTextBorderView.superview).offset(10);
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
    
}

#pragma mark - action

-(void)moreBtnClick{
    
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
    
    [FLFlippedWordsService commentFlippedWordWithId:self.data.id content:contentStr successBlock:^{
        
    } failBlock:^(NSError *error) {
        
    }];
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
        _commentTextField.placeholder = @"看到这条心动话，您有什么感想...";
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
