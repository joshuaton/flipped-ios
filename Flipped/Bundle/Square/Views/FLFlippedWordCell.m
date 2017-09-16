//
//  FLFlippedWordCell.m
//  Flipped
//
//  Created by ShaoJun on 2017/7/9.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLFlippedWordCell.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "FLStringUtils.h"
#import "FLFlippedListViewController.h"
#import "FLCopyLabel.h"

@interface FLFlippedWordCell()

@property (nonatomic, strong) FLCopyLabel *contentLabel;
@property (nonatomic, strong) UILabel *sendLabel;
@property (nonatomic, strong) UIView *lineView1;
@property (nonatomic, strong) UILabel *commentNumLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UIImageView *picImageView;

@end

@implementation FLFlippedWordCell

-(void)refreshWithData:(FLFlippedWord *)data{
    
    NSString *textContent = @"";
    for(int i=0; i<data.contents.count; i++){
        FLContent *content = data.contents[i];
        if([content.type isEqualToString:@"text"]){
            textContent = content.text;
        }
    }
    self.contentLabel.text = textContent;
    [UILabel changeLineSpaceForLabel:self.contentLabel WithSpace:4.0];
    self.sendLabel.text = [NSString stringWithFormat:@"发送给:%@", data.sendto];
    self.commentNumLabel.text = [NSString stringWithFormat:@"%ld条评论", data.commentnum];
    
    self.lineView.hidden = YES;
    self.backgroundColor = COLOR_W;
    
    if(self.type == FLFlippedListTypeSend){
        
        self.lineView.hidden = NO;
        
        NSString *statusStr = @"";
        NSInteger status = [data.status integerValue];
        if (status == 0 || status == 100){
            statusStr = @"对方未读";
        } else if (status == 200){
            statusStr = @"对方已读";
        }
        self.statusLabel.text = statusStr;

    }else if(self.type == FLFlippedListTypeReceive){

        NSString *statusStr = @"";
        NSInteger status = [data.status integerValue];
        if (status == 0 ){
            self.lineView.hidden = NO;
            statusStr = @"新收到的";
            self.backgroundColor = [UIColor colorWithHexString:@"ffac38"];
        }
        self.statusLabel.text = statusStr;

    }
    
    self.picImageView.hidden = YES;
    for(int i=0; i<data.contents.count; i++){
        FLContent *content = data.contents[i];
        if([content.type isEqualToString:@"picture"]){
            self.picImageView.hidden = NO;
            break;
        }
    }
    
    
    
    [self makeConstraints];
}

-(void)makeConstraints{
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.superview).offset(10);
        make.left.equalTo(self.contentLabel.superview).offset(10);
        make.right.equalTo(self.contentLabel.superview).offset(-10);
    }];
    
    [self.sendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.left.equalTo(self.sendLabel.superview).offset(10);
        make.bottom.lessThanOrEqualTo(self.sendLabel.superview).offset(-10);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sendLabel);
        make.left.equalTo(self.sendLabel.mas_right).offset(5);
        make.bottom.equalTo(self.sendLabel);
        make.width.equalTo(@1);
    }];
    
    [self.commentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView1);
        make.left.equalTo(self.lineView1.mas_right).offset(5);
        make.bottom.equalTo(self.lineView1);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentNumLabel);
        make.left.equalTo(self.commentNumLabel.mas_right).offset(5);
        make.bottom.equalTo(self.commentNumLabel);
        make.width.equalTo(@1);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView);
        make.left.equalTo(self.lineView.mas_right).offset(5);
        make.bottom.equalTo(self.lineView);
    }];
    
    [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.statusLabel);
        make.right.equalTo(self.picImageView.superview).offset(-10);
    }];
}

#pragma mark - getter & setter

-(FLCopyLabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[FLCopyLabel alloc] init];
        _contentLabel.numberOfLines = 5;
        _contentLabel.font = FONT_L;
        _contentLabel.textColor = COLOR_H1;
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

-(UILabel *)sendLabel{
    if(!_sendLabel){
        _sendLabel = [[UILabel alloc] init];
        _sendLabel.font = FONT_M;
        _sendLabel.textColor = COLOR_H2;
        [self.contentView addSubview:_sendLabel];
    }
    return _sendLabel;
}

-(UIView *)lineView1{
    if(!_lineView1){
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = COLOR_H4;
        [self.contentView addSubview:_lineView1];
    }
    return _lineView1;
}

-(UILabel *)commentNumLabel{
    if(!_commentNumLabel){
        _commentNumLabel = [[UILabel alloc] init];
        _commentNumLabel.font = FONT_M;
        _commentNumLabel.textColor = COLOR_H2;
        [self.contentView addSubview:_commentNumLabel];
    }
    return _commentNumLabel;
}

-(UILabel *)statusLabel{
    if(!_statusLabel){
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = FONT_M;
        _statusLabel.textColor = COLOR_H2;
        [self.contentView addSubview:_statusLabel];
    }
    return _statusLabel;
}

-(UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLOR_H4;
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}

-(UILabel *)distanceLabel{
    if(!_distanceLabel){
        _distanceLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_distanceLabel];
    }
    return _distanceLabel;
}

-(UIImageView *)picImageView{
    if(!_picImageView){
        _picImageView = [[UIImageView alloc] init];
        _picImageView.image = [UIImage imageNamed:@"flipped_content_pic"];
        [self.contentView addSubview:_picImageView];
    }
    return _picImageView;
}

@end
