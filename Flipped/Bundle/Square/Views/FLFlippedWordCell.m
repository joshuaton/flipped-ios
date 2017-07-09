//
//  FLFlippedWordCell.m
//  Flipped
//
//  Created by ShaoJun on 2017/7/9.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLFlippedWordCell.h"

@interface FLFlippedWordCell()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *sendLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UIImageView *soundImageView;
@property (nonatomic, strong) UIImageView *picImageView;

@end

@implementation FLFlippedWordCell

#pragma mark - getter & setter

-(UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
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

-(UILabel *)distanceLabel{
    if(!_distanceLabel){
        _distanceLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_distanceLabel];
    }
    return _distanceLabel;
}

-(UIImageView *)videoImageView{
    if(!_videoImageView){
        _videoImageView = [[UIImageView alloc] init];
        _videoImageView.image = [UIImage imageNamed:@"flipped_content_video"];
        [self.contentView addSubview:_videoImageView];
    }
    return _videoImageView;
}

-(UIImageView *)soundImageView{
    if(!_soundImageView){
        _soundImageView = [[UIImageView alloc] init];
        _videoImageView.image = [UIImage imageNamed:@"flipped_content_sound"];
        [self.contentView addSubview:_soundImageView];
    }
    return _soundImageView;
}

-(UIImageView *)picImageView{
    if(!_picImageView){
        _picImageView = [[UIImageView alloc] init];
        _videoImageView.image = [UIImage imageNamed:@"flipped_content_pic"];
        [self.contentView addSubview:_picImageView];
    }
    return _picImageView;
}

@end
