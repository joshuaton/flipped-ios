//
//  CPShareView.m
//  CampusX
//
//  Created by jocentzhou on 2017/4/9.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "CPShareView.h"
#import "CPShareEntity.h"
#import "CPShareManager.h"
#import "CPShareViewCell.h"
#import "FLToast.h"

#define CANCEL_HEIGHT   50.0
#define ANIMATION_TIME  0.2
#define MAX_DESC_LENGTH 50.0

@interface CPShareView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView* shareView; //包括取消按钮在内的图层
@property (nonatomic, strong) UICollectionView *shareCollectionView;
@property (nonatomic, strong) UIView *line1View;
@property (nonatomic, strong) UICollectionView *operCollectionView;
@property (nonatomic, strong) UIView *line2View;
@property (nonatomic, strong) UIButton* cancelButton;

@end

@implementation CPShareView

static CPShareView* current = nil;
+ (CPShareView *)sharedInstance {
    if (!current) {
        current = [[self alloc] init];
    }
    
    return current;
}


- (id) init {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        self.windowLevel = UIWindowLevelAlert - 1;
        self.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.5];
        self.alpha = 0;
        
    }
    return self;
}


- (void) setupUI {
    
    CGFloat shareCollectionViewHeight = 0;
    CGFloat line1Height = 0;
    if(self.shareBtnTypes.count > 0){
        shareCollectionViewHeight = CELL_HEIGHT;
        line1Height = 1;
    }
    self.shareCollectionView.frame = CGRectMake(0, 0, self.frame.size.width, shareCollectionViewHeight);
    self.line1View.frame = CGRectMake(0, CGRectGetMaxY(self.shareCollectionView.frame), self.frame.size.width, line1Height);
    CGFloat operCollectionViewHeight = 0;
    CGFloat line2Height = 0;
    if(self.operBtnTypes.count > 0){
        operCollectionViewHeight = CELL_HEIGHT;
        line2Height = 1;
    }
    self.operCollectionView.frame = CGRectMake(0, CGRectGetMaxY(self.line1View.frame), self.frame.size.width, operCollectionViewHeight);
    self.line2View.frame = CGRectMake(0, CGRectGetMaxY(self.operCollectionView.frame), self.frame.size.width, line2Height);
    self.cancelButton.frame = CGRectMake(0, CGRectGetMaxY(self.line2View.frame), self.frame.size.width, CANCEL_HEIGHT);
    
    CGFloat shareViewHeight = CGRectGetMaxY(self.cancelButton.frame);
    
    self.shareView.frame = CGRectMake(0, SCREEN_HEIGHT, self.frame.size.width, shareViewHeight);
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        self.shareView.frame = CGRectMake(0, SCREEN_HEIGHT-shareViewHeight, self.frame.size.width, shareViewHeight);
    }];
    
    
    
    
}

#pragma mark - private
- (void)share:(NSInteger )type {
    
    if(type == ShareButtonTypeWXFriend || type == ShareButtonTypeWXTimeline){
        if(![CPShareManager isWXAppInstalled]){
            [FLToast showToast:@"未安装微信"];
            
            return;
        }
    }
    
    CPShareEntity *model = [[CPShareEntity alloc] init];
    model.title = self.shareTitle;
    model.desc = self.shareDesc;
    model.contentUrl = self.shareUrl;
    if(self.previewImageUrl){
        model.previewImageUrl = self.previewImageUrl;
    }
    
    if (model.desc.length > MAX_DESC_LENGTH) {
        model.desc = [model.desc substringToIndex:MAX_DESC_LENGTH];
    }
    
    SharePlat plat = WXSession;
    if (type == ShareButtonTypeWXFriend) {
        plat = WXSession;
    }else if (type == ShareButtonTypeWXTimeline) {
        plat = WXTimeline;
    }else if (type == ShareButtonTypeQQZone) {
        plat = QQZone;
    }else if (type == ShareButtonTypeQQFriend) {
        plat = QQSession;
    }
    
    [[CPShareManager shareInstance] share:model toPlat:plat shareCompletionBlock:^(NSInteger resultCode, CPShareEntity *model) {
        if(resultCode == 1) return ;
        [FLToast showToast:resultCode == 0?@"分享成功":@"分享失败"];
    }];
    
    [self dismiss];
}

#pragma mark - action




- (void) show {
    [self setupUI];
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [[[self class] sharedInstance] makeKeyAndVisible];
    [window makeKeyWindow];
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        current.alpha = 1.0;
    }];
}

- (void) dismiss {
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        current.alpha = 0.0;
    } completion:^(BOOL finished) {
        current = nil;
    }];
}

#pragma mark - collectionview delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if(collectionView == self.shareCollectionView){
        return self.shareBtnTypes.count;
    }else if(collectionView == self.operCollectionView){
        return self.operBtnTypes.count;
    }
    
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger type = 0;
    if(collectionView == self.shareCollectionView){
        type = [[self.shareBtnTypes objectAtIndex:indexPath.item] integerValue];
    }else if(collectionView == self.operCollectionView){
        type = [[self.operBtnTypes objectAtIndex:indexPath.item] integerValue];
    }
    
    CPShareViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CPShareViewCell_ReuseId forIndexPath:indexPath];
    cell.type = type;
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(IMAGE_WIDTH + SPACE_WIDTH, CELL_HEIGHT);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//cell的最小列间
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger type = 0;
    
    if(collectionView == self.shareCollectionView){
        type = [[self.shareBtnTypes objectAtIndex:indexPath.item] integerValue];
    }else if(collectionView == self.operCollectionView){
        type = [[self.operBtnTypes objectAtIndex:indexPath.item] integerValue];
    }
 
    if(type == ShareButtonTypeQQFriend || type == ShareButtonTypeQQZone || type == ShareButtonTypeWXTimeline || type == ShareButtonTypeWXFriend){
        [self share:type];
    }else{
        if(self.btnClickBlock){
            self.btnClickBlock(type);
        }
        [self dismiss];
    }
    
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, SPACE_WIDTH/2, 0, SPACE_WIDTH/2);
}

#pragma mark - getter & setter

-(UIView *)shareView{
    if(!_shareView){
        _shareView = [[UIView alloc] init];
        _shareView.backgroundColor = COLOR_H5;
        [self addSubview:_shareView];
    }
    return _shareView;
}

-(UICollectionView *)shareCollectionView{
    if(!_shareCollectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _shareCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _shareCollectionView.delegate = self;
        _shareCollectionView.dataSource = self;
        _shareCollectionView.backgroundColor = COLOR_H5;
        [_shareCollectionView registerClass:[CPShareViewCell class] forCellWithReuseIdentifier:CPShareViewCell_ReuseId];
        [self.shareView addSubview:_shareCollectionView];
    }
    return _shareCollectionView;
}

-(UICollectionView *)operCollectionView{
    if(!_operCollectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _operCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _operCollectionView.delegate = self;
        _operCollectionView.dataSource = self;
        _operCollectionView.backgroundColor = COLOR_H5;
        [_operCollectionView registerClass:[CPShareViewCell class] forCellWithReuseIdentifier:CPShareViewCell_ReuseId];
        [self.shareView addSubview:_operCollectionView];
    }
    return _operCollectionView;
}

-(UIView *)line1View{
    if(!_line1View){
        _line1View = [[UIView alloc] init];
        _line1View.backgroundColor = COLOR_H4;
        [self.shareView addSubview:_line1View];
    }
    return _line1View;
}

-(UIView *)line2View{
    if(!_line2View){
        _line2View = [[UIView alloc] init];
        _line2View.backgroundColor = COLOR_H4;
        [self.shareView addSubview:_line2View];
    }
    return _line2View;
}

-(UIButton *)cancelButton{
    if(!_cancelButton){
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.backgroundColor = COLOR_H6;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:COLOR_H1 forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = FONT_L;
        [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.shareView addSubview:_cancelButton];
    }
    return _cancelButton;
}


@end
