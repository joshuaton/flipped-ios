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
@property (nonatomic, strong) UIButton *sendtoButton;
@property (nonatomic, strong) UIButton *commentNumButton;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *distanceButton;
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
    [self.sendtoButton setTitle:data.sendto forState:UIControlStateNormal];
    [self.commentNumButton setTitle:[NSString stringWithFormat:@"%ld", (long)data.commentnum] forState:UIControlStateNormal];
    
    //发送的显示已读未读statusLabel
    if(self.type == FLFlippedListTypeSend){
        self.distanceButton.hidden = YES;
        self.statusLabel.hidden = NO;
    }
    //其余的显示距离
    else{
        self.distanceButton.hidden = NO;
        self.statusLabel.hidden = YES;
        
        if(data.distance == nil){
            self.distanceButton.hidden = YES;
        }else{
            
            self.distanceButton.hidden = NO;
            NSInteger distance = [data.distance integerValue];
            if(distance > 0){
                
                NSString *distanceStr = @"";
                if(distance >= 1000){
                    distanceStr = [NSString stringWithFormat:@"%.2fkm", distance/1000.0];
                }else{
                    distanceStr = [NSString stringWithFormat:@"%ldm", (long)distance];
                }
                [self.distanceButton setTitle:distanceStr forState:UIControlStateNormal];
            }else if(distance == 0){
                [self.distanceButton setTitle:@"就在您身边" forState:UIControlStateNormal];
            }
        }
        
        
    }
    
    self.backgroundColor = COLOR_W;
    
    if(self.type == FLFlippedListTypeSend){
        
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
    
    [self.sendtoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.left.equalTo(self.sendtoButton.superview).offset(10);
        make.bottom.lessThanOrEqualTo(self.sendtoButton.superview).offset(-10);
    }];
    
    [self.commentNumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sendtoButton);
        make.left.equalTo(self.sendtoButton.mas_right).offset(10);
        make.bottom.equalTo(self.sendtoButton);
    }];
    
    [self.distanceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentNumButton);
        make.left.equalTo(self.commentNumButton.mas_right).offset(10);
        make.bottom.equalTo(self.commentNumButton);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentNumButton);
        make.left.equalTo(self.commentNumButton.mas_right).offset(10);
        make.bottom.equalTo(self.commentNumButton);
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

-(UIButton *)sendtoButton{
    if(!_sendtoButton){
        _sendtoButton = [[UIButton alloc] init];
        _sendtoButton.userInteractionEnabled = NO;
        _sendtoButton.titleLabel.font = FONT_M;
        [_sendtoButton setTitleColor:COLOR_H2 forState:UIControlStateNormal];
        [_sendtoButton setImage:[UIImage imageNamed:@"flipped_sendto_icon"] forState:UIControlStateNormal];
        [self.contentView addSubview:_sendtoButton];
    }
    return _sendtoButton;
}

-(UIButton *)commentNumButton{
    if(!_commentNumButton){
        _commentNumButton = [[UIButton alloc] init];
        _commentNumButton.userInteractionEnabled = NO;
        [_commentNumButton setImage:[UIImage imageNamed:@"flipped_comment_num_icon"] forState:UIControlStateNormal];
        _commentNumButton.titleLabel.font = FONT_M;
        [_commentNumButton setTitleColor:COLOR_H2 forState:UIControlStateNormal];
        [self.contentView addSubview:_commentNumButton];
    }
    return _commentNumButton;
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

-(UIButton *)distanceButton{
    if(!_distanceButton){
        _distanceButton = [[UIButton alloc] init];
        _distanceButton.userInteractionEnabled = NO;
        [_distanceButton setImage:[UIImage imageNamed:@"flipped_distance_icon"] forState:UIControlStateNormal];
        _distanceButton.titleLabel.font = FONT_M;
        [_distanceButton setTitleColor:COLOR_H2 forState:UIControlStateNormal];
        [self.contentView addSubview:_distanceButton];
    }
    return _distanceButton;
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
