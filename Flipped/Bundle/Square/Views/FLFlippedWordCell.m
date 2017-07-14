//
//  FLFlippedWordCell.m
//  Flipped
//
//  Created by ShaoJun on 2017/7/9.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLFlippedWordCell.h"
#import "Masonry.h"

@interface FLFlippedWordCell()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *sendLabel;
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
    self.sendLabel.text = [NSString stringWithFormat:@"发送给：%@", data.sendto];
    
    if(!data.distance){
        data.distance = [NSNumber numberWithInt:0];
    }
    self.distanceLabel.text = [NSString stringWithFormat:@"距离：%@m", data.distance];
    
    self.picImageView.hidden = YES;
    for(int i=0; i<data.contents.count; i++){
        FLContent *content = data.contents[i];
        if([content.type isEqualToString:@"picture"]){
            self.picImageView.hidden = NO;
            continue;
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
        make.bottom.equalTo(self.sendLabel.superview).offset(-10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sendLabel);
        make.left.equalTo(self.sendLabel.mas_right).offset(5);
        make.bottom.equalTo(self.sendLabel);
        make.width.equalTo(@1);
    }];
    
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView);
        make.left.equalTo(self.lineView.mas_right).offset(5);
        make.bottom.equalTo(self.lineView);
    }];
    
    [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.distanceLabel);
        make.right.equalTo(self.picImageView.superview).offset(-10);
    }];
}

#pragma mark - getter & setter

-(UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

-(UILabel *)sendLabel{
    if(!_sendLabel){
        _sendLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_sendLabel];
    }
    return _sendLabel;
}

-(UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor blackColor];
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
        [_picImageView sizeToFit];
        [self.contentView addSubview:_picImageView];
    }
    return _picImageView;
}

@end
