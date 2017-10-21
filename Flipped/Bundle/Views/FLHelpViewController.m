//
//  HelpViewController.m
//  Flipped
//
//  Created by ShaoJun on 2017/7/23.
//  Copyright © 2017年 junshao. All rights reserved.
//

#import "FLHelpViewController.h"
#import "FLHelpService.h"
#import "FLContent.h"
#import "Masonry.h"

@interface FLHelpViewController()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation FLHelpViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"使用帮助";
    
    
    [FLHelpService getHelpContentWithSuccessBlock:^(NSMutableArray *contents) {
        NSString *contentStr = @"";
        for(int i=0; i<contents.count; i++){
            FLContent *content = contents[i];
            contentStr = [NSString stringWithFormat:@"%@%@\n\n", contentStr, content.text];
        }
        
        self.contentLabel.text = contentStr;
        
    } failBlock:^(NSError *error) {
        
    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.superview).offset(64+10);
        make.left.equalTo(self.contentLabel.superview).offset(10);
        make.right.equalTo(self.contentLabel.superview).offset(-10);
    }];
}

-(UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = COLOR_H1;
        _contentLabel.font = FONT_L;
        [self.view addSubview:_contentLabel];
    }
    return _contentLabel;
}

@end
