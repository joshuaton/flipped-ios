//
//  FLPostViewController.m
//  Flipped
//
//  Created by junshao on 2017/7/4.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLPostViewController.h"
#import "Masonry.h"
#import "FLFlippedWord.h"
#import "FLFlippedWordsService.h"
#import "FLToast.h"
#import "FLCloudService.h"
#import "FLUserInfoManager.h"
#import "FLStringUtils.h"

@interface FLPostViewController() <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UIImageView *addPicImageView;
@property (nonatomic, strong) UILabel *addPicLabel;
@property (nonatomic, strong) UIImageView *selectedImageView;

@end

@implementation FLPostViewController

+(void)present{
    
    if(![[FLUserInfoManager sharedInstance] checkLogin]){
        return;
    }
    
    FLPostViewController *vc = [[FLPostViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [[FLBaseViewController currentViewController].navigationController presentViewController:navi animated:YES completion:^{
        
    }];
}

-(void)viewDidLoad{
    [super viewDidLoad];

    self.title = @"发布到表白墙";
    [self configRightNavigationItemWithTitle:@"发布" image:nil action:@selector(postBtnDidClick)];
    [self configLeftNavigationItemWithTitle:@"关闭" image:nil action:@selector(closeBtnDidClick)];
    
    self.selectedImageView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherClick)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self makeConstraints];

    [self.phoneNumTextField becomeFirstResponder];
}

-(void)makeConstraints{
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLabel.superview).offset(64+20);
        make.centerX.equalTo(self.tipsLabel.superview);
    }];
    
    [self.phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(25);
        make.left.equalTo(self.phoneNumTextField.superview).offset(10);
        make.right.equalTo(self.phoneNumTextField.superview).offset(-10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumTextField.mas_bottom).offset(5+8);//8是文字离边框的距离
        make.left.equalTo(self.phoneNumTextField);
        make.right.equalTo(self.phoneNumTextField);
        make.height.equalTo(@1);
    }];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(5);
        make.left.equalTo(self.phoneNumTextField);
        make.right.equalTo(self.phoneNumTextField);
        make.height.equalTo(@150);
    }];
    
    [self.addPicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTextView.mas_bottom).offset(10);
        make.left.equalTo(self.contentTextView);
    }];
    
    [self.addPicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addPicImageView.mas_bottom).offset(5);
        make.centerX.equalTo(self.addPicImageView);
    }];
    
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTextView.mas_bottom).offset(10);
        make.left.equalTo(self.contentTextView);
        make.right.equalTo(self.contentTextView);
        make.height.equalTo(@250);

    }];
}

#pragma mark - action

-(void)postBtnDidClick{
    
    NSString *phoneNum = self.phoneNumTextField.text;
    NSString *contentStr = self.contentTextView.text;
    phoneNum = [phoneNum stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNum = [phoneNum stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
    
    if(phoneNum.length != 11){
        [FLToast showToast:@"手机号格式不正确"];
        return;
    }
    
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
            url = [FLStringUtils convertToHttpsWithUrl:url];
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
        self.addPicImageView.hidden = NO;
        self.addPicLabel.hidden = NO;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:deletePhotoAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

-(void)otherClick{
    
    [self.phoneNumTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
}

#pragma mark - private

-(void)showImage:(UIImage *)image{
    
    self.selectedImageView.hidden = NO;
    self.addPicImageView.hidden = YES;
    self.addPicLabel.hidden = YES;
    
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
        _tipsLabel.text = @"对Ta表白，系统会通过短信匿名通知到Ta";
        _tipsLabel.font = FONT_M;
        _tipsLabel.textColor = COLOR_H2;
        [self.view addSubview:_tipsLabel];
    }
    return _tipsLabel;
}

-(UITextField *)phoneNumTextField{
    if(!_phoneNumTextField){
        _phoneNumTextField = [[UITextField alloc] init];
        _phoneNumTextField.font = FONT_L;
        _phoneNumTextField.textColor = COLOR_H1;
        _phoneNumTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
        //设置显示模式为永远显示(默认不显示)
        _phoneNumTextField.leftViewMode = UITextFieldViewModeAlways;
        
        NSString *holderText = @"输入Ta的手机号";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:COLOR_H4
                            range:NSMakeRange(0, holderText.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:FONT_L
                            range:NSMakeRange(0, holderText.length)];
        _phoneNumTextField.attributedPlaceholder = placeholder;
        
        [self.view addSubview:_phoneNumTextField];
    }
    return _phoneNumTextField;
}

-(UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLOR_H5;
        [self.view addSubview:_lineView];
    }
    return _lineView;
}

-(UITextView *)contentTextView{
    if(!_contentTextView){
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.font = FONT_L;
        _contentTextView.textColor = COLOR_H1;
        [self.view addSubview:_contentTextView];
        
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.text = @"说点什么吧...";
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = COLOR_H4;
        placeHolderLabel.font = FONT_L;
        [placeHolderLabel sizeToFit];
        [_contentTextView addSubview:placeHolderLabel];
        
        [_contentTextView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
        
        [self.view addSubview:_contentTextView];

    }
    return _contentTextView;
}

-(UIImageView *)addPicImageView{
    if(!_addPicImageView){
        _addPicImageView = [[UIImageView alloc] init];
        _addPicImageView.image = [UIImage imageNamed:@"flipped_post_add_pic"];
        [_addPicImageView sizeToFit];
        _addPicImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPicClick)];
        [_addPicImageView addGestureRecognizer:tap];
        [self.view addSubview:_addPicImageView];
    }
    return _addPicImageView;
}

-(UILabel *)addPicLabel{
    if(!_addPicLabel){
        _addPicLabel = [[UILabel alloc] init];
        _addPicLabel.text = @"添加图片";
        _addPicLabel.font = FONT_M;
        _addPicLabel.textColor = COLOR_H2;
        [self.view addSubview:_addPicLabel];
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
