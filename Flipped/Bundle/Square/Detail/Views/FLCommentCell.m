//
//  FLCommentCell.m
//  Flipped
//
//  Created by ShaoJun on 2017/8/1.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLCommentCell.h"
#import "Masonry.h"

@interface FLCommentCell()

@property (nonatomic, strong) UILabel *uidLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation FLCommentCell

-(void)refreshWithData:(FLComment *)data{
    
    self.uidLabel.text = data.uid;
    NSArray<FLContent> *contents = data.contents;
    
    for(int i=0; i<contents.count; i++){
        FLContent *content = data.contents[i];
        if([content.type isEqualToString:@"text"]){
            self.contentLabel.text = content.text;
            break;
        }
    }
    
    [self makeConstraints];
}

-(void)makeConstraints{
    
    [self.uidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.uidLabel).offset(10);
        make.left.equalTo(self.uidLabel).offset(10);
        make.right.equalTo(self.uidLabel).offset(-10);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.uidLabel.mas_bottom).offset(10);
        make.left.equalTo(self.uidLabel);
        make.right.equalTo(self.uidLabel);
    }];
}

-(UILabel *)uidLabel{
    if(!_uidLabel){
        _uidLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_uidLabel];
    }
    return _uidLabel;
}

-(UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

@end
