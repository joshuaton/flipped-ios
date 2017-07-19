//
//  FLPostViewController.m
//  Flipped
//
//  Created by junshao on 2017/7/4.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLPostViewController.h"
#import "Masonry.h"
#import "FLCommHeader.h"
#import "FLFlippedWord.h"
#import "FLFlippedWordsService.h"
#import "FLToast.h"
#import "FLCloudService.h"
#import "FLCommHeader.h"

@interface FLPostViewController() <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UILabel *phoneNumLabel;
@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UIView *addPicView;
@property (nonatomic, strong) UIImageView *addPicImageView;
@property (nonatomic, strong) UILabel *addPicLabel;
@property (nonatomic, strong) UIImageView *selectedImageView;

@end

@implementation FLPostViewController

-(void)viewDidLoad{
    [super viewDidLoad];

    self.title = @"发布动心话";
    [self configRightNavigationItemWithTitle:@"发布" image:nil action:@selector(postBtnDidClick)];
    [self configLeftNavigationItemWithTitle:@"关闭" image:nil action:@selector(closeBtnDidClick)];
    
    self.selectedImageView.hidden = YES;
    
    [self makeConstraints];
    

}

-(void)makeConstraints{
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLabel.superview).offset(64+20);
        make.centerX.equalTo(self.tipsLabel.superview);
    }];
    
    [self.phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(20);
        make.left.equalTo(self.phoneNumLabel.superview).offset(10);
        make.right.equalTo(self.phoneNumLabel.superview).offset(-10);
    }];
    
    [self.phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumLabel.mas_bottom).offset(5);
        make.left.equalTo(self.phoneNumTextField.superview).offset(10);
        make.right.equalTo(self.phoneNumTextField.superview).offset(-10);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumTextField.mas_bottom).offset(10);
        make.left.equalTo(self.phoneNumTextField);
        make.right.equalTo(self.phoneNumTextField);
    }];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
        make.left.equalTo(self.contentLabel);
        make.right.equalTo(self.contentLabel);
        make.height.equalTo(@100);
    }];
    
    [self.addPicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTextView.mas_bottom).offset(10);
        make.left.equalTo(self.contentTextView);
        make.right.equalTo(self.contentTextView);
        make.height.equalTo(@200);
    }];
    
    [self.addPicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addPicImageView.superview);
        make.centerX.equalTo(self.addPicImageView.superview);
    }];
    
    [self.addPicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addPicImageView.mas_bottom);
        make.centerX.equalTo(self.addPicImageView.mas_centerX);
    }];
    
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTextView.mas_bottom).offset(10);
        make.left.equalTo(self.contentTextView);
        make.bottom.equalTo(self.selectedImageView.superview);
        make.right.equalTo(self.contentTextView);
    }];
}

#pragma mark - action

-(void)postBtnDidClick{
    
    NSString *phoneNum = self.phoneNumTextField.text;
    NSString *contentStr = self.contentTextView.text;
    contentStr = [contentStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(!contentStr || contentStr.length == 0){
        [FLToast showToast:@"内容不能为空"];
        return;
    }
    
    FLFlippedWord *data = [[FLFlippedWord alloc] init];
    data.sendto = phoneNum;
    
    FLContent *content = [[FLContent alloc] init];
    content.type = @"text";
    content.text = contentStr;
    
    NSMutableArray<FLContent> *contentArr = [[NSMutableArray<FLContent> alloc] init];
    [contentArr addObject:content];
    data.contents = contentArr;
    
    if(self.selectedImageView.image){
        
        [FLToast showLoading:@"发表中..."];
        
        [FLCloudService uploadImage:self.selectedImageView.image withSuccessBlock:^(NSString *url) {
            
            FLContent *picContent = [[FLContent alloc] init];
            picContent.type = @"picture";
            picContent.text = url;
            [contentArr addObject:picContent];
            
            [FLFlippedWordsService publishFlippedWordsWithData:data successBlock:^{
                [self publishSuccess];
            } failBlock:^(NSError *error) {
                NSLog(@"publish error : %@", error);
                [FLToast hideLoading];
            }];
        } failBlock:^(NSError *error) {
            [FLToast hideLoading];
        }];
       
    }else{
        
        [FLFlippedWordsService publishFlippedWordsWithData:data successBlock:^{
            [self publishSuccess];
        } failBlock:^(NSError *error) {
            NSLog(@"publish error : %@", error);
            [FLToast hideLoading];
        }];
    }
    
}

-(void)closeBtnDidClick{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)addPicClick{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            [FLToast showToast:@"不支持拍照"];
            return;
        }
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }];
    
    UIAlertAction *selectPhotoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
            [FLToast showToast:@"不支持读取相册"];
            return;
        }
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:takePhotoAction];
    [alertController addAction:selectPhotoAction];
    [alertController addAction:cancelAction];
    
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)selectedImageClick{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否删除图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *deletePhotoAction = [UIAlertAction actionWithTitle:@"删除图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        self.selectedImageView.image = nil;
        self.selectedImageView.hidden = YES;
        self.addPicView.hidden = NO;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:deletePhotoAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

#pragma mark - private

-(void)showImage:(UIImage *)image{
    
    self.selectedImageView.hidden = NO;
    self.addPicView.hidden = YES;
    
    self.selectedImageView.image = image;
}

-(void)publishSuccess{
    
    [FLToast hideLoading];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_POST_SUCCESS object:self userInfo:nil];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self showImage:image];
    NSLog(@"did select image");
}



#pragma mark - getter & setter

-(UILabel *)tipsLabel{
    if(!_tipsLabel){
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"对Ta说出心动的话";
        [self.view addSubview:_tipsLabel];
    }
    return _tipsLabel;
}

-(UILabel *)phoneNumLabel{
    if(!_phoneNumLabel){
        _phoneNumLabel = [[UILabel alloc] init];
        _phoneNumLabel.text = @"输入Ta的手机";
        [self.view addSubview:_phoneNumLabel];
    }
    return _phoneNumLabel;
}

-(UITextField *)phoneNumTextField{
    if(!_phoneNumTextField){
        _phoneNumTextField = [[UITextField alloc] init];
        _phoneNumTextField.borderStyle = UITextBorderStyleLine;
        [self.view addSubview:_phoneNumTextField];
    }
    return _phoneNumTextField;
}

-(UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = @"想对Ta说的话";
        [self.view addSubview:_contentLabel];
    }
    return _contentLabel;
}

-(UITextView *)contentTextView{
    if(!_contentTextView){
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.layer.borderWidth = 1;
        _contentTextView.layer.borderColor = [UIColor blackColor].CGColor;
        [self.view addSubview:_contentTextView];
    }
    return _contentTextView;
}

-(UIView *)addPicView{
    if(!_addPicView){
        _addPicView = [[UIView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPicClick)];
        [_addPicView addGestureRecognizer:tap];
        [self.view addSubview:_addPicView];
    }
    return _addPicView;
}

-(UIImageView *)addPicImageView{
    if(!_addPicImageView){
        _addPicImageView = [[UIImageView alloc] init];
        _addPicImageView.image = [UIImage imageNamed:@"flipped_post_add_pic"];
        [self.addPicView addSubview:_addPicImageView];
    }
    return _addPicImageView;
}

-(UILabel *)addPicLabel{
    if(!_addPicLabel){
        _addPicLabel = [[UILabel alloc] init];
        _addPicLabel.text = @"添加图片";
        [self.addPicView addSubview:_addPicLabel];
    }
    return _addPicLabel;
}

-(UIImageView *)selectedImageView{
    if(!_selectedImageView){
        _selectedImageView = [[UIImageView alloc] init];
        _selectedImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _selectedImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedImageClick)];
        [_selectedImageView addGestureRecognizer:tap];
        [self.view addSubview:_selectedImageView];
    }
    return _selectedImageView;
}

@end
