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
#import "FLCommHeader.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "FLStringUtils.h"
#import "FLFlippedListViewController.h"

@interface FLFlippedWordCell()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *sendLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIView *lineView;
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
    self.sendLabel.text = [NSString stringWithFormat:@"发送给：%@", data.sendto];
    
    self.lineView.hidden = YES;
    
    if(self.type == FLFlippedListTypeSend){
        self.lineView.hidden = NO;
        
        NSString *statusStr = @"";
        if (data.status == 0 || data.status == 100){
            statusStr = @"对方未读";
        } else if (data.status == 200){
            statusStr = @"对方已读";
        }
        
        self.statusLabel.text = statusStr;


    }
//    if(!data.distance){
//        data.distance = [NSNumber numberWithInt:0];
//    }
//    self.distanceLabel.text = [NSString stringWithFormat:@"距离：%@m", data.distance];
    
    self.picImageView.hidden = YES;
    [self updateConstraints:NO];
    for(int i=0; i<data.contents.count; i++){
        FLContent *content = data.contents[i];
        if([content.type isEqualToString:@"picture"]){
            self.picImageView.hidden = NO;
            [self updateConstraints:YES];
            
            content.text = [FLStringUtils convertToHttpsWithUrl:content.text];

            [self.picImageView sd_setImageWithURL:[NSURL URLWithString:content.text] placeholderImage:[UIImage imageNamed:@"flipped_pic_default"]];
            continue;
        }
    }
    
    [self makeConstraints];
}

-(void)makeConstraints{
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.superview).offset(10);
        make.left.equalTo(self.contentLabel.superview).offset(10);
    }];
    
    [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel);
        make.left.equalTo(self.contentLabel.mas_right).offset(10);
        make.bottom.lessThanOrEqualTo(self.picImageView.superview).offset(-10);
        make.right.equalTo(self.picImageView.superview).offset(-10);
    }];
    
    [self.sendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.left.equalTo(self.sendLabel.superview).offset(10);
        make.bottom.lessThanOrEqualTo(self.sendLabel.superview).offset(-10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sendLabel);
        make.left.equalTo(self.sendLabel.mas_right).offset(5);
        make.bottom.equalTo(self.sendLabel);
        make.width.equalTo(@1);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView);
        make.left.equalTo(self.lineView.mas_right).offset(5);
        make.bottom.equalTo(self.lineView);
    }];
    
    
}

-(void)updateConstraints:(BOOL)hasImage{
    if(hasImage){
        
        [self.picImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(100*SCREEN_SCALE_WIDTH));
            make.height.equalTo(@(100*SCREEN_SCALE_WIDTH));
        }];
    }else{
        
        [self.picImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(0));
            make.height.equalTo(@(0));
        }];
    }
}

#pragma mark - getter & setter

-(UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
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
        _picImageView.contentMode = UIViewContentModeScaleAspectFill;
        _picImageView.clipsToBounds = YES;
        [self.contentView addSubview:_picImageView];
    }
    return _picImageView;
}

@end
