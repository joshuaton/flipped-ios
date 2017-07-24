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

@interface FLFlippedDetailViewController() <MWPhotoBrowserDelegate>

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *sendLabel;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation FLFlippedDetailViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"详情";
    [self configRightNavigationItemWithTitle:@"举报" image:nil action:@selector(reportBtnClick)];

    [self makeConstraints];
    
    [FLFlippedWordsService getFlippedWordsDetailWithId:self.flippedId successBlock:^(FLFlippedWord *data) {
        
        [self showData:data];
    } failBlock:^(NSError *error) {
        NSLog(@"get detail error");

    }];
}

-(void)makeConstraints{
    
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
        make.height.equalTo(@250);
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

-(void)reportBtnClick{
    [FLToast showToast:@"举报内容已收到，会尽快处理"];
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

#pragma mark - getter & setter

-(UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = FONT_L;
        _contentLabel.textColor = COLOR_H1;
        _contentLabel.numberOfLines = 0;
        [self.view addSubview:_contentLabel];
    }
    return _contentLabel;
}

-(UILabel *)sendLabel{
    if(!_sendLabel){
        _sendLabel = [[UILabel alloc] init];
        _sendLabel.font = FONT_M;
        _sendLabel.textColor = COLOR_H2;
        [self.view addSubview:_sendLabel];
    }
    return _sendLabel;
}

-(UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick)];
        [_imageView addGestureRecognizer:tap];
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

@end
