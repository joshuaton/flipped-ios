//
//  CPShareViewCell.m
//  CampusX
//
//  Created by junshao on 2017/5/5.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "CPShareViewCell.h"
#import "CPShareView.h"

@interface CPShareViewCell()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation CPShareViewCell

-(void)setupView{
 
    switch (self.type) {
        case ShareButtonTypeWXFriend:
            self.imageView.image = [UIImage imageNamed:@"CPDiscovery_sharem_wx"];
            self.label.text = @"微信好友";
            break;
        case ShareButtonTypeWXTimeline:
            self.imageView.image = [UIImage imageNamed:@"CPDiscovery_sharem_friends_network"];
            self.label.text = @"微信朋友圈";
            break;
        case ShareButtonTypeQQFriend:
            self.imageView.image = [UIImage imageNamed:@"CPDiscovery_sharem_qq"];
            self.label.text = @"QQ好友";
            break;
        case ShareButtonTypeQQZone:
            self.imageView.image = [UIImage imageNamed:@"CPDiscovery_sharem_zone"];
            self.label.text = @"QQ空间";
            break;
        case ShareButtonTypeMineTweet:
            self.imageView.image = [UIImage imageNamed:@"CPDiscovery_sharem_tweet"];
            self.label.text = @"我的动态";
            break;
        case ShareButtonTypeTeamTweet:
            self.imageView.image = [UIImage imageNamed:@"CPDiscovery_sharem_team"];
            self.label.text = @"社团动态";
            break;
        case OperButtonTypeSetting:
            self.imageView.image = [UIImage imageNamed:@"CPDiscovery_sharem_team_info"];
            self.label.text = @"社团资料";
            break;
        case OperButtonTypeReport:
            self.imageView.image = [UIImage imageNamed:@"CPDiscovery_sharem_report"];
            self.label.text = @"举报";
            break;
        case OperButtonTypeEdit:
            self.imageView.image = [UIImage imageNamed:@"CPDiscovery_sharem_edit"];
            self.label.text = @"编辑";
            break;
        case OperButtonTypeDelete:
            self.imageView.image = [UIImage imageNamed:@"CPDiscovery_sharem_delete"];
            self.label.text = @"删除";
            break;
        case OperButtonTypeFollow:
            self.imageView.image = [UIImage imageNamed:@"CPDiscovery_sharem_follow"];
            self.label.text = @"关注";
            break;
        case OperButtonTypeCancelFollow:
            self.imageView.image = [UIImage imageNamed:@"CPDiscovery_sharem_cancel_follow"];
            self.label.text = @"取消关注";
            break;
        default:
            break;
    }
    [self.label sizeToFit];
    
    self.imageView.frame = CGRectMake(SPACE_WIDTH/2, 27, IMAGE_WIDTH, IMAGE_WIDTH);
    self.label.frame = CGRectMake(self.imageView.center.x-self.label.frame.size.width/2, CGRectGetMaxY(self.imageView.frame)+7, self.label.frame.size.width, self.label.frame.size.height);
}

-(void)setType:(NSInteger)type{
    _type = type;
    
    [self setupView];
}

-(UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    return _imageView;
}

-(UILabel *)label{
    if(!_label){
        _label = [[UILabel alloc] init];
        _label.font = FONT_M;
        _label.textColor = COLOR_H2;
        [self addSubview:_label];
    }
    return _label;
}

@end
