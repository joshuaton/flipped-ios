//
//  FLCommentCell.m
//  Flipped
//
//  Created by ShaoJun on 2017/8/1.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLCommentCell.h"
#import "Masonry.h"
#import "FLCommHeader.h"

@interface FLCommentCell()

@property (nonatomic, strong) UILabel *uidLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *floorNumLabel;

@end

@implementation FLCommentCell

-(void)refreshWithData:(FLComment *)data{
    
    self.uidLabel.text = [NSString stringWithFormat:@"来自%@", data.uid];
    NSArray<FLContent> *contents = data.contents;
    
    for(int i=0; i<contents.count; i++){
        FLContent *content = data.contents[i];
        if([content.type isEqualToString:@"text"]){
            self.contentLabel.text = content.text;
            break;
        }
    }
    
    self.floorNumLabel.text = [NSString stringWithFormat:@"%ld楼", (long)data.floor];
    
    [self makeConstraints];
}

-(void)makeConstraints{
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@10);
        make.right.equalTo(@10);
    }];
    
    [self.uidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
        make.left.equalTo(self.contentLabel);
        make.right.equalTo(self.contentLabel);
        make.bottom.equalTo(@-10);
    }];
    
    [self.floorNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.uidLabel);
        make.bottom.equalTo(self.uidLabel);
        make.right.equalTo(@-10);
    }];
}

-(UILabel *)uidLabel{
    if(!_uidLabel){
        _uidLabel = [[UILabel alloc] init];
        _uidLabel.textColor = COLOR_H2;
        _uidLabel.font = FONT_S;
        [self.contentView addSubview:_uidLabel];
    }
    return _uidLabel;
}

-(UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = COLOR_H1;
        _contentLabel.font = FONT_M;
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

-(UILabel *)floorNumLabel{
    if(!_floorNumLabel){
        _floorNumLabel = [[UILabel alloc] init];
        _floorNumLabel.textColor = COLOR_H2;
        _floorNumLabel.font = FONT_S;
        [self.contentView addSubview:_floorNumLabel];
    }
    return _floorNumLabel;
}

@end
